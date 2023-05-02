SELECT
    specimen."id_specimen" AS id,
    json_build_object(
        'resourceType', 'Specimen',
        'id', fhir_id('{{ ref("osiris_master_tab_Specimen_specimen") }}', specimen."id_specimen"::TEXT),
        'meta', json_build_object(
            'profile', json_build_array(
                'https://build.fhir.org/ig/arkhn/arkhn-ig-osiris/StructureDefinition/onco-biological-sample'
            )
        ),
        'type', json_build_object(
            'coding',
            json_build_array(
                json_build_object(
                    'system', type_cc."code_system",
                    'code', specimen."type",
                    'display', type_cc."display"
                )
            ),
            'text', 'Biological sample nature'
        ),
        'subject', json_build_object(
            'reference', fhir_ref(
                'Patient',
                '{{ ref("osiris_master_tab_Patient") }}',
                specimen."subject"::VARCHAR)
        ),
        'parent', json_build_array(
            json_build_object(
                'reference', fhir_ref(
                    'Specimen',
                    '{{ ref("osiris_master_tab_Specimen_specimen") }}',
                    specimen."parent"::VARCHAR
                )
            )
        ),
        'identifier', json_build_array(
            json_build_object(
                'value', specimen."identifier")
        ),
        'collection', json_build_object(
            'collectedDateTime', specimen."collection_collectedDateTime",
            'quantity', json_build_object(
                'value', specimen."collection_quantity_value",
                'unit', '%',
                'system', 'http://www.nlm.nih.gov/research/umls',
                'code', 'C4055283'
            ),
            'bodySite', json_build_object(
                'coding', json_build_array(
                    json_build_object(
                        'system', bodysite_cc."code_system",
                        'code', specimen."collection_bodySite",
                        'display', bodysite_cc."display"
                    )
                ),
                'text', 'Topography code'
            )
        ),
        'condition', json_build_array(
            json_build_object(
                'coding', json_build_array(
                    json_build_object(
                        'system', storage_temp_cc."code_system",
                        'code', specimen."condition_storage_temperature",
                        'display', storage_temp_cc."display"
                    )
                ),
                'text', 'Storage temperature of the sample.'
            )
        ),
        'extension', json_build_array(
            json_build_object(
                'url', 'https://build.fhir.org/ig/arkhn/arkhn-ig-osiris/StructureDefinition/BasedOnCondition',
                'valueReference', json_build_object(
                    'reference', fhir_ref(
                        'Condition',
                        '{{ ref("osiris_master_tab_Condition_tumorPathologyEvent") }}',
                        specimen."extension_basedoncondition"::VARCHAR
                    )
                )
            ),
            json_build_object(
                'url', 'https://build.fhir.org/ig/arkhn/arkhn-ig-osiris/StructureDefinition/BiologicalSampleOrigin',
                'valueCodeableConcept', json_build_object(
                    'coding', json_build_array(
                        json_build_object(
                            'system', origin_cc."code_system",
                            'code', specimen."extension_biologicalsampleorigine",
                            'display', origin_cc."display"
                        )
                    ),
                    'text', 'Origin of the sample'
                )
            )
        )
    ) AS fhir
FROM
    {{ ref('osiris_master_tab_Specimen_specimen') }} AS specimen
LEFT JOIN
    {{ ref('osiris_master_tab_Specimen_codeableConcept') }} AS type_cc
    ON specimen."type" = type_cc."code"
LEFT JOIN
    {{ ref('osiris_master_tab_Specimen_codeableConcept') }} AS bodysite_cc
    ON specimen."collection_bodySite" = bodysite_cc."code"
LEFT JOIN
    {{ ref('osiris_master_tab_Specimen_codeableConcept') }} AS storage_temp_cc
    ON specimen."condition_storage_temperature" = storage_temp_cc."code"
LEFT JOIN
    {{ ref('osiris_master_tab_Specimen_codeableConcept') }} AS origin_cc
    ON specimen."extension_biologicalsampleorigine" = origin_cc."code"
