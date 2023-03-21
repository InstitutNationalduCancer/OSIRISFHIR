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
    "OSIRIS_pivot_Patient"."Patient_BirthDate" AS "birthdate",
    "OSIRIS_pivot_Patient"."Patient_DeathDate" AS "deceaseddatetime",
    "OSIRIS_pivot_Patient"."Patient_ProviderCenterId"::VARCHAR AS "managingorganization_valuereference",
    "OSIRIS_pivot_Patient"."Patient_OriginCenterId"::VARCHAR AS "extension_origin_center_valuereference"
FROM
    {{ ref('OSIRIS_pivot_Patient') }}
UNION
SELECT DISTINCT
    "OSIRIS_pivot_Analysis"."Patient_Id" AS "id_patient",
    "OSIRIS_pivot_Analysis"."Patient_Id" AS "identifier_value",
    NULL AS "gender",
    NULL AS "extension_ethnicity_valueCodeableConcept_coding_code",
    NULL::DATE AS "birthdate",
    NULL::DATE AS "deceaseddatetime",
    NULL AS "managingorganization_valuereference",
    NULL AS "extension_origin_center_valuereference"
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
    NULL AS "gender",
    NULL AS "extension_ethnicity_valueCodeableConcept_coding_code",
    NULL::DATE AS "birthdate",
    NULL::DATE AS "deceaseddatetime",
    NULL AS "managingorganization_valuereference",
    NULL AS "extension_origin_center_valuereference"
FROM
    {{ ref('OSIRIS_pivot_Treatment') }} --some patient are not in patient pivot file
WHERE "Patient_Id" NOT IN (
    SELECT "OSIRIS_pivot_Patient"."Patient_Id" AS "id_patient"
    FROM
        {{ ref('OSIRIS_pivot_Patient') }}
)
UNION
SELECT DISTINCT
    "OSIRIS_pivot_CourseRT"."Patient_Id" AS "id_patient",
    "OSIRIS_pivot_CourseRT"."Patient_Id" AS "identifier_value",
    NULL AS "gender",
    NULL AS "extension_ethnicity_valueCodeableConcept_coding_code",
    NULL::DATE AS "birthdate",
    NULL::DATE AS "deceaseddatetime",
    NULL AS "managingorganization_valuereference",
    NULL AS "extension_origin_center_valuereference"
FROM
    {{ ref('OSIRIS_pivot_CourseRT') }} --some patient are not in patient pivot file
WHERE "Patient_Id" NOT IN (
    SELECT "OSIRIS_pivot_Patient"."Patient_Id" AS "id_patient"
    FROM
        {{ ref('OSIRIS_pivot_Patient') }}
)
ORDER BY ID_PATIENT
