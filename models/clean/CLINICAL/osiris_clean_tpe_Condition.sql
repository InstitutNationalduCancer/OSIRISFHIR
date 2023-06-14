SELECT
    "Patient_Id" || '-' || "Instance_Id" AS "id_condition",
    "Patient_Id" || '-' || "TumorPathologyEvent_ParentRef" AS "extension_due_to_valuereference",
    RIGHT(
        "TumorPathologyEvent_Laterality", -POSITION(':' IN "TumorPathologyEvent_Laterality")
    ) AS "extension_laterality_valueCodeableConcept_coding_code",
    CASE 
	WHEN "TumorPathologyEvent_Type" IS NOT NULL THEN RIGHT("TumorPathologyEvent_Type", -POSITION(':' IN "TumorPathologyEvent_Type")) 
	ELSE 'C0439673'
	END AS "code_coding_code",
    "TumorPathologyEvent_TopographyCode" AS "bodySite_coding_code",
    "Patient_Id" AS "subject",
    CASE
	WHEN "TumorPathologyEvent_StartDate" IS NOT NULL THEN "TumorPathologyEvent_StartDate"
	ELSE '1000-01-01'
	END AS "onsetDateTime",
    CASE 
	WHEN "TumorPathologyEvent_DiagnosisDate" IS NOT NULL THEN "TumorPathologyEvent_StartDate"
	ELSE '1000-01-01'
	END AS "recordedDate",
    CASE 
	WHEN "TumorPathologyEvent_MorphologyCode" is NOT NULL THEN replace(replace("TumorPathologyEvent_MorphologyCode", '-', '/'), 'UMLS:', '')
	ELSE 'C0430673'	
	END AS "stage_morphology_summary_coding_code",
    "TumorPathologyEvent_HistologicalGradeType" AS "extension_histology_extension_histologygradetype",
    "TumorPathologyEvent_HistologicalGradeValue" AS "extension_histology_extension_histologygradevalue",
    "TumorPathologyEvent_StadeType",
    "TumorPathologyEvent_StadeValue",
    "TumorPathologyEvent_PerformanceStatus",
    "TumorPathologyEvent_G8"
FROM
    {{ ref('OSIRIS_pivot_TumorPathologyEvent') }}
