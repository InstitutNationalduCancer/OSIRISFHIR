SELECT DISTINCT
    'http://finess.sante.gouv.fr' AS "identifier_finess_system",
    "managingorganization_valuereference" AS "identifier_finess_value"
FROM
    {{ ref('osiris_clean_patient_Patient') }}
WHERE "managingorganization_valuereference" IS NOT NULL
UNION
SELECT DISTINCT
    'http://finess.sante.gouv.fr' AS "identifier_finess_system",
    "extension_origin_center_valuereference" AS "identifier_finess_value"
FROM
    {{ ref('osiris_clean_patient_Patient') }}
WHERE "extension_origin_center_valuereference" IS NOT NULL
