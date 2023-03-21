SELECT
    "id_observation" AS id_observation,
    "identifier_value" AS "identifier_value",
    RIGHT("category_coding_code", -POSITION(':' IN "category_coding_code")) AS
    "category_coding_code",
    CASE
        WHEN "code_coding_code" IS NULL THEN 'C0439673'
        ELSE
            RIGHT(
                CAST("code_coding_code" AS varchar),
                -POSITION(':' IN CAST("code_coding_code" AS varchar))
            )
    END AS "code_coding_code",
    "subject" AS "subject",
    "focus" AS "focus",
    "effectiveDateTime" AS "effectiveDateTime"
FROM
    {{ ref('osiris_clean_analysis_Observation') }}
