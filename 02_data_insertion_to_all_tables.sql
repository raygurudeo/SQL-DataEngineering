-- Creating internal named stage to load data from local to stage.
create or replace stage hospitaldb.hospital.hospitalstage file_format=(type=csv skip_header=1);
list @hospitalstage;

-- loading patients data from stage to patients table
describe table hospitaldb.hospital.patients;
select * from hospitaldb.hospital.patients;
copy into HOSPITALDB.HOSPITAL.PATIENTS from @HOSPITALDB.HOSPITAL.hospitalstage/patients.csv.gz file_format=(type=csv skip_header=1) on_error='ABORT_STATEMENT';

-- loading doctors data from stage to doctors table
describe table hospitaldb.hospital.doctors;
select * from hospitaldb.hospital.doctors;
copy into hospitaldb.hospital.doctors from @hospitaldb.hospital.hospitalstage/doctors.csv.gz file_format=(type=csv skip_header=1) on_error='ABORT_STATEMENT';


-- loading billings data from stage to billings table
describe table hospitaldb.hospital.billings;
select * from hospitaldb.hospital.billings;
copy into hospitaldb.hospital.billings from @hospitaldb.hospital.hospitalstage/billings.csv.gz file_format=(type=csv skip_header=1) on_error='ABORT_STATEMENT';

-- loading admissions data from stage to admissions table
describe table hospitaldb.hospital.admissions;
select * from hospitaldb.hospital.admissions;
copy into hospitaldb.hospital.admissions from @hospitaldb.hospital.hospitalstage/admissions.csv.gz file_format=(type=csv skip_header=1) on_error='ABORT_STATEMENT';



-- Snow cli steps:
use role GURU_ROLE_RW;
use database HOSPITALDB;
use schema HOSPITAL;
-- To upload all hospital related csv file to hospital stage;
PUT file://///mnt/e/Data_Engineering/files/* @hospitalstage;

