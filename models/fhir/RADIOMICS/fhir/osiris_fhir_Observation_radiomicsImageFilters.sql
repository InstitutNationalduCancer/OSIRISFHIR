SELECT
    imagefilter."id_imagefilter" AS id,
    json_build_object(
        'resourceType', 'Observation',
        'id', fhir_id(
            '{{ ref("osiris_master_tab_Observation_radiomicsimagefilter") }}',
            imagefilter."id_imagefilter"::TEXT
        ),
        'meta', json_build_object(
            'profile', json_build_array(
                'https://build.fhir.org/ig/arkhn/arkhn-ig-osiris/StructureDefinition/radiomics-Image-filters'
            )
        ),
        'partOf', json_build_array(
            json_build_object(
                'reference', fhir_ref(
                    'ImagingStudy',
                    '{{ ref("osiris_master_tab_ImagingStudy") }}',
                    imagefilter."id_imagingstudy"::VARCHAR
                )
            )
        ),
        'status', 'final',
        'note', json_build_array(
            json_build_object(
                'text', imagefilter."note"
            )
        ),
        'subject', json_build_object(
            'reference', fhir_ref(
                'Patient',
                '{{ ref("osiris_master_tab_Patient") }}',
                imagefilter."subject"::VARCHAR
            )
        ),
        'code', json_build_object(
            'coding', json_build_array(
                json_build_object(
                    'system', 'http://loinc.org',
                    'code', '85430-7',
                    'display', 'Diagnostic imaging report'
                )
            )
        ),
        -- OSIRIS extension
        'extension', json_build_array(
            json_build_object(
                'extension', json_build_array(
                    json_build_object(
                        'url', 'softwareName',
                        'valueString', imagefilter."extension_softwareName_valueString"
                    ),
                    json_build_object(
                        'url', 'softwareVersion',
                        'valueString', imagefilter."extension_softwareVersion_valueString"
                    ),
                    CASE WHEN imagefilter."extension_filterMethod_valueString" IS NOT NULL
                        THEN json_build_object(
                            'url', 'filterMethod',
                            'valueString', imagefilter."extension_filterMethod_valueString"
                        ) END,
                    CASE WHEN imagefilter."extension_filterType_valueString" IS NOT NULL
                        THEN json_build_object(
                            'url', 'filterType',
                            'valueString', imagefilter."extension_filterType_valueString"
                        ) END,
                    CASE WHEN imagefilter."extension_filterInterpolation_valueString" IS NOT NULL
                        THEN json_build_object(
                            'url', 'filterInterpolation',
                            'valueString', imagefilter."extension_filterInterpolation_valueString"
                        ) END,
                    CASE
                        WHEN
                            imagefilter."extension_intensityRounding_extension_valueString_valueString"
                            IS NOT NULL
                            THEN json_build_object(
                                'extension', json_build_array(
                                    json_build_object(
                                        'url', 'code',
                                        'valueCoding', json_build_object(
                                            'system', imagefilter_cc."code_system",
                                            'code',
                                            imagefilter."extension_intensityRounding_extension_valueCode_code",
                                            'display', imagefilter_cc."display"
                                        )
                                    ),
                                    json_build_object(
                                        'url', 'valueString',
                                        'valueString',
                                        imagefilter."extension_intensityRounding_extension_valueString_valueString"
                                    )
                                ),
                                'url', 'intensityRounding'
                            ) END,
                    CASE WHEN imagefilter."extension_boundaryCondition_valueString" IS NOT NULL
                        THEN json_build_object(
                            'url', 'boundaryCondition',
                            'valueString', imagefilter."extension_boundaryCondition_valueString"
                        ) END
                ),
                'url',
                'https://build.fhir.org/ig/arkhn/arkhn-ig-osiris/StructureDefinition/radiomics-image-filters-settings'
            )
        )
    ) AS fhir,
    false as is_deleted,
    (now()::DATE - INTERVAL '1 day')::DATE as partition_date
FROM
    {{ ref('osiris_master_tab_Observation_radiomicsimagefilter') }} AS imagefilter
LEFT JOIN
    {{ ref('osiris_master_tab_Observation_radiomics_codeableconcept') }} AS imagefilter_cc
    ON imagefilter."extension_intensityRounding_extension_valueCode_code" = imagefilter_cc."code"
