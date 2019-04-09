import sqlite3

if __name__ == '__main__':
    conn = sqlite3.connect('data.sqlite')
    c = conn.cursor()

    mxml = """
<WorkflowLog xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="http://is.tm.tue.nl/research/processmining/WorkflowLog.xsd">
    <Source program="business-intelligence-exercise1-a100659-mxml-generator"/>
    <Process id="business-intelligence-exercise1-a100659" description="Hospital activities">
        <ProcessInstance id="0" description="Audit trail of all recorded hospital activities.">
        $AUDIT_TRAIL
        </ProcessInstance>
    </Process>
</WorkflowLog>
    """
    audit_trail_entry_string = ""

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

    # 2. Get all PCAs/PCAPs/PAPValues.
    events = {}
    for row in c.execute("""
        select 
            pca.id, pca.starttime, pca.stoptime, a.name as activity, pap.id as pap_id, p.name, papv.pvalue, pc.id as pc_id
        from
            ProcesscaseActivity pca
        inner join Activity a on
            a.id = pca.activityId
        left join ProcesscaseActivityParameter pap on
            pap.processcaseactivityId = pca.id
        left join Parameter p on
            p.id = pap.parameterId
        left join PAPValue papv on
            papv.PAPId = pap.id
        left join Processcase pc on
                    pc.id = pca.processcaseId
        ;
    """):
        if row[0] not in events:
            events[row[0]] = {
                "start": row[1],
                "stop": row[2],
                "parameters": [],
                "patient_id": row[7],
                "patient": patients[row[7]],
                "type": row[3]
            }

        events[row[0]]["parameters"].append({row[5]: row[6]})

    # 3. Split fetched data in AuditTrailEntries.
    for event_id in events:
        event = events[event_id]
        audit_trail_entry_template = """
            <AuditTrailEntry>
                <WorkflowModelElement>{workflow_model_element}</WorkflowModelElement>
                {data}
                <EventType>{event_type}</EventType>
                <Timestamp>{timestamp}</Timestamp>
                <Originator>{originator}</Originator>
            </AuditTrailEntry>
        """

        data = ""
        for param in event["parameters"]:
            if list(param.keys())[0] is not None:
                data += '\n\t\t\t\t\t<Attribute name="' + list(param.keys())[0] + '">' + list(param.values())[0] + '</Attribute>'
        for param in event["patient"]:
            data += '\n\t\t\t\t\t<Attribute name="' + param + '">' + event["patient"][param] + '</Attribute>'
        if len(data):
            data = "<Data>\n" + data[1:] + "\n\t\t\t\t</Data>"

        if event["start"] != event["stop"]:
            audit_trail_entry_string += audit_trail_entry_template.format(
                workflow_model_element=event["type"],
                event_type="start",
                timestamp=event["start"],
                originator=event["patient_id"],
                data=data
            )

        audit_trail_entry_string += audit_trail_entry_template.format(
            workflow_model_element=event["type"],
            event_type="complete",
            timestamp=event["stop"],
            originator=event["patient_id"],
            data=data
        )

    print(mxml.replace("$AUDIT_TRAIL", audit_trail_entry_string))
