SELECT
    "Patient_Id" || '-' || "Instance_Id" AS "id_responseevaluation",
    "Patient_Id" AS "subject",
    "Patient_Id" || '-' || "Treatment_Ref" AS "basedon",
    CASE WHEN CAST(CAST("ResponseEvaluation_Date" AS varchar) AS date) IS NULL THEN '1000-01-01'
        ELSE CAST(CAST("ResponseEvaluation_Date" AS varchar) AS date)
    END AS "effectiveDateTime",
    CASE WHEN "ResponseEvaluation_Status"::varchar IS NULL THEN 'C0439673'
        ELSE replace("ResponseEvaluation_Status"::varchar, 'UMLS:', '') 
    END AS "valueCodableConcept"
FROM
    {{ ref('OSIRIS_pivot_ResponseEvaluation') }}
