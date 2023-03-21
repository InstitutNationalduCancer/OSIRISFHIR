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
                'http://fhir.arkhn.com/osiris/StructureDefinition/analysis'
            )
        ),
        'identifier',
        json_build_array(
            json_build_object(
                'value', observation."identifier_value")
        ),
        'subject', json_build_object(
            'reference', fhir_ref(
                'Patient',
                '"osiris_master_tab_Patient"',
                observation."subject"::VARCHAR)
        ),
        'status', 'final',
        'category', json_build_array(
            json_build_object(
                'coding', json_build_array(
                    json_build_object(
                        'system', observation_codeableconcept_category."code_system",
                        'code', observation."category_coding_code",
                        'display', observation_codeableconcept_category."display"
                    )
                )
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
                    '"osiris_master_tab_Condition"',
                    observation."focus"::VARCHAR
                )
            )
        ),
        'effectiveDateTime', observation."effectiveDateTime"

    )
    AS fhir
FROM
    {{ ref('osiris_master_tab_Observation_analysis') }}
    AS observation
LEFT JOIN
    {{ ref('osiris_master_tab_Observation_codeableConcept') }}
    AS observation_codeableconcept_category
    ON
        observation."category_coding_code" = observation_codeableconcept_category."code"
LEFT JOIN
    {{ ref('osiris_master_tab_Observation_codeableConcept') }}
    AS observation_codeableconcept_code
    ON
        observation."code_coding_code" = observation_codeableconcept_code."code"
