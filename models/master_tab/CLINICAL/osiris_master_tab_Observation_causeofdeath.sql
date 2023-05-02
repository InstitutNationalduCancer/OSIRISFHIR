SELECT
    ROW_NUMBER() OVER (ORDER BY "id_patient") AS "id_causeofdeath",
    '69453-9' AS "code_coding_code",
    "id_patient" AS "subject",
    "causeofdeath_effectiveDateTime",
    "causeofdeath_valueCodeableConcept_coding_code"
FROM
    {{ ref('osiris_clean_patient_Patient') }}
WHERE "causeofdeath_valueCodeableConcept_coding_code" IS NOT NULL
