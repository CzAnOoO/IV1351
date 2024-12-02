/* TABLE 2 */
SELECT 
"num_of_siblings" AS "No of Siblings",
COUNT(*) AS "No of Students"

FROM(
 SELECT Count(*) AS "num_of_siblings"
 FROM "Siblings_linked_list"
 GROUP BY "next_sibling_id"
) AS sibling_counts

GROUP BY "num_of_siblings"
ORDER BY "num_of_siblings";
/* 
 No of Siblings | No of Students 
----------------+----------------
              1 |              6
              2 |              9
              4 |              5
(3 rows)

 */