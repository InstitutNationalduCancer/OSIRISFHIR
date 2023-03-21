SELECT
    "id_patient",
    "identifier_value",
    "gender",
    "birthdate",
    "deceaseddatetime",
    "managingorganization_valuereference",
    "extension_origin_center_valuereference",
    "extension_ethnicity_valueCodeableConcept_coding_code",
    CASE
        WHEN "extension_ethnicity_valueCodeableConcept_coding_code" IS NULL THEN NULL
        ELSE 'http://terminology.hl7.org/CodeSystem/v3-Race'
    END AS "extension_ethnicity_valueCodeableConcept_coding_system"
FROM
    {{ ref('osiris_clean_patient_Patient') }}
