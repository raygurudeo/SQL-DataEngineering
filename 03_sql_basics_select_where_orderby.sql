-- This retrieves patients from New York and sorts them alphabetically by last name
select * from hospitaldb.hospital.patients where state='NY' order by last_name asc;

-- List all patients from California (CA)
select * from HOSPITALDB.hospital.patients where state='CA';

-- Find patients born after 2000
select * from HOSPITALDB.HOSPITAL.PATIENTS where date_of_birth > '2000-12-31';

-- Show all doctors in Valley Health
select * from hospitaldb.hospital.doctors where facility='Valley Health';

-- ---------------  Joins  --------------
-- <<<Show each patient with their assigned doctor’s specialty.>>> As there is no direct relation in between patient and doctor table we need to join patient to admission and then again with doctor table to get expected result.
select p.patient_id, p.first_name, p.last_name, d.first_name || ' ' || d.last_name as Doctor_Name, d.specialty from hospital.patients p join hospital.admissions a on p.patient_id=a.patient_id
join hospital.doctors d on a.doctor_id=d.doctor_id;

-- <<<List patients who have no admissions.>>> we need to get all the patient list and left join to admission table on the basis of patient_id then which ever patient will not have details in admission table that will become null in new joined table. then based on it we will give where condition with a.patient_id is null which will return expected result.
select p.patient_id, p.first_name || ' ' || p.last_name as Patient_Name from hospital.patients p 
left join hospital.admissions a on p.patient_id = a.patient_id where a.patient_id is null;

-- Show patients and their doctors (via admissions) 
select p.patient_id, p.first_name, p.last_name, d.first_name as Doctor_Name, d.specialty from HOSPITALDB.HOSPITAL.PATIENTS p join hospital.admissions a on p.patient_id=a.patient_id join hospital.doctors d on a.doctor_id = d.doctor_id;

