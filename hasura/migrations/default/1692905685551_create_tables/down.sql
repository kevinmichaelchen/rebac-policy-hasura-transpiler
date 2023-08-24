DROP TABLE "public"."teacher_classroom";

DROP TABLE "public"."teacher";

DROP TABLE "public"."classroom";

ALTER TABLE
  "public"."org_unit" DROP CONSTRAINT "org_unit_parent_id_fkey";

DROP TABLE "public"."org_unit";
