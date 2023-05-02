{{ config(severity = 'warn') }}

SELECT *
FROM
    {{ ref('osiris_master_tab_Procedure_radiotherapycourse') }}
WHERE
    "category_coding_code" = 'Planned'
    AND "extension_numberOfSessions" IS NULL
