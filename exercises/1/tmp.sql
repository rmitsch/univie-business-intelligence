-- Get patient data.
select 
    * 
from 
    Processcase pc
inner join ProcesscaseParameter pcp on
    pcp.processcaseId = pc.id
inner join Parameter p on
    p.id = pcp.parameterId
;

-- Get all PCAs.
select
    *
from 
    ProcesscaseActivity pca
inner join Activity a on
    a.id = pca.activityId
;

-- Get all PCAPs.
select 
    pca.id, pca.starttime, pca.stoptime, a.name as activity, pap.id as pap_id, p.name, papv.*
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
;