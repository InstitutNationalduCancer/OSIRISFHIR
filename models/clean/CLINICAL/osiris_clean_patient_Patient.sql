SELECT
    "OSIRIS_pivot_Patient"."Patient_Id" AS "id_patient",
    "OSIRIS_pivot_Patient"."Patient_Id" AS "identifier_value",
    CASE
    "OSIRIS_pivot_Patient"."Patient_Gender"
        WHEN 'HL7:M' THEN 'male'
        WHEN 'HL7:F' THEN 'female'
        ELSE 'unknown'
    END AS "gender",
    "OSIRIS_pivot_Patient"."Patient_Ethnicity" AS
    "extension_ethnicity_valueCodeableConcept_coding_code",
    COALESCE("OSIRIS_pivot_Patient"."Patient_BirthDate", '1000-01-01'::DATE) AS "birthdate",
    "OSIRIS_pivot_Patient"."Patient_DeathDate" AS "deceaseddatetime",
    COALESCE("OSIRIS_pivot_Patient"."Patient_ProviderCenterId"::VARCHAR, 'Unknown') AS "managingorganization_valuereference",
    COALESCE("OSIRIS_pivot_Patient"."Patient_OriginCenterId"::VARCHAR, 'Unknown') AS "extension_origin_center_valuereference",
    COALESCE("OSIRIS_pivot_Patient"."Patient_LastNewsDate", '1000-01-01'::DATE) AS "vitalstatus_effectiveDateTime",
    COALESCE("OSIRIS_pivot_Patient"."Patient_LastNewsDate", '1000-01-01'::DATE) AS "causeofdeath_effectiveDateTime",
    CASE
        WHEN "OSIRIS_pivot_Patient"."Patient_LastNewsStatus" IS NULL THEN 'C0439673'
        ELSE
            RIGHT(
                "OSIRIS_pivot_Patient"."Patient_LastNewsStatus", -POSITION(':' IN "OSIRIS_pivot_Patient"."Patient_LastNewsStatus")
            )
    END AS "vitalstatus_valueCodeableConcept_coding_code",
    RIGHT("OSIRIS_pivot_Patient"."Patient_CauseOfDeath", -POSITION(':' IN "OSIRIS_pivot_Patient"."Patient_CauseOfDeath"))
    AS "causeofdeath_valueCodeableConcept_coding_code"

FROM
    {{ ref('OSIRIS_pivot_Patient') }}
UNION
SELECT DISTINCT
    "OSIRIS_pivot_Analysis"."Patient_Id" AS "id_patient",
    "OSIRIS_pivot_Analysis"."Patient_Id" AS "identifier_value",
    'unknown' AS "gender",
    NULL AS "extension_ethnicity_valueCodeableConcept_coding_code",
    '1000-01-01'::DATE AS "birthdate",
    NULL::DATE AS "deceaseddatetime",
    'Unknown' AS "managingorganization_valuereference",
    'Unknown' AS "extension_origin_center_valuereference",
    '1000-01-01'::DATE AS "vitalstatus_effectiveDateTime",
    '1000-01-01'::DATE AS "causeofdeath_effectiveDateTime",
    'C0439673' AS "vitalstatus_valueCodeableConcept_coding_code",
    NULL AS "causeofdeath_valueCodeableConcept_coding_code"
FROM
    {{ ref('OSIRIS_pivot_Analysis') }} --some patient are not in patient pivot file
WHERE "Patient_Id" NOT IN (
    SELECT "OSIRIS_pivot_Patient"."Patient_Id" AS "id_patient"
    FROM
        {{ ref('OSIRIS_pivot_Patient') }}
)
UNION
SELECT DISTINCT
    "OSIRIS_pivot_Treatment"."Patient_Id" AS "id_patient",
    "OSIRIS_pivot_Treatment"."Patient_Id" AS "identifier_value",
    'unknown' AS "gender",
    NULL AS "extension_ethnicity_valueCodeableConcept_coding_code",
    '1000-01-01'::DATE AS "birthdate",
    NULL::DATE AS "deceaseddatetime",
    'Unknown' AS "managingorganization_valuereference",
    'Unknown' AS "extension_origin_center_valuereference",
    '1000-01-01'::DATE AS "vitalstatus_effectiveDateTime",
    '1000-01-01'::DATE AS "causeofdeath_effectiveDateTime",
    'C0439673' AS "vitalstatus_valueCodeableConcept_coding_code",
    NULL AS "causeofdeath_valueCodeableConcept_coding_code"
FROM
    {{ ref('OSIRIS_pivot_Treatment') }} --some patient are not in patient pivot file
WHERE "Patient_Id" NOT IN (
    SELECT "OSIRIS_pivot_Patient"."Patient_Id" AS "id_patient"
    FROM
        {{ ref('OSIRIS_pivot_Patient') }}
)
UNION
SELECT DISTINCT
    "OSIRIS_pivot_CourseRT"."Patient_Id"::VARCHAR AS "id_patient",
    "OSIRIS_pivot_CourseRT"."Patient_Id"::VARCHAR AS "identifier_value",
    'unknown' AS "gender",
    NULL AS "extension_ethnicity_valueCodeableConcept_coding_code",
    '1000-01-01'::DATE AS "birthdate",
    NULL::DATE AS "deceaseddatetime",
    'Unknown' AS "managingorganization_valuereference",
    'Unknown' AS "extension_origin_center_valuereference",
    '1000-01-01'::DATE AS "vitalstatus_effectiveDateTime",
    '1000-01-01'::DATE AS "causeofdeath_effectiveDateTime",
    'C0439673' AS "vitalstatus_valueCodeableConcept_coding_code",
    NULL AS "causeofdeath_valueCodeableConcept_coding_code"
FROM
    {{ ref('OSIRIS_pivot_CourseRT') }} --some patient are not in patient pivot file
WHERE "Patient_Id"::VARCHAR NOT IN (
    SELECT "OSIRIS_pivot_Patient"."Patient_Id" AS "id_patient"
    FROM
        {{ ref('OSIRIS_pivot_Patient') }}
)
ORDER BY ID_PATIENT
