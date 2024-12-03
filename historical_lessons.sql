INSERT INTO
    "Historical_Lessons" (
        lesson_type,
        genre,
        instrument,
        lesson_price,
        student_name,
        student_email,
        date
    )
SELECT DISTINCT
    CASE
        WHEN l.lesson_type = 'ensemble' THEN 'ensemble'::lesson_type
        WHEN l.lesson_type = 'group' THEN 'group'::lesson_type
        WHEN l.lesson_type = 'individual' THEN 'individual'::lesson_type
    END AS lesson_type,
    CASE
        WHEN l.lesson_type = 'ensemble' THEN e.genre
        ELSE NULL
    END AS genre,
    CASE
        WHEN l.lesson_type = 'group' THEN g.instrument
        WHEN l.lesson_type = 'individual' THEN i.instrument
        ELSE NULL
    END AS instrument,
    p.price AS lesson_price,
    s.name AS student_name,
    s.mail AS student_email,
    b.date AS date
FROM
    "Lesson" l
    LEFT JOIN "Ensemble_lesson" e ON l.lesson_id = e.lesson_id
    LEFT JOIN "Group_lesson" g ON l.lesson_id = g.lesson_id
    LEFT JOIN "Individual_lesson" i ON l.lesson_id = i.lesson_id
    JOIN "Student_lesson_booking" b ON b.lesson_id = l.lesson_id
    JOIN "Student" s ON b.student_id = s.student_id
    JOIN "Price_List" p ON l.lesson_type = p.lesson_type
    AND l.skill_level = p.skill_level
WHERE
    b.status = 'completed'
/*     AND NOT EXISTS (
        SELECT 1
        FROM "Historical_Lessons" h
        WHERE h.lesson_type = CASE 
                                WHEN l.lesson_type = 'ensemble' THEN 'ensemble'::lesson_type
                                WHEN l.lesson_type = 'group' THEN 'group'::lesson_type
                                WHEN l.lesson_type = 'individual' THEN 'individual'::lesson_type
                              END
          AND h.student_email = s.mail
          AND h.date = b.date
    ); */
/* 


\i historical_lessons.sql 
INSERT 0 63

--Check inserted data--
SELECT * FROM "Historical_Lessons" WHERE "lesson_type"= 'ensemble' limit 3;
 history_id | lesson_type | genre  | instrument | lesson_price |    student_name    |       student_email        |    date    
------------+-------------+--------+------------+--------------+--------------------+----------------------------+------------
         45 | ensemble    | action |            |           30 | Marline Sybe       | pscougallcr@guardian.co.uk | 2024-05-02
         46 | ensemble    | comedy |            |           80 | Arther Dymond      | gwoolfendence@google.nl    | 2023-08-12
         47 | ensemble    | comedy |            |           80 | Blondy Wintersgill | rlumpkin8y@booking.com     | 2024-07-01
(3 rows)

SELECT * FROM "Historical_Lessons" WHERE "lesson_type"= 'group' limit 3;
 history_id | lesson_type | genre | instrument | lesson_price |  student_name   |          student_email           |    date    
------------+-------------+-------+------------+--------------+-----------------+----------------------------------+------------
         17 | group       |       | accordion  |           60 | Andy Grinnell   | krawles6u@loc.gov                | 2024-05-23
         18 | group       |       | accordion  |           60 | Lukas Greig     | bcongreve7o@discuz.net           | 2023-11-26
         19 | group       |       | accordion  |           60 | Sawyere Goodman | wcallicott19@businessinsider.com | 2023-07-07
(3 rows)

test=# SELECT * FROM "Historical_Lessons" WHERE "lesson_type"= 'individual' limit 3;
 history_id | lesson_type | genre | instrument | lesson_price |   student_name    |      student_email       |    date    
------------+-------------+-------+------------+--------------+-------------------+--------------------------+------------
          1 | individual  |       | accordion  |          130 | Alyosha Maps      | nrodenburghj@salon.com   | 2023-07-20
          2 | individual  |       | accordion  |          150 | Alyosha Maps      | nrodenburghj@salon.com   | 2023-07-20
          3 | individual  |       | banjo      |           50 | Natalina Tinghill | vcuphus2u@eventbrite.com | 2023-06-22
(3 rows)
 */