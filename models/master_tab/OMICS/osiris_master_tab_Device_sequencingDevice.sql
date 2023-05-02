SELECT
    "id_observation" AS "id_sequencingdevice",
    "device" AS "type",
    "device_identifier",
    "device_version_type_coding"
FROM
    {{ ref('osiris_clean_analysis_Observation') }}
WHERE
    "code_coding_code" = 'C37-3' -- only for omics analysis
