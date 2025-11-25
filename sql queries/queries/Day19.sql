/*
Challenge:
Question: For each service, rank the weeks by patient satisfaction score (highest first).
Show service, week, patient_satisfaction, patients_admitted, and the rank. Include only the top 3 weeks per service.
*/
SELECT service,week,patient_satisfaction,patients_admitted,
rank
FROM (
SELECT
service,week,patient_satisfaction,patients_admitted,
RANK() OVER (
PARTITION BY service
ORDER BY patient_satisfaction DESC
) AS rank
FROM services_weekly
)
WHERE rank <= 3
ORDER BY service, rank, week;