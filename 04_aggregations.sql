-- ----------------------- Aggregations (sum(), avg(), max(), min(), count(), group by, having)  --------------

-- Count patients by gender.
select gender, count(gender) as Patient_Count
from hospital.patients
group by gender;

-- Find the least common blood type. <<We need find least count of a blood type across the patients.>>
select BLOOD_TYPE, count(BLOOD_TYPE) as COUNT_OF_EACH_BLOOD_TYPE
from hospital.PATIENTS
group by BLOOD_TYPE
order by COUNT_OF_EACH_BLOOD_TYPE asc
limit 1;

-- Calculate total billing per facility.
select d.facility, sum(b.total_charges) as Total_Billing
from hospital.doctors d 
join hospital.admissions a on d.doctor_id=a.doctor_id
join hospital.billings b on b.admission_id=a.admission_id
group by d.facility;


-- Count how many admissions happened in each facility.
select d.facility, count(a.admission_id) as total_admissions
from hospital.doctors d 
join hospital.admissions a 
on d.doctor_id = a.doctor_id 
group by d.facility
ORDER BY total_admissions DESC;

-- Average Billing Amount per Insurance Provider
select insurance_provider, ROUND(avg(amount_paid_by_insurance),2) as Average_Amount
from hospital.billings
group by insurance_provider
order by Average_Amount desc;

-- Highest and Lowest Billing per Patient
select p.patient_id, p.first_name || ' ' || p.last_name as Patient_Name,
max(b.total_charges) as Highest_Bill,
min(b.total_charges) as Lowest_Bill
from hospital.patients p 
join hospital.admissions a on p.patient_id=a.patient_id
join hospital.billings b on b.admission_id=a.admission_id
group by p.patient_id, p.first_name, p.last_name;

-- Top 3 Doctors by Total Billing
select d.doctor_id, 
d.first_name || ' ' || d.last_name as Doctor_Name,
sum(b.total_charges) as Total_Bill
from hospital.doctors d 
join hospital.admissions a on d.doctor_id=a.doctor_id
join hospital.billings b on b.admission_id=a.admission_id
group by d.doctor_id, d.first_name, d.last_name
order by Total_Bill desc
limit 3;

-- Patients with More Than 2 Admissions
select p.patient_id,
p.first_name || ' ' || p.last_name as Patient_Name,
count(a.admission_id) as total_admissions
from hospital.patients p 
join hospital.admissions a on p.patient_id=a.patient_id
group by p.patient_id, p.first_name, p.last_name
having count(a.admission_id) > 2
order by total_admissions asc;

-- Average Length of Stay per Facility <<<datediff()>>>>
select d.facility, 
avg(datediff(day, a.admission_date, a.discharge_date)) as Average_Stay
from hospital.doctors d 
join hospital.admissions a on a.doctor_id=d.doctor_id
group by d.facility;

