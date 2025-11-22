--1.Show each patient with their service's average satisfaction as an additional column.
SELECT p.patient_id,p.name,p.service,p.satisfaction AS personal_satisfaction,
(SELECT ROUND (AVG(satisfaction),0)
FROM patients AS p2
WHERE p2.service = p.service) AS service_avg_satisfaction
FROM patients AS p
ORDER BY p.service, 
p.satisfaction DESC;

--2.Create a derived table of service statistics and query from it.
SELECT p.service,p.total_patients,p.avg_age,p.avg_satisfaction
FROM (SELECT service,
COUNT (patient_id) AS total_patients,
ROUND (AVG(age), 0) AS avg_age,
ROUND (AVG(satisfaction)) AS avg_satisfaction
FROM patients
GROUP BY service) AS P;

--3.Display staff with their service's total patient count as a calculated field.
SELECT s.staff_id,s.staff_name,s.role,s.service,
(SELECT COUNT(patient_id)
FROM patients AS p
WHERE p.service = s.service) AS service_patient_count
FROM staff AS s;

/*
Challenge:
Question: Create a report showing each service with: service name, total patients admitted,
the difference between their total admissions and the average admissions across all services,
and a rank indicator ('Above Average', 'Average', 'Below Average'). Order by total patients admitted descending.
*/
SELECT s.service,s.total_admitted,
CASE WHEN s.total_admitted > overall.avg_admitted THEN 'Above Average'
WHEN s.total_admitted = overall.avg_admitted THEN 'Average'
ELSE 'Below Average' END AS rank_indicator
FROM (SELECT service,SUM(patients_admitted) AS total_admitted
FROM services_weekly
GROUP BY service) AS s
CROSS JOIN (SELECT ROUND (AVG(total_admitted), 0) AS avg_admitted
FROM (SELECT SUM(patients_admitted) AS total_admitted
FROM services_weekly
GROUP BY service) AS s) AS overall
ORDER BY s.total_admitted DESC;