SELECT
    "Instance_Id" AS "id_feature",
    "Patient_Id" AS "subject",
    "RadiomicsCriteria_Ref" AS "hasmember",
    CASE
        WHEN "RadiomicsFeature_Id" = 'UMLS:C0439673' THEN 'C0439673'
        ELSE "RadiomicsFeature_Id"
    END AS "code_coding_code",
    "RadiomicsFeature_Name" AS "code_coding_text",
    "RadiomicsFeature_Value" AS "value"
FROM
    {{ ref('OSIRIS_pivot_RadiomicsFeature') }}
