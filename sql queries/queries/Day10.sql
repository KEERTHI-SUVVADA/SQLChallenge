--1.Categorise patients as 'High', 'Medium', or 'Low' satisfaction based on their scores.
SELECT * ,
CASE
	WHEN satisfaction>=80 THEN 'HIGH'
	WHEN satisfaction>=60 THEN 'MEDIUM'
	ELSE 'LOW'
END AS satisfaction_category
FROM patients;

--2.Label staff roles as 'Medical' or 'Support' based on role type.
SELECT staff_id, staff_name,
CASE 
	WHEN role IN('doctor','nurse') THEN 'Medical'
	ELSE 'Support'
END AS staff_role_category
FROM staff;

--3.Create age groups for patients (0-18, 19-40, 41-65, 65+).
SELECT patient_id, name, age,
CASE
	WHEN age>=0 AND age<=18 THEN 'Minor'
	WHEN age>=19 AND age<=40 THEN 'Adult'
	WHEN age>=41 AND age<=65 THEN 'Middile Age'
	ELSE 'Senior'
END AS age_category
FROM patients;

/*
Challenge:
Question: Create a service performance report showing service name, total patients admitted,
and a performance category based on the following: 'Excellent' if avg satisfaction >= 85,
'Good' if >= 75, 'Fair' if >= 65, otherwise 'Needs Improvement'. Order by average satisfaction descending.
*/

SELECT service,
SUM(patients_admitted) AS total_patients_admitted,
ROUND(AVG(patient_satisfaction),3) AS avg_satisfaction,
CASE
	WHEN AVG(patient_satisfaction)>=85 THEN 'Excellent'
	WHEN AVG(patient_satisfaction)>=75 THEN 'Good'
	WHEN AVG(patient_satisfaction)>=65 THEN 'Fair'
	ELSE 'Needs Improvement'
END AS performance_category
FROM services_weekly
GROUP BY service
ORDER BY avg_satisfaction DESC;












