
{{ config(severity = 'warn') }}

SELECT *
FROM
    {{ ref('osiris_master_tab_Condition_tumorPathologyEvent') }}
WHERE
    "extension_histology_extension_histologygradetype" IS NULL
    AND "extension_histology_extension_histologygradevalue" IS NOT NULL
