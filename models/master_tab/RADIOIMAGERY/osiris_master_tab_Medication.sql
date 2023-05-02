SELECT
    "id_medication",
    "code_text"
FROM
    {{ ref('osiris_clean_injection_Medication') }}
