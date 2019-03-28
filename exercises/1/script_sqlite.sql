--Translate from script.sql with https://www.jooq.org/translate/.

create table Processcase(
  id integer primary key autoincrement not null,
  externalidentifier varchar(500) null default null
);

create table Activity(
  id integer primary key autoincrement not null,
  name varchar(60) null default null
);

create table Parameter(
  id integer primary key autoincrement not null,
  name varchar(250) null default null,
  type int null default 0
);

create table PossibleValue(
  id integer primary key autoincrement not null,
  parameterId int null default null,
  pvalue varchar(1000) null default null,
  foreign key (parameterId)
  references Parameter (id)
);

create table ProcesscaseActivity(
  id integer primary key autoincrement not null,
  processcaseId int not null,
  activityId int not null,
  starttime datetime null default null,
  stoptime datetime null default null,
  timeprecision int null default null,
  foreign key (activityId)
  references Activity (id),
  foreign key (processcaseId)
  references Processcase (id)
);

create table ProcesscaseActivityParameter(
  id integer primary key autoincrement not null,
  processcaseactivityId int not null,
  parameterId int not null,
  foreign key (parameterId)
  references Parameter (id),
  foreign key (processcaseactivityId)
  references ProcesscaseActivity (id)
);

create table ProcesscaseParameter(
  id integer primary key autoincrement not null,
  processcaseId int not null,
  parameterId int not null,
  foreign key (parameterId)
  references Parameter (id),
  foreign key (processcaseId)
  references Processcase (id)
);

create table PAPValue(
  id integer primary key autoincrement not null,
  PAPId int not null,
  pvalue varchar(1000) null default null,
  foreign key (PAPId)
  references ProcesscaseActivityParameter (id)
);

create table PPValue(
  id integer primary key autoincrement not null,
  PPId int not null,
  pvalue varchar(1000) null default null,
  foreign key (PPId)
  references ProcesscaseParameter (id)
);

create table Patient(
  id integer primary key autoincrement not null,
  vorname varchar(50) null default null,
  nachname varchar(50) null default null,
  geburtsjahr int null default null
);

create table Krankenhausaufenthalt(
  id integer primary key autoincrement not null,
  patientId int not null,
  aufnahme datetime null default null,
  entlassung datetime null default null,
  foreign key (patientId)
  references Patient (id)
);

create table Leistung(
  id integer primary key autoincrement not null,
  leistungscode varchar(50) null default null,
  bezeichnung varchar(50) null default null
);

create table Medikation(
  id integer primary key autoincrement not null,
  patientId int not null,
  bezeichnung varchar(50) null default null,
  ausgabe datetime null default null,
  dosis int null default null,
  foreign key (patientId)
  references Patient (id)
);

create table KrankenhausaufenthaltLeistung(
  id integer primary key autoincrement not null,
  leistungId int not null,
  krankenhausaufenthaltId int not null,
  foreign key (leistungId)
  references Leistung (id),
  foreign key (krankenhausaufenthaltId)
  references Krankenhausaufenthalt (id)
);

insert into Patient (vorname, nachname, geburtsjahr) values ('Ano1', 'Nym1', 1961);
insert into Patient (vorname, nachname, geburtsjahr) values ('Ano2', 'Nym2', 1981);
insert into Patient (vorname, nachname, geburtsjahr) values ('Ano3', 'Nym3', 1975);

insert into Leistung (leistungscode, bezeichnung) values ('01', 'Exzision Melanom');
insert into Leistung (leistungscode, bezeichnung) values ('02', 'Nachexzision Melanom');
insert into Leistung (leistungscode, bezeichnung) values ('03', 'radikale axilläre Lymphknotenausräumung');

insert into Krankenhausaufenthalt (patientId, aufnahme, entlassung) values ((select id from Patient where nachname = 'Nym1'), '2012-03-02 11:34:00', '2012-03-02 14:52:00');
insert into Krankenhausaufenthalt (patientId, aufnahme, entlassung) values ((select id from Patient where nachname = 'Nym1'), '2012-03-12 09:12:00', '2012-03-14 11:27:00');

insert into KrankenhausaufenthaltLeistung (leistungId, krankenhausaufenthaltId) values ((select id from Leistung where leistungscode = '01'), (select Krankenhausaufenthalt.id from   Krankenhausaufenthalt, Patient where  Krankenhausaufenthalt.patientId = Patient.id and Patient.nachname = 'Nym1' and Krankenhausaufenthalt.aufnahme = '2012-03-02 11:34:00'));
insert into KrankenhausaufenthaltLeistung (leistungId, krankenhausaufenthaltId) values ((select id from Leistung where leistungscode = '02'), (select Krankenhausaufenthalt.id from   Krankenhausaufenthalt, Patient where  Krankenhausaufenthalt.patientId = Patient.id and Patient.nachname = 'Nym1' and Krankenhausaufenthalt.aufnahme = '2012-03-02 11:34:00'));
insert into KrankenhausaufenthaltLeistung (leistungId, krankenhausaufenthaltId) values ((select id from Leistung where leistungscode = '03'), (select Krankenhausaufenthalt.id from   Krankenhausaufenthalt, Patient where  Krankenhausaufenthalt.patientId = Patient.id and Patient.nachname = 'Nym1' and Krankenhausaufenthalt.aufnahme = '2012-03-12 09:12:00'));

insert into Medikation (patientId, bezeichnung, ausgabe, dosis) values ((select id from Patient where nachname = 'Nym1'), 'Enalapril', '2012-03-23 09:12:00', 20);
insert into Medikation (patientId, bezeichnung, ausgabe, dosis) values ((select id from Patient where nachname = 'Nym1'), 'Enalapril', '2012-04-21 10:42:00', 40);
insert into Medikation (patientId, bezeichnung, ausgabe, dosis) values ((select id from Patient where nachname = 'Nym1'), 'Enalapril', '2012-06-27 09:01:00', 20);
insert into Medikation (patientId, bezeichnung, ausgabe, dosis) values ((select id from Patient where nachname = 'Nym1'), 'Enalapril', '2012-07-30 12:25:00', 20);

insert into Krankenhausaufenthalt (patientId, aufnahme, entlassung) values ((select id from Patient where nachname = 'Nym2'), '2012-01-04 10:59:00', '2012-01-04 12:41:00');

insert into KrankenhausaufenthaltLeistung (leistungId, krankenhausaufenthaltId) values ((select id from Leistung where leistungscode = '01'), (select Krankenhausaufenthalt.id from   Krankenhausaufenthalt, Patient where  Krankenhausaufenthalt.patientId = Patient.id and Patient.nachname = 'Nym2' and Krankenhausaufenthalt.aufnahme = '2012-01-04 10:59:00'));

insert into Medikation (patientId, bezeichnung, ausgabe, dosis) values ((select id from Patient where nachname = 'Nym2'), 'Tebofortan', '2012-01-13 08:12:00', 40);
insert into Medikation (patientId, bezeichnung, ausgabe, dosis) values ((select id from Patient where nachname = 'Nym2'), 'Tebofortan', '2012-02-01 11:22:00', 40);
insert into Medikation (patientId, bezeichnung, ausgabe, dosis) values ((select id from Patient where nachname = 'Nym2'), 'Tebofortan', '2012-02-26 12:51:00', 40);
insert into Medikation (patientId, bezeichnung, ausgabe, dosis) values ((select id from Patient where nachname = 'Nym2'), 'Tebofortan', '2012-03-10 09:30:00', 40);
insert into Medikation (patientId, bezeichnung, ausgabe, dosis) values ((select id from Patient where nachname = 'Nym2'), 'Tebofortan', '2012-03-24 19:31:00', 40);

insert into Krankenhausaufenthalt (patientId, aufnahme, entlassung) values ((select id from Patient where nachname = 'Nym3'), '2012-03-23 09:12:00', '2012-03-23 11:28:00');

insert into KrankenhausaufenthaltLeistung (leistungId, krankenhausaufenthaltId) values ((select id from Leistung where leistungscode = '01'), (select Krankenhausaufenthalt.id from   Krankenhausaufenthalt, Patient where  Krankenhausaufenthalt.patientId = Patient.id and Patient.nachname = 'Nym3' and Krankenhausaufenthalt.aufnahme = '2012-03-23 09:12:00'));
insert into KrankenhausaufenthaltLeistung (leistungId, krankenhausaufenthaltId) values ((select id from Leistung where leistungscode = '02'), (select Krankenhausaufenthalt.id from   Krankenhausaufenthalt, Patient where  Krankenhausaufenthalt.patientId = Patient.id and Patient.nachname = 'Nym3' and Krankenhausaufenthalt.aufnahme = '2012-03-23 09:12:00'));
