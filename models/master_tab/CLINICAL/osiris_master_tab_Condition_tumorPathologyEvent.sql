SELECT
    "id_condition",
    "subject",
    "extension_due_to_valuereference",
    "extension_laterality_valueCodeableConcept_coding_code",
    "code_coding_code",
    "bodySite_coding_code",
    "onsetDateTime",
    "recordedDate",
    "stage_morphology_summary_coding_code",
    "extension_histology_extension_histologygradetype",
    "extension_histology_extension_histologygradevalue",
    '116676008' AS "stage_morphology_type_coding_code"
FROM
    {{ ref('osiris_clean_tpe_Condition') }}
