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

-- List each admission with patient name and doctor name <<<Example for inner join or only join. As we want each admission details with patient name and doctor name. SO in that case we don't want a admission without patient name and doctor name so I used inner join. If we need all admission even if doctor or patient details are not present for that admission then we can use left join>>>
select a.admission_id, a.admission_date, p.first_name || ' ' || p.last_name as Patient_Name, d.first_name || ' ' || d.last_name as Doctor_Name from hospital.admissions a
join patients p on a.patient_id = p.patient_id
join doctors d on a.doctor_id = d.doctor_id;

-- Show all bills with patient name and insurance provider.
select a.admission_id,
b.billing_id,
p.first_name || ' ' || p.last_name as Patient_Name,
b.insurance_provider, 
b.total_charges, 
b.amount_paid_by_insurance, 
b.payment_status from hospital.billings b
join hospital.admissions a on b.admission_id = a.admission_id
join hospital.patients p on a.patient_id = p.patient_id;

-- Find doctors who treated patients from California
select d.first_name || ' ' || d.last_name as Doctor_Name,
p.first_name || ' ' || p.last_name as Patient_Name,
p.state
from hospital.doctors d
join hospital.admissions a on d.doctor_id=a.doctor_id
join hospital.patients p on p.patient_id=a.patient_id
where p.state='CA';