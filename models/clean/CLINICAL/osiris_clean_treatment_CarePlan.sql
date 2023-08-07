SELECT
    "OSIRIS_pivot_Treatment"."Instance_Id" AS "id_treatment",
    "OSIRIS_pivot_Treatment"."Patient_Id" AS "subject",
    "OSIRIS_pivot_Treatment"."Treatment_Type" AS "category_coding_code",
    "OSIRIS_pivot_Treatment"."Treatment_StartDate" AS "period_start",
    "OSIRIS_pivot_Treatment"."Treatment_EndDate" AS "period_end",
    "OSIRIS_pivot_Treatment"."Treatment_ActivityCode" AS "activity_activity_code",
    "OSIRIS_pivot_Treatment"."TumorPathologyEvent_Ref" AS "activity_detail_reasonreference",
    "OSIRIS_pivot_Treatment"."Treatment_LineNumber" AS "extension_treatment_line",
    COALESCE(
        "OSIRIS_pivot_Treatment"."Treatment_ClinicalTrialId"::VARCHAR, 'Unknown'
    ) AS "supportinginfo"
FROM
    {{ ref('OSIRIS_pivot_Treatment') }}
