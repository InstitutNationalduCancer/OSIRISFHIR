SELECT
    ROW_NUMBER() OVER (ORDER BY "id_patient") AS "id_vitalstatus",
    '22023-6' AS "code_coding_code",
    "id_patient" AS "subject",
    "vitalstatus_effectiveDateTime",
    "vitalstatus_valueCodeableConcept_coding_code"
FROM
    {{ ref('osiris_clean_patient_Patient') }}
