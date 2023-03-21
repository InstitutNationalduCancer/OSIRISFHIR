SELECT DISTINCT
    "id_researchstudy",
    "identifier_value",
    "title"
FROM
    {{ ref('osiris_clean_treatment_ResearchStudy') }}
