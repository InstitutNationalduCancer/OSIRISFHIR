SELECT
    coursert."id_coursert" AS id,
    json_build_object(
        'resourceType', 'Procedure',
        'id', fhir_id(
            '{{ ref("osiris_master_tab_Procedure_radiotherapycourse") }}',
            coursert."id_coursert"::TEXT
        ),
        'meta', json_build_object(
            'profile', json_build_array(
                'http://fhir.arkhn.com/osiris/StructureDefinition/radiotherapy-course-summary'
            )
        ),
        'subject', json_build_object(
            'reference', fhir_ref(
                'Patient',
                '"osiris_master_tab_Patient"',
                coursert."subject"::VARCHAR
            )
        ),
        'basedOn', json_build_array(
            json_build_object(
                'reference', fhir_ref(
                    'CarePlan',
                    '"osiris_master_tab_CarePlan"',
                    coursert."basedon"::VARCHAR
                )
            )
        ),
        'category', json_build_object(
            'coding', json_build_array(
                json_build_object(
                    'system', codeableconcept_category."code_system",
                    'code', coursert."category_coding_code",
                    'display', codeableconcept_category."display"
                )
            )
        ),
        'code', json_build_object(
            'coding', json_build_array(
                json_build_object(
                    'system', codeableconcept_code."code_system",
                    'code', coursert."code_coding_code",
                    'display', codeableconcept_code."display"
                )
            )
        ),
        'performedPeriod', json_build_object(
            'start', coursert."performedPeriod_start",
            'end', coursert."performedPeriod_end"
        ),
        'status', 'completed',
        -- OSIRIS extension
        'extension', json_build_array(
            CASE WHEN coursert."extension_treatmentIntent" IS NOT NULL THEN json_build_object(
                'url', 'http://fhir.arkhn.com/osiris/StructureDefinition/treatmentIntent',
                'valueCodeableConcept', json_build_object(
                    'coding', json_build_array(
                        json_build_object(
                            'system', codeableconcept_treatmentintent."code_system",
                            'code', coursert."extension_treatmentIntent",
                            'display', codeableconcept_treatmentintent."display"
                        )
                    )
                )
                ) END,
            CASE WHEN coursert."extension_numberOfSessions" IS NOT NULL THEN json_build_object(
                'url', 'http://fhir.arkhn.com/osiris/StructureDefinition/numberOfSessions',
                'valueUnsignedInt', coursert."extension_numberOfSessions"
                ) END,
            CASE
                WHEN
                    coursert."extension_treatmentTerminationReason" IS NOT NULL
                    THEN json_build_object(
                        'url',
                        'http://fhir.arkhn.com/osiris/StructureDefinition/treatmentTerminationReason',
                        'valueCodeableConcept', json_build_object(
                            'coding', json_build_array(
                                json_build_object(
                                    'system', codeableconcept_treatmenttermination."code_system",
                                    'code', coursert."extension_treatmentTerminationReason",
                                    'display', codeableconcept_treatmenttermination."display"
                                )
                            )
                        )
                    ) END
        )
    ) AS fhir
FROM
    {{ ref('osiris_master_tab_Procedure_radiotherapycourse') }} AS coursert
LEFT JOIN
    {{ ref('osiris_master_tab_Procedure_radiotherapy_codeableconcept') }}
    AS codeableconcept_category
    ON coursert."category_coding_code" = codeableconcept_category."code"
LEFT JOIN
    {{ ref('osiris_master_tab_Procedure_radiotherapy_codeableconcept') }}
    AS codeableconcept_treatmentintent
    ON coursert."extension_treatmentIntent" = codeableconcept_treatmentintent."code"
LEFT JOIN
    {{ ref('osiris_master_tab_Procedure_radiotherapy_codeableconcept') }}
    AS codeableconcept_treatmenttermination
    ON coursert."extension_treatmentTerminationReason" = codeableconcept_treatmenttermination."code"
LEFT JOIN
    {{ ref('osiris_master_tab_Procedure_radiotherapy_codeableconcept') }}
    AS codeableconcept_code
    ON coursert."code_coding_code" = codeableconcept_code."code"
