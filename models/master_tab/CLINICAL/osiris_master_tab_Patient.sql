SELECT
    "id_patient",
    "identifier_value",
    "gender",
    "birthdate",
    "deceaseddatetime",
    "managingorganization_valuereference",
    "extension_origin_center_valuereference",
    "extension_ethnicity_valueCodeableConcept_coding_code"
FROM
    {{ ref('osiris_clean_patient_Patient') }}
