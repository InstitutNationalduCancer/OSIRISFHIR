SELECT
    "Instance_Id" AS "id_ctimage",
    "CommonImage_Ref" AS "commonimage",
    "CTImage_KVp" AS "series_extension_ctimage_kvp",
    "CTImage_XRayTubeCurrent" AS "series_extension_ctimage_xray_tube_current",
    "CTImage_ExposureTime" AS"series_extension_ctimage_exposure_time",
    "CTImage_FilterType" AS "series_extension_ctimage_filter_type",
    "CTImage_ConvolutionKernel" AS "series_extension_ctimage_convolution_kernel",
    CASE
        WHEN "CTImage_SpiralPitchFactor" = 'UMLS:C0439673' THEN 999999
        ELSE "CTImage_SpiralPitchFactor"::decimal
    END AS "series_extension_ctimage_spiral_pitch_factor"
FROM
    {{ ref('OSIRIS_pivot_CTImage') }}
