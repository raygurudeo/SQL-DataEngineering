-- Window Function Concept Explanation:
-- • ROW_NUMBER → Sequential number per row. 
-- • RANK → Ranking with gaps for ties. 
-- • DENSE_RANK → Ranking without gaps. 
-- • LAG/LEAD → Compare current row with previous/next. 
-- • PARTITION BY → Divide data into groups for window calculations. 

-- Ranking patients by age. 
select first_name || ' ' || last_name as Patient_Name,
date_of_birth,
rank() over (order by date_of_birth desc) as Age_Rank
from hospital.patients;

-- Top 10 patients by billing. 
select p.patient_id,
p.first_name || ' ' || p.last_name as Patient_Name,
sum(b.total_charges) as Total_Bill,
rank() over (order by Total_Bill desc) as Billing_Rank
from hospital.patients p 
join hospital.admissions a on a.patient_id=p.patient_id
join hospital.billings b on b.admission_id=a.admission_id
group by p.patient_id, p.first_name, p.last_name
ORDER BY billing_rank
limit 10;

-- List each admission for a patient with a sequential number
-- Shows admission history with numbering per patient.
select p.patient_id,
p.first_name || ' ' || p.last_name as Patient_Name,
a.admission_date,
row_number() over (partition by p.patient_id order by a.admission_date) as admission_number
from hospital.patients p 
join hospital.admissions a on a.patient_id=p.patient_id;

-- DENSE_RANK – Doctors by Admissions
-- Rank doctors by number of admissions, without gaps.
select d.doctor_id,
d.first_name || ' ' || d.last_name as Doctor_Name,
count(a.admission_id) as Total_Admissions,
dense_rank() over (order by count(a.admission_id) desc) as Doctor_Rank
from hospital.doctors d 
join hospital.admissions a on a.doctor_id=a.doctor_id
group by d.doctor_id, d.first_name, d.last_name
order by Doctor_Rank;

-- LAG – Compare Current vs Previous Billing
-- Show each patient’s billing and their previous bill.
-- LAG() looks backward to the previous row’s value in a dataset, based on the order you define.
-- With PARTITION BY, it does this separately for each group (like each patient), showing the last admission or billing record before the current one.
select p.patient_id,
p.first_name || ' ' || p.last_name as Patient_Name,
b.total_charges as current_bill,
LAG(b.total_charges) over (partition by p.patient_id order by b.billing_id) as previous_bill
from hospital.patients p 
join hospital.admissions a on a.patient_id=p.patient_id
join hospital.billings b on b.admission_id=a.admission_id;

-- LEAD – Next Appointment Date
-- Show each patient’s admission date and their next scheduled admission.
-- LEAD() looks forward to the next row’s value in a dataset, based on the order you define
-- With PARTITION BY, it does this separately for each group (like each patient), showing the next admission or billing record.
select p.patient_id,
p.first_name || ' ' || p.last_name as Patient_Name,
a.admission_date,
LEAD(a.admission_date) over (partition by p.patient_id order by a.admission_date) as Next_Appointment
from hospital.patients p 
join hospital.admissions a on a.patient_id=p.patient_id;

-- PARTITION BY – Average Billing per Facility
-- Calculate average billing per facility, but show it alongside each admission.
-- PARTITION BY divides data into groups (here by facility).
-- The window function (like AVG) calculates a value for each group and shows it alongside every row in that group.
select d.facility,
a.admission_id,
b.total_charges,
avg(b.total_charges) over (partition by d.facility) as Average_Billing
from hospital.admissions a 
join hospital.doctors d on d.doctor_id=a.doctor_id
join hospital.billings b on b.admission_id=a.admission_id;