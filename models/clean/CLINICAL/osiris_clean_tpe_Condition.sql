SELECT
    "Patient_Id" || '-' || "Instance_Id" AS "id_condition",
    "Patient_Id" || '-' || "TumorPathologyEvent_ParentRef" AS "extension_due_to_valuereference",
    RIGHT(
        "TumorPathologyEvent_Laterality", -POSITION(':' IN "TumorPathologyEvent_Laterality")
    ) AS "extension_laterality_valueCodeableConcept_coding_code",
    RIGHT("TumorPathologyEvent_Type", -POSITION(':' IN "TumorPathologyEvent_Type")) AS "code_coding_code",
    "TumorPathologyEvent_TopographyCode" AS "bodySite_coding_code",
    "Patient_Id" AS "subject",
    "TumorPathologyEvent_StartDate" AS "onsetDateTime",
    "TumorPathologyEvent_DiagnosisDate" AS "recordedDate",
    replace(replace("TumorPathologyEvent_MorphologyCode", '-', '/'), 'UMLS:', '') AS "stage_morphology_summary_coding_code",
    "TumorPathologyEvent_HistologicalGradeType" AS "extension_histology_extension_histologygradetype",
    "TumorPathologyEvent_HistologicalGradeValue" AS "extension_histology_extension_histologygradevalue",
    "TumorPathologyEvent_StadeType",
    "TumorPathologyEvent_StadeValue",
    "TumorPathologyEvent_PerformanceStatus",
    "TumorPathologyEvent_G8"
FROM
    {{ ref('OSIRIS_pivot_TumorPathologyEvent') }}
