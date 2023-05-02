{{ config(severity = 'warn') }}

SELECT
    patient."id_patient",
    patient."deceaseddatetime",
    vitalstatus."vitalstatus_valueCodeableConcept_coding_code"
FROM
    {{ ref('osiris_master_tab_Patient') }} AS patient
LEFT JOIN
    {{ ref('osiris_master_tab_Observation_vitalstatus') }} AS vitalstatus
    ON patient."id_patient" = vitalstatus."subject"
WHERE
    vitalstatus."vitalstatus_valueCodeableConcept_coding_code" = 'C1546956'
    AND patient."deceaseddatetime" IS NULL
