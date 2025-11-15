--1.Find all weeks in services_weekly where no special event occurred.
SELECT week FROM services_weekly WHERE EVENT IS NULL AND EVENT = 'none';

--2.Count how many records have null or empty event values.
SELECT COUNT(*) AS total_records
FROM services_weekly
WHERE EVENT IS NULL AND EVENT = 'none';

--3.List all services that had at least one week with a special event.
SELECT DISTINCT service
FROM services_weekly
WHERE EVENT IS NOT NULL AND EVENT != 'none';

/*
Challenge:
Question: Analyze the event impact by comparing weeks with events vs weeks without events.
Show: event status ('With Event' or 'No Event'), count of weeks, average patient satisfaction,
and average staff morale. Order by average patient satisfaction descending.
*/

SELECT
CASE
	WHEN EVENT IS NULL AND EVENT !='none' 
	THEN 'with event' 
	ELSE 'no event' 
END AS event_status,
COUNT(week) AS count_of_weeks,
ROUND(AVG(patient_satisfaction),3) AS avg_patient_satisfaction,
ROUND(AVG(staff_morale),3) AS avg_staff_morale
FROM services_weekly 
GROUP BY event_status
ORDER BY avg_patient_satisfaction DESC;


