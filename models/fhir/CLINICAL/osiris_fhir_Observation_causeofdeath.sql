SELECT
    causeofdeath."id_causeofdeath" AS id,
    json_build_object(
        'resourceType', 'Observation',
        'id',
        fhir_id('{{ ref("osiris_master_tab_Observation_causeofdeath") }}', causeofdeath."id_causeofdeath"::TEXT),
        'meta', json_build_object(
            'profile', json_build_array(
                'https://build.fhir.org/ig/arkhn/arkhn-ig-osiris/StructureDefinition/cause-of-death'
            )
        ),
        'code', json_build_object(
            'coding', json_build_array(
                json_build_object(
                    'system', causeofdeath_cc_code."code_system",
                    'code', causeofdeath."code_coding_code",
                    'display', causeofdeath_cc_code."display"
                )
            )
        ),
        'effectiveDateTime', causeofdeath."causeofdeath_effectiveDateTime",
        'valueCodeableConcept', json_build_object(
            'coding', json_build_array(
                json_build_object(
                    'system', causeofdeath_cc_value."code_system",
                    'code', causeofdeath."causeofdeath_valueCodeableConcept_coding_code",
                    'display', causeofdeath_cc_value."display"
                )
            )
        ),
        'subject', json_build_object(
            'reference', fhir_ref(
                'Patient',
                '{{ ref("osiris_master_tab_Patient") }}',
                causeofdeath."subject"::VARCHAR)
        ),
        'status', 'final'
    ) AS fhir
FROM
    {{ ref('osiris_master_tab_Observation_causeofdeath') }} AS causeofdeath
LEFT JOIN
    {{ ref('osiris_master_tab_Observation_codeableConcept') }} AS causeofdeath_cc_value
    ON causeofdeath."causeofdeath_valueCodeableConcept_coding_code" = causeofdeath_cc_value."code"
LEFT JOIN
    {{ ref('osiris_master_tab_Observation_codeableConcept') }} AS causeofdeath_cc_code
    ON causeofdeath."code_coding_code" = causeofdeath_cc_code."code"
