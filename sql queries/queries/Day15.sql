--1.Join patients, staff, and staff_schedule to show patient service and staff availability.
SELECT p.patient_id, p.name as patient_name,
p.age as patient_age,p.service AS patient_service,
s.staff_id,s.staff_name,s.role as staff_role,
ss.week as SS_week,ss.present as Staff_present
FROM patients p
LEFT JOIN staff s
ON p.service = s.service
LEFT JOIN staff_schedule ss
ON s.staff_id = ss.staff_id
ORDER BY p.patient_id, s.staff_id, ss.week;

--2.Combine services_weekly with staff and staff_schedule for comprehensive service analysis.
SELECT sw.week,sw.service,
s.staff_id,s.staff_name,
s.role,ss.present AS staff_present
FROM services_weekly sw
LEFT JOIN staff s
ON sw.service = s.service
LEFT JOIN staff_schedule ss
ON s.staff_id = ss.staff_id
AND sw.week = ss.week
ORDER BY sw.service, sw.week, s.staff_id;

--3.Create a multi-table report showing patient admissions with staff information.
SELECT p.patient_id,p.name AS patient_name, 
p.age,p.arrival_date,p.departure_date,
p.service AS patient_service,p.satisfaction,
st.staff_id,st.staff_name,st.role,
st.service AS staff_service,
ss.week,ss.present
FROM patients p
LEFT JOIN staff st
ON p.service = st.service
LEFT JOIN staff_schedule ss
ON st.staff_id = ss.staff_id;

/*Challenge:
Question: Create a comprehensive service analysis report for week 20 showing:
service name, total patients admitted that week, total patients refused,
average patient satisfaction, count of staff assigned to service, and 
count of staff present that week. Order by patients admitted descending.
*/
SELECT
sw.service,sw.patients_admitted AS total_admitted,
sw.patients_refused AS total_refused,
ROUND(AVG(p.satisfaction),3) AS avg_satisfaction,
COUNT(DISTINCT s.staff_id) AS staff_assigned,
COUNT(DISTINCT CASE WHEN ss.present=1 THEN ss.staff_id END)
AS staff_present_week20
FROM services_weekly sw
LEFT JOIN patients p
ON sw.service = p.service AND DATE_PART('week', p.arrival_date) = 20
LEFT JOIN staff s
ON sw.service=s.service
LEFT JOIN staff_schedule ss
ON s.staff_id = ss.staff_id AND ss.week = 20
WHERE sw.week = 28
GROUP BY sw.service,sw.patients_admitted,sw.patients_refused
ORDER BY sw.patients_admitted DESC;
