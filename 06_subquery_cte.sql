-- Subquery → A query inside another query, used to filter or calculate intermediate results.
-- Wnen to use:  Filtering with dynamic values (above average, below max, etc.),  Checking existence (WHERE EXISTS (...)),  Comparing against another dataset (IN (...))

-- (Patients with bills > average bill)  <<The inner query calculates the average bill, and the outer query finds patients with bills above that average.>>

select p.patient_id,
p.first_name || ' ' || p.last_name as Patient_Name,
b.total_charges as Patient_Bill,
from hospital.patients p 
join hospital.admissions a on a.patient_id=p.patient_id
join hospital.billings b on b.admission_id=a.admission_id
where b.total_charges > (select avg(total_charges) from hospital.billings);

-- Subquery Exampl 2 - Find patients admitted to “City Medical Center.”
select p.patient_id,
p.first_name || ' ' || p.last_name as Patient_Name,
d.facility
from hospital.patients p 
join hospital.admissions a on a.patient_id=p.patient_id
join hospital.doctors d on d.doctor_id=a.doctor_id
where a.doctor_id in (select doctor_id from hospital.doctors where facility='City Medical Center');


-- CET:---------------------------------------------
-- CTE (WITH) → A named temporary result set that makes complex queries easier to read and reuse. You define a query once, give it a name, and reuse it in the main query.
-- Wnen to use : Complex queries with multiple steps, When readability matters (interviews, production code), When you want to reuse the same logic multiple times in one query.

-- CTE : Find patients admitted to “City Medical Center.”
with patient_with_city_medical_center as (
    select p.patient_id,
    p.first_name || ' ' || p.last_name as Patient_Name,
    d.facility as hospital_name
    from hospital.patients p 
    join hospital.admissions a on a.patient_id=p.patient_id
    join hospital.doctors d on d.doctor_id=a.doctor_id
    where d.facility='City Medical Center'
) select patient_id,
Patient_Name,
hospital_name
from patient_with_city_medical_center;

-- CTE : Build a list of patients with total bills.
with patient_with_total_bills as (
    select p.patient_id,
    p.first_name || ' ' || p.last_name as Patient_Name,
    sum(b.total_charges) as total_bills
    from hospital.patients p 
    join hospital.admissions a on a.patient_id=p.patient_id
    join hospital.billings b on b.admission_id=a.admission_id
    group by p.patient_id, p.first_name, p.last_name
) select patient_id,
Patient_Name,
total_bills
from patient_with_total_bills;


-- CTE: Rank patients by bill amount (Total billing per patient, then rank them).
with patient_with_total_bills as (
    select p.patient_id,
    p.first_name || ' ' || p.last_name as Patient_Name,
    sum(b.total_charges) as total_bills
    from hospital.patients p 
    join hospital.admissions a on a.patient_id=p.patient_id
    join hospital.billings b on b.admission_id=a.admission_id
    group by p.patient_id, p.first_name, p.last_name
) select patient_id,
Patient_Name,
total_bills,
rank() over (order by total_bills desc) as patient_rank
from patient_with_total_bills;

-- Combine: Use a CTE to calculate patient totals, then a subquery to compare each patient against the overall average.
with patient_with_total_bills as ( 
    select p.patient_id,
    p.first_name || ' ' || p.last_name as Patient_Name,
    sum(b.total_charges) as total_bills
    from hospital.patients p 
    join hospital.admissions a on a.patient_id=p.patient_id
    join hospital.billings b on b.admission_id=a.admission_id
    group by p.patient_id, p.first_name, p.last_name
) select patient_id,  
Patient_Name,
total_bills
from patient_with_total_bills
where total_bills > (select avg(total_charges) from hospital.billings) 
order by total_bills desc;


-- Scenario: “Find top 3 patients whose bill is above average, ranked by charges.”
with patient_with_total_bills as (  -- first queried patients with total bills with rank
    select p.patient_id,
    p.first_name || ' ' || p.last_name as Patient_Name,
    sum(b.total_charges) as total_bills,
    rank() over (order by sum(b.total_charges) desc) as total_bill_rank  -- bills with rank
    from hospital.patients p 
    join hospital.admissions a on a.patient_id=p.patient_id
    join hospital.billings b on b.admission_id=a.admission_id
    group by p.patient_id, p.first_name, p.last_name
) select patient_id, -- queried top 3 patients whose total bill is more than hospital average bill
Patient_Name,
total_bills,
total_bill_rank
from patient_with_total_bills
where total_bills > (select avg(total_charges) from hospital.billings) -- used subquery to find hospital average bill
order by total_bills desc
limit 3;


