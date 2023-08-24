
CREATE EXTENSION IF NOT EXISTS pgcrypto;

ALTER TABLE
  "public"."teacher_classroom"
ADD
  COLUMN "id" uuid NOT NULL DEFAULT gen_random_uuid();

BEGIN TRANSACTION;

ALTER TABLE
  "public"."teacher_classroom" DROP CONSTRAINT "teacher_classroom_pkey";

ALTER TABLE
  "public"."teacher_classroom"
ADD
  CONSTRAINT "teacher_classroom_pkey" PRIMARY KEY ("id");

COMMIT TRANSACTION;
