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
    sql = """
        delete from PAPValue;
        delete from PPValue;
        delete from ProcesscaseActivityParameter;
        delete from ProcesscaseParameter;
        delete from ProcesscaseActivity;
        delete from Processcase;
        delete from Activity;
        delete from Parameter;
        
        delete from sqlite_sequence where name ='PAPValue';
        delete from sqlite_sequence where name ='PPValue';
        delete from sqlite_sequence where name ='ProcesscaseActivityParameter';
        delete from sqlite_sequence where name ='ProcesscaseParameter';
        delete from sqlite_sequence where name ='ProcesscaseActivity';
        delete from sqlite_sequence where name ='Processcase';
        delete from sqlite_sequence where name ='Activity';
        delete from sqlite_sequence where name ='Parameter';
    """.strip()

    # Map fixed values for inserts.
    fixed_values = {
        "Activity": [
            "operation", "hospital_stay", "medication", "examination", "diagnosis"
        ],
        "ProcesscaseParameters": [
            ("patient_first_name", 1),
            ("patient_middle_name", 1),
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
            ("examination_name", 1),
            ("diagnosis_name", 1),
            ("diagnosis_result", 1),
            ("diagnosis_depends_on_examination", 0)
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

    sql += "\n\ninsert into Activity (name) values {activities};".format(
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
    # 4. ProcesscaseParameter and PPValue.
    #######################################################################

    ###########################################
    # 4. 1. From DB.
    ###########################################

    # PPs.
    sql_template = "\n" + """
        insert into ProcesscaseParameter (processcaseId, parameterId)
            select 
                pc.id, param.id
            from 
                Patient p
            inner join Processcase pc on
                cast(pc.externalidentifier as int) = p.id
            inner join parameter param on
                param.name = '{param_name}'
            ;
    """.replace("\n", " ").strip()
    sql += sql_template.format(param_name="patient_first_name")
    sql += sql_template.format(param_name="patient_last_name")
    sql += sql_template.format(param_name="patient_year_of_birth")

    # PPValues.
    sql_template = "\n" + """
            insert into PPValue (PPId, pvalue)
                select 
                    pp.id, p.{attr_name}
                from 
                    Patient p
                inner join Processcase pc on
                    cast(pc.externalidentifier as int) = p.id
                inner join parameter param on
                    param.name = '{param_name}'
                inner join ProcesscaseParameter pp on
                    pp.processcaseId = pc.id and
                    pp.parameterId = param.id
                ;
        """.replace("\n", " ").strip()
    sql += sql_template.format(attr_name="vorname", param_name="patient_first_name")
    sql += sql_template.format(attr_name="nachname", param_name="patient_last_name")
    sql += sql_template.format(attr_name="geburtsjahr", param_name="patient_year_of_birth")

    ###########################################
    # 4. 2. From spreadsheet.
    ###########################################

    sql_template = "\n" + """
        insert into ProcesscaseParameter (processcaseId, parameterId)
            select 
                pc.id, p.id
            from 
                Processcase pc
            inner join parameter p on
                p.name = '{param_name}'
            where
                pc.externalidentifier = '{ext_id}'
            ;
    """.replace("\n", " ").strip()

    # PPs.
    for idx, patient in df.iterrows():
        sql += sql_template.format(param_name="patient_first_name", ext_id=patient.Patient)
        if len(patient.Patient.split()) > 3:
            sql += sql_template.format(param_name="patient_middle_name", ext_id=patient.Patient)
        sql += sql_template.format(param_name="patient_last_name", ext_id=patient.Patient)

        sql += sql_template.format(param_name="patient_year_of_birth", ext_id=patient.Patient)
        sql += sql_template.format(param_name="patient_month_of_birth", ext_id=patient.Patient)
        sql += sql_template.format(param_name="patient_day_of_birth", ext_id=patient.Patient)

    # PPValues.
    sql_template = "\n" + """
        insert into PPValue (PPId, pvalue)
            select 
                pp.id, '{value}'
            from 
                Processcase pc
            inner join parameter p on
                p.name = '{param_name}'
            inner join ProcesscaseParameter pp on
                pp.processcaseId = pc.id and
                pp.parameterId = p.id
            where
                pc.externalidentifier = '{ext_id}'
            ;
    """.replace("\n", " ").strip()

    for idx, patient in df.iterrows():
        names = patient.Patient.split()
        sql += sql_template.format(param_name="patient_first_name", value=names[0], ext_id=patient.Patient)
        if len(names) > 3:
            sql += sql_template.format(param_name="patient_middle_name", value=" ".join(names[1:-1]), ext_id=patient.Patient)
        sql += sql_template.format(param_name="patient_last_name", value=names[-1], ext_id=patient.Patient)

        birthdate = patient.Geburtsdatum
        sql += sql_template.format(param_name="patient_year_of_birth", value=birthdate.year, ext_id=patient.Patient)
        sql += sql_template.format(param_name="patient_month_of_birth", value=birthdate.month, ext_id=patient.Patient)
        sql += sql_template.format(param_name="patient_day_of_birth", value=birthdate.day, ext_id=patient.Patient)

    #######################################################################
    # 5. ProcesscaseActivity, ProcesscaseActivityParameters, PAPValue.
    #######################################################################

    ###########################################
    # 5. 1. (a) Medications from DB.
    ###########################################

    # PAs.
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

    # PAPs.
    sql_template = """
        insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) 
            select 
                pca.id, p.id
            from 
                Medikation m 
            inner join Activity a on 
                a.name = 'medication'
            inner join Processcase pc on
                cast(pc.externalidentifier as int) = m.patientId
            inner join ProcesscaseActivity pca on 
                pca.processcaseId = pc.id and
                pca.activityId = a.id and
                pca.starttime = m.ausgabe
            inner join Parameter p on
                p.name = 'medication_{param_suffix}'
        ;
    """

    sql += "\n" + sql_template.format(param_suffix="dosage").replace("\n", " ").strip()
    sql += "\n" + sql_template.format(param_suffix="name").replace("\n", " ").strip()

    # PAPValues.
    sql_template = """
        insert into PAPValue (PAPId, pvalue)
            select 
                pap.id, m.{attribute}
            from 
                Medikation m 
            inner join ProcesscaseActivityParameter pap on
                pap.processcaseactivityId = pca.id and
                pap.parameterId = p.id
            inner join Activity a on 
                a.name = 'medication'
            inner join Processcase pc on
                cast(pc.externalidentifier as int) = m.patientId
            inner join ProcesscaseActivity pca on 
                pca.processcaseId = pc.id and
                pca.activityId = a.id and
                pca.starttime = m.ausgabe
            inner join Parameter p on
                p.name = 'medication_{param_suffix}'
                ;
    """

    sql += "\n" + sql_template.format(attribute="dosis", param_suffix="dosage").replace("\n", " ").strip()
    sql += "\n" + sql_template.format(attribute="bezeichnung", param_suffix="name").replace("\n", " ").strip()

    ###########################################
    # 5. 1. (b) Medications from spreadsheet.
    ###########################################

    # PCAs.
    for idx, patient in df[df.Therapie.notnull()].iterrows():
        for therapy_date in patient.Therapiesitzungen.split(", "):
            therapy_date = datetime.strptime(therapy_date, '%d.%m.%Y')
            sql += "\n" + """
                insert into ProcesscaseActivity (processcaseId, activityId, starttime, stoptime, timeprecision) 
                    select 
                        pc.id, a.id, '{start}', '{stop}', 0 
                    from 
                        Activity a 
                    inner join Processcase pc on
                        pc.externalidentifier = '{patient_id}'
                    where
                        a.name = 'medication'
                ;
            """.format(
                patient_id=patient.Patient, start=str(therapy_date), stop=str(therapy_date)
            ).replace("\n", " ").strip()

    # PAPs.
    sql_template = """
        insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid)
            select 
                pca.id, p.id
            from 
                Activity a
            inner join Processcase pc on
                pc.externalidentifier = '{patient_id}'
            inner join ProcesscaseActivity pca on 
                pca.processcaseId = pc.id and
                pca.activityId = a.id and
                pca.starttime = '{med_time}'
            inner join Parameter p on
                p.name = 'medication_{param_suffix}'
            where
                a.name = 'medication'
        ;
    """
    for idx, patient in df[df.Therapie.notnull()].iterrows():
        for therapy_date in patient.Therapiesitzungen.split(", "):
            sql += "\n" + sql_template.format(
                patient_id=patient.Patient,
                med_time=datetime.strptime(therapy_date, '%d.%m.%Y'),
                param_suffix="name"
            ).replace("\n", " ").strip()

    # PAPValues.
    sql_template = """
        insert into PAPValue (PAPId, pvalue)
            select 
                pap.id, '{value}'
            from 
                Activity a
            inner join ProcesscaseActivityParameter pap on
                pap.processcaseactivityId = pca.id and
                pap.parameterId = p.id
            inner join Processcase pc on
                pc.externalidentifier = '{patient_id}'
            inner join ProcesscaseActivity pca on 
                pca.processcaseId = pc.id and
                pca.activityId = a.id and
                pca.starttime = '{med_time}'
            inner join Parameter p on
                p.name = 'medication_{param_suffix}'
            where
                a.name = 'medication'
        ;
    """
    for idx, patient in df[df.Therapie.notnull()].iterrows():
        for therapy_date in patient.Therapiesitzungen.split(", "):
            sql += "\n" + sql_template.format(
                value=patient.Therapie,
                patient_id=patient.Patient,
                med_time=datetime.strptime(therapy_date, '%d.%m.%Y'),
                param_suffix="name"
            ).replace("\n", " ").strip()

    ###########################################
    # 5. 2. (a) Hospital stays from database.
    ###########################################

    # PCAs.
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

    # No attributes except start and end datetime, which are already associated with the corresponding PCA.

    ###########################################
    # 5. 2. (b) Hospital stays from spreadsheet.
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

    # No attributes except start and end datetime, which are already associated with the corresponding PCA.

    ###########################################
    # 5. 3. (a) Operations from DB.
    ###########################################

    # PCAs.
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

    # PAPs and PAPValues.
    # Workaround, since multiple operations might take place at the same time on the same day: Hardcoded inserts.
    # Dynamic alternative: Process data in script, assign PCAs to PAPs iteratively.
    # Note that IDs are bound to state of DB prior to these statements - any change in prior code should be reflected in
    # change of IDs.
    sql += "\n" + """
        insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) values (48, (select id from Parameter where name = 'operation_name'));
        insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) values (49, (select id from Parameter where name = 'operation_name'));
        insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) values (50, (select id from Parameter where name = 'operation_name'));
        insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) values (51, (select id from Parameter where name = 'operation_name'));
        insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) values (52, (select id from Parameter where name = 'operation_name'));
        insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) values (53, (select id from Parameter where name = 'operation_name'));
        
        insert into PAPValue (PAPId, pvalue) values (37, 'Exzision Melanom');
        insert into PAPValue (PAPId, pvalue) values (38, 'Nachexzision Melanom');
        insert into PAPValue (PAPId, pvalue) values (39, 'radikale axilläre Lymphknotenausräumung');
        insert into PAPValue (PAPId, pvalue) values (40, 'Exzision Melanom');
        insert into PAPValue (PAPId, pvalue) values (41, 'Exzision Melanom');
        insert into PAPValue (PAPId, pvalue) values (42, 'Nachexzision Melanom');
    """.strip()

    ###########################################
    # 5. 3. (b) Operations from spreadsheet.
    ###########################################

    # PCAs.
    for idx, patient in df.iterrows():
        for date_col in [
            "Primärexzision", "Histologische Primärexzision", "Nachexzision", "Histologische Nachexzision"
        ]:
            if is_timestamp_valid(patient[date_col]):
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
                    start=str(patient[date_col]), end=str(patient[date_col]), patient_id=patient.Patient
                ).replace("\n", " ").strip()

    # PAPs and PAPValues.
    sql += "\n" + """
        insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) values (54, (select id from Parameter where name = 'operation_name'));
        insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) values (55, (select id from Parameter where name = 'operation_name'));
        insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) values (56, (select id from Parameter where name = 'operation_name'));
        insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) values (57, (select id from Parameter where name = 'operation_name'));
        insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) values (58, (select id from Parameter where name = 'operation_name'));
        insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) values (59, (select id from Parameter where name = 'operation_name'));
        insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) values (60, (select id from Parameter where name = 'operation_name'));
        
        insert into PAPValue (PAPId, pvalue) values (43, 'Primärexzision');
        insert into PAPValue (PAPId, pvalue) values (44, 'Histologische Primärexzision');
        insert into PAPValue (PAPId, pvalue) values (45, 'Nachexzision');
        insert into PAPValue (PAPId, pvalue) values (46, 'Primärexzision');
        insert into PAPValue (PAPId, pvalue) values (47, 'Histologische Primärexzision');
        insert into PAPValue (PAPId, pvalue) values (48, 'Primärexzision');
        insert into PAPValue (PAPId, pvalue) values (49, 'Histologische Primärexzision');
    """.strip()

    ###########################################
    # 5. 4. Examinations from spreadsheet.
    ###########################################

    for idx, patient in df.iterrows():
        for date_col in [
                "Erstuntersuchung", "Primärexzision", "Histologische Untersuchung", "Magnetresonanztomographie",
                "Computertomographie", "Labor"
        ]:
            if is_timestamp_valid(patient[date_col]):
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
                    start=str(patient[date_col]), end=str(patient[date_col]), patient_id=patient.Patient
                ).replace("\n", " ").strip()

    # PAPs and PAPValues.
    for i in range(61, 75):
        sql += "\ninsert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) values (" + str(i) + ", (select id from Parameter where name = 'examination_name'));"

    sql += "\n" + """
        insert into PAPValue (PAPId, pvalue) values (50, 'Erstuntersuchung');
        insert into PAPValue (PAPId, pvalue) values (51, 'Primärexzision');
        insert into PAPValue (PAPId, pvalue) values (52, 'Histologische Untersuchung');
        insert into PAPValue (PAPId, pvalue) values (53, 'Magnetresonanztomographie');
        insert into PAPValue (PAPId, pvalue) values (54, 'Labor');
        insert into PAPValue (PAPId, pvalue) values (55, 'Erstuntersuchung');
        insert into PAPValue (PAPId, pvalue) values (56, 'Primärexzision');
        insert into PAPValue (PAPId, pvalue) values (57, 'Histologische Untersuchung');
        insert into PAPValue (PAPId, pvalue) values (58, 'Erstuntersuchung');
        insert into PAPValue (PAPId, pvalue) values (59, 'Primärexzision');
        insert into PAPValue (PAPId, pvalue) values (60, 'Histologische Untersuchung');
        insert into PAPValue (PAPId, pvalue) values (61, 'Magnetresonanztomographie');
        insert into PAPValue (PAPId, pvalue) values (62, 'Computertomographie');
        insert into PAPValue (PAPId, pvalue) values (63, 'Labor');    
    """.strip()

    ###########################################
    # 5. 4. Diagnoses from spreadsheet.
    ###########################################

    curr_pac_id = 75
    curr_pap_id = 64
    for idx, patient in df.iterrows():
        for col in [
            "Lokalisation", "AJCC Stadium", "MRT Diagnose", "CT Diagnose", "Lokalisation Fernmetastasen",
            "Tumormarker LDH", "AJCC Stadium Therapie"
        ]:
            # Add only if patient had diagnoses in current column.
            if type(patient[col]) != float or not np.isnan(patient[col]):
                examination_date = max([patient[exam_col] for exam_col in diagnosis_to_examinations[col]])

                # ("diagnosis_name", 1),
                # ("diagnosis_result", 1),
                # ("diagnosis_depends_on_pca_id", 0)

                # PCAs.
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
                ).replace("\n", "").strip()

                # PAPs.
                sql += "\n" + """
                    insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) values ({idx}, (select id from Parameter where name = 'diagnosis_name'));
                    insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) values ({idx}, (select id from Parameter where name = 'diagnosis_result'));
                """.format(idx=curr_pac_id).strip()
                for dep in diagnosis_to_examinations[col]:
                    sql += "\ninsert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) values (" \
                           "{idx}, (select id from Parameter where name = 'diagnosis_depends_on_examination'));".format(idx=curr_pac_id)

                # PAPValues.
                sql += "\n" + """
                    insert into PAPValue (PAPId, pvalue) values ({pap_id_1}, '{diagnosis_name}');
                    insert into PAPValue (PAPId, pvalue) values ({pap_id_2}, '{diagnosis_result}');
                """.format(
                    pap_id_1=str(curr_pap_id),
                    pap_id_2=str(curr_pap_id + 1),
                    diagnosis_name=col,
                    diagnosis_result=patient[col]
                ).strip()
                for i, dep in enumerate(diagnosis_to_examinations[col]):
                    sql += "\n" + """
                        insert into PAPValue (PAPId, pvalue) values ({pap_id}, '{diagnosis_depends_on_examination}');
                    """.format(
                        pap_id=str(curr_pap_id + 2 + i), diagnosis_depends_on_examination=dep
                    ).strip()

                curr_pac_id += 1
                curr_pap_id += 2 + len(diagnosis_to_examinations[col])

    print(re.sub(r"( +)", " ", sql))
