SELECT
    condition."id_condition" AS id,
    json_build_object(
        'resourceType', 'Condition',
        'id',
        fhir_id(
            '{{ ref("osiris_master_tab_Condition") }}',
            condition."id_condition"::TEXT
        ),
        'meta', json_build_object(
            'profile', json_build_array(
                'http://fhir.arkhn.com/osiris/StructureDefinition/tumor-pathology-event'
            )
        ),
        'code', json_build_object(
            'coding', json_build_array(
                json_build_object(
                    'system', condition_code."code_system",
                    'code', condition."code_coding_code",
                    'display', condition_code."display"
                )
            )
        ),
        'bodySite', json_build_array(
            json_build_object(
                'coding', json_build_array(
                    json_build_object(
                        'system', condition_bodysite."code_system",
                        'code', condition."bodySite_coding_code",
                        'display', condition_bodysite."display"
                    )
                )
            )
        ),
        'subject', json_build_object(
            'reference', fhir_ref(
                'Patient',
                '{{ ref("osiris_master_tab_Patient") }}',
                condition."subject"
            )
        ),
        'onsetDateTime', condition."onsetDateTime",
        'recordedDate', condition."recordedDate",
        'stage', json_build_array(
            json_build_object(
                'summary', json_build_object(
                    'coding', json_build_array(
                        json_build_object(
                            'system', condition_stage_summary."code_system",
                            'code', condition."stage_morphology_summary_coding_code",
                            'display', condition_stage_summary."display"
                        )
                    )
                ),
                'type', json_build_object(
                    'coding', json_build_array(
                        json_build_object(
                            'system', condition_stage_type."code_system",
                            'code', condition."stage_morphology_type_coding_code",
                            'display', condition_stage_type."display"
                        )
                    )
                )
            )
        ),
        -- OSIRIS extension
        'extension',
        json_build_array(
            CASE
                WHEN condition."extension_due_to_valuereference" IS NOT NULL
                    THEN json_build_object(
                        'url',
                        'http://fhir.arkhn.com/osiris/StructureDefinition/dueTo-tumor-pathology-event',
                        'valueReference', json_build_object(
                            'reference', fhir_ref(
                                'Condition',
                                '{{ ref("osiris_master_tab_Condition") }}',
                                condition."extension_due_to_valuereference"::VARCHAR)
                        )
                    ) END,
            CASE
                WHEN condition."extension_laterality_valueCodeableConcept_coding_code" IS NOT NULL
                    THEN json_build_object(
                        'url', 'https://fhir.arkhn.com/osiris/StructureDefinition-laterality.html',
                        'valueCodeableConcept', json_build_object(
                            'coding', json_build_array(
                                json_build_object(
                                    'system', condition_laterality."code_system",
                                    'code', condition."extension_laterality_valueCodeableConcept_coding_code",
                                    'display', condition_laterality."display"
                                )
                            )
                        )
                    ) END
        )
    ) AS fhir
FROM
    {{ ref('osiris_master_tab_Condition') }} AS condition
LEFT JOIN
    {{ ref('osiris_master_tab_Condition_codeableConcept') }} AS condition_stage_summary
    ON
        condition."stage_morphology_summary_coding_code" = condition_stage_summary."code"
LEFT JOIN
    {{ ref('osiris_master_tab_Condition_codeableConcept') }} AS condition_bodysite
    ON
        condition."bodySite_coding_code" = condition_bodysite."code"
LEFT JOIN
    {{ ref('osiris_master_tab_Condition_codeableConcept') }} AS condition_code
    ON
        condition."code_coding_code" = condition_code."code"
LEFT JOIN
    {{ ref('osiris_master_tab_Condition_codeableConcept') }} AS condition_stage_type
    ON
        condition."stage_morphology_type_coding_code" = condition_stage_type."code"
LEFT JOIN
    {{ ref('osiris_master_tab_Condition_codeableConcept') }} AS condition_laterality
    ON
        condition."extension_laterality_valueCodeableConcept_coding_code"
        = condition_laterality."code"
