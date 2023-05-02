WITH
"location" AS (
    SELECT
        "location".*,
        "imagingstudy".*
    FROM
        {{ ref('osiris_clean_study_ImagingStudy') }} AS "imagingstudy"
    LEFT JOIN
        {{ ref('osiris_clean_study_Location') }} AS "location"
        ON
            "imagingstudy"."location" = "location"."name"
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
        CASE
            WHEN "location"."id_imagingstudy" IS NULL THEN 'Series' || "series"."imagingstudy"::varchar
            ELSE "location"."id_imagingstudy"::varchar
        END AS "id_imagingstudy",
        "series"."id_series",
        COALESCE("location"."identifier_value"::text, 'Unknown') AS "identifier_value",
        CASE
            WHEN "location"."modality" IS NULL THEN 'C0439673'
            ELSE RIGHT(
                "location"."modality"::varchar,
                -POSITION(':' IN "location"."modality"::varchar)
            )
        END AS modality,
        COALESCE("location"."subject", "series"."subject") AS "subject",
        "location"."started",
        "location"."endpoint",
        "location"."numberOfSeries",
        "location"."id_location" AS "location",
        "location"."reasonreference",
        COALESCE("location"."description", 'Unknown') AS "description",
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
                AND "series"."series_modality_code"::text = 'PT' THEN 999999
            ELSE "series"."series_extension_patient_weight"
        END AS "series_extension_patient_weight",
        CASE
            WHEN "series"."series_extension_patient_height" IS NULL
                AND "series"."series_modality_code"::text = 'PT' THEN 999999
            ELSE "series"."series_extension_patient_height"
        END AS "series_extension_patient_height"
    FROM
        "location"
    FULL JOIN
        {{ ref('osiris_clean_series_ImagingStudy') }} AS series
        ON "location"."id_imagingstudy" = series."imagingstudy"
),

study_series_commonimage AS (
    SELECT
        "study_series".*,
        "commonimage"."id_commonimage",
        COALESCE("commonimage"."series_extension_slice_thickness"::text, 'Unknown')
        AS "series_extension_slice_thickness",
        COALESCE("commonimage"."series_extension_pixel_spacing"::text,
            'Unknown') AS "series_extension_pixel_spacing",
        COALESCE("commonimage"."series_extension_rows", 999999)
        AS "series_extension_rows",
        COALESCE("commonimage"."series_extension_columns", 999999)
        AS "series_extension_columns",
        "commonimage"."series_extension_field_of_view",
        "injection"."id_medication_administration",
        COALESCE(commonimage."series_instance_uid"::text, 'Unknown') AS "series_instance_uid"
    FROM
        study_series
    FULL JOIN
        {{ ref('osiris_clean_commonimage_ImagingStudy') }} AS commonimage
        ON study_series."id_series" = commonimage."series"
    LEFT JOIN
        "injection"
        ON
            "study_series"."id_series" = "injection"."series"
),

study_series_commonimage_modality AS (
    SELECT
        CASE
            WHEN "study_series_commonimage"."id_imagingstudy" IS NULL AND ctimage."id_ctimage" IS NOT NULL
                THEN 'CT_Image' || ctimage."id_ctimage"::varchar
            WHEN "study_series_commonimage"."id_imagingstudy" IS NULL AND mrimage."id_mrimage" IS NOT NULL
                THEN 'MR_Image' || mrimage."id_mrimage"::varchar
            WHEN "study_series_commonimage"."id_imagingstudy" IS NULL AND dximage."id_dximage" IS NOT NULL
                THEN 'DX_Image' || dximage."id_dximage"::varchar
            WHEN "study_series_commonimage"."id_imagingstudy" IS NULL AND nmimage."id_nmimage" IS NOT NULL
                THEN 'NM_Image' || nmimage."id_nmimage"::varchar
            ELSE "study_series_commonimage"."id_imagingstudy"::varchar
        END AS "id_imagingstudy",
        CASE
            WHEN "study_series_commonimage"."id_imagingstudy" IS NULL AND ctimage."id_ctimage" IS NOT NULL
                THEN 'CT_Image' || ctimage."id_ctimage"::varchar
            WHEN "study_series_commonimage"."id_imagingstudy" IS NULL AND mrimage."id_mrimage" IS NOT NULL
                THEN 'MR_Image' || mrimage."id_mrimage"::varchar
            WHEN "study_series_commonimage"."id_imagingstudy" IS NULL AND dximage."id_dximage" IS NOT NULL
                THEN 'DX_Image' || dximage."id_dximage"::varchar
            WHEN "study_series_commonimage"."id_imagingstudy" IS NULL AND nmimage."id_nmimage" IS NOT NULL
                THEN 'NM_Image' || nmimage."id_nmimage"::varchar
            ELSE "study_series_commonimage"."id_series"::varchar
        END AS "id_series",
        COALESCE("study_series_commonimage"."identifier_value", 'Unknown') AS "identifier_value",
        COALESCE("study_series_commonimage"."modality", 'C0439673') AS modality,
        CASE
            WHEN ctimage."id_ctimage" IS NOT NULL
                THEN ctimage."subject"
            WHEN mrimage."id_mrimage" IS NOT NULL
                THEN mrimage."subject"
            WHEN dximage."id_dximage" IS NOT NULL
                THEN dximage."subject"
            WHEN nmimage."id_nmimage" IS NOT NULL
                THEN nmimage."subject"
            ELSE "study_series_commonimage"."subject"
        END AS "subject",
        COALESCE("study_series_commonimage"."started", '1000-01-01') AS "started",
        COALESCE("study_series_commonimage"."endpoint"::text, 'Unknown') AS "endpoint",
        COALESCE("study_series_commonimage"."numberOfSeries", 999999) AS "numberOfSeries",
        "study_series_commonimage"."location" AS "location",
        CASE
            WHEN "study_series_commonimage"."reasonreference" IS NULL THEN 'Unknown-Imagery'
            ELSE "study_series_commonimage"."reasonreference"::varchar
        END AS "reasonreference",
        COALESCE("study_series_commonimage"."description"::text, 'Unknown') AS "description",
        "study_series_commonimage"."series_performer_actor",
        "study_series_commonimage"."series_number",
        COALESCE("study_series_commonimage"."series_uid"::text, 'Unknown') AS "series_uid",
        CASE
            WHEN "study_series_commonimage"."id_imagingstudy" IS NULL AND dximage."id_dximage" IS NOT NULL
                THEN 'DX'
            WHEN "study_series_commonimage"."id_imagingstudy" IS NULL AND mrimage."id_mrimage" IS NOT NULL
                THEN 'MR'
            WHEN "study_series_commonimage"."id_imagingstudy" IS NULL AND ctimage."id_ctimage" IS NOT NULL
                THEN 'CT'
            WHEN "study_series_commonimage"."id_imagingstudy" IS NULL AND nmimage."id_nmimage" IS NOT NULL
                THEN 'PT'
            WHEN "study_series_commonimage"."series_modality_code" IS NOT NULL
                THEN "study_series_commonimage"."series_modality_code"::text
        END AS "series_modality_code",
        COALESCE("study_series_commonimage"."series_started"::text, '1000-01-01') AS "series_started",
        COALESCE("study_series_commonimage"."series_description"::text, 'Unknown') AS "series_description",
        "study_series_commonimage"."series_bodySite_code",
        COALESCE("study_series_commonimage"."series_numberOfInstances", 999999) AS "series_numberOfInstances",
        CASE
            WHEN "study_series_commonimage"."id_imagingstudy" IS NULL AND nmimage."id_nmimage" IS NOT NULL THEN 999999
            ELSE "study_series_commonimage"."series_extension_patient_weight"
        END AS "series_extension_patient_weight",
        CASE
            WHEN "study_series_commonimage"."id_imagingstudy" IS NULL AND nmimage."id_nmimage" IS NOT NULL THEN 999999
            ELSE "study_series_commonimage"."series_extension_patient_height"
        END AS "series_extension_patient_height",
        COALESCE("study_series_commonimage"."series_extension_slice_thickness"::text, 'Unknown')
        AS "series_extension_slice_thickness",
        COALESCE("study_series_commonimage"."series_extension_pixel_spacing"::text,
            'Unknown') AS "series_extension_pixel_spacing",
        COALESCE("study_series_commonimage"."series_extension_rows", 999999)
        AS "series_extension_rows",
        COALESCE("study_series_commonimage"."series_extension_columns", 999999)
        AS "series_extension_columns",
        "study_series_commonimage"."series_extension_field_of_view",
        "study_series_commonimage"."id_medication_administration",
        "study_series_commonimage"."series_instance_uid",
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
            WHEN "dximage"."series_extension_dximage_kvp"::text = 'DX' THEN 999999
            ELSE "dximage"."series_extension_dximage_kvp"::int
        END AS
        "series_extension_dximage_kvp",
        "dximage"."series_extension_dximage_exposure",
        "dximage"."series_extension_dximage_exposure_time",
        "nmimage"."series_extension_nmimage_attenuation_correction_method",
        "nmimage"."series_extension_nmimage_reconstruction_method",
        "nmimage"."series_extension_nmimage_scatter_correction_method",
        CASE
            WHEN "study_series_commonimage"."id_imagingstudy" IS NULL AND dximage."id_dximage" IS NOT NULL
                THEN 'Computed Radiography Image Storage'
            WHEN "study_series_commonimage"."id_imagingstudy" IS NULL AND mrimage."id_mrimage" IS NOT NULL
                THEN 'MR Image Storage'
            WHEN "study_series_commonimage"."id_imagingstudy" IS NULL AND ctimage."id_ctimage" IS NOT NULL
                THEN 'CT Image Storage'
            WHEN study_series_commonimage."series_modality_code"::text = 'NM'
                THEN 'Nuclear Medicine Image Storage'
            WHEN "study_series_commonimage"."id_imagingstudy" IS NULL AND nmimage."id_nmimage" IS NOT NULL
                THEN 'Positron Emission Tomography Image Storage'
            WHEN study_series_commonimage."series_modality_code"::text = 'RTSTRUCT'
                THEN 'RT Structure Set Storage'
        END AS "series_instance_sopClass"
    FROM
        study_series_commonimage
    FULL JOIN
        {{ ref('osiris_clean_ctimage_ImagingStudy') }} AS ctimage
        ON study_series_commonimage."id_commonimage" = ctimage."commonimage"
    FULL JOIN
        {{ ref('osiris_clean_mrimage_ImagingStudy') }} AS mrimage
        ON study_series_commonimage."id_commonimage" = mrimage."commonimage"
    FULL JOIN
        {{ ref('osiris_clean_dximage_ImagingStudy') }} AS dximage
        ON study_series_commonimage."id_commonimage" = dximage."commonimage"
    FULL JOIN
        {{ ref('osiris_clean_nmimage_ImagingStudy') }} AS nmimage
        ON study_series_commonimage."id_commonimage" = nmimage."commonimage"
),

"imagingstudy_with_endpoint" AS (
    SELECT
        study_series_commonimage_modality.*,
        "endpoint"."id_endpoint"
    FROM
        study_series_commonimage_modality
    LEFT JOIN
        {{ ref('osiris_master_tab_Endpoint') }} AS "endpoint"
        ON
            "study_series_commonimage_modality"."endpoint" = "endpoint"."name"
)

SELECT *
FROM
    "imagingstudy_with_endpoint"
