SELECT
    *,
    '1217123003' AS "code_coding_code"
FROM {{ ref('osiris_clean_coursert_Procedure') }}
