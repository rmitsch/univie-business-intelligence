import re

import pandas as pd
import argparse
from datetime import datetime
import numpy as np


def is_timestamp_valid(timestamp):
    """
    Checks whether argument is a valid pandas Timestamp.
    :param timestamp:
    :return:
    """

    return type(timestamp) == pd._libs.tslibs.timestamps.Timestamp


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument("-i", "--input", type=str)
    args = parser.parse_args()
    df = pd.read_excel(args.input, sheet_name=0)
    sql = ""

    # Map fixed values for inserts.
    fixed_values = {
        "Activity": [
            "operation", "hospital_stay", "medication", "examination", "diagnosis"
        ],
        "ProcesscaseParameters": [
            ("patient_first_name", 1),
            ("patient_last_name", 1),
            ("patient_year_of_birth", 0),
            ("patient_month_of_birth", 0),
            ("patient_day_of_birth", 0),
            ("patient_gender", 1)
        ],
        "ProcesscaseActivityParameters": [
            ("operation_name", 1),
            ("medication_name", 1),
            ("medication_dosage", 0),
            ("operation_name", 1),
            ("examination_name", 1),
            ("diagnosis_name", 1),
            ("diagosis_result", 1),
            # Note: depends_on_pca_id reflects dependency of this PCA on one other PCA.
            ("depends_on_pca_id", 0)
        ]
    }

    # Define mapping from diagnoses to necessary examinations.
    diagnosis_to_examinations = {
        "Lokalisation": ["Erstuntersuchung"],
        "AJCC Stadium": ["Histologische Untersuchung"],
        "MRT Diagnose": ["Magnetresonanztomographie"],
        "CT Diagnose": ["Computertomographie"],
        "Lokalisation Fernmetastasen": ["Magnetresonanztomographie", "Computertomographie"],
        "Tumormarker LDH": ["Labor"],
        "AJCC Stadium Therapie": ["Magnetresonanztomographie", "Computertomographie", "Labor"]
    }

    #######################################################################
    # 1. Activities.
    #######################################################################

    sql += "insert into Activity (name) values {activities};".format(
        activities="('" + "'), ('".join(fixed_values["Activity"]) + "')"
    )

    #######################################################################
    # 2. Parameters.
    #######################################################################

    vals = fixed_values["ProcesscaseParameters"]
    vals.extend(fixed_values["ProcesscaseActivityParameters"])
    for val in fixed_values["ProcesscaseParameters"]:
        sql += "\ninsert into Parameter (name, type) values ('{name}', {type});".format(name=val[0], type=val[1])

    #######################################################################
    # 3. Processcases.
    #######################################################################

    sql += "\ninsert into Processcase (externalidentifier) select id from Patient;"
    sql += "\ninsert into Processcase (externalidentifier) values {vals};".format(
        vals="('" + "'), ('".join(df.Patient.values.tolist()) + "')"
    )

    #######################################################################
    # 4. ProcesscaseActivity.
    #######################################################################

    ###########################################
    # 4. 1. (a) Medications from DB.
    ###########################################

    sql += "\n" + """
        insert into ProcesscaseActivity (processcaseId, activityId, starttime, stoptime, timeprecision) 
            select 
                p.id, a.id, m.ausgabe, m.ausgabe, 0 
            from 
                Medikation m 
            inner join Activity a on 
                a.name = 'medication'
            inner join Processcase p on
                cast(p.externalidentifier as int) = m.patientId
        ;
    """.replace("\n", " ").strip()

    ###########################################
    # 4. 1. (b) Medications from spreadsheet.
    ###########################################

    for patient_id in df[df.Therapie.notnull()].Patient.values:
        sql += "\n" + """
            insert into ProcesscaseActivity (processcaseId, activityId, starttime, stoptime, timeprecision) 
                select 
                    p.id, a.id, m.ausgabe, m.ausgabe, 0 
                from 
                    Medikation m 
                inner join Activity a on 
                    a.name = 'medication'
                inner join Processcase p on
                    p.externalidentifier = '{patient_id}'
            ;
        """.format(patient_id=patient_id).replace("\n", " ").strip()

    ###########################################
    # 4. 2. (a) Hospital stays from database.
    ###########################################

    sql += "\n" + """
        insert into ProcesscaseActivity (processcaseId, activityId, starttime, stoptime, timeprecision) 
            select 
                p.id, a.id, k.aufnahme, k.entlassung, 0
            from KrankenhausaufenthaltLeistung kl
            inner join Krankenhausaufenthalt k on
                k.id = kl.krankenhausaufenthaltId
            inner join Processcase p on 
                cast(p.externalidentifier as int) = k.patientId
            inner join Activity a on
                a.name = "hospital_stay"
        ;
    """.replace("\n", " ").strip()

    ###########################################
    # 4. 2. (b) Hospital stays from spreadsheet.
    ###########################################

    for idx, patient in df.iterrows():
        stays = [
            (patient["Erstuntersuchung"], patient["Histologische Primärexzision"])
        ]
        stays.extend([
            (patient[date_col], patient[date_col])
            for date_col in [
                "Nachexzision", "Histologische Nachexzision"
            ] if is_timestamp_valid(patient[date_col])
        ])

        # Add therapy sessions, if they exist.
        if type(patient["Therapiesitzungen"]) == str:
            stays.extend([
                (
                    datetime.strptime(therapy_date, '%d.%m.%Y'),
                    datetime.strptime(therapy_date, '%d.%m.%Y')
                )
                for therapy_date in patient["Therapiesitzungen"].split(", ")
            ])

        for stay in stays:
            sql += "\n" + """
                insert into ProcesscaseActivity (processcaseId, activityId, starttime, stoptime, timeprecision) 
                    select 
                        p.id, a.id, '{start}', '{end}', 0
                    from Processcase p
                    inner join Activity a on
                        a.name = 'hospital_stay'
                    where
                        p.externalidentifier = '{patient_id}'
                ;
            """.format(start=str(stay[0]), end=str(stay[1]), patient_id=patient.Patient).replace("\n", " ").strip()

    ###########################################
    # 4. 3. (a) Operations from DB.
    ###########################################

    # Note: Only slightly adapted version from 4.3.
    sql += "\n" + """
        insert into ProcesscaseActivity (processcaseId, activityId, starttime, stoptime, timeprecision) 
            select 
                p.id, a.id, k.aufnahme, k.aufnahme, 0
            from KrankenhausaufenthaltLeistung kl
            inner join Krankenhausaufenthalt k on
                k.id = kl.krankenhausaufenthaltId
            inner join Processcase p on 
                cast(p.externalidentifier as int) = k.patientId
            inner join Activity a on
                a.name = "operation"
        ;
    """.replace("\n", " ").strip()

    ###########################################
    # 4. 3. (b) Operations from spreadsheet.
    ###########################################

    # Note: Slightly modified version from 2.4.
    for idx, patient in df.iterrows():
        for operation_date in [
            patient[date_col]
            for date_col in [
                "Histologische Primärexzision", "Nachexzision", "Histologische Nachexzision"
            ] if is_timestamp_valid(patient[date_col])
        ]:
            sql += "\n" + """
                insert into ProcesscaseActivity (processcaseId, activityId, starttime, stoptime, timeprecision) 
                    select 
                        p.id, a.id, '{start}', '{end}', 0
                    from Processcase p
                    inner join Activity a on
                        a.name = 'operation'
                    where
                        p.externalidentifier = '{patient_id}'
                ;
            """.format(
                start=str(operation_date), end=str(operation_date), patient_id=patient.Patient
            ).replace("\n", " ").strip()

    ###########################################
    # 4. 4. Examinations from spreadsheet.
    ###########################################

    for idx, patient in df.iterrows():
        for examination_date in [
            patient[date_col]
            for date_col in [
                "Erstuntersuchung", "Primärexzision", "Histologische Untersuchung", "Magnetresonanztomographie",
                "Computertomographie", "Labor"
            ] if is_timestamp_valid(patient[date_col])
        ]:
            sql += "\n" + """
                insert into ProcesscaseActivity (processcaseId, activityId, starttime, stoptime, timeprecision) 
                    select 
                        p.id, a.id, '{start}', '{end}', 0
                    from Processcase p
                    inner join Activity a on
                        a.name = 'examination'
                    where
                        p.externalidentifier = '{patient_id}'
                ;
            """.format(
                start=str(examination_date), end=str(examination_date), patient_id=patient.Patient
            ).replace("\n", " ").strip()

    ###########################################
    # 4. 5. Diagnoses from spreadsheet.
    ###########################################

    for idx, patient in df.iterrows():
        for col in [
            "Lokalisation", "AJCC Stadium", "MRT Diagnose", "CT Diagnose", "Lokalisation Fernmetastasen",
            "Tumormarker LDH", "AJCC Stadium Therapie"
        ]:
            # Add only if patient had diagnoses in current column.
            if type(patient[col]) != float or not np.isnan(patient[col]):
                examination_date = max([patient[exam_col] for exam_col in diagnosis_to_examinations[col]])
                sql += "\n" + """
                    insert into ProcesscaseActivity (processcaseId, activityId, starttime, stoptime, timeprecision)
                        select
                            p.id, a.id, '{start}', '{end}', 0
                        from Processcase p
                        inner join Activity a on
                            a.name = 'diagnosis'
                        where
                            p.externalidentifier = '{patient_id}'
                    ;
                """.format(
                    start=str(examination_date), end=str(examination_date), patient_id=patient.Patient
                ).replace("\n", " ").strip()

    #######################################################################
    # 5. PPValue.
    #######################################################################

    # Note: Only record type in Processcase table are patients.

    #######################################################################
    # 6. PAPValue.
    #######################################################################

    ###########################################
    # 6. 1. For operations.
    ###########################################

    ###########################################
    # 6. 2. For medications.
    ###########################################

    ###########################################
    # 6. 3. For examinations.
    ###########################################

    ###########################################
    # 6. 4. For diagnoses.
    ###########################################

    # Include dependencies to multiple examinations! -> multiple PAPValues for ProcesscaseActivityParameter entry for
    # dependency possible, depending on number of exmination dependencies for diagnosis.

    print(re.sub(r"( +)", " ", sql))
