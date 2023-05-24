SELECT
    "careplan"."id_careplan" AS id,
    json_build_object(
        'resourceType', 'CarePlan',
        'id', fhir_id('{{ ref("osiris_master_tab_CarePlan") }}', "careplan"."id_careplan"::TEXT),
        'meta', json_build_object(
            'profile', json_build_array(
                'https://build.fhir.org/ig/arkhn/arkhn-ig-osiris/StructureDefinition/treatment'
            )
        ),
        'subject', json_build_object(
            'reference', fhir_ref(
                'Patient',
                '{{ ref("osiris_master_tab_Patient") }}',
                careplan."subject"::VARCHAR)
        ),
        'category', json_build_array(
            json_build_object(
                'coding', json_build_array(
                    json_build_object(
                        'system', careplan_codeableconcept."code_system",
                        'code', careplan."category_coding_code",
                        'display', careplan_codeableconcept."display"
                    )
                )
            )
        ),
        'status', 'unknown',
        'intent', 'plan',
        'period', json_build_object(
            'start', careplan."period_start",
            'end', careplan."period_end"
        ),
        'supportingInfo', json_build_array(
            json_build_object(
                'reference', fhir_ref(
                    'ResearchStudy',
                    '{{ ref("osiris_master_tab_ResearchStudy") }}',
                    careplan."supportinginfo"::VARCHAR
                )
            )
        ),
        'activity', json_build_array(
            json_build_object(
                'detail', json_build_object(
                    'reasonReference', json_build_array(
                        json_build_object(
                            'reference', fhir_ref(
                                'Condition',
                                '{{ ref("osiris_master_tab_Condition_tumorPathologyEvent") }}',
                                careplan."activity_detail_reasonreference"::VARCHAR
                            )
                        )
                    ),
                    'code', json_build_object(
                        'coding', json_build_array(
                            json_build_object(
                                'code', careplan."activity_detail_code"
                            )
                        )
                    ),
                    'status', 'unknown'
                )
            )
        ),
        -- OSIRIS extension
        'extension',
        json_build_array(
            CASE
                WHEN careplan."extension_treatment_line" IS NOT NULL
                    THEN json_build_object(
                        'url',
                        'https://build.fhir.org/ig/arkhn/arkhn-ig-osiris/StructureDefinition-treatment-line.html',
                        'valueInteger', careplan."extension_treatment_line"
                    ) END
        )
    ) AS fhir,
    false as is_deleted, 
    (now()::DATE - INTERVAL '1 day')::DATE as partition_date
FROM
    {{ ref('osiris_master_tab_CarePlan') }} AS careplan
LEFT JOIN
    {{ ref('osiris_master_tab_CarePlan_codeableConcept') }}
    AS careplan_codeableconcept
    ON
        careplan."category_coding_code" = careplan_codeableconcept."code"
