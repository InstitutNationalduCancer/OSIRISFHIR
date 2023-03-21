SELECT
    "id_condition" AS "id_condition",
    RIGHT(
        CAST("code_coding_code" AS varchar), -POSITION(':' IN CAST("code_coding_code" AS varchar))
    ) AS "code_coding_code",
    "bodySite_coding_code" AS "bodySite_coding_code",
    "subject" AS "subject",
    "onsetDateTime" AS "onsetDateTime",
    "recordedDate" AS "recordedDate",
    "stage_morphology_summary_coding_code" AS "stage_morphology_summary_coding_code",
    '116676008' AS "stage_morphology_type_coding_code",
    "extension_due_to_valuereference" AS "extension_due_to_valuereference",
    RIGHT(
        CAST("extension_laterality_valueCodeableConcept_coding_code" AS varchar),
        -POSITION(':' IN CAST("extension_laterality_valueCodeableConcept_coding_code" AS varchar))
    ) AS "extension_laterality_valueCodeableConcept_coding_code"
FROM
    {{ ref('osiris_clean_tpe_Condition') }}
