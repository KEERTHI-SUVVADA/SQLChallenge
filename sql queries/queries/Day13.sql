--1.Join patients and staff based on their common service field (show patient and staff who work in same service).
SELECT p.patient_id,p.name,p.age,s.staff_id,s.staff_name,s.role,p.service
FROM patients p INNER JOIN staff s
ON p.service=s.service
ORDER BY p.service,p.name;

--2.Join services_weekly with staff to show weekly service data with staff information.
select se.week,se.month,se.service,se.event,st.staff_id,st.staff_name,st.role
FROM services_weekly se INNER JOIN staff st 
ON st.service=se.service;

--3.Create a report showing patient information along with staff assigned to their service.
SELECT p.patient_id,p.name,p.age,p.arrival_date,p.departure_date,p.service,p.satisfaction,s.staff_id,s.staff_name
FROM patients p INNER JOIN staff s
ON p.service=s.service;

/*
Challenge:
Question: Create a comprehensive report showing patient_id, patient name, age, service,
and the total number of staff members available in their service. 
Only include patients from services that have more than 5 staff members. 
Order by number of staff descending, then by patient name.
*/

SELECT p.patient_id,p.name,p.age,p.service,COUNT(s.staff_id) AS staff_available
FROM patients p INNER JOIN staff s
ON p.service=s.service
GROUP BY p.patient_id,p.name,p.age,p.service
HAVING COUNT(s.staff_id)>5
ORDER BY staff_available DESC , p.name;






