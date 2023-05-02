SELECT
    "Patient_Id" || '-' || "Instance_Id" AS "id_feature",
    "Patient_Id" AS "subject",
    "Patient_Id" || '-' || "RadiomicsCriteria_Ref" AS "hasmember",
    CASE
        WHEN "RadiomicsFeature_Id"::text = 'UMLS:C0439673' THEN 'C0439673'
        ELSE "RadiomicsFeature_Id"::text
    END AS "code_coding_code",
    "RadiomicsFeature_Name" AS "code_coding_text",
    "RadiomicsFeature_Value" AS "value"
FROM
    {{ ref('OSIRIS_pivot_RadiomicsFeature') }}
