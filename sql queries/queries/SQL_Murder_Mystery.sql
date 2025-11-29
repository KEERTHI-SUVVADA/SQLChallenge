-- DROP TABLES if exist
DROP TABLE IF EXISTS employees, keycard_logs, calls, alibis, evidence;

-- Employees Table
CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    name VARCHAR(50),
    department VARCHAR(50),
    role VARCHAR(50)
);

INSERT INTO employees VALUES
(1, 'Alice Johnson', 'Engineering', 'Software Engineer'),
(2, 'Bob Smith', 'HR', 'HR Manager'),
(3, 'Clara Lee', 'Finance', 'Accountant'),
(4, 'David Kumar', 'Engineering', 'DevOps Engineer'),
(5, 'Eva Brown', 'Marketing', 'Marketing Lead'),
(6, 'Frank Li', 'Engineering', 'QA Engineer'),
(7, 'Grace Tan', 'Finance', 'CFO'),
(8, 'Henry Wu', 'Engineering', 'CTO'),
(9, 'Isla Patel', 'Support', 'Customer Support'),
(10, 'Jack Chen', 'HR', 'Recruiter');

-- Keycard Logs Table
CREATE TABLE keycard_logs (
    log_id INT PRIMARY KEY,
    employee_id INT,
    room VARCHAR(50),
    entry_time TIMESTAMP,
    exit_time TIMESTAMP
);

INSERT INTO keycard_logs VALUES
(1, 1, 'Office', '2025-10-15 08:00', '2025-10-15 12:00'),
(2, 2, 'HR Office', '2025-10-15 08:30', '2025-10-15 17:00'),
(3, 3, 'Finance Office', '2025-10-15 08:45', '2025-10-15 12:30'),
(4, 4, 'Server Room', '2025-10-15 08:50', '2025-10-15 09:10'),
(5, 5, 'Marketing Office', '2025-10-15 09:00', '2025-10-15 17:30'),
(6, 6, 'Office', '2025-10-15 08:30', '2025-10-15 12:30'),
(7, 7, 'Finance Office', '2025-10-15 08:00', '2025-10-15 18:00'),
(8, 8, 'Server Room', '2025-10-15 08:40', '2025-10-15 09:05'),
(9, 9, 'Support Office', '2025-10-15 08:30', '2025-10-15 16:30'),
(10, 10, 'HR Office', '2025-10-15 09:00', '2025-10-15 17:00'),
(11, 4, 'CEO Office', '2025-10-15 20:50', '2025-10-15 21:00'); -- killer

-- Calls Table
CREATE TABLE calls (
    call_id INT PRIMARY KEY,
    caller_id INT,
    receiver_id INT,
    call_time TIMESTAMP,
    duration_sec INT
);

INSERT INTO calls VALUES
(1, 4, 1, '2025-10-15 20:55', 45),
(2, 5, 1, '2025-10-15 19:30', 120),
(3, 3, 7, '2025-10-15 14:00', 60),
(4, 2, 10, '2025-10-15 16:30', 30),
(5, 4, 7, '2025-10-15 20:40', 90);

-- Alibis Table
CREATE TABLE alibis (
    alibi_id INT PRIMARY KEY,
    employee_id INT,
    claimed_location VARCHAR(50),
    claim_time TIMESTAMP
);

INSERT INTO alibis VALUES
(1, 1, 'Office', '2025-10-15 20:50'),
(2, 4, 'Server Room', '2025-10-15 20:50'), -- false alibi
(3, 5, 'Marketing Office', '2025-10-15 20:50'),
(4, 6, 'Office', '2025-10-15 20:50');

-- Evidence Table
CREATE TABLE evidence (
    evidence_id INT PRIMARY KEY,
    room VARCHAR(50),
    description VARCHAR(255),
    found_time TIMESTAMP
);

INSERT INTO evidence VALUES
(1, 'CEO Office', 'Fingerprint on desk', '2025-10-15 21:05'),
(2, 'CEO Office', 'Keycard swipe logs mismatch', '2025-10-15 21:10'),
(3, 'Server Room', 'Unusual access pattern', '2025-10-15 21:15');=

--1)Identify where and when the crime happened
SELECT room, description, found_time
FROM evidence
WHERE room = 'CEO Office'
ORDER BY found_time;

--2)Who entered the CEO’s Office close to the time of the murder?
SELECT
e.employee_id,
e.name,
k.room,
k.entry_time
FROM keycard_logs AS k
LEFT JOIN employees AS e
ON k.employee_id = e.employee_id
WHERE k.room='CEO Office'
AND k.entry_time::date = '2025-10-15'
AND k.entry_time::time BETWEEN '20:50:00' AND '21:50:00';

--3)Who claimed to be somewhere else but was not?
SELECT
k.employee_id,
e.name,
a.claimed_location,
k.room AS acutual_room
FROM keycard_logs AS k
LEFT JOIN employees AS e
ON k.employee_id = e.employee_id
LEFT JOIN alibis AS a
ON k.employee_id = a.employee_id
WHERE k.room='CEO Office';

--4)Who made or received calls around 20:50–21:00?
SELECT
e1.name AS made_call,
e2.name AS received_call,
c.call_time
FROM calls c
JOIN employees AS e1
ON e1.employee_id = c.caller_id
JOIN employees AS e2
ON e2.employee_id = c.receiver_id
WHERE CAST(c.call_time AS time)
BETWEEN '20:50:00' AND '21:00:00';

--5) What evidence was found at the crime scene?
SELECT description FROM evidence; 

--6) Which suspect’s movements, alibi, and call activity don’t add up?
SELECT DISTINCT e.employee_id,e.name,
a.claimed_location,
k.room AS actual_room,c.call_time
FROM employees e
JOIN keycard_logs k
ON e.employee_id = k.employee_id
AND k.room = 'CEO Office'
AND k.entry_time::TIME BETWEEN '20:50:00' AND '21:00:00'
JOIN alibis as a
ON e.employee_id = a.employee_id
AND a.claimed_location <> 'CEO Office'
JOIN calls as c
ON (e.employee_id = c.caller_id OR e.employee_id = c.receiver_id)  
AND c.call_time::time BETWEEN '20:50:00' AND '21:00:00';

--Case Solved
WITH
a AS (
  SELECT employee_id, claimed_location, claim_time
  FROM alibis
),
k AS (
  SELECT employee_id, room, entry_time, exit_time
  FROM keycard_logs
),
c AS (
  SELECT caller_id, receiver_id, call_time, duration_sec
  FROM calls
),
evi AS (
  SELECT room, description, found_time
  FROM evidence
  WHERE room = 'CEO Office'
    AND found_time::date = '2025-10-15'
),
suspect AS (
  SELECT DISTINCT e.employee_id, e.name
  FROM employees e
  JOIN k ON k.employee_id = e.employee_id
  JOIN a ON a.employee_id = e.employee_id
  WHERE k.room = 'CEO Office'
    AND k.entry_time::date = '2025-10-15'
    AND k.entry_time::time BETWEEN '20:50:00' AND '21:05:00'
    AND COALESCE(a.claimed_location, '') <> 'CEO Office'
    AND EXISTS (
      SELECT 1
      FROM c
      WHERE (c.caller_id = e.employee_id OR c.receiver_id = e.employee_id)
        AND c.call_time::date = '2025-10-15'
        AND c.call_time::time BETWEEN '20:50:00' AND '21:05:00'
    )
)
SELECT name AS killer
FROM suspect
ORDER BY name;


