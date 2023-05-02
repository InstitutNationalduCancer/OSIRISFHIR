SELECT
    "id_variant" AS "id_verificationresult",
    "id_variant" AS "target",
    "validationType_coding",
    "validationProcess_text",
    "verification_status" AS "status"
FROM
    {{ ref('osiris_clean_variant_Variant') }}
