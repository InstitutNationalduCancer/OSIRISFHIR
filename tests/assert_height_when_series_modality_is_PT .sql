{{ config(severity = 'warn') }}

SELECT *
FROM
    {{ ref('osiris_master_tab_ImagingStudy') }}
WHERE
    "series_modality_code" = 'PT'
    AND "series_extension_patient_height" IS NULL
