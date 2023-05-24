SELECT
    criteria."id_criteria" AS id,
    json_build_object(
        'resourceType', 'Observation',
        'id', fhir_id(
            '{{ ref("osiris_master_tab_Observation_radiomicscriteria") }}',
            criteria."id_criteria"::TEXT
        ),
        'meta', json_build_object(
            'profile', json_build_array(
                'https://build.fhir.org/ig/arkhn/arkhn-ig-osiris/StructureDefinition/radiomics-criteria'
            )
        ),
        'status', 'final',
        'code', json_build_object(
            'coding', json_build_array(
                json_build_object(
                    'system', 'http://loinc.org',
                    'code', '85430-7',
                    'display', 'Diagnostic imaging report'
                )
            )
        ),
        'subject', json_build_object(
            'reference', fhir_ref(
                'Patient',
                '{{ ref("osiris_master_tab_Patient") }}',
                criteria."subject"::VARCHAR
            )
        ),
        'focus', json_build_array(
            json_build_object(
                'reference', fhir_ref(
                    'Observation',
                    '{{ ref("osiris_master_tab_Observation_roisegmentation") }}',
                    criteria."focus"::VARCHAR
                )
            )
        ),
        'hasMember', json_build_array(json_build_object(
                'reference', fhir_ref(
                    'Observation',
                    '{{ ref("osiris_master_tab_Observation_radiomicsimagefilter") }}',
                    criteria."hasmember"::VARCHAR
                )
            )
        ),
        --extension OSIRIS
        'extension', json_build_array(
            json_build_object(
                'extension', json_build_array(
                    json_build_object(
                        'extension', json_build_array(
                            json_build_object(
                                'url', 'code',
                                'valueCoding', json_build_object(
                                    'system', criteria_cc_softwarename."code_system",
                                    'code',
                                    criteria."extension_settings_softwareName_valueCoding_code",
                                    'display', criteria_cc_softwarename."display"
                                )
                            ),
                            json_build_object(
                                'url', 'valueString',
                                'valueString',
                                criteria."extension_settings_softwareName_valueString_valueString"
                            )
                        ),
                        'url', 'softwareName'
                    ),
                    json_build_object(
                        'extension', json_build_array(
                            json_build_object(
                                'url', 'code',
                                'valueCoding', json_build_object(
                                    'system', criteria_cc_softwareversion."code_system",
                                    'code',
                                    criteria."extension_settings_softwareVersion_valueCoding_code",
                                    'display', criteria_cc_softwareversion."display"
                                )
                            ),
                            json_build_object(
                                'url', 'valueString',
                                'valueString',
                                criteria."extension_settings_softwareVersion_valueString_valueString"
                            )
                        ),
                        'url', 'softwareVersion'
                    ),
                    json_build_object(
                        'url', 'localizationMethod',
                        'valueString', criteria."extension_settings_localizationMethod_valueString"
                    ),
                    CASE WHEN criteria."extension_settings_windowMatrix_valueString" IS NOT NULL
                        THEN json_build_object(
                            'url', 'windowMatrix',
                            'valueString', criteria."extension_settings_windowMatrix_valueString"
                        ) END,
                    json_build_object(
                        'url', 'usedImageFilter',
                        'valueString', criteria."extension_settings_usedImageFilter_valueString"
                    ),
                    json_build_object(
                        'url', 'usedImageFilterParameters',
                        'valueString',
                        criteria."extension_settings_usedImageFilterParameters_valueString"
                    ),
                    json_build_object(
                        'extension', json_build_array(
                            json_build_object(
                                'url', 'code',
                                'valueCoding', json_build_object(
                                    'system', criteria_cc_distance."code_system",
                                    'code',
                                    criteria."extension_settings_distanceWeighting_valueCoding_code",
                                    'display', criteria_cc_distance."display"
                                )
                            ),
                            json_build_object(
                                'url', 'valueString',
                                'valueString',
                                criteria."extension_settings_distanceWeighting_valueString_valueString"
                            )
                        ),
                        'url', 'distanceWeighting'
                    ),
                    json_build_object(
                        'extension', json_build_array(
                            json_build_object(
                                'url', 'code',
                                'valueCoding', json_build_object(
                                    'system', criteria_cc_method."code_system",
                                    'code',
                                    criteria."extension_settings_discretisationMethod_valueCoding_code",
                                    'display', criteria_cc_method."display"
                                )
                            ),
                            json_build_object(
                                'url', 'valueString',
                                'valueString',
                                criteria."extension_settings_discretisationMethod_valueString_valueString"
                            )
                        ),
                        'url', 'discretisationMethod'
                    ),
                    json_build_object(
                        'extension', json_build_array(
                            json_build_object(
                                'url', 'code',
                                'valueCoding', json_build_object(
                                    'system', criteria_cc_binsize."code_system",
                                    'code', criteria."extension_settings_binSize_valueCoding_code",
                                    'display', criteria_cc_binsize."display"
                                )
                            ),
                            json_build_object(
                                'url', 'valueDecimal',
                                'valueDecimal',
                                criteria."extension_settings_binSize_valueDecimal_valueDecimal"
                            )
                        ),
                        'url', 'binSize'
                    ),
                    CASE WHEN criteria."extension_settings_bounds_valueString" IS NOT NULL
                        THEN json_build_object(
                            'url', 'bounds',
                            'valueString', criteria."extension_settings_bounds_valueString"
                        ) END,
                    CASE
                        WHEN
                            criteria."extension_settings_lowestIntensity_valueDecimal_valueDecimal" IS NOT NULL
                            THEN json_build_object(
                                'extension', json_build_array(
                                    json_build_object(
                                        'url', 'code',
                                        'valueCoding', json_build_object(
                                            'system', criteria_cc_lowestintensity."code_system",
                                            'code',
                                            criteria."extension_settings_lowestIntensity_valueCoding_code",
                                            'display', criteria_cc_lowestintensity."display"
                                        )
                                    ),
                                    json_build_object(
                                        'url', 'valueDecimal',
                                        'valueDecimal',
                                        criteria."extension_settings_lowestIntensity_valueDecimal_valueDecimal"
                                    )
                                ),
                                'url', 'lowestIntensity'
                            ) END,
                    CASE
                        WHEN
                            criteria."extension_settings_biggestIntensity_valueCoding_code" IS NOT NULL
                            THEN json_build_object(
                                'extension', json_build_array(
                                    json_build_object(
                                        'url', 'code',
                                        'valueCoding', json_build_object(
                                            'system', criteria_cc_biggestintensity."code_system",
                                            'code',
                                            criteria."extension_settings_biggestIntensity_valueCoding_code",
                                            'display', criteria_cc_biggestintensity."display"
                                        )
                                    ),
                                    json_build_object(
                                        'url', 'valueDecimal',
                                        'valueDecimal',
                                        criteria."extension_settings_biggestIntensity_valueDecimal_valueDecimal"
                                    )
                                ),
                                'url', 'biggestIntensity'
                            ) END,
                    json_build_object(
                        'url', 'boundsRangeOfValueAfterDiscretisation',
                        'valueString',
                        criteria."extension_settings_boundsRangeOfValueAfterDiscretisation"
                    ),
                    json_build_object(
                        'url', 'spatialResamplingMethod',
                        'valueString',
                        criteria."extension_settings_spatialResamplingMethod_valueString"
                    ),
                    CASE
                        WHEN
                            criteria."extension_settings_spatialResamplingValues" IS NOT NULL
                            THEN
                            json_build_object(
                                'url', 'spatialResamplingValues',
                                'valueString',
                                criteria."extension_settings_spatialResamplingValues"
                            ) END,
                    json_build_object(
                        'extension', json_build_array(
                            json_build_object(
                                'url', 'code',
                                'valueCoding', json_build_object(
                                    'system', criteria_cc_texture."code_system",
                                    'code',
                                    criteria."extension_settings_textureMatrixAggregation_valueCoding_code",
                                    'display', criteria_cc_texture."display"
                                )
                            ),
                            json_build_object(
                                'url', 'valueString',
                                'valueString',
                                criteria."extension_settings_textureMatrixAggregation_valueString"
                            )
                        ),
                        'url', 'textureMatrixAggregation'
                    )
                ),
                'url',
                'https://build.fhir.org/ig/arkhn/arkhn-ig-osiris/StructureDefinition/radiomics-criteria-settings'
            )
        )
    ) AS fhir,
    false as is_deleted,
    (now()::DATE - INTERVAL '1 day')::DATE as partition_date
FROM
    {{ ref('osiris_master_tab_Observation_radiomicscriteria') }} AS criteria
LEFT JOIN
    {{ ref('osiris_master_tab_Observation_radiomics_codeableconcept') }} AS criteria_cc_softwarename
    ON criteria."extension_settings_softwareName_valueCoding_code" = criteria_cc_softwarename."code"
LEFT JOIN
    {{ ref('osiris_master_tab_Observation_radiomics_codeableconcept') }} AS criteria_cc_softwareversion
    ON
        criteria."extension_settings_softwareVersion_valueCoding_code" = criteria_cc_softwareversion."code"
LEFT JOIN
    {{ ref('osiris_master_tab_Observation_radiomics_codeableconcept') }} AS criteria_cc_distance
    ON
        criteria."extension_settings_distanceWeighting_valueCoding_code" = criteria_cc_distance."code"
LEFT JOIN
    {{ ref('osiris_master_tab_Observation_radiomics_codeableconcept') }} AS criteria_cc_method
    ON
        criteria."extension_settings_discretisationMethod_valueCoding_code" = criteria_cc_method."code"
LEFT JOIN
    {{ ref('osiris_master_tab_Observation_radiomics_codeableconcept') }} AS criteria_cc_binsize
    ON criteria."extension_settings_binSize_valueCoding_code" = criteria_cc_binsize."code"
LEFT JOIN
    {{ ref('osiris_master_tab_Observation_radiomics_codeableconcept') }} AS criteria_cc_lowestintensity
    ON
        criteria."extension_settings_lowestIntensity_valueCoding_code" = criteria_cc_lowestintensity."code"
LEFT JOIN
    {{ ref('osiris_master_tab_Observation_radiomics_codeableconcept') }} AS criteria_cc_biggestintensity
    ON
        criteria."extension_settings_biggestIntensity_valueCoding_code" = criteria_cc_biggestintensity."code"
LEFT JOIN
    {{ ref('osiris_master_tab_Observation_radiomics_codeableconcept') }} AS criteria_cc_texture
    ON
        criteria."extension_settings_textureMatrixAggregation_valueCoding_code" = criteria_cc_texture."code"
