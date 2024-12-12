/* TABLE 1*/
CREATE VIEW tabel_1 AS
SELECT
TO_CHAR(TO_DATE(EXTRACT(MONTH FROM "date")::text, 'MM'),
'FMMonth') AS "Month",
COUNT(*) AS "Total",
COUNT(*) FILTER (WHERE L."lesson_type" = 'individual') AS "Individual",
COUNT(*) FILTER (WHERE L."lesson_type" = 'group') AS "Group",
COUNT(*) FILTER (WHERE L."lesson_type" = 'ensemble') AS "Ensemble"
FROM "Time_slot" AS T
INNER JOIN "Lesson" AS L
ON T."time_slot_id" = L."time_slot_id"
WHERE EXTRACT(YEAR FROM "date") = 2024
GROUP BY EXTRACT(MONTH FROM "date")
ORDER BY EXTRACT(MONTH FROM "date");

/* 
test=# SELECT * FROM tabel_1;
  Month   | Total | Individual | Group | Ensemble 
----------+-------+------------+-------+----------
 November |    21 |         10 |     7 |        4
 December |    39 |         20 |    13 |        6
(2 rows) 

*/