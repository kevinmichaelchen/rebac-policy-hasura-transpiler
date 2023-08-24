
ALTER TABLE
  "public"."teacher_classroom" DROP CONSTRAINT "teacher_classroom_pkey";

ALTER TABLE
  "public"."teacher_classroom"
ADD
  CONSTRAINT "teacher_classroom_pkey" PRIMARY KEY ("teacher_id", "classroom_id");

ALTER TABLE
  "public"."teacher_classroom" DROP COLUMN "id" CASCADE
ALTER TABLE
  "public"."teacher_classroom" DROP COLUMN "id";

-- Could not auto-generate a down migration.
-- Please write an appropriate down migration for the SQL below:
-- CREATE EXTENSION IF NOT EXISTS pgcrypto;
