SELECT
    "OSIRIS_pivot_TumorPathologyEvent"."Instance_Id" AS "id_condition",
    "OSIRIS_pivot_TumorPathologyEvent"."TumorPathologyEvent_ParentRef" AS
    "extension_due_to_valuereference",
    "OSIRIS_pivot_TumorPathologyEvent"."TumorPathologyEvent_Laterality" AS
    "extension_laterality_valueCodeableConcept_coding_code",
    "OSIRIS_pivot_TumorPathologyEvent"."TumorPathologyEvent_Type" AS "code_coding_code",
    "OSIRIS_pivot_TumorPathologyEvent"."TumorPathologyEvent_TopographyCode" AS
    "bodySite_coding_code",
    "OSIRIS_pivot_TumorPathologyEvent"."Patient_Id" AS
    subject,
    "OSIRIS_pivot_TumorPathologyEvent"."TumorPathologyEvent_StartDate" AS
    "onsetDateTime",
    "OSIRIS_pivot_TumorPathologyEvent"."TumorPathologyEvent_DiagnosisDate" AS
    "recordedDate",
    "OSIRIS_pivot_TumorPathologyEvent"."TumorPathologyEvent_MorphologyCode" AS
    "stage_morphology_summary_coding_code",
    '116676008' AS
    "stage_morphology_type_coding_code"
FROM
    {{ ref('OSIRIS_pivot_TumorPathologyEvent') }}
