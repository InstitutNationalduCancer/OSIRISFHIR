SELECT
    criteria."id_criteria",
    criteria."subject",
    roisegmentation."id_roisegmentation" AS "focus",
    imagefilter."id_imagefilter" AS "hasmember",
    criteria."extension_settings_softwareName_valueString_valueString",
    '61' AS "extension_settings_softwareName_valueCoding_code",
    criteria."extension_settings_softwareVersion_valueString_valueString",
    '61' AS "extension_settings_softwareVersion_valueCoding_code",
    criteria."extension_settings_localizationMethod_valueString",
    criteria."extension_settings_windowMatrix_valueString",
    criteria."extension_settings_usedImageFilter_valueString",
    criteria."extension_settings_usedImageFilterParameters_valueString",
    criteria."extension_settings_distanceWeighting_valueString_valueString",
    '63' AS "extension_settings_distanceWeighting_valueCoding_code",
    criteria."extension_settings_discretisationMethod_valueString_valueString",
    '56a' AS "extension_settings_discretisationMethod_valueCoding_code",
    criteria."extension_settings_bounds_valueString",
    criteria."extension_settings_binSize_valueDecimal_valueDecimal",
    '56b' AS "extension_settings_binSize_valueCoding_code",
    criteria."extension_settings_lowestIntensity_valueDecimal_valueDecimal",
    '56c' AS "extension_settings_lowestIntensity_valueCoding_code",
    criteria."extension_settings_biggestIntensity_valueDecimal_valueDecimal",
    '56c' AS "extension_settings_biggestIntensity_valueCoding_code",
    criteria."extension_settings_boundsRangeOfValueAfterDiscretisation",
    criteria."extension_settings_spatialResamplingMethod_valueString",
    criteria."extension_settings_spatialResamplingValues",
    criteria."extension_settings_textureMatrixAggregation_valueString",
    '62' AS "extension_settings_textureMatrixAggregation_valueCoding_code"
FROM
    {{ ref ('osiris_clean_radiomicscriteria_Observation') }} AS criteria
LEFT JOIN
    {{ ref('osiris_master_tab_Observation_roisegmentation') }} AS roisegmentation
    ON criteria.focus = roisegmentation."id_roisegmentation"
LEFT JOIN
    {{ ref('osiris_master_tab_Observation_radiomicsimagefilter') }} AS imagefilter
    ON criteria.hasmember = imagefilter."id_imagefilter"
