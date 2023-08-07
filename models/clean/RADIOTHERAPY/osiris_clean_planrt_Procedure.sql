SELECT
    "Instance_Id" AS "id_planrt",
    "Patient_Id" AS "subject",
    "PhaseRT_Ref" AS "partof",
    "ModalityAndTechnique_Ref" AS "modalityandtechnique",
    "Plan_Type" AS "category_coding_code",
    "Plan_NumberOfFractions" AS "extension_numberOfFractions",
    "Plan_StartDate" AS "performedPeriod_start",
    "Plan_EndDate" AS "performedPeriod_end",
    CASE WHEN "Plan_ReasonReplanification" = 'UMLS:C1272460' THEN 'C1272460'
        ELSE "Plan_ReasonReplanification"
    END AS "extension_reasonReplanification",
    CASE WHEN "Plan_AlgorithmName" = 'UMLS:C0439673' THEN 'Unknown'
        ELSE "Plan_AlgorithmName"
    END AS "extension_AlgorithName",
    CASE WHEN "Series_Ref" = 'UMLS:C0439673' THEN 'Unknown'
        ELSE "Series_Ref"
    END AS "extension_basedon_seriesuid",
    CASE WHEN "ROISegmentation_Ref" = 'UMLS:C0439673' THEN 'Unknown'
        ELSE "ROISegmentation_Ref"
    END AS "extension_basedon_rtstructuid",
    CASE WHEN "Plan_RtDoseUID" = 'UMLS:C0439673' THEN 'Unknown'
        ELSE "Plan_RtDoseUID"
    END AS "extension_dosetovolume_rtdoseuid",
    CASE WHEN "Plan_RtPlanUID" = 'UMLS:C0439673' THEN 'Unknown'
        ELSE "Plan_RtPlanUID"
    END AS "identifier_value"
FROM
    {{ ref('OSIRIS_pivot_PlanRT') }}
