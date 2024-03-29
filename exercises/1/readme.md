# Business Intelligence - Exercise 1: Data Transformation and Integration
**Author: Raphael Mitsch (a1006529).**

### Notes
* The original SQL code was translated to a SQLite dialect using https://www.jooq.org/translate/.
* I was not aware which role the attribute `ProcesscaseActivity.timeprecision` is supposed to play. I hence ignored it. 
* Similar with the table `PossibleValue` - it seems impractical at best and impossible at worst to fill a table with all 
possible values for non-finite sets (e. g. arbitrary patient names). Most likely I misunderstood the purpose of this 
table; I ignored it.
* The resulting SQLite database and .mxml log are included in the uploaded archive. To reproduce the results please be 
referred to the next section (_Usage_). 

## Usage

1. Set up Conda environment using provided `environment.yml` and activate it.
2. Generate the import script with `python import.py -i /path/to/DermatologischePatientendaten.xls > data.sql`. 
3. Apply the generated import script with an arbitrary SQLite database tool (i. e. _SQLite Studio_ or any programmatic 
SQLite client API).
4. Store the resulting database as `data.sqlite` in the same folder as `generate_mxml.py`.
5. Generate the .mxml file using `generate_mxml.py > log.mxml`.


## Tasks

Abbreviations used in the following:
* ProcesscaseActivity: PCA.
* Processcase: PC.

**1. Create a list of problems and assumptions when/for doing the integration. (2 points)**

##### Problems

* Some of assumptions made are guaranteed to misrepresent the data (e. g. assuming date and times where 
these are not available) but might be considered useful in converging to a useful integrated data model in terms of 
stability and comparability.
* `Lokalisation Fermetastasen` is suppossed to depend on MRT and CT, but not all cases provide both and yet have been 
assigned a diagnosis.
* Some records possess data records others do not - so we either discard the additional data or conceive a structure 
that allows additional data to be stored optionally. E. g.: Patients are associated with their full birthdate in the 
spreadsheet, but only their birth year in the database.
* The two data sources have diverging sets of activities.
* The type of the activities is not always clear - e. g. how are `Primärexzision` and `Histologische Exzision` related? 
Are they both operations? Examinations? Both? Domain knowledge is clearly lacking on my side.

##### Assumptions

Note that all assumptions are valid only for the provided data set and might not be reasonably extended to unseen data
with diverging (dependencies between) attribute values. 

_General assumptions_:
* Patients in spreadsheet and database are treated as different entities, since their cases don't obviously overlap and 
hence we can't reasonably assume they are the same persons.
* Data consistency w.r.t. to usage of parameters will be guaranteed at runtime / when new data is entered.
* Examination (e. g. CT) and diagnosis are considered to be two different activities to allow modeling dependencies 
between dependencies and multiple examinations (e. g. `Lokalisation Fernmetastasen` is derived from  MRI & CT 
examinations) in the predetermined integration model.
* `Primärexzision` is considered both an operation and an examination, since the `Localisation` property is derived from 
it.
* The patient-to-column structure in the spreadsheet precludes more than one ProcesscaseActivity of the same type and 
the same name (i. e. an examination of type `Labor`) for one patient on one day occuring there - i. e. multiple values 
in one cell are not permitted.
* `Therapie` as used in the spreadsheet is considered to be a medication that takes place during a hospital stay.

_Assumptions w.r.t. date and time (followed from top to bottom)_:
* One PA might be contained in another (e. g. a medication takes place during a hospital stay), but PAs must not overlap
or take place at the same instant.
* If a PCA's date is not known (e. g. in case of `KrankenhausaufenthaltLeistung` in database), we assume the date and 
time of this patient's admission into the hospital as date for the corresponding PCA.
* If a PCA's start time is not known (e. g. for `Therapiesitzung` in the spreadsheet), it 
is assumed to be 00:00 on the corresponding day.
* If a PCA's end time is not known (e. g. for `Medikation` in the database), it is considered to be the same as the end time. While this is guaranteed to be not 
correct, since no action can take place instantaneously, it allows fitting the data into the supplied immutable data 
structure while maintaining a property that can be exploited to locate records which where imported with those 
attributes missing). 
* Regarding operations contained in the spreadsheet: 
  * The time span between `Erstuntersuchung` and `Histologische Primärexzision` to be one hospital stay. Other 
  activities, such as `MRT Diagnose`, are considered to be check-ups that take place after the original hospital stay 
  has been completed.
  * All other date fields are assumed to reflect one operation each. Both operation and stay in the hospital are in 
  line with the assumptions made above to allow for identification and rectification of those insufficiently specified 
  timeframes. 
* Diagnoses are assumed to have been made at the same time as the latest necessary examination.

**2. Integrate the data into the given data integration model from Figure 1. (4 points)**  

See `import.py`. The `pandas` package is utilized to read and integrate data from the spreadsheet.

**3. Export the data from the data integration model into MXML and submit the resulting MXML file.
One option to do so is using the SQLXML standard. (3 points)**  

See `generate_mxml.py`. The .mxml file is generated in the Python script; SQLXML was not used.