WITH
"endpoint" AS (
    SELECT
        imagingstudy.*,
        "endpoint".*
    FROM
        {{ ref('osiris_clean_study_ImagingStudy') }} AS "imagingstudy"
    LEFT JOIN
        {{ ref('osiris_clean_study_Endpoint') }} AS "endpoint"
        ON
            "imagingstudy"."endpoint" = "endpoint"."name"
),

"location" AS (
    SELECT
        "location".*,
        "endpoint".*
    FROM
        "endpoint"
    LEFT JOIN
        {{ ref('osiris_clean_study_Location') }} AS "location"
        ON
            "endpoint"."location" = "location"."name"
),

"injection" AS (
    SELECT
        "id_medication_administration",
        "series"
    FROM
        {{ ref('osiris_clean_injection_MedicationAdministration') }}
),

study_series AS (
    SELECT
        "location"."id_imagingstudy",
        "series"."id_series",
        "location"."identifier_value",
        RIGHT(
            CAST("location"."modality" AS varchar),
            -POSITION(':' IN CAST("location"."modality" AS varchar))
        ) AS modality,
        "location"."subject",
        "location"."started",
        "location"."id_endpoint" AS "endpoint",
        "location"."numberOfSeries",
        "location"."id_location" AS "location",
        "location"."reasonreference",
        "location"."description",
        "series"."series_performer_actor",
        "series"."series_number",
        "series"."series_uid",
        "series"."series_modality_code",
        "series"."series_started",
        "series"."series_description",
        "series"."series_bodySite_code",
        "series"."series_numberOfInstances",
        CASE
            WHEN "series"."series_extension_patient_weight" IS NULL
                AND "series"."series_modality_code" = 'PT' THEN 999999
            ELSE "series"."series_extension_patient_weight"
        END AS "series_extension_patient_weight",
        CASE
            WHEN "series"."series_extension_patient_height" IS NULL
                AND "series"."series_modality_code" = 'PT' THEN 999999
            ELSE "series"."series_extension_patient_height"
        END AS "series_extension_patient_height"
    FROM
        "location"
    LEFT JOIN
        {{ ref('osiris_clean_series_ImagingStudy') }} AS series
        ON "location"."id_imagingstudy" = series."imagingstudy"
),

study_series_commonimage AS (
    SELECT
        "study_series".*,
        "commonimage"."id_commonimage",
        COALESCE("commonimage"."series_extension_slice_thickness", 'Unknown')
        AS "series_extension_slice_thickness",
        COALESCE("commonimage"."series_extension_pixel_spacing",
            'Unknown') AS "series_extension_pixel_spacing",
        COALESCE("commonimage"."series_extension_rows", 999999)
        AS "series_extension_rows",
        COALESCE("commonimage"."series_extension_columns", 999999)
        AS "series_extension_columns",
        "commonimage"."series_extension_field_of_view",
        "injection"."id_medication_administration",
        CASE
            WHEN study_series."series_modality_code" = 'DX'
                THEN 'Computed Radiography Image Storage'
            WHEN study_series."series_modality_code" = 'MR'
                THEN 'MR Image Storage'
            WHEN study_series."series_modality_code" = 'CT'
                THEN 'CT Image Storage'
            WHEN study_series."series_modality_code" = 'NM'
                THEN 'Nuclear Medicine Image Storage'
            WHEN study_series."series_modality_code" = 'PT'
                THEN 'Positron Emission Tomography Image Storage'
            WHEN study_series."series_modality_code" = 'RTSTRUCT'
                THEN 'RT Structure Set Storage'
        END AS "series_instance_sopClass",
        COALESCE(commonimage."series_instance_uid", 'Unknown') AS "series_instance_uid"
    FROM
        study_series
    LEFT JOIN
        {{ ref('osiris_clean_commonimage_ImagingStudy') }} AS commonimage
        ON study_series."id_series" = commonimage."series"
    LEFT JOIN
        "injection"
        ON
            "study_series"."id_series" = "injection"."series"
),

study_series_commonimage_modality AS (
    SELECT
        "study_series_commonimage".*,
        "ctimage"."series_extension_ctimage_kvp",
        "ctimage"."series_extension_ctimage_xray_tube_current",
        "ctimage"."series_extension_ctimage_exposure_time",
        "ctimage"."series_extension_ctimage_spiral_pitch_factor",
        "ctimage"."series_extension_ctimage_filter_type",
        "ctimage"."series_extension_ctimage_convolution_kernel",
        "mrimage"."series_extention_mrimage_sequence_name",
        "mrimage"."series_extention_mrimage_magnetic_field_strength",
        "mrimage"."series_extention_mrimage_mr_acquisition_type",
        "mrimage"."series_extention_mrimage_repetition_time",
        "mrimage"."series_extention_mrimage_echo_time",
        "mrimage"."series_extention_mrimage_imaging_frequency",
        "mrimage"."series_extention_mrimage_flip_angle",
        "mrimage"."series_extention_mrimage_inversion_time",
        "mrimage"."series_extention_mrimage_receive_coil_name",
        "dximage"."series_extension_dximage_image_laterality",
        "dximage"."series_extension_dximage_patient_orientation",
        CASE
            WHEN "dximage"."series_extension_dximage_kvp" = 'DX' THEN 999999
            ELSE CAST("dximage"."series_extension_dximage_kvp" AS int)
        END AS
        "series_extension_dximage_kvp",
        "dximage"."series_extension_dximage_exposure",
        "dximage"."series_extension_dximage_exposure_time",
        "nmimage"."series_extension_nmimage_attenuation_correction_method",
        "nmimage"."series_extension_nmimage_reconstruction_method",
        "nmimage"."series_extension_nmimage_scatter_correction_method"
    FROM
        study_series_commonimage
    LEFT JOIN
        {{ ref('osiris_clean_ctimage_ImagingStudy') }} AS ctimage
        ON study_series_commonimage."id_commonimage" = ctimage."commonimage"
    LEFT JOIN
        {{ ref('osiris_clean_mrimage_ImagingStudy') }} AS mrimage
        ON study_series_commonimage."id_commonimage" = mrimage."commonimage"
    LEFT JOIN
        {{ ref('osiris_clean_dximage_ImagingStudy') }} AS dximage
        ON study_series_commonimage."id_commonimage" = dximage."commonimage"
    LEFT JOIN
        {{ ref('osiris_clean_nmimage_ImagingStudy') }} AS nmimage
        ON study_series_commonimage."id_commonimage" = nmimage."commonimage"
)

SELECT *
FROM
    study_series_commonimage_modality
