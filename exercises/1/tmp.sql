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

insert into Activity (name) values ('operation'), ('hospital_stay'), ('medication'), ('examination'), ('diagnosis');
insert into Parameter (name, type) values ('patient_first_name', 1);
insert into Parameter (name, type) values ('patient_middle_name', 1);
insert into Parameter (name, type) values ('patient_last_name', 1);
insert into Parameter (name, type) values ('patient_year_of_birth', 0);
insert into Parameter (name, type) values ('patient_month_of_birth', 0);
insert into Parameter (name, type) values ('patient_day_of_birth', 0);
insert into Parameter (name, type) values ('patient_gender', 1);
insert into Parameter (name, type) values ('operation_name', 1);
insert into Parameter (name, type) values ('medication_name', 1);
insert into Parameter (name, type) values ('medication_dosage', 0);
insert into Parameter (name, type) values ('examination_name', 1);
insert into Parameter (name, type) values ('diagnosis_name', 1);
insert into Parameter (name, type) values ('diagnosis_result', 1);
insert into Parameter (name, type) values ('diagnosis_depends_on_examination', 0);
insert into Processcase (externalidentifier) select id from Patient;
insert into Processcase (externalidentifier) values ('Ano10 Nym10'), ('Ano11 Nym11'), ('An12 On12 Ym12');
insert into ProcesscaseParameter (processcaseId, parameterId) select pc.id, param.id from Patient p inner join Processcase pc on cast(pc.externalidentifier as int) = p.id inner join parameter param on param.name = 'patient_first_name' ;
insert into ProcesscaseParameter (processcaseId, parameterId) select pc.id, param.id from Patient p inner join Processcase pc on cast(pc.externalidentifier as int) = p.id inner join parameter param on param.name = 'patient_last_name' ;
insert into ProcesscaseParameter (processcaseId, parameterId) select pc.id, param.id from Patient p inner join Processcase pc on cast(pc.externalidentifier as int) = p.id inner join parameter param on param.name = 'patient_year_of_birth' ;
insert into PPValue (PPId, pvalue) select pp.id, p.vorname from Patient p inner join Processcase pc on cast(pc.externalidentifier as int) = p.id inner join parameter param on param.name = 'patient_first_name' inner join ProcesscaseParameter pp on pp.processcaseId = pc.id and pp.parameterId = param.id ;
insert into PPValue (PPId, pvalue) select pp.id, p.nachname from Patient p inner join Processcase pc on cast(pc.externalidentifier as int) = p.id inner join parameter param on param.name = 'patient_last_name' inner join ProcesscaseParameter pp on pp.processcaseId = pc.id and pp.parameterId = param.id ;
insert into PPValue (PPId, pvalue) select pp.id, p.geburtsjahr from Patient p inner join Processcase pc on cast(pc.externalidentifier as int) = p.id inner join parameter param on param.name = 'patient_year_of_birth' inner join ProcesscaseParameter pp on pp.processcaseId = pc.id and pp.parameterId = param.id ;
insert into ProcesscaseParameter (processcaseId, parameterId) select pc.id, p.id from Processcase pc inner join parameter p on p.name = 'patient_first_name' where pc.externalidentifier = 'Ano10 Nym10' ;
insert into ProcesscaseParameter (processcaseId, parameterId) select pc.id, p.id from Processcase pc inner join parameter p on p.name = 'patient_last_name' where pc.externalidentifier = 'Ano10 Nym10' ;
insert into ProcesscaseParameter (processcaseId, parameterId) select pc.id, p.id from Processcase pc inner join parameter p on p.name = 'patient_year_of_birth' where pc.externalidentifier = 'Ano10 Nym10' ;
insert into ProcesscaseParameter (processcaseId, parameterId) select pc.id, p.id from Processcase pc inner join parameter p on p.name = 'patient_month_of_birth' where pc.externalidentifier = 'Ano10 Nym10' ;
insert into ProcesscaseParameter (processcaseId, parameterId) select pc.id, p.id from Processcase pc inner join parameter p on p.name = 'patient_day_of_birth' where pc.externalidentifier = 'Ano10 Nym10' ;
insert into ProcesscaseParameter (processcaseId, parameterId) select pc.id, p.id from Processcase pc inner join parameter p on p.name = 'patient_first_name' where pc.externalidentifier = 'Ano11 Nym11' ;
insert into ProcesscaseParameter (processcaseId, parameterId) select pc.id, p.id from Processcase pc inner join parameter p on p.name = 'patient_last_name' where pc.externalidentifier = 'Ano11 Nym11' ;
insert into ProcesscaseParameter (processcaseId, parameterId) select pc.id, p.id from Processcase pc inner join parameter p on p.name = 'patient_year_of_birth' where pc.externalidentifier = 'Ano11 Nym11' ;
insert into ProcesscaseParameter (processcaseId, parameterId) select pc.id, p.id from Processcase pc inner join parameter p on p.name = 'patient_month_of_birth' where pc.externalidentifier = 'Ano11 Nym11' ;
insert into ProcesscaseParameter (processcaseId, parameterId) select pc.id, p.id from Processcase pc inner join parameter p on p.name = 'patient_day_of_birth' where pc.externalidentifier = 'Ano11 Nym11' ;
insert into ProcesscaseParameter (processcaseId, parameterId) select pc.id, p.id from Processcase pc inner join parameter p on p.name = 'patient_first_name' where pc.externalidentifier = 'An12 On12 Ym12' ;
insert into ProcesscaseParameter (processcaseId, parameterId) select pc.id, p.id from Processcase pc inner join parameter p on p.name = 'patient_last_name' where pc.externalidentifier = 'An12 On12 Ym12' ;
insert into ProcesscaseParameter (processcaseId, parameterId) select pc.id, p.id from Processcase pc inner join parameter p on p.name = 'patient_year_of_birth' where pc.externalidentifier = 'An12 On12 Ym12' ;
insert into ProcesscaseParameter (processcaseId, parameterId) select pc.id, p.id from Processcase pc inner join parameter p on p.name = 'patient_month_of_birth' where pc.externalidentifier = 'An12 On12 Ym12' ;
insert into ProcesscaseParameter (processcaseId, parameterId) select pc.id, p.id from Processcase pc inner join parameter p on p.name = 'patient_day_of_birth' where pc.externalidentifier = 'An12 On12 Ym12' ;
insert into PPValue (PPId, pvalue) select pp.id, 'Ano10' from Processcase pc inner join parameter p on p.name = 'patient_first_name' inner join ProcesscaseParameter pp on pp.processcaseId = pc.id and pp.parameterId = p.id where pc.externalidentifier = 'Ano10 Nym10' ;
insert into PPValue (PPId, pvalue) select pp.id, 'Nym10' from Processcase pc inner join parameter p on p.name = 'patient_last_name' inner join ProcesscaseParameter pp on pp.processcaseId = pc.id and pp.parameterId = p.id where pc.externalidentifier = 'Ano10 Nym10' ;
insert into PPValue (PPId, pvalue) select pp.id, '1972' from Processcase pc inner join parameter p on p.name = 'patient_year_of_birth' inner join ProcesscaseParameter pp on pp.processcaseId = pc.id and pp.parameterId = p.id where pc.externalidentifier = 'Ano10 Nym10' ;
insert into PPValue (PPId, pvalue) select pp.id, '9' from Processcase pc inner join parameter p on p.name = 'patient_month_of_birth' inner join ProcesscaseParameter pp on pp.processcaseId = pc.id and pp.parameterId = p.id where pc.externalidentifier = 'Ano10 Nym10' ;
insert into PPValue (PPId, pvalue) select pp.id, '20' from Processcase pc inner join parameter p on p.name = 'patient_day_of_birth' inner join ProcesscaseParameter pp on pp.processcaseId = pc.id and pp.parameterId = p.id where pc.externalidentifier = 'Ano10 Nym10' ;
insert into PPValue (PPId, pvalue) select pp.id, 'Ano11' from Processcase pc inner join parameter p on p.name = 'patient_first_name' inner join ProcesscaseParameter pp on pp.processcaseId = pc.id and pp.parameterId = p.id where pc.externalidentifier = 'Ano11 Nym11' ;
insert into PPValue (PPId, pvalue) select pp.id, 'Nym11' from Processcase pc inner join parameter p on p.name = 'patient_last_name' inner join ProcesscaseParameter pp on pp.processcaseId = pc.id and pp.parameterId = p.id where pc.externalidentifier = 'Ano11 Nym11' ;
insert into PPValue (PPId, pvalue) select pp.id, '1968' from Processcase pc inner join parameter p on p.name = 'patient_year_of_birth' inner join ProcesscaseParameter pp on pp.processcaseId = pc.id and pp.parameterId = p.id where pc.externalidentifier = 'Ano11 Nym11' ;
insert into PPValue (PPId, pvalue) select pp.id, '11' from Processcase pc inner join parameter p on p.name = 'patient_month_of_birth' inner join ProcesscaseParameter pp on pp.processcaseId = pc.id and pp.parameterId = p.id where pc.externalidentifier = 'Ano11 Nym11' ;
insert into PPValue (PPId, pvalue) select pp.id, '30' from Processcase pc inner join parameter p on p.name = 'patient_day_of_birth' inner join ProcesscaseParameter pp on pp.processcaseId = pc.id and pp.parameterId = p.id where pc.externalidentifier = 'Ano11 Nym11' ;
insert into PPValue (PPId, pvalue) select pp.id, 'An12' from Processcase pc inner join parameter p on p.name = 'patient_first_name' inner join ProcesscaseParameter pp on pp.processcaseId = pc.id and pp.parameterId = p.id where pc.externalidentifier = 'An12 On12 Ym12' ;
insert into PPValue (PPId, pvalue) select pp.id, 'Ym12' from Processcase pc inner join parameter p on p.name = 'patient_last_name' inner join ProcesscaseParameter pp on pp.processcaseId = pc.id and pp.parameterId = p.id where pc.externalidentifier = 'An12 On12 Ym12' ;
insert into PPValue (PPId, pvalue) select pp.id, '1981' from Processcase pc inner join parameter p on p.name = 'patient_year_of_birth' inner join ProcesscaseParameter pp on pp.processcaseId = pc.id and pp.parameterId = p.id where pc.externalidentifier = 'An12 On12 Ym12' ;
insert into PPValue (PPId, pvalue) select pp.id, '12' from Processcase pc inner join parameter p on p.name = 'patient_month_of_birth' inner join ProcesscaseParameter pp on pp.processcaseId = pc.id and pp.parameterId = p.id where pc.externalidentifier = 'An12 On12 Ym12' ;
insert into PPValue (PPId, pvalue) select pp.id, '6' from Processcase pc inner join parameter p on p.name = 'patient_day_of_birth' inner join ProcesscaseParameter pp on pp.processcaseId = pc.id and pp.parameterId = p.id where pc.externalidentifier = 'An12 On12 Ym12' ;
insert into ProcesscaseActivity (processcaseId, activityId, starttime, stoptime, timeprecision) select p.id, a.id, m.ausgabe, m.ausgabe, 0 from Medikation m inner join Activity a on a.name = 'medication' inner join Processcase p on cast(p.externalidentifier as int) = m.patientId ;
insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) select pca.id, p.id from Medikation m inner join Activity a on a.name = 'medication' inner join Processcase pc on cast(pc.externalidentifier as int) = m.patientId inner join ProcesscaseActivity pca on pca.processcaseId = pc.id and pca.activityId = a.id and pca.starttime = m.ausgabe inner join Parameter p on p.name = 'medication_dosage' ;
insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) select pca.id, p.id from Medikation m inner join Activity a on a.name = 'medication' inner join Processcase pc on cast(pc.externalidentifier as int) = m.patientId inner join ProcesscaseActivity pca on pca.processcaseId = pc.id and pca.activityId = a.id and pca.starttime = m.ausgabe inner join Parameter p on p.name = 'medication_name' ;
insert into PAPValue (PAPId, pvalue) select pap.id, m.dosis from Medikation m inner join ProcesscaseActivityParameter pap on pap.processcaseactivityId = pca.id and pap.parameterId = p.id inner join Activity a on a.name = 'medication' inner join Processcase pc on cast(pc.externalidentifier as int) = m.patientId inner join ProcesscaseActivity pca on pca.processcaseId = pc.id and pca.activityId = a.id and pca.starttime = m.ausgabe inner join Parameter p on p.name = 'medication_dosage' ;
insert into PAPValue (PAPId, pvalue) select pap.id, m.bezeichnung from Medikation m inner join ProcesscaseActivityParameter pap on pap.processcaseactivityId = pca.id and pap.parameterId = p.id inner join Activity a on a.name = 'medication' inner join Processcase pc on cast(pc.externalidentifier as int) = m.patientId inner join ProcesscaseActivity pca on pca.processcaseId = pc.id and pca.activityId = a.id and pca.starttime = m.ausgabe inner join Parameter p on p.name = 'medication_name' ;
insert into ProcesscaseActivity (processcaseId, activityId, starttime, stoptime, timeprecision) select pc.id, a.id, '2002-02-02 00:00:00', '2002-02-02 00:00:00', 0 from Activity a inner join Processcase pc on pc.externalidentifier = 'Ano10 Nym10' where a.name = 'medication' ;
insert into ProcesscaseActivity (processcaseId, activityId, starttime, stoptime, timeprecision) select pc.id, a.id, '2002-05-04 00:00:00', '2002-05-04 00:00:00', 0 from Activity a inner join Processcase pc on pc.externalidentifier = 'Ano10 Nym10' where a.name = 'medication' ;
insert into ProcesscaseActivity (processcaseId, activityId, starttime, stoptime, timeprecision) select pc.id, a.id, '2002-08-01 00:00:00', '2002-08-01 00:00:00', 0 from Activity a inner join Processcase pc on pc.externalidentifier = 'Ano10 Nym10' where a.name = 'medication' ;
insert into ProcesscaseActivity (processcaseId, activityId, starttime, stoptime, timeprecision) select pc.id, a.id, '2003-01-02 00:00:00', '2003-01-02 00:00:00', 0 from Activity a inner join Processcase pc on pc.externalidentifier = 'Ano10 Nym10' where a.name = 'medication' ;
insert into ProcesscaseActivity (processcaseId, activityId, starttime, stoptime, timeprecision) select pc.id, a.id, '2003-04-10 00:00:00', '2003-04-10 00:00:00', 0 from Activity a inner join Processcase pc on pc.externalidentifier = 'Ano10 Nym10' where a.name = 'medication' ;
insert into ProcesscaseActivity (processcaseId, activityId, starttime, stoptime, timeprecision) select pc.id, a.id, '2002-02-20 00:00:00', '2002-02-20 00:00:00', 0 from Activity a inner join Processcase pc on pc.externalidentifier = 'An12 On12 Ym12' where a.name = 'medication' ;
insert into ProcesscaseActivity (processcaseId, activityId, starttime, stoptime, timeprecision) select pc.id, a.id, '2002-02-28 00:00:00', '2002-02-28 00:00:00', 0 from Activity a inner join Processcase pc on pc.externalidentifier = 'An12 On12 Ym12' where a.name = 'medication' ;
insert into ProcesscaseActivity (processcaseId, activityId, starttime, stoptime, timeprecision) select pc.id, a.id, '2002-02-04 00:00:00', '2002-02-04 00:00:00', 0 from Activity a inner join Processcase pc on pc.externalidentifier = 'An12 On12 Ym12' where a.name = 'medication' ;
insert into ProcesscaseActivity (processcaseId, activityId, starttime, stoptime, timeprecision) select pc.id, a.id, '2002-02-12 00:00:00', '2002-02-12 00:00:00', 0 from Activity a inner join Processcase pc on pc.externalidentifier = 'An12 On12 Ym12' where a.name = 'medication' ;
insert into ProcesscaseActivity (processcaseId, activityId, starttime, stoptime, timeprecision) select pc.id, a.id, '2002-02-20 00:00:00', '2002-02-20 00:00:00', 0 from Activity a inner join Processcase pc on pc.externalidentifier = 'An12 On12 Ym12' where a.name = 'medication' ;
insert into ProcesscaseActivity (processcaseId, activityId, starttime, stoptime, timeprecision) select pc.id, a.id, '2002-02-28 00:00:00', '2002-02-28 00:00:00', 0 from Activity a inner join Processcase pc on pc.externalidentifier = 'An12 On12 Ym12' where a.name = 'medication' ;
insert into ProcesscaseActivity (processcaseId, activityId, starttime, stoptime, timeprecision) select pc.id, a.id, '2002-03-08 00:00:00', '2002-03-08 00:00:00', 0 from Activity a inner join Processcase pc on pc.externalidentifier = 'An12 On12 Ym12' where a.name = 'medication' ;
insert into ProcesscaseActivity (processcaseId, activityId, starttime, stoptime, timeprecision) select pc.id, a.id, '2002-03-17 00:00:00', '2002-03-17 00:00:00', 0 from Activity a inner join Processcase pc on pc.externalidentifier = 'An12 On12 Ym12' where a.name = 'medication' ;
insert into ProcesscaseActivity (processcaseId, activityId, starttime, stoptime, timeprecision) select pc.id, a.id, '2002-03-25 00:00:00', '2002-03-25 00:00:00', 0 from Activity a inner join Processcase pc on pc.externalidentifier = 'An12 On12 Ym12' where a.name = 'medication' ;
insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) select pca.id, p.id from Activity a inner join Processcase pc on pc.externalidentifier = 'Ano10 Nym10' inner join ProcesscaseActivity pca on pca.processcaseId = pc.id and pca.activityId = a.id and pca.starttime = '2002-02-02 00:00:00' inner join Parameter p on p.name = 'medication_dosage' where a.name = 'medication' ;
insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) select pca.id, p.id from Activity a inner join Processcase pc on pc.externalidentifier = 'Ano10 Nym10' inner join ProcesscaseActivity pca on pca.processcaseId = pc.id and pca.activityId = a.id and pca.starttime = '2002-02-02 00:00:00' inner join Parameter p on p.name = 'medication_name' where a.name = 'medication' ;
insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) select pca.id, p.id from Activity a inner join Processcase pc on pc.externalidentifier = 'Ano10 Nym10' inner join ProcesscaseActivity pca on pca.processcaseId = pc.id and pca.activityId = a.id and pca.starttime = '2002-05-04 00:00:00' inner join Parameter p on p.name = 'medication_dosage' where a.name = 'medication' ;
insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) select pca.id, p.id from Activity a inner join Processcase pc on pc.externalidentifier = 'Ano10 Nym10' inner join ProcesscaseActivity pca on pca.processcaseId = pc.id and pca.activityId = a.id and pca.starttime = '2002-05-04 00:00:00' inner join Parameter p on p.name = 'medication_name' where a.name = 'medication' ;
insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) select pca.id, p.id from Activity a inner join Processcase pc on pc.externalidentifier = 'Ano10 Nym10' inner join ProcesscaseActivity pca on pca.processcaseId = pc.id and pca.activityId = a.id and pca.starttime = '2002-08-01 00:00:00' inner join Parameter p on p.name = 'medication_dosage' where a.name = 'medication' ;
insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) select pca.id, p.id from Activity a inner join Processcase pc on pc.externalidentifier = 'Ano10 Nym10' inner join ProcesscaseActivity pca on pca.processcaseId = pc.id and pca.activityId = a.id and pca.starttime = '2002-08-01 00:00:00' inner join Parameter p on p.name = 'medication_name' where a.name = 'medication' ;
insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) select pca.id, p.id from Activity a inner join Processcase pc on pc.externalidentifier = 'Ano10 Nym10' inner join ProcesscaseActivity pca on pca.processcaseId = pc.id and pca.activityId = a.id and pca.starttime = '2003-01-02 00:00:00' inner join Parameter p on p.name = 'medication_dosage' where a.name = 'medication' ;
insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) select pca.id, p.id from Activity a inner join Processcase pc on pc.externalidentifier = 'Ano10 Nym10' inner join ProcesscaseActivity pca on pca.processcaseId = pc.id and pca.activityId = a.id and pca.starttime = '2003-01-02 00:00:00' inner join Parameter p on p.name = 'medication_name' where a.name = 'medication' ;
insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) select pca.id, p.id from Activity a inner join Processcase pc on pc.externalidentifier = 'Ano10 Nym10' inner join ProcesscaseActivity pca on pca.processcaseId = pc.id and pca.activityId = a.id and pca.starttime = '2003-04-10 00:00:00' inner join Parameter p on p.name = 'medication_dosage' where a.name = 'medication' ;
insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) select pca.id, p.id from Activity a inner join Processcase pc on pc.externalidentifier = 'Ano10 Nym10' inner join ProcesscaseActivity pca on pca.processcaseId = pc.id and pca.activityId = a.id and pca.starttime = '2003-04-10 00:00:00' inner join Parameter p on p.name = 'medication_name' where a.name = 'medication' ;
insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) select pca.id, p.id from Activity a inner join Processcase pc on pc.externalidentifier = 'An12 On12 Ym12' inner join ProcesscaseActivity pca on pca.processcaseId = pc.id and pca.activityId = a.id and pca.starttime = '2002-02-20 00:00:00' inner join Parameter p on p.name = 'medication_dosage' where a.name = 'medication' ;
insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) select pca.id, p.id from Activity a inner join Processcase pc on pc.externalidentifier = 'An12 On12 Ym12' inner join ProcesscaseActivity pca on pca.processcaseId = pc.id and pca.activityId = a.id and pca.starttime = '2002-02-20 00:00:00' inner join Parameter p on p.name = 'medication_name' where a.name = 'medication' ;
insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) select pca.id, p.id from Activity a inner join Processcase pc on pc.externalidentifier = 'An12 On12 Ym12' inner join ProcesscaseActivity pca on pca.processcaseId = pc.id and pca.activityId = a.id and pca.starttime = '2002-02-28 00:00:00' inner join Parameter p on p.name = 'medication_dosage' where a.name = 'medication' ;
insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) select pca.id, p.id from Activity a inner join Processcase pc on pc.externalidentifier = 'An12 On12 Ym12' inner join ProcesscaseActivity pca on pca.processcaseId = pc.id and pca.activityId = a.id and pca.starttime = '2002-02-28 00:00:00' inner join Parameter p on p.name = 'medication_name' where a.name = 'medication' ;
insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) select pca.id, p.id from Activity a inner join Processcase pc on pc.externalidentifier = 'An12 On12 Ym12' inner join ProcesscaseActivity pca on pca.processcaseId = pc.id and pca.activityId = a.id and pca.starttime = '2002-02-04 00:00:00' inner join Parameter p on p.name = 'medication_dosage' where a.name = 'medication' ;
insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) select pca.id, p.id from Activity a inner join Processcase pc on pc.externalidentifier = 'An12 On12 Ym12' inner join ProcesscaseActivity pca on pca.processcaseId = pc.id and pca.activityId = a.id and pca.starttime = '2002-02-04 00:00:00' inner join Parameter p on p.name = 'medication_name' where a.name = 'medication' ;
insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) select pca.id, p.id from Activity a inner join Processcase pc on pc.externalidentifier = 'An12 On12 Ym12' inner join ProcesscaseActivity pca on pca.processcaseId = pc.id and pca.activityId = a.id and pca.starttime = '2002-02-12 00:00:00' inner join Parameter p on p.name = 'medication_dosage' where a.name = 'medication' ;
insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) select pca.id, p.id from Activity a inner join Processcase pc on pc.externalidentifier = 'An12 On12 Ym12' inner join ProcesscaseActivity pca on pca.processcaseId = pc.id and pca.activityId = a.id and pca.starttime = '2002-02-12 00:00:00' inner join Parameter p on p.name = 'medication_name' where a.name = 'medication' ;
insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) select pca.id, p.id from Activity a inner join Processcase pc on pc.externalidentifier = 'An12 On12 Ym12' inner join ProcesscaseActivity pca on pca.processcaseId = pc.id and pca.activityId = a.id and pca.starttime = '2002-02-20 00:00:00' inner join Parameter p on p.name = 'medication_dosage' where a.name = 'medication' ;
insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) select pca.id, p.id from Activity a inner join Processcase pc on pc.externalidentifier = 'An12 On12 Ym12' inner join ProcesscaseActivity pca on pca.processcaseId = pc.id and pca.activityId = a.id and pca.starttime = '2002-02-20 00:00:00' inner join Parameter p on p.name = 'medication_name' where a.name = 'medication' ;
insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) select pca.id, p.id from Activity a inner join Processcase pc on pc.externalidentifier = 'An12 On12 Ym12' inner join ProcesscaseActivity pca on pca.processcaseId = pc.id and pca.activityId = a.id and pca.starttime = '2002-02-28 00:00:00' inner join Parameter p on p.name = 'medication_dosage' where a.name = 'medication' ;
insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) select pca.id, p.id from Activity a inner join Processcase pc on pc.externalidentifier = 'An12 On12 Ym12' inner join ProcesscaseActivity pca on pca.processcaseId = pc.id and pca.activityId = a.id and pca.starttime = '2002-02-28 00:00:00' inner join Parameter p on p.name = 'medication_name' where a.name = 'medication' ;
insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) select pca.id, p.id from Activity a inner join Processcase pc on pc.externalidentifier = 'An12 On12 Ym12' inner join ProcesscaseActivity pca on pca.processcaseId = pc.id and pca.activityId = a.id and pca.starttime = '2002-03-08 00:00:00' inner join Parameter p on p.name = 'medication_dosage' where a.name = 'medication' ;
insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) select pca.id, p.id from Activity a inner join Processcase pc on pc.externalidentifier = 'An12 On12 Ym12' inner join ProcesscaseActivity pca on pca.processcaseId = pc.id and pca.activityId = a.id and pca.starttime = '2002-03-08 00:00:00' inner join Parameter p on p.name = 'medication_name' where a.name = 'medication' ;
insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) select pca.id, p.id from Activity a inner join Processcase pc on pc.externalidentifier = 'An12 On12 Ym12' inner join ProcesscaseActivity pca on pca.processcaseId = pc.id and pca.activityId = a.id and pca.starttime = '2002-03-17 00:00:00' inner join Parameter p on p.name = 'medication_dosage' where a.name = 'medication' ;
insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) select pca.id, p.id from Activity a inner join Processcase pc on pc.externalidentifier = 'An12 On12 Ym12' inner join ProcesscaseActivity pca on pca.processcaseId = pc.id and pca.activityId = a.id and pca.starttime = '2002-03-17 00:00:00' inner join Parameter p on p.name = 'medication_name' where a.name = 'medication' ;
insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) select pca.id, p.id from Activity a inner join Processcase pc on pc.externalidentifier = 'An12 On12 Ym12' inner join ProcesscaseActivity pca on pca.processcaseId = pc.id and pca.activityId = a.id and pca.starttime = '2002-03-25 00:00:00' inner join Parameter p on p.name = 'medication_dosage' where a.name = 'medication' ;
insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) select pca.id, p.id from Activity a inner join Processcase pc on pc.externalidentifier = 'An12 On12 Ym12' inner join ProcesscaseActivity pca on pca.processcaseId = pc.id and pca.activityId = a.id and pca.starttime = '2002-03-25 00:00:00' inner join Parameter p on p.name = 'medication_name' where a.name = 'medication' ;
insert into PAPValue (PAPId, pvalue) select pap.id, 'Cisplatin Carboplatin' from Activity a inner join ProcesscaseActivityParameter pap on pap.processcaseactivityId = pca.id and pap.parameterId = p.id inner join Processcase pc on pc.externalidentifier = 'Ano10 Nym10' inner join ProcesscaseActivity pca on pca.processcaseId = pc.id and pca.activityId = a.id and pca.starttime = '2002-02-02 00:00:00' inner join Parameter p on p.name = 'medication_dosage' where a.name = 'medication' ;
insert into PAPValue (PAPId, pvalue) select pap.id, 'Cisplatin Carboplatin' from Activity a inner join ProcesscaseActivityParameter pap on pap.processcaseactivityId = pca.id and pap.parameterId = p.id inner join Processcase pc on pc.externalidentifier = 'Ano10 Nym10' inner join ProcesscaseActivity pca on pca.processcaseId = pc.id and pca.activityId = a.id and pca.starttime = '2002-02-02 00:00:00' inner join Parameter p on p.name = 'medication_name' where a.name = 'medication' ;
insert into PAPValue (PAPId, pvalue) select pap.id, 'Cisplatin Carboplatin' from Activity a inner join ProcesscaseActivityParameter pap on pap.processcaseactivityId = pca.id and pap.parameterId = p.id inner join Processcase pc on pc.externalidentifier = 'Ano10 Nym10' inner join ProcesscaseActivity pca on pca.processcaseId = pc.id and pca.activityId = a.id and pca.starttime = '2002-05-04 00:00:00' inner join Parameter p on p.name = 'medication_dosage' where a.name = 'medication' ;
insert into PAPValue (PAPId, pvalue) select pap.id, 'Cisplatin Carboplatin' from Activity a inner join ProcesscaseActivityParameter pap on pap.processcaseactivityId = pca.id and pap.parameterId = p.id inner join Processcase pc on pc.externalidentifier = 'Ano10 Nym10' inner join ProcesscaseActivity pca on pca.processcaseId = pc.id and pca.activityId = a.id and pca.starttime = '2002-05-04 00:00:00' inner join Parameter p on p.name = 'medication_name' where a.name = 'medication' ;
insert into PAPValue (PAPId, pvalue) select pap.id, 'Cisplatin Carboplatin' from Activity a inner join ProcesscaseActivityParameter pap on pap.processcaseactivityId = pca.id and pap.parameterId = p.id inner join Processcase pc on pc.externalidentifier = 'Ano10 Nym10' inner join ProcesscaseActivity pca on pca.processcaseId = pc.id and pca.activityId = a.id and pca.starttime = '2002-08-01 00:00:00' inner join Parameter p on p.name = 'medication_dosage' where a.name = 'medication' ;
insert into PAPValue (PAPId, pvalue) select pap.id, 'Cisplatin Carboplatin' from Activity a inner join ProcesscaseActivityParameter pap on pap.processcaseactivityId = pca.id and pap.parameterId = p.id inner join Processcase pc on pc.externalidentifier = 'Ano10 Nym10' inner join ProcesscaseActivity pca on pca.processcaseId = pc.id and pca.activityId = a.id and pca.starttime = '2002-08-01 00:00:00' inner join Parameter p on p.name = 'medication_name' where a.name = 'medication' ;
insert into PAPValue (PAPId, pvalue) select pap.id, 'Cisplatin Carboplatin' from Activity a inner join ProcesscaseActivityParameter pap on pap.processcaseactivityId = pca.id and pap.parameterId = p.id inner join Processcase pc on pc.externalidentifier = 'Ano10 Nym10' inner join ProcesscaseActivity pca on pca.processcaseId = pc.id and pca.activityId = a.id and pca.starttime = '2003-01-02 00:00:00' inner join Parameter p on p.name = 'medication_dosage' where a.name = 'medication' ;
insert into PAPValue (PAPId, pvalue) select pap.id, 'Cisplatin Carboplatin' from Activity a inner join ProcesscaseActivityParameter pap on pap.processcaseactivityId = pca.id and pap.parameterId = p.id inner join Processcase pc on pc.externalidentifier = 'Ano10 Nym10' inner join ProcesscaseActivity pca on pca.processcaseId = pc.id and pca.activityId = a.id and pca.starttime = '2003-01-02 00:00:00' inner join Parameter p on p.name = 'medication_name' where a.name = 'medication' ;
insert into PAPValue (PAPId, pvalue) select pap.id, 'Cisplatin Carboplatin' from Activity a inner join ProcesscaseActivityParameter pap on pap.processcaseactivityId = pca.id and pap.parameterId = p.id inner join Processcase pc on pc.externalidentifier = 'Ano10 Nym10' inner join ProcesscaseActivity pca on pca.processcaseId = pc.id and pca.activityId = a.id and pca.starttime = '2003-04-10 00:00:00' inner join Parameter p on p.name = 'medication_dosage' where a.name = 'medication' ;
insert into PAPValue (PAPId, pvalue) select pap.id, 'Cisplatin Carboplatin' from Activity a inner join ProcesscaseActivityParameter pap on pap.processcaseactivityId = pca.id and pap.parameterId = p.id inner join Processcase pc on pc.externalidentifier = 'Ano10 Nym10' inner join ProcesscaseActivity pca on pca.processcaseId = pc.id and pca.activityId = a.id and pca.starttime = '2003-04-10 00:00:00' inner join Parameter p on p.name = 'medication_name' where a.name = 'medication' ;
insert into PAPValue (PAPId, pvalue) select pap.id, 'Temozolomide' from Activity a inner join ProcesscaseActivityParameter pap on pap.processcaseactivityId = pca.id and pap.parameterId = p.id inner join Processcase pc on pc.externalidentifier = 'An12 On12 Ym12' inner join ProcesscaseActivity pca on pca.processcaseId = pc.id and pca.activityId = a.id and pca.starttime = '2002-02-20 00:00:00' inner join Parameter p on p.name = 'medication_dosage' where a.name = 'medication' ;
insert into PAPValue (PAPId, pvalue) select pap.id, 'Temozolomide' from Activity a inner join ProcesscaseActivityParameter pap on pap.processcaseactivityId = pca.id and pap.parameterId = p.id inner join Processcase pc on pc.externalidentifier = 'An12 On12 Ym12' inner join ProcesscaseActivity pca on pca.processcaseId = pc.id and pca.activityId = a.id and pca.starttime = '2002-02-20 00:00:00' inner join Parameter p on p.name = 'medication_name' where a.name = 'medication' ;
insert into PAPValue (PAPId, pvalue) select pap.id, 'Temozolomide' from Activity a inner join ProcesscaseActivityParameter pap on pap.processcaseactivityId = pca.id and pap.parameterId = p.id inner join Processcase pc on pc.externalidentifier = 'An12 On12 Ym12' inner join ProcesscaseActivity pca on pca.processcaseId = pc.id and pca.activityId = a.id and pca.starttime = '2002-02-28 00:00:00' inner join Parameter p on p.name = 'medication_dosage' where a.name = 'medication' ;
insert into PAPValue (PAPId, pvalue) select pap.id, 'Temozolomide' from Activity a inner join ProcesscaseActivityParameter pap on pap.processcaseactivityId = pca.id and pap.parameterId = p.id inner join Processcase pc on pc.externalidentifier = 'An12 On12 Ym12' inner join ProcesscaseActivity pca on pca.processcaseId = pc.id and pca.activityId = a.id and pca.starttime = '2002-02-28 00:00:00' inner join Parameter p on p.name = 'medication_name' where a.name = 'medication' ;
insert into PAPValue (PAPId, pvalue) select pap.id, 'Temozolomide' from Activity a inner join ProcesscaseActivityParameter pap on pap.processcaseactivityId = pca.id and pap.parameterId = p.id inner join Processcase pc on pc.externalidentifier = 'An12 On12 Ym12' inner join ProcesscaseActivity pca on pca.processcaseId = pc.id and pca.activityId = a.id and pca.starttime = '2002-02-04 00:00:00' inner join Parameter p on p.name = 'medication_dosage' where a.name = 'medication' ;
insert into PAPValue (PAPId, pvalue) select pap.id, 'Temozolomide' from Activity a inner join ProcesscaseActivityParameter pap on pap.processcaseactivityId = pca.id and pap.parameterId = p.id inner join Processcase pc on pc.externalidentifier = 'An12 On12 Ym12' inner join ProcesscaseActivity pca on pca.processcaseId = pc.id and pca.activityId = a.id and pca.starttime = '2002-02-04 00:00:00' inner join Parameter p on p.name = 'medication_name' where a.name = 'medication' ;
insert into PAPValue (PAPId, pvalue) select pap.id, 'Temozolomide' from Activity a inner join ProcesscaseActivityParameter pap on pap.processcaseactivityId = pca.id and pap.parameterId = p.id inner join Processcase pc on pc.externalidentifier = 'An12 On12 Ym12' inner join ProcesscaseActivity pca on pca.processcaseId = pc.id and pca.activityId = a.id and pca.starttime = '2002-02-12 00:00:00' inner join Parameter p on p.name = 'medication_dosage' where a.name = 'medication' ;
insert into PAPValue (PAPId, pvalue) select pap.id, 'Temozolomide' from Activity a inner join ProcesscaseActivityParameter pap on pap.processcaseactivityId = pca.id and pap.parameterId = p.id inner join Processcase pc on pc.externalidentifier = 'An12 On12 Ym12' inner join ProcesscaseActivity pca on pca.processcaseId = pc.id and pca.activityId = a.id and pca.starttime = '2002-02-12 00:00:00' inner join Parameter p on p.name = 'medication_name' where a.name = 'medication' ;
insert into PAPValue (PAPId, pvalue) select pap.id, 'Temozolomide' from Activity a inner join ProcesscaseActivityParameter pap on pap.processcaseactivityId = pca.id and pap.parameterId = p.id inner join Processcase pc on pc.externalidentifier = 'An12 On12 Ym12' inner join ProcesscaseActivity pca on pca.processcaseId = pc.id and pca.activityId = a.id and pca.starttime = '2002-02-20 00:00:00' inner join Parameter p on p.name = 'medication_dosage' where a.name = 'medication' ;
insert into PAPValue (PAPId, pvalue) select pap.id, 'Temozolomide' from Activity a inner join ProcesscaseActivityParameter pap on pap.processcaseactivityId = pca.id and pap.parameterId = p.id inner join Processcase pc on pc.externalidentifier = 'An12 On12 Ym12' inner join ProcesscaseActivity pca on pca.processcaseId = pc.id and pca.activityId = a.id and pca.starttime = '2002-02-20 00:00:00' inner join Parameter p on p.name = 'medication_name' where a.name = 'medication' ;
insert into PAPValue (PAPId, pvalue) select pap.id, 'Temozolomide' from Activity a inner join ProcesscaseActivityParameter pap on pap.processcaseactivityId = pca.id and pap.parameterId = p.id inner join Processcase pc on pc.externalidentifier = 'An12 On12 Ym12' inner join ProcesscaseActivity pca on pca.processcaseId = pc.id and pca.activityId = a.id and pca.starttime = '2002-02-28 00:00:00' inner join Parameter p on p.name = 'medication_dosage' where a.name = 'medication' ;
insert into PAPValue (PAPId, pvalue) select pap.id, 'Temozolomide' from Activity a inner join ProcesscaseActivityParameter pap on pap.processcaseactivityId = pca.id and pap.parameterId = p.id inner join Processcase pc on pc.externalidentifier = 'An12 On12 Ym12' inner join ProcesscaseActivity pca on pca.processcaseId = pc.id and pca.activityId = a.id and pca.starttime = '2002-02-28 00:00:00' inner join Parameter p on p.name = 'medication_name' where a.name = 'medication' ;
insert into PAPValue (PAPId, pvalue) select pap.id, 'Temozolomide' from Activity a inner join ProcesscaseActivityParameter pap on pap.processcaseactivityId = pca.id and pap.parameterId = p.id inner join Processcase pc on pc.externalidentifier = 'An12 On12 Ym12' inner join ProcesscaseActivity pca on pca.processcaseId = pc.id and pca.activityId = a.id and pca.starttime = '2002-03-08 00:00:00' inner join Parameter p on p.name = 'medication_dosage' where a.name = 'medication' ;
insert into PAPValue (PAPId, pvalue) select pap.id, 'Temozolomide' from Activity a inner join ProcesscaseActivityParameter pap on pap.processcaseactivityId = pca.id and pap.parameterId = p.id inner join Processcase pc on pc.externalidentifier = 'An12 On12 Ym12' inner join ProcesscaseActivity pca on pca.processcaseId = pc.id and pca.activityId = a.id and pca.starttime = '2002-03-08 00:00:00' inner join Parameter p on p.name = 'medication_name' where a.name = 'medication' ;
insert into PAPValue (PAPId, pvalue) select pap.id, 'Temozolomide' from Activity a inner join ProcesscaseActivityParameter pap on pap.processcaseactivityId = pca.id and pap.parameterId = p.id inner join Processcase pc on pc.externalidentifier = 'An12 On12 Ym12' inner join ProcesscaseActivity pca on pca.processcaseId = pc.id and pca.activityId = a.id and pca.starttime = '2002-03-17 00:00:00' inner join Parameter p on p.name = 'medication_dosage' where a.name = 'medication' ;
insert into PAPValue (PAPId, pvalue) select pap.id, 'Temozolomide' from Activity a inner join ProcesscaseActivityParameter pap on pap.processcaseactivityId = pca.id and pap.parameterId = p.id inner join Processcase pc on pc.externalidentifier = 'An12 On12 Ym12' inner join ProcesscaseActivity pca on pca.processcaseId = pc.id and pca.activityId = a.id and pca.starttime = '2002-03-17 00:00:00' inner join Parameter p on p.name = 'medication_name' where a.name = 'medication' ;
insert into PAPValue (PAPId, pvalue) select pap.id, 'Temozolomide' from Activity a inner join ProcesscaseActivityParameter pap on pap.processcaseactivityId = pca.id and pap.parameterId = p.id inner join Processcase pc on pc.externalidentifier = 'An12 On12 Ym12' inner join ProcesscaseActivity pca on pca.processcaseId = pc.id and pca.activityId = a.id and pca.starttime = '2002-03-25 00:00:00' inner join Parameter p on p.name = 'medication_dosage' where a.name = 'medication' ;
insert into PAPValue (PAPId, pvalue) select pap.id, 'Temozolomide' from Activity a inner join ProcesscaseActivityParameter pap on pap.processcaseactivityId = pca.id and pap.parameterId = p.id inner join Processcase pc on pc.externalidentifier = 'An12 On12 Ym12' inner join ProcesscaseActivity pca on pca.processcaseId = pc.id and pca.activityId = a.id and pca.starttime = '2002-03-25 00:00:00' inner join Parameter p on p.name = 'medication_name' where a.name = 'medication' ;
insert into ProcesscaseActivity (processcaseId, activityId, starttime, stoptime, timeprecision) select p.id, a.id, k.aufnahme, k.entlassung, 0 from KrankenhausaufenthaltLeistung kl inner join Krankenhausaufenthalt k on k.id = kl.krankenhausaufenthaltId inner join Processcase p on cast(p.externalidentifier as int) = k.patientId inner join Activity a on a.name = "hospital_stay" ;
insert into ProcesscaseActivity (processcaseId, activityId, starttime, stoptime, timeprecision) select p.id, a.id, '2001-12-10 00:00:00', '2001-12-14 00:00:00', 0 from Processcase p inner join Activity a on a.name = 'hospital_stay' where p.externalidentifier = 'Ano10 Nym10' ;
insert into ProcesscaseActivity (processcaseId, activityId, starttime, stoptime, timeprecision) select p.id, a.id, '2002-01-20 00:00:00', '2002-01-20 00:00:00', 0 from Processcase p inner join Activity a on a.name = 'hospital_stay' where p.externalidentifier = 'Ano10 Nym10' ;
insert into ProcesscaseActivity (processcaseId, activityId, starttime, stoptime, timeprecision) select p.id, a.id, '2002-02-02 00:00:00', '2002-02-02 00:00:00', 0 from Processcase p inner join Activity a on a.name = 'hospital_stay' where p.externalidentifier = 'Ano10 Nym10' ;
insert into ProcesscaseActivity (processcaseId, activityId, starttime, stoptime, timeprecision) select p.id, a.id, '2002-05-04 00:00:00', '2002-05-04 00:00:00', 0 from Processcase p inner join Activity a on a.name = 'hospital_stay' where p.externalidentifier = 'Ano10 Nym10' ;
insert into ProcesscaseActivity (processcaseId, activityId, starttime, stoptime, timeprecision) select p.id, a.id, '2002-08-01 00:00:00', '2002-08-01 00:00:00', 0 from Processcase p inner join Activity a on a.name = 'hospital_stay' where p.externalidentifier = 'Ano10 Nym10' ;
insert into ProcesscaseActivity (processcaseId, activityId, starttime, stoptime, timeprecision) select p.id, a.id, '2003-01-02 00:00:00', '2003-01-02 00:00:00', 0 from Processcase p inner join Activity a on a.name = 'hospital_stay' where p.externalidentifier = 'Ano10 Nym10' ;
insert into ProcesscaseActivity (processcaseId, activityId, starttime, stoptime, timeprecision) select p.id, a.id, '2003-04-10 00:00:00', '2003-04-10 00:00:00', 0 from Processcase p inner join Activity a on a.name = 'hospital_stay' where p.externalidentifier = 'Ano10 Nym10' ;
insert into ProcesscaseActivity (processcaseId, activityId, starttime, stoptime, timeprecision) select p.id, a.id, '2001-10-02 00:00:00', '2001-10-09 00:00:00', 0 from Processcase p inner join Activity a on a.name = 'hospital_stay' where p.externalidentifier = 'Ano11 Nym11' ;
insert into ProcesscaseActivity (processcaseId, activityId, starttime, stoptime, timeprecision) select p.id, a.id, '2002-01-25 00:00:00', '2002-02-02 00:00:00', 0 from Processcase p inner join Activity a on a.name = 'hospital_stay' where p.externalidentifier = 'An12 On12 Ym12' ;
insert into ProcesscaseActivity (processcaseId, activityId, starttime, stoptime, timeprecision) select p.id, a.id, '2002-02-20 00:00:00', '2002-02-20 00:00:00', 0 from Processcase p inner join Activity a on a.name = 'hospital_stay' where p.externalidentifier = 'An12 On12 Ym12' ;
insert into ProcesscaseActivity (processcaseId, activityId, starttime, stoptime, timeprecision) select p.id, a.id, '2002-02-28 00:00:00', '2002-02-28 00:00:00', 0 from Processcase p inner join Activity a on a.name = 'hospital_stay' where p.externalidentifier = 'An12 On12 Ym12' ;
insert into ProcesscaseActivity (processcaseId, activityId, starttime, stoptime, timeprecision) select p.id, a.id, '2002-02-04 00:00:00', '2002-02-04 00:00:00', 0 from Processcase p inner join Activity a on a.name = 'hospital_stay' where p.externalidentifier = 'An12 On12 Ym12' ;
insert into ProcesscaseActivity (processcaseId, activityId, starttime, stoptime, timeprecision) select p.id, a.id, '2002-02-12 00:00:00', '2002-02-12 00:00:00', 0 from Processcase p inner join Activity a on a.name = 'hospital_stay' where p.externalidentifier = 'An12 On12 Ym12' ;
insert into ProcesscaseActivity (processcaseId, activityId, starttime, stoptime, timeprecision) select p.id, a.id, '2002-02-20 00:00:00', '2002-02-20 00:00:00', 0 from Processcase p inner join Activity a on a.name = 'hospital_stay' where p.externalidentifier = 'An12 On12 Ym12' ;
insert into ProcesscaseActivity (processcaseId, activityId, starttime, stoptime, timeprecision) select p.id, a.id, '2002-02-28 00:00:00', '2002-02-28 00:00:00', 0 from Processcase p inner join Activity a on a.name = 'hospital_stay' where p.externalidentifier = 'An12 On12 Ym12' ;
insert into ProcesscaseActivity (processcaseId, activityId, starttime, stoptime, timeprecision) select p.id, a.id, '2002-03-08 00:00:00', '2002-03-08 00:00:00', 0 from Processcase p inner join Activity a on a.name = 'hospital_stay' where p.externalidentifier = 'An12 On12 Ym12' ;
insert into ProcesscaseActivity (processcaseId, activityId, starttime, stoptime, timeprecision) select p.id, a.id, '2002-03-17 00:00:00', '2002-03-17 00:00:00', 0 from Processcase p inner join Activity a on a.name = 'hospital_stay' where p.externalidentifier = 'An12 On12 Ym12' ;
insert into ProcesscaseActivity (processcaseId, activityId, starttime, stoptime, timeprecision) select p.id, a.id, '2002-03-25 00:00:00', '2002-03-25 00:00:00', 0 from Processcase p inner join Activity a on a.name = 'hospital_stay' where p.externalidentifier = 'An12 On12 Ym12' ;
insert into ProcesscaseActivity (processcaseId, activityId, starttime, stoptime, timeprecision) select p.id, a.id, k.aufnahme, k.aufnahme, 0 from KrankenhausaufenthaltLeistung kl inner join Krankenhausaufenthalt k on k.id = kl.krankenhausaufenthaltId inner join Processcase p on cast(p.externalidentifier as int) = k.patientId inner join Activity a on a.name = "operation" ;
insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) values (48, 7);
 insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) values (49, 7);
 insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) values (50, 7);
 insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) values (51, 7);
 insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) values (52, 7);
 insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) values (53, 7);
 
 insert into PAPValue (PAPId, pvalue) values (55, 'Exzision Melanom');
 insert into PAPValue (PAPId, pvalue) values (56, 'Nachexzision Melanom');
 insert into PAPValue (PAPId, pvalue) values (57, 'radikale axilläre Lymphknotenausräumung');
 insert into PAPValue (PAPId, pvalue) values (58, 'Exzision Melanom');
 insert into PAPValue (PAPId, pvalue) values (59, 'Exzision Melanom');
 insert into PAPValue (PAPId, pvalue) values (60, 'Nachexzision Melanom');
insert into ProcesscaseActivity (processcaseId, activityId, starttime, stoptime, timeprecision) select p.id, a.id, '2001-12-10 00:00:00', '2001-12-10 00:00:00', 0 from Processcase p inner join Activity a on a.name = 'operation' where p.externalidentifier = 'Ano10 Nym10' ;
insert into ProcesscaseActivity (processcaseId, activityId, starttime, stoptime, timeprecision) select p.id, a.id, '2001-12-14 00:00:00', '2001-12-14 00:00:00', 0 from Processcase p inner join Activity a on a.name = 'operation' where p.externalidentifier = 'Ano10 Nym10' ;
insert into ProcesscaseActivity (processcaseId, activityId, starttime, stoptime, timeprecision) select p.id, a.id, '2002-01-20 00:00:00', '2002-01-20 00:00:00', 0 from Processcase p inner join Activity a on a.name = 'operation' where p.externalidentifier = 'Ano10 Nym10' ;
insert into ProcesscaseActivity (processcaseId, activityId, starttime, stoptime, timeprecision) select p.id, a.id, '2001-10-03 00:00:00', '2001-10-03 00:00:00', 0 from Processcase p inner join Activity a on a.name = 'operation' where p.externalidentifier = 'Ano11 Nym11' ;
insert into ProcesscaseActivity (processcaseId, activityId, starttime, stoptime, timeprecision) select p.id, a.id, '2001-10-09 00:00:00', '2001-10-09 00:00:00', 0 from Processcase p inner join Activity a on a.name = 'operation' where p.externalidentifier = 'Ano11 Nym11' ;
insert into ProcesscaseActivity (processcaseId, activityId, starttime, stoptime, timeprecision) select p.id, a.id, '2002-01-25 00:00:00', '2002-01-25 00:00:00', 0 from Processcase p inner join Activity a on a.name = 'operation' where p.externalidentifier = 'An12 On12 Ym12' ;
insert into ProcesscaseActivity (processcaseId, activityId, starttime, stoptime, timeprecision) select p.id, a.id, '2002-02-02 00:00:00', '2002-02-02 00:00:00', 0 from Processcase p inner join Activity a on a.name = 'operation' where p.externalidentifier = 'An12 On12 Ym12' ;
insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) values (54, 7);
 insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) values (55, 7);
 insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) values (56, 7);
 insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) values (57, 7);
 insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) values (58, 7);
 insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) values (59, 7);
 insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) values (60, 7);
 
 insert into PAPValue (PAPId, pvalue) values (61, 'Primärexzision');
 insert into PAPValue (PAPId, pvalue) values (62, 'Histologische Primärexzision');
 insert into PAPValue (PAPId, pvalue) values (63, 'Nachexzision');
 insert into PAPValue (PAPId, pvalue) values (64, 'Primärexzision');
 insert into PAPValue (PAPId, pvalue) values (66, 'Histologische Primärexzision');
 insert into PAPValue (PAPId, pvalue) values (66, 'Primärexzision');
 insert into PAPValue (PAPId, pvalue) values (67, 'Histologische Primärexzision');
insert into ProcesscaseActivity (processcaseId, activityId, starttime, stoptime, timeprecision) select p.id, a.id, '2001-12-10 00:00:00', '2001-12-10 00:00:00', 0 from Processcase p inner join Activity a on a.name = 'examination' where p.externalidentifier = 'Ano10 Nym10' ;
insert into ProcesscaseActivity (processcaseId, activityId, starttime, stoptime, timeprecision) select p.id, a.id, '2001-12-10 00:00:00', '2001-12-10 00:00:00', 0 from Processcase p inner join Activity a on a.name = 'examination' where p.externalidentifier = 'Ano10 Nym10' ;
insert into ProcesscaseActivity (processcaseId, activityId, starttime, stoptime, timeprecision) select p.id, a.id, '2001-12-11 00:00:00', '2001-12-11 00:00:00', 0 from Processcase p inner join Activity a on a.name = 'examination' where p.externalidentifier = 'Ano10 Nym10' ;
insert into ProcesscaseActivity (processcaseId, activityId, starttime, stoptime, timeprecision) select p.id, a.id, '2002-01-22 00:00:00', '2002-01-22 00:00:00', 0 from Processcase p inner join Activity a on a.name = 'examination' where p.externalidentifier = 'Ano10 Nym10' ;
insert into ProcesscaseActivity (processcaseId, activityId, starttime, stoptime, timeprecision) select p.id, a.id, '2002-01-25 00:00:00', '2002-01-25 00:00:00', 0 from Processcase p inner join Activity a on a.name = 'examination' where p.externalidentifier = 'Ano10 Nym10' ;
insert into ProcesscaseActivity (processcaseId, activityId, starttime, stoptime, timeprecision) select p.id, a.id, '2001-10-02 00:00:00', '2001-10-02 00:00:00', 0 from Processcase p inner join Activity a on a.name = 'examination' where p.externalidentifier = 'Ano11 Nym11' ;
insert into ProcesscaseActivity (processcaseId, activityId, starttime, stoptime, timeprecision) select p.id, a.id, '2001-10-03 00:00:00', '2001-10-03 00:00:00', 0 from Processcase p inner join Activity a on a.name = 'examination' where p.externalidentifier = 'Ano11 Nym11' ;
insert into ProcesscaseActivity (processcaseId, activityId, starttime, stoptime, timeprecision) select p.id, a.id, '2001-10-05 00:00:00', '2001-10-05 00:00:00', 0 from Processcase p inner join Activity a on a.name = 'examination' where p.externalidentifier = 'Ano11 Nym11' ;
insert into ProcesscaseActivity (processcaseId, activityId, starttime, stoptime, timeprecision) select p.id, a.id, '2002-01-25 00:00:00', '2002-01-25 00:00:00', 0 from Processcase p inner join Activity a on a.name = 'examination' where p.externalidentifier = 'An12 On12 Ym12' ;
insert into ProcesscaseActivity (processcaseId, activityId, starttime, stoptime, timeprecision) select p.id, a.id, '2002-01-25 00:00:00', '2002-01-25 00:00:00', 0 from Processcase p inner join Activity a on a.name = 'examination' where p.externalidentifier = 'An12 On12 Ym12' ;
insert into ProcesscaseActivity (processcaseId, activityId, starttime, stoptime, timeprecision) select p.id, a.id, '2002-01-27 00:00:00', '2002-01-27 00:00:00', 0 from Processcase p inner join Activity a on a.name = 'examination' where p.externalidentifier = 'An12 On12 Ym12' ;
insert into ProcesscaseActivity (processcaseId, activityId, starttime, stoptime, timeprecision) select p.id, a.id, '2002-02-10 00:00:00', '2002-02-10 00:00:00', 0 from Processcase p inner join Activity a on a.name = 'examination' where p.externalidentifier = 'An12 On12 Ym12' ;
insert into ProcesscaseActivity (processcaseId, activityId, starttime, stoptime, timeprecision) select p.id, a.id, '2002-02-09 00:00:00', '2002-02-09 00:00:00', 0 from Processcase p inner join Activity a on a.name = 'examination' where p.externalidentifier = 'An12 On12 Ym12' ;
insert into ProcesscaseActivity (processcaseId, activityId, starttime, stoptime, timeprecision) select p.id, a.id, '2002-02-12 00:00:00', '2002-02-12 00:00:00', 0 from Processcase p inner join Activity a on a.name = 'examination' where p.externalidentifier = 'An12 On12 Ym12' ;
insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) values (61, 10);
insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) values (62, 10);
insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) values (63, 10);
insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) values (64, 10);
insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) values (65, 10);
insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) values (66, 10);
insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) values (67, 10);
insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) values (68, 10);
insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) values (69, 10);
insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) values (70, 10);
insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) values (71, 10);
insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) values (72, 10);
insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) values (73, 10);
insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) values (74, 10);
insert into PAPValue (PAPId, pvalue) values (68, 'Erstuntersuchung');
 insert into PAPValue (PAPId, pvalue) values (69, 'Primärexzision');
 insert into PAPValue (PAPId, pvalue) values (70, 'Histologische Untersuchung');
 insert into PAPValue (PAPId, pvalue) values (71, 'Magnetresonanztomographie');
 insert into PAPValue (PAPId, pvalue) values (72, 'Labor');
 insert into PAPValue (PAPId, pvalue) values (72, 'Erstuntersuchung');
 insert into PAPValue (PAPId, pvalue) values (73, 'Primärexzision');
 insert into PAPValue (PAPId, pvalue) values (74, 'Histologische Untersuchung');
 insert into PAPValue (PAPId, pvalue) values (75, 'Erstuntersuchung');
 insert into PAPValue (PAPId, pvalue) values (76, 'Primärexzision');
 insert into PAPValue (PAPId, pvalue) values (77, 'Histologische Untersuchung');
 insert into PAPValue (PAPId, pvalue) values (78, 'Magnetresonanztomographie');
 insert into PAPValue (PAPId, pvalue) values (79, 'Computertomographie');
 insert into PAPValue (PAPId, pvalue) values (80, 'Labor');
insert into ProcesscaseActivity (processcaseId, activityId, starttime, stoptime, timeprecision) select p.id, a.id, '2001-12-10 00:00:00', '2001-12-10 00:00:00', 0 from Processcase p inner join Activity a on a.name = 'diagnosis' where p.externalidentifier = 'Ano10 Nym10' ;
insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) values (75, 11);
 insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) values (75, 12);
insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) values (75, 13);
insert into PAPValue (PAPId, pvalue) values (82, 'Lokalisation');
 insert into PAPValue (PAPId, pvalue) values (83, 'Rücken');
insert into PAPValue (PAPId, pvalue) values (84, 'Erstuntersuchung');
insert into ProcesscaseActivity (processcaseId, activityId, starttime, stoptime, timeprecision) select p.id, a.id, '2001-12-11 00:00:00', '2001-12-11 00:00:00', 0 from Processcase p inner join Activity a on a.name = 'diagnosis' where p.externalidentifier = 'Ano10 Nym10' ;
insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) values (76, 11);
 insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) values (76, 12);
insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) values (76, 13);
insert into PAPValue (PAPId, pvalue) values (85, 'AJCC Stadium');
 insert into PAPValue (PAPId, pvalue) values (86, 'IIB');
insert into PAPValue (PAPId, pvalue) values (87, 'Histologische Untersuchung');
insert into ProcesscaseActivity (processcaseId, activityId, starttime, stoptime, timeprecision) select p.id, a.id, '2002-01-22 00:00:00', '2002-01-22 00:00:00', 0 from Processcase p inner join Activity a on a.name = 'diagnosis' where p.externalidentifier = 'Ano10 Nym10' ;
insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) values (77, 11);
 insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) values (77, 12);
insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) values (77, 13);
insert into PAPValue (PAPId, pvalue) values (88, 'MRT Diagnose');
 insert into PAPValue (PAPId, pvalue) values (89, 'Verdacht auf Progression');
insert into PAPValue (PAPId, pvalue) values (90, 'Magnetresonanztomographie');
insert into ProcesscaseActivity (processcaseId, activityId, starttime, stoptime, timeprecision) select p.id, a.id, '2002-01-22 00:00:00', '2002-01-22 00:00:00', 0 from Processcase p inner join Activity a on a.name = 'diagnosis' where p.externalidentifier = 'Ano10 Nym10' ;
insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) values (78, 11);
 insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) values (78, 12);
insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) values (78, 13);
insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) values (78, 13);
insert into PAPValue (PAPId, pvalue) values (91, 'Lokalisation Fernmetastasen');
 insert into PAPValue (PAPId, pvalue) values (92, 'Hirn');
insert into PAPValue (PAPId, pvalue) values (93, 'Magnetresonanztomographie');
insert into PAPValue (PAPId, pvalue) values (94, 'Computertomographie');
insert into ProcesscaseActivity (processcaseId, activityId, starttime, stoptime, timeprecision) select p.id, a.id, '2002-01-25 00:00:00', '2002-01-25 00:00:00', 0 from Processcase p inner join Activity a on a.name = 'diagnosis' where p.externalidentifier = 'Ano10 Nym10' ;
insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) values (79, 11);
 insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) values (79, 12);
insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) values (79, 13);
insert into PAPValue (PAPId, pvalue) values (95, 'Tumormarker LDH');
 insert into PAPValue (PAPId, pvalue) values (96, '194.0');
insert into PAPValue (PAPId, pvalue) values (97, 'Labor');
insert into ProcesscaseActivity (processcaseId, activityId, starttime, stoptime, timeprecision) select p.id, a.id, '2002-01-25 00:00:00', '2002-01-25 00:00:00', 0 from Processcase p inner join Activity a on a.name = 'diagnosis' where p.externalidentifier = 'Ano10 Nym10' ;
insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) values (80, 11);
 insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) values (80, 12);
insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) values (80, 13);
insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) values (80, 13);
insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) values (80, 13);
insert into PAPValue (PAPId, pvalue) values (98, 'AJCC Stadium Therapie');
 insert into PAPValue (PAPId, pvalue) values (99, 'IV');
insert into PAPValue (PAPId, pvalue) values (100, 'Magnetresonanztomographie');
insert into PAPValue (PAPId, pvalue) values (101, 'Computertomographie');
insert into PAPValue (PAPId, pvalue) values (102, 'Labor');
insert into ProcesscaseActivity (processcaseId, activityId, starttime, stoptime, timeprecision) select p.id, a.id, '2001-10-02 00:00:00', '2001-10-02 00:00:00', 0 from Processcase p inner join Activity a on a.name = 'diagnosis' where p.externalidentifier = 'Ano11 Nym11' ;
insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) values (81, 11);
 insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) values (81, 12);
insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) values (81, 13);
insert into PAPValue (PAPId, pvalue) values (103, 'Lokalisation');
 insert into PAPValue (PAPId, pvalue) values (104, 'Arm');
insert into PAPValue (PAPId, pvalue) values (105, 'Erstuntersuchung');
insert into ProcesscaseActivity (processcaseId, activityId, starttime, stoptime, timeprecision) select p.id, a.id, '2001-10-05 00:00:00', '2001-10-05 00:00:00', 0 from Processcase p inner join Activity a on a.name = 'diagnosis' where p.externalidentifier = 'Ano11 Nym11' ;
insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) values (82, 11);
 insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) values (82, 12);
insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) values (82, 13);
insert into PAPValue (PAPId, pvalue) values (106, 'AJCC Stadium');
 insert into PAPValue (PAPId, pvalue) values (107, 'I');
insert into PAPValue (PAPId, pvalue) values (108, 'Histologische Untersuchung');
insert into ProcesscaseActivity (processcaseId, activityId, starttime, stoptime, timeprecision) select p.id, a.id, '2002-01-25 00:00:00', '2002-01-25 00:00:00', 0 from Processcase p inner join Activity a on a.name = 'diagnosis' where p.externalidentifier = 'An12 On12 Ym12' ;
insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) values (83, 11);
 insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) values (83, 12);
insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) values (83, 13);
insert into PAPValue (PAPId, pvalue) values (109, 'Lokalisation');
 insert into PAPValue (PAPId, pvalue) values (110, 'Kopf');
insert into PAPValue (PAPId, pvalue) values (111, 'Erstuntersuchung');
insert into ProcesscaseActivity (processcaseId, activityId, starttime, stoptime, timeprecision) select p.id, a.id, '2002-01-27 00:00:00', '2002-01-27 00:00:00', 0 from Processcase p inner join Activity a on a.name = 'diagnosis' where p.externalidentifier = 'An12 On12 Ym12' ;
insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) values (84, 11);
 insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) values (84, 12);
insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) values (84, 13);
insert into PAPValue (PAPId, pvalue) values (112, 'AJCC Stadium');
 insert into PAPValue (PAPId, pvalue) values (113, 'IV');
insert into PAPValue (PAPId, pvalue) values (114, 'Histologische Untersuchung');
insert into ProcesscaseActivity (processcaseId, activityId, starttime, stoptime, timeprecision) select p.id, a.id, '2002-02-10 00:00:00', '2002-02-10 00:00:00', 0 from Processcase p inner join Activity a on a.name = 'diagnosis' where p.externalidentifier = 'An12 On12 Ym12' ;
insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) values (85, 11);
 insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) values (85, 12);
insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) values (85, 13);
insert into PAPValue (PAPId, pvalue) values (115, 'MRT Diagnose');
 insert into PAPValue (PAPId, pvalue) values (116, 'beweisend für Grundkrankheit');
insert into PAPValue (PAPId, pvalue) values (117, 'Magnetresonanztomographie');
insert into ProcesscaseActivity (processcaseId, activityId, starttime, stoptime, timeprecision) select p.id, a.id, '2002-02-09 00:00:00', '2002-02-09 00:00:00', 0 from Processcase p inner join Activity a on a.name = 'diagnosis' where p.externalidentifier = 'An12 On12 Ym12' ;
insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) values (86, 11);
 insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) values (86, 12);
insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) values (86, 13);
insert into PAPValue (PAPId, pvalue) values (118, 'CT Diagnose');
 insert into PAPValue (PAPId, pvalue) values (119, 'Verdacht auf Progression');
insert into PAPValue (PAPId, pvalue) values (120, 'Computertomographie');
insert into ProcesscaseActivity (processcaseId, activityId, starttime, stoptime, timeprecision) select p.id, a.id, '2002-02-10 00:00:00', '2002-02-10 00:00:00', 0 from Processcase p inner join Activity a on a.name = 'diagnosis' where p.externalidentifier = 'An12 On12 Ym12' ;
insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) values (87, 11);
 insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) values (87, 12);
insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) values (87, 13);
insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) values (87, 13);
insert into PAPValue (PAPId, pvalue) values (121, 'Lokalisation Fernmetastasen');
 insert into PAPValue (PAPId, pvalue) values (122, 'Lunge, Weichteile, Knochen');
insert into PAPValue (PAPId, pvalue) values (123, 'Magnetresonanztomographie');
insert into PAPValue (PAPId, pvalue) values (124, 'Computertomographie');
insert into ProcesscaseActivity (processcaseId, activityId, starttime, stoptime, timeprecision) select p.id, a.id, '2002-02-12 00:00:00', '2002-02-12 00:00:00', 0 from Processcase p inner join Activity a on a.name = 'diagnosis' where p.externalidentifier = 'An12 On12 Ym12' ;
insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) values (88, 11);
 insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) values (88, 12);
insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) values (88, 13);
insert into PAPValue (PAPId, pvalue) values (125, 'Tumormarker LDH');
 insert into PAPValue (PAPId, pvalue) values (126, '1353.0');
insert into PAPValue (PAPId, pvalue) values (127, 'Labor');
insert into ProcesscaseActivity (processcaseId, activityId, starttime, stoptime, timeprecision) select p.id, a.id, '2002-02-12 00:00:00', '2002-02-12 00:00:00', 0 from Processcase p inner join Activity a on a.name = 'diagnosis' where p.externalidentifier = 'An12 On12 Ym12' ;
insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) values (89, 11);
 insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) values (89, 12);
insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) values (89, 13);
insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) values (89, 13);
insert into ProcesscaseActivityParameter (processcaseactivityid, parameterid) values (89, 13);
insert into PAPValue (PAPId, pvalue) values (128, 'AJCC Stadium Therapie');
 insert into PAPValue (PAPId, pvalue) values (129, 'IV');
insert into PAPValue (PAPId, pvalue) values (130, 'Magnetresonanztomographie');
insert into PAPValue (PAPId, pvalue) values (131, 'Computertomographie');
insert into PAPValue (PAPId, pvalue) values (132, 'Labor');


select * from PPValue ppv inner join ProcesscaseParameter pp on ppv.PPId = pp.id inner join Parameter p on p.id = pp.parameterId;


select 
    pp.id, p.*
from 
    Patient p
inner join Processcase pc on
    cast(pc.externalidentifier as int) = p.id
inner join parameter param on
    param.name = 'patient_last_name'
inner join ProcesscaseParameter pp on
    pp.processcaseId = pc.id and
    pp.parameterId = param.id
;

select * from ProcesscaseParameter;

select 
    p.*, pp.*
from 
    Patient p
inner join Processcase pc on
    cast(pc.externalidentifier as int) = p.id
inner join parameter param on
    param.name = 'patient_last_name'
left join ProcesscaseParameter pp on
    pp.parameterId = param.id and
    pp.processcaseId = pc.id
;

select 
    pc.id, p.id, *
from 
    Patient p
inner join Processcase pc on
    cast(pc.externalidentifier as int) = p.id
inner join parameter param on
    param.name = 'patient_last_name'
;