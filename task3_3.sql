/* TABLE 3 */
CREATE VIEW tabel_3 AS
SELECT i.instructor_id, i.name, COUNT(l.lesson_id) AS lesson_count
FROM "Instructor" i
JOIN "Instructor_lesson_assignment" ila
    ON i.instructor_id = ila.instructor_id
JOIN "Lesson" l
    ON ila.lesson_id = l.lesson_id
JOIN "Time_slot" ts
    ON l.time_slot_id = ts.time_slot_id
WHERE ts.date >= DATE_TRUNC('month', DATE '2024-11-28')  -- DATE_TRUNC('month', CURRENT_DATE)
  AND ts.date <= DATE '2024-11-28'  -- ts.date <= CURRENT_DATE
GROUP BY i.instructor_id, i.name
HAVING COUNT(l.lesson_id) > 2  -- COUNT(l.lesson_id) > specific_number
ORDER BY lesson_count DESC;

/*  
test=# SELECT * FROM tabel_3;
 instructor_id | name | lesson_count 
---------------+------+--------------
            24 | Odey |            4
            20 | Hew  |            3
(2 rows)

SELECT * FROM "Instructor_lesson_assignment" AS i WHERE i.instructor_id=24; 
 assignment_id | instructor_id | lesson_id |    date    |  status   
---------------+---------------+-----------+------------+-----------
             1 |            24 |         1 | 2024-05-07 | cancelled
            26 |            24 |        26 | 2024-08-20 | cancelled
            34 |            24 |        34 | 2023-06-11 | pending
            42 |            24 |        42 | 2024-11-10 | completed
            46 |            24 |        46 | 2024-05-26 | pending
            47 |            24 |        47 | 2024-09-17 | confirmed
(6 rows)

SELECT "time_slot_id" FROM "Lesson" WHERE "lesson_id" IN (1, 26, 34, 42, 46, 47);
 time_slot_id 
--------------
            5
           23
            1
           30
           12
           20
(6 rows)

SELECT "date" FROM "Time_slot" WHERE "time_slot_id" in (5, 23, 1, 30, 12, 20);
    date    
------------
 2024-11-08
 2024-12-18
 2024-11-18
 2024-12-09
 2024-11-11
 2024-11-02
(6 rows)

 */