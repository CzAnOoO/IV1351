/* TABLE 2 */
SELECT 
    "num_of_siblings" AS "No of Siblings",
    COUNT(*) AS "No of Students"
FROM (
    SELECT COUNT(*) AS "num_of_siblings"
    FROM "Siblings_linked_list"
    GROUP BY "sibling_id"
) sibling_counts
GROUP BY "num_of_siblings"
UNION ALL
SELECT 
    0 AS "No of Siblings",
    (SELECT COUNT(*) FROM "Student") - 
    (SELECT COUNT(DISTINCT "sibling_id") FROM "Siblings_linked_list") AS "No of Students"
ORDER BY "No of Siblings";
/* 
 No of Siblings | No of Students 
----------------+----------------
              1 |              6
              2 |              9
              4 |              5
(3 rows)

 */