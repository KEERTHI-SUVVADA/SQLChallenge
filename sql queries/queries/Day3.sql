--1.List all patients sorted by age in descending order.
SELECT * 
from patients 
ORDER BY age DESC;

--2.Show all services_weekly data sorted by week number ascending and patients_request descending.
SELECT *
from services_weekly
ORDER BY week ASC, patients_request DESC;

--3.Display staff members sorted alphabetically by their names.
SELECT * 
from staff
ORDER BY staff_name ASC;

--Challenge: Retrieve the top 5 weeks with the highest patient refusals across all services, showing week, service, patients_refused, and patients_request. Sort by patients_refused in descending order.
SELECT week, service, patients_refused, patients_request 
from services_weekly 
ORDER BY patients_refused DESC
LIMIT 5;