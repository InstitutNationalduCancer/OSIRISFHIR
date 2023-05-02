SELECT
    "Patient_Id" || '-' || "Instance_Id" AS "id_biomarker",
    "Patient_Id" AS "subject",
    "Patient_Id" || '-' || "Analysis_Ref" AS "derivedfrom",
    CASE 
        WHEN "Biomarker_Code" = 'alk' THEN 'C39-43'
        WHEN "Biomarker_Code" = 'pdl1' THEN 'C39-34'
        WHEN "Biomarker_Code" = 'ros1' THEN 'C39-44'
        ELSE "Biomarker_Code"
    END AS "code",
    "Biomarker_Value" AS "value",
    "Biomarker_Unit" AS "value_unit"
FROM
    {{ ref('OSIRIS_pivot_Biomarker') }}
