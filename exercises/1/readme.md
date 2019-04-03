# Exercise 1: Data Transformation and Integration

### Notes
The original SQL code was translated to a SQLite dialect using https://www.jooq.org/translate/.

### Todos
* Read up on MXML model.
* Transform database data -> integration model.
* Transform spreadsheet data -> integration model.





## Tasks

**1. Create a list of problems and assumptions when/for doing the integration. (2 points)**  
* Patients in spreadsheet and database are treated as different entities, since their cases don't obviously overlap and 
hence we can't reasonably assume they are the same persons.
* Data consistency w.r.t. to usage of parameters is guaranteed at runtime / when new data is entered.
* Medications are considered complete instantaneously.

**2. Integrate the data into the given data integration model from Figure 1. (4 points)**  

Table and spreadsheet mapping:
* Patient <-> Processcase
* Leistung, KrankenhausaufenthaltLeistung, Medication <-> ProcessCaseActivity + parameter tables
* "Operation", "Krankenhausaufenthalt", "Medikation", various column header in spreadsheet <-> Activity
-> use name instead of just "Operation" so we can't duplicate params? applies to all params though. we could presume 
additional constraints preventing multiple params with the same name for one Processcase (except those which explicitly 
can occur multple times, such as "depends on" or "derived from").

Processcase:
* externalidentifier -> patient ID

ProcesscaseParameters (assuming Processcase <-> Krankenhausaufenthalt):
* Processcase ID
* Patient first name
* Patient last name
* Patient year of birth
* Patient month of birth
* Patient day of birth 
* Patient gender


ProcessCaseActivityParameters (assuming ProcesscaseActivity <-> KrankenhausAufenthaltsLeistung + Medikation):
* Medication name
* Medication dosage
* Name of operation
* MRT diagnosis
* CT diagnosis
* Localisation
* LDH marker

TODO how to reflect depencency for diagnoses? param for "depends on other activity"?
lowest common denominator for normalizing data (e. g. exzision)
matching patients?

**3. Export the data from the data integration model into MXML and submit the resulting MXML file.
One option to do so is using the SQLXML standard. (3 points)**  
* dsdsd