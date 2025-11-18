--1.Show all staff members and their schedule information (including those with no schedule entries).
SELECT
    s.staff_id,
    s.staff_name,
    ss.week,
    ss.service,
    COALESCE(CAST(ss.present AS TEXT), 'No Schedule') AS weeks_present
FROM staff s
LEFT JOIN staff_schedule ss ON s.staff_id = ss.staff_id;

--2.List all services from services_weekly and their corresponding staff (show services even if no staff assigned).
SELECT se.service, st.staff_id,st.staff_name
FROM services_weekly se LEFT JOIN staff st on se.service=st.service;

--3.Display all patients and their service's weekly statistics (if available).
SELECT
	p.patient_id, p.name,p.age,
    sw.service,
    sw.week
FROM services_weekly sw
LEFT JOIN patients p ON sw.service = p.service;

/*
Challenge:
Question: Create a staff utilisation report showing all staff members (staff_id, staff_name, role, service)
and the count of weeks they were present (from staff_schedule). Include staff members even if they have no
schedule records. Order by weeks present descending.
*/
SELECT s.staff_id, s.staff_name, s.role, s.service,
COALESCE(SUM(st.present), 0) AS weeks_present
FROM staff s LEFT JOIN staff_schedule st
ON s.staff_id = st.staff_id
GROUP BY s.staff_id, s.staff_name, s.role, s.service
ORDER BY weeks_present DESC;