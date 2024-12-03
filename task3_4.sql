/* TABLE 4 */
SELECT 
    -- If you need to verify whether the query is correct, you can remove the gaze here.
    -- e.lesson_id,
    -- ts.date,
    TO_CHAR(ts.date, 'Day') AS weekday,
    e.genre,
    CASE 
        WHEN COUNT(sl.booking_id) >= e.max_students THEN 'Fully booked'
        WHEN e.max_students - COUNT(sl.booking_id) BETWEEN 1 AND 2 THEN '1-2 seats left'
        ELSE 'More seats left'
    END AS booking_status
FROM "Ensemble_lesson" e
JOIN "Time_slot" ts
    ON e.time_slot_id = ts.time_slot_id
JOIN "Student_lesson_booking" sl
    ON e.lesson_id = sl.lesson_id

-- It should be: CURRENT_DATE + (8 - EXTRACT(DOW FROM CURRENT_DATE))::INT
WHERE ts.date >= DATE '2024-12-02' + (8 - EXTRACT(DOW FROM DATE '2024-12-02'))::INT -- Start from next Monday 
  AND ts.date < DATE '2024-12-02' + (15 - EXTRACT(DOW FROM DATE '2024-12-02'))::INT -- Include up to next Sunday
GROUP BY e.lesson_id, e.genre, ts.date, e.max_students
ORDER BY e.genre, ts.date;
/* 
test=# \i task3_4.sql
 lesson_id |    date    |  weekday  |                       genre                        | booking_status  
-----------+------------+-----------+----------------------------------------------------+-----------------
        57 | 2024-12-13 | Friday    | drama                                              | Fully booked
        56 | 2024-12-09 | Monday    | fantasy                                            | More seats left
        60 | 2024-12-12 | Thursday  | thriller                                           | 1-2 seats left
(3 rows)

test=# SELECT * FROM "Ensemble_lesson" WHERE "lesson_id"=60;
 lesson_id | lesson_type | skill_level  | time_slot_id |    genre     | max_students | min_students 
-----------+-------------+--------------+--------------+--------------+--------------+--------------
        60 | ensemble    | intermediate |           24 |    thriller  |           12 |      3
(1 row)

-- Query the total number of students enrolled in a certain course
SELECT 
    COUNT(DISTINCT sl.student_id) AS total_students
FROM 
    "Student_lesson_booking" sl
WHERE 
    sl.lesson_id = 60;
 total_students 
----------------
             11
(1 row)

-- Query the students registered for a certain course
SELECT   
    s.student_id, 
    s.name AS student_name
FROM 
    "Student" s
JOIN 
    "Student_lesson_booking" sl ON s.student_id = sl.student_id  
WHERE 
    sl.lesson_id = 60  -- Replace with the course ID you want to query
GROUP BY 
    s.student_id, s.name
ORDER BY 
    s.name; 

*/