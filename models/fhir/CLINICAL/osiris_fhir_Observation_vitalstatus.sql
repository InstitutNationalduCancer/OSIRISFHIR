SELECT
    vitalstatus."id_vitalstatus" AS id,
    json_build_object(
        'resourceType', 'Observation',
        'id',
        fhir_id('{{ ref("osiris_master_tab_Observation_vitalstatus") }}', vitalstatus."id_vitalstatus"::TEXT),
        'meta', json_build_object(
            'profile', json_build_array(
                'https://build.fhir.org/ig/arkhn/arkhn-ig-osiris/StructureDefinition/vital-status'
            )
        ),
        'code', json_build_object(
            'coding', json_build_array(
                json_build_object(
                    'system', vitalstatus_cc_code."code_system",
                    'code', vitalstatus."code_coding_code",
                    'display', vitalstatus_cc_code."display"
                )
            )
        ),
        'effectiveDateTime', vitalstatus."vitalstatus_effectiveDateTime",
        'valueCodeableConcept', json_build_object(
            'coding', json_build_array(
                json_build_object(
                    'system', vitalstatus_cc_value."code_system",
                    'code', vitalstatus."vitalstatus_valueCodeableConcept_coding_code",
                    'display', vitalstatus_cc_value."display"
                )
            )
        ),
        'subject', json_build_object(
            'reference', fhir_ref(
                'Patient',
                '{{ ref("osiris_master_tab_Patient") }}',
                vitalstatus."subject"::VARCHAR)
        ),
        'status', 'final'
    ) AS fhir
FROM
    {{ ref('osiris_master_tab_Observation_vitalstatus') }} AS vitalstatus
LEFT JOIN
    {{ ref('osiris_master_tab_Observation_codeableConcept') }} AS vitalstatus_cc_value
    ON vitalstatus."vitalstatus_valueCodeableConcept_coding_code" = vitalstatus_cc_value."code"
LEFT JOIN
    {{ ref('osiris_master_tab_Observation_codeableConcept') }} AS vitalstatus_cc_code
    ON vitalstatus."code_coding_code" = vitalstatus_cc_code."code"
