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
SELECT
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
    b.status = 'completed';
/* 
\i historical_lessons.sql 
INSERT 0 69

--Check inserted data--
SELECT * FROM "Historical_Lessons" WHERE "lesson_type"= 'ensemble' limit 3;
test=# SELECT * FROM "Historical_Lessons" WHERE "lesson_type"= 'ensemble' limit 3;
 history_id | lesson_type | genre | instrument | lesson_price |     student_name      |       student_email       |    date    
------------+-------------+-------+------------+--------------+-----------------------+---------------------------+------------
         23 | ensemble    | drama |            |           30 | Lefty Camelli         | dantonov5v@newyorker.com  | 2024-03-03
         24 | ensemble    | drama |            |           30 | Travis Tithacott      | snekrewsb7@i2i.jp         | 2024-03-30
         25 | ensemble    | drama |            |           30 | Casandra Bestwerthick | cpanchincj@opensource.org | 2024-05-12
(3 rows)

SELECT * FROM "Historical_Lessons" WHERE "lesson_type"= 'group' limit 3;
 history_id | lesson_type | genre | instrument | lesson_price |     student_name      |      student_email      |    date    
------------+-------------+-------+------------+--------------+-----------------------+-------------------------+------------
         17 | group       |       | guitar     |           20 | Antonietta Bladesmith | kgouleyy@lycos.com      | 2024-02-22
         18 | group       |       | guitar     |           20 | Leland Brundle        | lcragell3v@unicef.org   | 2024-03-02
         19 | group       |       | trumpet    |           20 | Barbee Erickssen      | bjakoviljevic4h@mail.ru | 2024-05-13
(3 rows)

SELECT * FROM "Historical_Lessons" WHERE "lesson_type"= 'individual' limit 3;
 history_id | lesson_type | genre | instrument | lesson_price |   student_name    |      student_email       |    date    
------------+-------------+-------+------------+--------------+-------------------+--------------------------+------------
          1 | individual  |       | drums      |          130 | Iggy Aston        | gpeotz78@examiner.com    | 2024-08-22
          2 | individual  |       | drums      |          150 | Iggy Aston        | gpeotz78@examiner.com    | 2024-08-22
          3 | individual  |       | banjo      |           50 | Natalina Tinghill | vcuphus2u@eventbrite.com | 2023-06-22
(3 rows)
 */