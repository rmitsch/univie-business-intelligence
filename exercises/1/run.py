import re

import pandas as pd
import argparse

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument("-i", "--input", type=str)
    args = parser.parse_args()

    df = pd.read_excel(args.input, sheet_name=0)

    # Map fixed values for inserts.
    values = {
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
            ("medication_name", 1),
            ("medication_dosage", 0),
            ("operation_name", 1),
            ("diagnosis_name", 1),
            ("diagosis_result", 1),
            # Note: depends_on_pca_id reflects dependency of this PCA on one other PCA.
            ("depends_on_pca_id", 0)
        ]
    }

    sql = ""

    # todo Format insert of PossibleValues. What's suposed to go in here?
    # sql += """
    #     insert into PossibleValue
    # """

    # 1. Activities.
    sql += "insert into Activity (name) values {activities}".format(
        activities="('" + "'), ('".join(values["Activity"]) + "')"
    )

    # 2. Parameters.
    vals = values["ProcesscaseParameters"]
    vals.extend(values["ProcesscaseActivityParameters"])
    for val in values["ProcesscaseParameters"]:
        sql += "\ninsert into Parameter (name, type) values ('{name}', {type})".format(name=val[0], type=val[1])

    # 3. Processcases.
    sql += "\ninsert into Processcase (externalidentifier) select id from Patient"
    sql += "\ninsert into Processcase (externalidentifier) values {vals}".format(
        vals="('" + "'), ('".join(df.Patient.values.tolist()) + "')"
    )

    # 4. ProcesscaseActivity.
    # todo What's time precision?

    # 4. 1. Medications from DB.
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
    """.replace("\n", " ").strip()

    # 4. 2. Medications from spreadsheet.
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
        """.format(patient_id=patient_id).replace("\n", " ").strip()

    # 4. 3. Operations

    with pd.option_context('display.max_rows', None, 'display.max_columns', None, 'display.width', None):
        print(df[df.Therapie.notnull()])

    print(re.sub(r"( +)", " ", sql))
