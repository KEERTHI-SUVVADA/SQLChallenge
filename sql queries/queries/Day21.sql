WITH service_level_sate AS(
 select
    service,
    sum(patients_admitted) as total_admitted,
    sum(patients_refused) as total_refused,
    avg(patient_satisfaction) as avg_satisfaction 
 from services_weekly
 group by service
 ),

staff_lavel_stat AS ( 
 select
    service,
    count(*) as total_staff
 from staff
 group by service
 ),
 
 patient_lavel_stat AS (
    select
        service,
        round(avg(age),2) as avg_age,
        count(*) as total_patient
    from patients
    group by service )

select
    ss.service,
    ss.total_admitted,
    ss.total_refused,
    ss.avg_satisfaction,
    sls.total_staff,
    ps.total_patient,
    ps.avg_age,
    round((100* ss.total_admitted / (ss.total_admitted + ss.total_refused)),2) as admission_rate,
    ROUND(
        (0.6 * (ss.total_admitted * 1.0 / (ss.total_admitted + ss.total_refused))) +
        (0.4 * ss.avg_satisfaction), 2
    ) as performance_score
from service_level_sate ss 
left join staff_lavel_stat sls on ss.service = sls.service
left join patient_lavel_stat ps on sls.service= ps.service;