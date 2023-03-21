SELECT
    "Instance_Id" AS "id_criteria",
    "Patient_Id" AS "subject",
    "ROISegmentation_Ref" AS "focus",
    "RadiomicsImageFilter_Ref" AS "hasmember",
    "RadiomicsCriteria_SoftwareName" AS "extension_settings_softwareName_valueString_valueString",
    "RadiomicsCriteria_SoftwareVersion" AS "extension_settings_softwareVersion_valueString_valueString",
    "RadiomicsCriteria_ComputationalLocalisationMethod" AS "extension_settings_localizationMethod_valueString",
    "RadiomicsCriteria_CalculationWindowMatrix" AS "extension_settings_windowMatrix_valueString",
    "RadiomicsCriteria_UsedImageFilter" AS "extension_settings_usedImageFilter_valueString",
    "RadiomicsCriteria_UsedImageFilterParameters" AS "extension_settings_usedImageFilterParameters_valueString",
    "RadiomicsCriteria_DistanceWeighted" AS "extension_settings_distanceWeighting_valueString_valueString",
    "RadiomicsCriteria_DiscretisationMethod" AS "extension_settings_discretisationMethod_valueString_valueString",
    "RadiomicsCriteria_Bound" AS "extension_settings_bounds_valueString",
    "RadiomicsCriteria_BinSize" AS "extension_settings_binSize_valueDecimal_valueDecimal",
    "RadiomicsCriteria_LowestIntensity" AS "extension_settings_lowestIntensity_valueDecimal_valueDecimal",
    "RadiomicsCriteria_BiggestIntensity" AS "extension_settings_biggestIntensity_valueDecimal_valueDecimal",
    CAST(
        "RadiomicsCriteria_BoundsRangeOfValueAfterDiscretisation" AS VARCHAR
    ) AS "extension_settings_boundsRangeOfValueAfterDiscretisation",
    "RadiomicsCriteria_SpatialResamplingMethod" AS "extension_settings_spatialResamplingMethod_valueString",
    "RadiomicsCriteria_SpatialResamplingValues" AS "extension_settings_spatialResamplingValues",
    "RadiomicsCriteria_TextureMatrixAggregation" AS "extension_settings_textureMatrixAggregation_valueString"
FROM
    {{ ref ('OSIRIS_pivot_RadiomicsCriteria') }}
