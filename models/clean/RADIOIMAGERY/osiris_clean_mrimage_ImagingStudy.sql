SELECT
    "Instance_Id" AS "id_mrimage",
    "Patient_Id" AS "subject",
    "CommonImage_Ref" AS "commonimage",
    CASE
        WHEN "MRImage_SequenceName" = 'UMLS:C0439673' THEN 'Unknown'
        ELSE "MRImage_SequenceName"
    END AS "series_extention_mrimage_sequence_name",
    CASE
        WHEN "MRImage_MagneticFieldStrength" = 'UMLS:C0439673' THEN '999999'
        ELSE "MRImage_MagneticFieldStrength"::decimal
    END AS "series_extention_mrimage_magnetic_field_strength",
    CASE
        WHEN "MRImage_MRAcquisitionType" = 'UMLS:C0439673' THEN 'Unknown'
        ELSE "MRImage_MRAcquisitionType"
    END AS "series_extention_mrimage_mr_acquisition_type",
    CASE
        -- This column has a decimal type. Strings are not allowed.
        WHEN "MRImage_RepetitionTime" = 'None' THEN 0
        ELSE "MRImage_RepetitionTime"::decimal
    END AS "series_extention_mrimage_repetition_time",
    CASE
        -- This column has a decimal type. Strings are not allowed.
        WHEN "MRImage_EchoTime" = 'None' THEN 0
        ELSE "MRImage_EchoTime"::decimal
    END AS "series_extention_mrimage_echo_time",
    CASE
        WHEN "MRImage_ImagingFrequency" = 'UMLS:C0439673' THEN '999999'
        ELSE "MRImage_ImagingFrequency"::decimal
    END AS "series_extention_mrimage_imaging_frequency",
    CASE
        WHEN "MRImage_FlipAngle" = 'UMLS:C0439673' THEN '999999'
        ELSE "MRImage_FlipAngle"::decimal
    END AS "series_extention_mrimage_flip_angle",
    CASE
        WHEN "MRImage_InversionTime" = 'UMLS:C0439673' THEN '999999'
        -- This column has a decimal type. Strings are not allowed.
        WHEN "MRImage_InversionTime" = 'None' THEN 0
        ELSE "MRImage_InversionTime"::decimal
    END AS "series_extention_mrimage_inversion_time",
    CASE
        WHEN "MRImage_ReceiveCoilName" = 'UMLS:C0439673' THEN 'Unknown'
        ELSE "MRImage_ReceiveCoilName"
    END AS "series_extention_mrimage_receive_coil_name"
FROM
    {{ ref('OSIRIS_pivot_MRImage') }}
