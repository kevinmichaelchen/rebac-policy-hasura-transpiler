CREATE TABLE "public"."org_unit" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "name" text NOT NULL,
  "parent_id" uuid,
  PRIMARY KEY ("id")
);

CREATE EXTENSION IF NOT EXISTS pgcrypto;

ALTER TABLE
  "public"."org_unit"
ADD
  CONSTRAINT "org_unit_parent_id_fkey" FOREIGN KEY ("parent_id") REFERENCES "public"."org_unit" ("id") ON
UPDATE
  no ACTION ON DELETE CASCADE;

CREATE TABLE "public"."classroom" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "org_unit_id" uuid NOT NULL,
  PRIMARY KEY ("id"),
  FOREIGN KEY ("org_unit_id") REFERENCES "public"."org_unit"("id") ON
  UPDATE
    no ACTION ON DELETE CASCADE
);

CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE "public"."teacher" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "name" text NOT NULL,
  "email" text NOT NULL,
  "org_unit_id" uuid NOT NULL,
  PRIMARY KEY ("id"),
  FOREIGN KEY ("org_unit_id") REFERENCES "public"."org_unit"("id") ON
  UPDATE
    no ACTION ON DELETE CASCADE,
    UNIQUE ("email")
);

CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE "public"."teacher_classroom" (
  "teacher_id" uuid NOT NULL,
  "classroom_id" uuid NOT NULL,
  PRIMARY KEY ("teacher_id", "classroom_id"),
  FOREIGN KEY ("classroom_id") REFERENCES "public"."classroom"("id") ON
  UPDATE
    no ACTION ON DELETE CASCADE,
    FOREIGN KEY ("teacher_id") REFERENCES "public"."teacher"("id") ON
  UPDATE
    no ACTION ON DELETE CASCADE
);
