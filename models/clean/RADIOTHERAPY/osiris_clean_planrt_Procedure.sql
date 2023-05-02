SELECT
    "Patient_Id" || '-' || "Instance_Id" AS "id_planrt",
    "Patient_Id" AS "subject",
    "Patient_Id" || '-' || "PhaseRT_Ref" AS "partof",
    "ModalityAndTechnique_Ref" AS "modalityandtechnique",
    "Plan_Type" AS "category_coding_code",
    "Plan_NumberOfFractions" AS "extension_numberOfFractions",
    "Plan_StartDate" AS "performedPeriod_start",
    "Plan_EndDate" AS "performedPeriod_end",
    CASE WHEN "Plan_ReasonReplanification"::text = 'UMLS:C1272460' THEN 'C1272460'
        ELSE "Plan_ReasonReplanification"::text
    END AS "extension_reasonReplanification",
    CASE WHEN "Plan_AlgorithmName"::text = 'UMLS:C0439673' THEN 'Unknown'
        ELSE "Plan_AlgorithmName"::text
    END AS "extension_AlgorithName",
    CASE WHEN "Series_Ref"::text = 'UMLS:C0439673' THEN 'Unknown'
        ELSE "Series_Ref"::text
    END AS "extension_basedon_seriesuid",
    CASE WHEN "ROISegmentation_Ref"::text = 'UMLS:C0439673' THEN 'Unknown'
        ELSE "ROISegmentation_Ref"::text
    END AS "extension_basedon_rtstructuid",
    CASE WHEN "Plan_RtDoseUID"::text = 'UMLS:C0439673' THEN 'Unknown'
        ELSE "Plan_RtDoseUID"::text
    END AS "extension_dosetovolume_rtdoseuid",
    CASE WHEN "Plan_RtPlanUID"::text = 'UMLS:C0439673' THEN 'Unknown'
        ELSE "Plan_RtPlanUID"::text
    END AS "identifier_value"
FROM
    {{ ref('OSIRIS_pivot_PlanRT') }}
