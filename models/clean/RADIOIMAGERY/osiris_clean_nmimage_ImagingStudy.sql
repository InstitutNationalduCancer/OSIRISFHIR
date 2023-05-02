SELECT
    "Patient_Id" || '-' || "Instance_Id" AS "id_nmimage",
    "Patient_Id" AS "subject",
    "Patient_Id" || '-' || "CommonImage_Ref" AS "commonimage",
    "NMImage_AttenuationCorrectionMethod" AS
    "series_extension_nmimage_attenuation_correction_method",
    "NMImage_ReconstructionMethod" AS "series_extension_nmimage_reconstruction_method",
    "NMImage_ScatterCorrectionMethod" AS "series_extension_nmimage_scatter_correction_method"
FROM
    {{ ref('OSIRIS_pivot_NMImage') }}
