\copy "Student" ("student_id", "name", "address", "phone", "mail", "contact_person", "contact_person_phone") FROM 'data/Student.csv' DELIMITER ',' CSV HEADER;

\copy "Instructor" ("name", "address", "phone", "mail") FROM 'data/Instructor.csv' DELIMITER ',' CSV HEADER;

\copy "Time_slot" ("date", "start_time", "end_time") FROM 'data/Time_slot.csv' DELIMITER ',' CSV HEADER;

\copy "Individual_lesson" ("lesson_type", "skill_level", "time_slot_id", "instrument") FROM 'data/Individual_lesson.csv' DELIMITER ',' CSV HEADER;

\copy "Group_lesson" ("lesson_type", "skill_level", "time_slot_id", "max_students", "min_students", "instrument") FROM 'data/Group_lesson.csv' DELIMITER ',' CSV HEADER;

\copy "Ensemble_lesson" ("lesson_type", "skill_level", "time_slot_id", "genre", "max_students", "min_students") FROM 'data/Ensemble_Lesson.csv' DELIMITER ',' CSV HEADER; 

\copy "Price_List" ("lesson_type", "skill_level", "price", "start_date", "end_date", "sibling_discount_rate", "previous_list_id") FROM 'data/Price_list.csv' DELIMITER ',' CSV HEADER; 

/* \copy "Lesson" ("lesson_type", "skill_level", "time_slot_id", "genre", "max_students", "min_students", "instrument") FROM 'Lesson.csv' DELIMITER ',' CSV HEADER; */

\copy "Student_lesson_booking" ("student_id", "lesson_id", "date", "status") FROM 'data/Student_lesson_booking.csv' DELIMITER ',' CSV HEADER; 

\copy "Instructor_lesson_assignment" ("instructor_id", "lesson_id", "date", "status") FROM 'data/Instructor_lesson_assignment.csv' DELIMITER ',' CSV HEADER; 

\copy "Siblings_linked_list" ("sibling_id", "next_sibling_id") FROM 'data/Siblings.csv' DELIMITER ',' CSV HEADER;