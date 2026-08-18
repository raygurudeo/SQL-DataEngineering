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






-- Window Functions Explained Simply
-- 1. ROW_NUMBER
-- What it does: Gives a sequential number to each row in the result set.

-- Use case: Number admissions per patient in order.

-- Think of it as: “Give me a running serial number.”

-- 2. RANK
-- What it does: Assigns rank based on order, but leaves gaps if there are ties.

-- Example: If two patients share the highest bill, both get rank 1, and the next patient gets rank 3.

-- Think of it as: “Rank with gaps when values tie.”

-- 3. DENSE_RANK
-- What it does: Similar to RANK, but no gaps for ties.

-- Example: Two patients share rank 1, the next patient gets rank 2 (not 3).

-- Think of it as: “Rank without gaps.”

-- 4. LAG
-- What it does: Looks at the previous row’s value.

-- Use case: Compare current bill with the last bill.

-- Think of it as: “What came just before this row?”

-- 5. LEAD
-- What it does: Looks at the next row’s value.

-- Use case: Show the next scheduled admission date for a patient.

-- Think of it as: “What comes after this row?”

-- 6. PARTITION BY
-- What it does: Splits data into groups, and applies the window function separately to each group.

-- Use case: Calculate average billing per facility, but show it alongside each admission.

-- Think of it as: “Do the calculation group by group, but still show every row.”

-- 📊 How to Apply During Exercises
-- Step 1: Decide if you need numbering, ranking, or comparison.

-- Step 2: Choose the right function:

-- Sequential → ROW_NUMBER

-- Ranking → RANK or DENSE_RANK

-- Compare with previous → LAG

-- Compare with next → LEAD

-- Grouped calculation → PARTITION BY

-- Step 3: Always pair with ORDER BY inside the window function to control the sequence.

-- Step 4: Use PARTITION BY when you want the logic applied separately for each patient, doctor, or facility.

-- 👉 In short:

-- ROW_NUMBER → serial numbers

-- RANK/DENSE_RANK → ranking with/without gaps

-- LAG/LEAD → look back/look forward

-- PARTITION BY → group-wise calculations