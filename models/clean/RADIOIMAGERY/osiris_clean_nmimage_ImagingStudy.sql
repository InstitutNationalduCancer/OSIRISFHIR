SELECT
    "Instance_Id" AS "id_nmimage",
    "CommonImage_Ref" AS "commonimage",
    "NMImage_AttenuationCorrectionMethod" AS
    "series_extension_nmimage_attenuation_correction_method",
    "NMImage_ReconstructionMethod" AS "series_extension_nmimage_reconstruction_method",
    "NMImage_ScatterCorrectionMethod" AS "series_extension_nmimage_scatter_correction_method"
FROM
    {{ ref('OSIRIS_pivot_NMImage') }}

