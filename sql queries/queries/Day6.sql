--1.Count the number of patients by each service.
SELECT service, COUNT(*)
FROM patients
GROUP BY service;

--2.Calculate the average age of patients grouped by service.
SELECT service ,ROUND(AVG(age),3) AS avg_age
FROM patients
GROUP BY service;

--3.Find the total number of staff members per role.
SELECT role, COUNT(*)
FROM staff
GROUP BY role;

/*
Challenge:
Question: For each hospital service, calculate the total number of patients admitted, total patients refused, 
and the admission rate (percentage of requests that were admitted). Order by admission rate descending.
*/

SELECT service, 
SUM(patients_admitted) AS patients_admitted,
SUM(patients_refused) AS patients_refused, 
SUM(patients_admitted)*100/SUM(patients_request) AS admission_rate
FROM services_weekly
GROUP BY service
ORDER BY admission_rate DESC;
