--1.Count the total number of patients in the hospital.
SELECT COUNT(patient_id) 
AS no_of_patients
FROM patients;

--2.Calculate the average satisfaction score of all patients.
SELECT AVG(satisfaction)
AS satsifaction_avg
FROM patients;

--3.Find the minimum and maximum age of patients.
SELECT MIN(age) 
AS min_age,
MAX(age)
AS max_age
FROM patients;

/*Challenege:
Question: Calculate the total number of patients admitted, total patients refused, and the average patient satisfaction across
all services and weeks. Round the average satisfaction to 2 decimal places.
*/
SELECT COUNT(patients_admitted)
AS no_of_patients_admitted,
COUNT(patients_refused)
AS tot_patients_refused,
ROUND(AVG(patient_satisfaction),2)
AS avg_satifaction
FROM services_weekly
