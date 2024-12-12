CREATE TYPE lesson_type AS ENUM ('individual', 'group', 'ensemble');

CREATE TYPE skill_level AS ENUM ('beginner', 'intermediate', 'advanced');

CREATE TYPE status AS ENUM (
  'confirmed',
  'pending',
  'cancelled',
  'completed'
);

CREATE TABLE "Student" (
  "student_id" serial NOT NULL,
  "name" varchar(50),
  "address" varchar(100) NOT NULL,
  "phone" varchar(15),
  "mail" varchar(50),
  "contact_person" varchar(50),
  "contact_person_phone" varchar(15),
  PRIMARY KEY ("student_id")
);

CREATE TABLE "Instructor" (
  "instructor_id" serial NOT NULL,
  "name" varchar(50),
  "address" varchar(50),
  "phone" varchar(15),
  "mail" varchar(50),
  PRIMARY KEY ("instructor_id")
);

CREATE TABLE "Time_slot" (
  "time_slot_id" Serial NOT NULL,
  "date" date NOT NULL,
  "start_time" time NOT NULL,
  "end_time" time NOT NULL,
  PRIMARY KEY ("time_slot_id"),
  UNIQUE ("date", "start_time", "end_time")
);

-------------------------
CREATE TABLE "Lesson" (
  "lesson_id" serial,
  "lesson_type" lesson_type NOT NULL,
  "skill_level" skill_level NOT NULL,
  "time_slot_id" int,
  PRIMARY KEY ("lesson_id"),
  CONSTRAINT "FK_Lesson.time_slot_id" FOREIGN KEY ("time_slot_id") REFERENCES "Time_slot"("time_slot_id")
);

--- sub tabel ---
CREATE TABLE "Ensemble_lesson" (
  "genre" char(20),
  "max_students" smallint NOT NULL,
  "min_students" smallint NOT NULL
) INHERITS ("Lesson");

CREATE TABLE "Group_lesson" (
  "max_students" smallint NOT NULL,
  "min_students" smallint NOT NULL,
  "instrument" char(20) NOT NULL
) INHERITS ("Lesson");

CREATE TABLE "Individual_lesson" ("instrument" char(20) NOT NULL) INHERITS ("Lesson");

-------------------------
CREATE TABLE "Student_lesson_booking" (
  "booking_id" serial,
  "student_id" int NOT NULL,
  "lesson_id" int NOT NULL,
  "date" date,
  /* "time" time, */
  "status" status NOT NULL,
  PRIMARY KEY ("booking_id"),
  CONSTRAINT "FK_Student_lesson_booking.student_id" FOREIGN KEY ("student_id") REFERENCES "Student"("student_id") ON DELETE CASCADE
);

CREATE TABLE "Instructor_lesson_assignment" (
  "assignment_id" serial,
  "instructor_id" int NOT NULL,
  "lesson_id" int NOT NULL,
  "date" date,
  /* "time" time, */
  "status" status NOT NULL,
  PRIMARY KEY ("assignment_id"),
  CONSTRAINT "FK_Instructor_lesson_assignment.instructor_id" FOREIGN KEY ("instructor_id") REFERENCES "Instructor"("instructor_id") ON DELETE CASCADE
);

CREATE TABLE "Price_List" (
  "list_id" serial NOT NULL,
  "lesson_type" lesson_type,
  "skill_level" skill_level,
  "price" float NOT NULL,
  "start_date" date NOT NULL,
  "end_date" date,
  "sibling_discount_rate" float NOT NULL,
  "previous_list_id" int,
  PRIMARY KEY ("list_id")
);

CREATE TABLE "instructor_avalible_instruments" (
  "instructor_id" int NOT NULL,
  "instrument_type" varchar(50) NOT NULL,
  PRIMARY KEY ("instructor_id", "instrument_type"),
  CONSTRAINT "FK_instructor_avalible_instruments.instructor_id" FOREIGN KEY ("instructor_id") REFERENCES "Instructor"("instructor_id")
);

CREATE TABLE "Instructor_payment" (
  "receipt_id" serial,
  "instructor_id" Int NOT NULL,
  "year" date NOT NULL,
  "month" smallint NOT NULL,
  "total_amount" float NOT NULL,
  "payment_status" bool NOT NULL,
  PRIMARY KEY ("receipt_id"),
  CONSTRAINT "FK_Instructor_payment.instructor_id" FOREIGN KEY ("instructor_id") REFERENCES "Instructor"("instructor_id")
);

CREATE TABLE "Student_payment" (
  "invoice _id" Serial,
  "student_id" Int NOT NULL,
  "year" date NOT NULL,
  "month" smallint NOT NULL,
  "total_amount" float NOT NULL,
  "sibling_discount" float,
  "payment_status" bool NOT NULL,
  PRIMARY KEY ("invoice _id"),
  CONSTRAINT "FK_Student_payment.student_id" FOREIGN KEY ("student_id") REFERENCES "Student"("student_id")
);

CREATE TABLE "Instrument_rental" (
  "rental_id" serial NOT NULL,
  "student_id" Int NOT NULL,
  "instrument_id" Int NOT NULL,
  "start_date" Date NOT NULL,
  "end_date" Date,
  "rental_status" bool NOT NULL,
  PRIMARY KEY ("rental_id"),
  CONSTRAINT "FK_Instrument_rental.student_id" FOREIGN KEY ("student_id") REFERENCES "Student"("student_id")
);

CREATE TABLE "Instrument" (
  "instrument_id" serial NOT NULL,
  "instrument_type" varchar(30) NOT NULL,
  "brand" varchar(30) NOT NULL,
  "price_per_month" int NOT NULL,
  "store_number" int,
  PRIMARY KEY ("instrument_id")
);

CREATE TABLE "Siblings_linked_list" (
  "student_id" int NOT NULL,
  "sibling_id" int NOT NULL,
    CONSTRAINT fk_sibling
    FOREIGN KEY ("student_id") REFERENCES "Student"("student_id")
    ON DELETE CASCADE
);

CREATE TABLE "instructor_unavalible_timeslots" (
  "instructor_id " int NOT NULL,
  "time_slot_id" int NOT NULL,
  CONSTRAINT "FK_instructor_unavalible_timeslots.instructor_id " FOREIGN KEY ("instructor_id ") REFERENCES "Instructor"("instructor_id"),
  CONSTRAINT "FK_instructor_unavalible_timeslots.time_slot_id" FOREIGN KEY ("time_slot_id") REFERENCES "Time_slot"("time_slot_id")
);

CREATE TABLE config (
config_key VARCHAR(255) PRIMARY KEY, 
config_value int
);

CREATE TABLE "Historical_Lessons" (
  "history_id" serial PRIMARY KEY,
  "lesson_type" lesson_type NOT NULL,
  "genre" varchar(20),
  "instrument" varchar(20),
  "lesson_price" float NOT NULL,
  "student_name" varchar(30) NOT NULL,
  "student_email" varchar(40) NOT NULL,
  "date" date NOT NULL,
  CONSTRAINT unique_historical_lesson UNIQUE ("lesson_type", "genre", "instrument", "student_email", "date")
);

\i inserts_data.sql;
\i task_3/historical_lessons.sql;
\i task_3/task3_1.sql
\i task_3/task3_2.sql
\i task_3/task3_3.sql
\i task_3/task3_4.sql
