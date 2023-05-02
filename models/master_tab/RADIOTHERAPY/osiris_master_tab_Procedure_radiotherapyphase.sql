SELECT
    *,
    '1222565005' AS "code_coding_code"
FROM
    {{ ref('osiris_clean_phasert_Procedure') }}
