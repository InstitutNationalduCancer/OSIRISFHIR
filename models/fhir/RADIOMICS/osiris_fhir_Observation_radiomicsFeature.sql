SELECT
    feature."id_feature" AS id,
    json_build_object(
        'resourceType', 'Observation',
        'id', fhir_id(
            '{{ ref("osiris_master_tab_Observation_radiomicsfeature") }}',
            feature."id_feature"::TEXT
        ),
        'meta', json_build_object(
            'profile', json_build_array(
                'http://fhir.arkhn.com/osiris/StructureDefinition/radiomics-features'
            )
        ),
        'status', 'final',
        'subject', json_build_object(
            'reference', fhir_ref(
                'Patient',
                '{{ ref("osiris_master_tab_Patient") }}',
                feature."subject"::VARCHAR
            )
        ),
        'hasMember', json_build_array(
            json_build_object(
                'reference', fhir_ref(
                    'Observation',
                    '{{ ref("osiris_master_tab_Observation_radiomicscriteria") }}',
                    feature."hasmember"::VARCHAR
                )
            )
        ),
        'code', json_build_object(
            'coding', json_build_array(
                json_build_object(
                    'system', codeableconcept."code_system",
                    'code', feature."code_coding_code",
                    'display', codeableconcept."display"
                )
            ),
            'text', feature."code_coding_text"
        ),
        'valueQuantity', json_build_object(
            'value', feature."value"
        )
    ) AS fhir
FROM
    {{ ref('osiris_master_tab_Observation_radiomicsfeature') }} AS feature
LEFT JOIN
    {{ ref('osiris_master_tab_Observation_radiomics_codeableconcept') }} AS codeableconcept
    ON feature."code_coding_code" = codeableconcept."code"
