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

\copy "Siblings_linked_list" ("student_id", "sibling_id") FROM 'data/Siblings.csv' DELIMITER ',' CSV HEADER;

\copy "Instrument" ("instrument_type", "brand", "price_per_month", "store_number") FROM 'data/Instrument.csv' DELIMITER ',' CSV HEADER;

\copy "Instrument_rental" ("student_id", "instrument_id", "start_date", "end_date", "rental_status") FROM 'data/Instrument_rental.csv' DELIMITER ',' CSV HEADER;

INSERT INTO config (config_key, config_value) VALUES ('max_instruments_per_student', 2);
