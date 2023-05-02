{{ config(severity = 'warn') }}

SELECT
    vitalstatus."subject",
    causeofdeath."causeofdeath_valueCodeableConcept_coding_code",
    vitalstatus."vitalstatus_valueCodeableConcept_coding_code"
FROM
    {{ ref('osiris_master_tab_Observation_vitalstatus') }} AS vitalstatus
LEFT JOIN
    {{ ref('osiris_master_tab_Observation_causeofdeath') }} AS causeofdeath
    ON causeofdeath."subject" = vitalstatus."subject"
WHERE
    vitalstatus."vitalstatus_valueCodeableConcept_coding_code" = 'C1546956'
    AND causeofdeath."causeofdeath_valueCodeableConcept_coding_code" IS NULL
