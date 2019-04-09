import sqlite3
import pandas as pd
import pprint


if __name__ == '__main__':
    conn = sqlite3.connect('data.sqlite')
    c = conn.cursor()

    mxml = """
<WorkflowLog xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="http://is.tm.tue.nl/research/processmining/WorkflowLog.xsd">
    <Source program="Fluxicon Nitro"/>
    <Process id="business-intelligence-exercise1-a100659" description="Hospital activities">
        <ProcessInstance id="0" description="Simulated process instance">
        $PROCESS_INSTANCE
        </ProcessInstance>
    </Process>
</WorkflowLog>
    """
    process_instance = ""

    # 1. Get all patient data, transform to lookup.
    patients = {}
    for row in c.execute("""
        select 
            pc.id, p.name, ppv.pvalue
        from 
            Processcase pc
        inner join ProcesscaseParameter pcp on
            pcp.processcaseId = pc.id
        inner join Parameter p on
            p.id = pcp.parameterId
        inner join PPValue ppv on 
            ppv.PPId = pcp.id
    """):
        if row[0] not in patients:
            patients[row[0]] = {}
        patients[row[0]][row[1]] = row[2]
    patients = pd.DataFrame.from_dict(patients, orient="index")
    with pd.option_context('display.max_rows', None, 'display.max_columns', None, 'display.width', None):
        print(patients)

    # 2. Get all PCAs/PCAPs/PAPValues.
    events = {}
    for row in c.execute("""
        select 
            pca.id, pca.starttime, pca.stoptime, a.name as activity, pap.id as pap_id, p.name, papv.pvalue, pc.id as pc_id
        from
            ProcesscaseActivity pca
        inner join Activity a on
            a.id = pca.activityId
        inner join ProcesscaseActivityParameter pap on
            pap.processcaseactivityId = pca.id
        inner join Parameter p on
            p.id = pap.parameterId
        inner join PAPValue papv on
            papv.PAPId = pap.id
        inner join Processcase pc on
            pc.id = pca.processcaseId
        ;
    """):
        if row[0] not in events:
            events[row[0]] = {
                "start": row[1],
                "stop": row[2],
                "parameters": [],
                "processcase_id": row[7]
            }

        events[row[0]]["parameters"].append({
            "type": row[3],
            row[5]: row[6]
        })
        print(len(events[row[0]]["parameters"]))
        print(row)


    print("-----")
    pp = pprint.PrettyPrinter(depth=6)
    pp.pprint(events)

    # 3. Split fetched data in AuditTrailEntries.
    # print(mxml)
