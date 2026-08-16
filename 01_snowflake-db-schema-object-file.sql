select current_role();
use role accountadmin;

-- Step 1: Create Database
CREATE DATABASE HospitalDB;
-- Step 2: Create Schema
CREATE SCHEMA hospital;
-- Step 3: Create Patients Table
CREATE TABLE hospital.patients (
    patient_id VARCHAR(20) PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    gender VARCHAR(20),
    date_of_birth DATE,
    blood_type VARCHAR(5),
    state VARCHAR(50)
);
-- Step 4: Create Doctors Table
CREATE TABLE hospital.doctors (
    doctor_id VARCHAR(20) PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    specialty VARCHAR(50),
    facility VARCHAR(100)
);
-- Step 5: Create Billings Table
-- (Assuming columns: billing_id, patient_id, doctor_id, amount, billing_date)
CREATE OR REPLACE TABLE HospitalDB.hospital.billings (
    billing_id VARCHAR PRIMARY KEY,              -- Unique billing record ID
    admission_id VARCHAR,                        -- Links to admissions table
    insurance_provider STRING,                  -- Name of insurance provider or 'Self-Pay'
    total_charges NUMBER(10,2),                 -- Total billed amount
    amount_paid_by_insurance NUMBER(10,2),      -- Amount covered by insurance
    payment_status VARCHAR                       -- e.g., 'Paid', 'Partially Paid', 'Pending'
    
);

-- Step 6: Create Admissions Table
-- (Assuming columns: admission_id, patient_id, doctor_id, facility, admission_date, discharge_date)
CREATE OR REPLACE TABLE HospitalDB.hospital.admissions (
    admission_id VARCHAR PRIMARY KEY,      -- Unique admission record ID
    patient_id VARCHAR(20),                    -- Links to patients table
    doctor_id VARCHAR(20),                     -- Links to doctors table
    admission_date DATE,                  -- Date of patient admission
    discharge_date DATE,                  -- Date of discharge
    diagnosis VARCHAR,                     -- Medical diagnosis (e.g., Asthma, Fracture)
    treatment VARCHAR,                     -- Treatment provided (e.g., Surgery, Medication)
    discharge_status VARCHAR,               -- e.g., 'Discharged', 'Under Observation'
    FOREIGN KEY (patient_id) REFERENCES hospital.patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES hospital.doctors(doctor_id)
);
