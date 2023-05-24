SELECT
    observation."id_observation" AS "id",
    json_build_object(
        'resourceType', 'Observation',
        'id',
        fhir_id(
            '{{ ref("osiris_master_tab_Observation_analysis") }}',
            observation."id_observation"::TEXT
        ),
        'meta',
        json_build_object(
            'profile', json_build_array(
                'https://build.fhir.org/ig/arkhn/arkhn-ig-osiris/StructureDefinition/analysis'
            )
        ),
        'subject', json_build_object(
            'reference', fhir_ref(
                'Patient',
                '{{ ref("osiris_master_tab_Patient") }}',
                observation."subject"::VARCHAR)
        ),
        'status', 'final',
        'category', json_build_array(
            json_build_object(
                'text', observation."category_text"
            )
        ),
        'code', json_build_object(
            'coding', json_build_array(
                json_build_object(
                    'system', observation_codeableconcept_code."code_system",
                    'code', observation."code_coding_code",
                    'display', observation_codeableconcept_code."display"
                )
            )
        ),
        'focus', json_build_array(
            json_build_object(
                'reference', fhir_ref(
                    'Condition',
                    '{{ ref("osiris_master_tab_Condition_tumorPathologyEvent") }}',
                    observation."focus"
                )
            )
        ),
        'effectiveDateTime', observation."effectiveDateTime"

    )
    AS fhir,
    false as is_deleted, 
    (now()::DATE - INTERVAL '1 day')::DATE as partition_date
FROM
    {{ ref('osiris_master_tab_Observation_analysis') }}
    AS observation
LEFT JOIN
    {{ ref('osiris_master_tab_Observation_codeableConcept') }}
    AS observation_codeableconcept_code
    ON
        observation."code_coding_code" = observation_codeableconcept_code."code"
