
--<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< COALESCE (Handling NULLs) >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--COALESCE is used to replace NULL values with a default.
--It’s very common in data engineering because real‑world data often has missing values.
-- Syntax :  COALESCE(column_name, default_value)


-- Some patients don’t have a middle name, and some admissions may not have billing records yet. We need to replace the the Middle name null value with N/A and if total bill is nothing then relace with 0.
-- This is a very common data engineering pattern: replacing missing values with defaults before loading data into reports or pipelines

select p.patient_id,
p.first_name || ' ' || p.last_name as Patient_Name,
coalesce(sum(b.total_charges), 0) as patient_total_bill  -- Basically we can use when we try to left join then there will be many patients with no bills so in this case we can replace those null value with 0 so future calculations will be fine on this.
from hospital.patients p 
left join hospital.admissions a on a.patient_id=p.patient_id
left join hospital.billings b on b.admission_id=a.admission_id
group by p.patient_id, p.first_name, p.last_name;



