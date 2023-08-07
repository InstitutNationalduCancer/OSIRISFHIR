SELECT
    phasert."id_phasert" AS id,
    json_build_object(
        'resourceType', 'Procedure',
        'id', fhir_id(
            '{{ ref("osiris_master_tab_Procedure_radiotherapyphase") }}',
            phasert."id_phasert"::TEXT
        ),
        'meta', json_build_object(
            'profile', json_build_array(
                'http://fhir.arkhn.com/osiris/StructureDefinition/radiotherapy-phase'
            )
        ),
        'subject', json_build_object(
            'reference', fhir_ref(
                'Patient',
                '{{ ref("osiris_master_tab_Patient") }}',
                phasert."subject"::VARCHAR
            )
        ),
        'partOf', json_build_array(
            json_build_object(
                'reference', fhir_ref(
                    'Procedure',
                    '{{ ref("osiris_master_tab_Procedure_radiotherapycourse") }}',
                    phasert."partof"::VARCHAR
                )
            )
        ),
        'category', json_build_object(
            'coding', json_build_array(
                json_build_object(
                    'system', codeableconcept_category."code_system",
                    'code', phasert."category_coding_code",
                    'display', codeableconcept_category."display"
                )
            )
        ),
        'code', json_build_object(
            'coding', json_build_array(
                json_build_object(
                    'system', codeableconcept_code."code_system",
                    'code', phasert."code_coding_code",
                    'display', codeableconcept_code."display"
                )
            )
        ),
        'performedPeriod', json_build_object(
            'start', phasert."performedPeriod_start",
            'end', phasert."performedPeriod_end"
        ),
        'status', 'completed',
        -- OSIRIS extension
        'extension', json_build_array(
            json_build_object(
                'url', 'http://fhir.arkhn.com/osiris/StructureDefinition/numberOfFractions',
                'valueUnsignedInt', phasert."extension_numberOfFractions"
            )
        )
    ) AS fhir
FROM
    {{ ref('osiris_master_tab_Procedure_radiotherapyphase') }} AS phasert
LEFT JOIN
    {{ ref('osiris_master_tab_Procedure_radiotherapy_codeableconcept') }}
    AS codeableconcept_category
    ON phasert."category_coding_code" = codeableconcept_category."code"
LEFT JOIN
    {{ ref('osiris_master_tab_Procedure_radiotherapy_codeableconcept') }}
    AS codeableconcept_code
    ON phasert."code_coding_code" = codeableconcept_code."code"
