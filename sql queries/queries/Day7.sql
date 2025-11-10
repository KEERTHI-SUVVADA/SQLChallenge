--1.Find services that have admitted more than 500 patients in total.
SELECT service, SUM(patients_admitted) total_patients_admitted
FROM services_weekly 
GROUP BY service
HAVING SUM(patients_admitted)>500;

--2.Show services where average patient satisfaction is below 75.
SELECT service, ROUND(AVG(patient_satisfaction),3) AS avg_patient_satisfaction
FROM services_weekly
GROUP BY service
HAVING AVG(patient_satisfaction)<80;

--3.List weeks where total staff presence across all services was less than 50.
SELECT week, sum(present) as total_present_staff
from staff_schedule
group by week
having sum(present)<50;

/*Challenge:
Question: Identify services that refused more than 100 patients in total and had an average patient satisfaction below 80.
Show service name, total refused, and average satisfaction.
*/

select service, sum(patients_refused) as total_patients_refused, ROUND(avg(patient_satisfaction),2) as avg_patient_satisfaction
from services_weekly
group by service
having sum(patients_refused)>100 AND avg(patient_satisfaction)<80;