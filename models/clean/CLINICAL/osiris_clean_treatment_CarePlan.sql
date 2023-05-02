SELECT
    "Patient_Id" || '-' || "Instance_Id" AS "id_treatment",
    "Patient_Id" AS "subject",
    RIGHT("Treatment_Type", -POSITION(':' IN "Treatment_Type")) AS "category_coding_code",
    "Treatment_StartDate" AS "period_start",
    "Treatment_EndDate" AS "period_end",
    NULL AS "activity_detail_code", --missing column in pivot file
    "Patient_Id" || '-' || "TumorPathologyEvent_Ref" AS "activity_detail_reasonreference",
    "Treatment_LineNumber" AS "extension_treatment_line",
    COALESCE(
        "Treatment_ClinicalTrialId"::VARCHAR, 'Unknown'
    ) AS "supportinginfo",
    "Treatment_ClinicalTrialContext",
    COALESCE(
        "Treatment_ClinicalTrialName"::VARCHAR, 'Unknown'
    ) AS "clinical_trial_title",
    "Treatment_SurgeryResectionQuality" AS "surgery_outcome",
    "Treatment_SurgeryNature" AS "surgery_category"
FROM
    {{ ref('OSIRIS_pivot_Treatment') }}
