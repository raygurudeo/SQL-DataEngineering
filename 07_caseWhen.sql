-- Concept Explanation: 
-- • CASE WHEN → Conditional logic. 
-- • COALESCE → Replace NULLs with default. 
-- • EXPLAIN → Analyze query execution plan. 


-- CASE WHEN → Conditional logic. :  Think of it like an IF‑ELSE inside SQL, It lets you create new columns or conditions based on rules.

-- Classify patients’ bills as High if above 10,000, else Normal.
select p.patient_id,
p.first_name || ' ' || p.last_name as Patient_Name,
sum(b.total_charges) as Patient_Tolal_Bill,
CASE 
    WHEN sum(b.total_charges) > 10000 THEN 'High'  -- Checking patient bill if it crossed 10000
    ELSE 'Normal'
END AS bill_category     -- Added a new column bill_category
from hospital.patients p 
join hospital.admissions a on a.patient_id=p.patient_id
join hospital.billings b on b.admission_id=a.admission_id
group by p.patient_id, p.first_name, p.last_name;


-- Write a query to classify each patient’s total bill as - "High" if above 15,000, "Medium" if between 8,000 and 15,000, "Low" if below 8,000
select p.patient_id,
p.first_name || ' ' || p.last_name as Patient_Name,
sum(b.total_charges) as patient_total_bills,
CASE 
    WHEN sum(b.total_charges) > 15000 THEN 'High'
    WHEN sum(b.total_charges) < 15000 AND sum(b.total_charges) > 8000 THEN 'Medium'
    else 'Low'
END as bill_category
from hospital.patients p 
join hospital.admissions a on a.patient_id=p.patient_id
join hospital.billings b on b.admission_id=a.admission_id
group by p.patient_id, p.first_name, p.last_name;

-- Pass/Fail Billing Threshold - For each patient, show "Pass" if their total bill is above the hospital average, otherwise "Fail".
WITH patient_bill_threshold as ( -- Creating CTE to get patient details including total bill and bill threshold whether bill is greated than hospital average bill or not
    select p.patient_id,
    p.first_name || ' ' || p.last_name as Patient_Name,
    sum(b.total_charges) as Patient_Tolal_Bill,
    CASE 
        WHEN sum(b.total_charges) > (select avg(total_charges) from hospital.billings) THEN 'Pass' -- using subquery comparing patient total bill with hospital average bill.
        ELSE 'Fail'
    END as Bill_threshold -- creating new coulumn Bill_threshold
    from hospital.patients p 
    join hospital.admissions a on a.patient_id=p.patient_id
    join hospital.billings b on b.admission_id=a.admission_id
    group by p.patient_id, p.first_name, p.last_name
) select patient_id,
Patient_Name,
Patient_Tolal_Bill,
Bill_threshold
from PATIENT_BILL_THRESHOLD; -- fetching patient details including bill threshold from CTE.


-- prepare a dataset of patients with their total bills, average bill per admission, and a flag if they are above hospital average

WITH patient_data as (  -- CTE to get Patient Summary
    select p.patient_id,
    p.first_name || ' ' || p.last_name as Patient_Name,
    sum(b.total_charges) as Patient_Tolal_Bill,
    avg(b.total_charges) as Average_bill_pre_Admission,
    count(a.admission_id) as number_of_admission
    from hospital.patients p 
    join hospital.admissions a on a.patient_id=p.patient_id
    join hospital.billings b on b.admission_id=a.admission_id
    group by p.patient_id, p.first_name, p.last_name
), hospital_avg_bill as (     -- CTE to get overall hospital average bill
    select avg(total_charges) hospital_avg
    from hospital.billings
) select patient_id, -- Main query to show patient details and add flag if patient average bill across the admission is higher that hospital average or not using CASE WHEN
pd.Patient_Name,
pd.number_of_admission,
pd.Average_bill_pre_Admission,
pd.Patient_Tolal_Bill,
CASE 
    WHEN pd.Average_bill_pre_Admission > hav.hospital_avg THEN 'High'
    ELSE 'Low'
END as Bill_threshold,
rank() over (order by Average_bill_pre_Admission desc) as patient_avg_bill_rank  -- Ranked patient based on their average hospital bill
from patient_data pd, hospital_avg_bill hav;


