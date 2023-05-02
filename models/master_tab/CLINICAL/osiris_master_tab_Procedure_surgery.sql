SELECT
    'surgery_identifier' || row_number() OVER () AS id_surgery,
    "id_treatment" AS "treatment",
    "subject",
    "surgery_category" AS "category",
    "surgery_outcome" AS "outcome"
FROM
    {{ ref('osiris_clean_treatment_CarePlan') }}
WHERE
    "category_coding_code" = 'C0728940'
