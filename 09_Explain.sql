-- <<<<<<<<<<<<<<<<<<<<<<<<<<<< EXPLAIN  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- EXPLAIN shows the execution plan — the steps the database engine will take to run your query.
-- It doesn’t return data; instead, it returns metadata about how the query will be executed.
-- Useful for performance tuning: you can see if indexes are used, if there are full table scans, or if joins are expensive.


-- When you ask the database: “How many patients are there?”, the database has to plan the steps before actually running it.
-- EXPLAIN shows those steps.

-- Example:
-- Imagine you ask a librarian: “How many books are in this shelf?”
-- Generator = the assistant who walks along the shelf and counts each book.
-- Result = the librarian who takes the number and tells you: “There are 5000 books.”
-- GlobalStats = the library’s note saying: “This shelf is small, no extra helpers needed.”

EXPLAIN
select count(patient_id) as total_patient from patients;


EXPLAIN
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


-- Key Takeaway
-- TableScan = reading raw data.
-- Join = combining tables.
-- Aggregate = calculating totals/averages.
-- CartesianJoin = combining with hospital average (single row).
-- WindowFunction = ranking patients.
-- Result = final output.

