WITH
instances_object AS (
    SELECT
        "id_series",
        json_build_object(
            'uid', "series_instance_uid",
            'sopClass', json_build_object(
                'code', "series_instance_sopClass",
                'system',
                'http://dicom.nema.org/medical/dicom/current/
output/chtml/part04/sect_B.5.html#table_B.5-1'
            )
        ) AS fhir
    FROM
        {{ ref('osiris_master_tab_ImagingStudy') }}
),

instances_array AS (
    SELECT
        id_series,
        json_agg(fhir) AS fhir
    FROM instances_object
    GROUP BY id_series
),

series_object AS (
    SELECT DISTINCT ON (imagingstudy."id_series")
        imagingstudy."id_imagingstudy" AS id,
        imagingstudy."id_series",
        json_build_object(
            'extension', json_build_array( --global extension array
                CASE WHEN
                    imagingstudy."series_extension_slice_thickness" IS NOT NULL
                    OR imagingstudy."series_extension_pixel_spacing" IS NOT NULL
                    OR imagingstudy."series_extension_field_of_view" IS NOT NULL
                    OR imagingstudy."series_extension_rows" IS NOT NULL
                    OR imagingstudy."series_extension_columns" IS NOT NULL
                    THEN json_build_object(
                        'extension', json_build_array( --image_settings extension array
                            CASE WHEN
                                imagingstudy."series_extension_slice_thickness" IS NOT NULL 
                                THEN json_build_object(
                                    'valueString', imagingstudy."series_extension_slice_thickness",
                                    'url', 'slice_thickness'
                                ) END,
                            CASE WHEN
                                imagingstudy."series_extension_pixel_spacing" IS NOT NULL 
                                THEN json_build_object(
                                    'valueString', imagingstudy."series_extension_pixel_spacing",
                                    'url', 'pixel_spacing'
                                ) END,
                            CASE WHEN
                                imagingstudy."series_extension_field_of_view" IS NOT NULL 
                                THEN json_build_object(
                                    'valueInteger', imagingstudy."series_extension_field_of_view",
                                    'url', 'field_of_view'
                                ) END,
                            CASE WHEN
                                imagingstudy."series_extension_rows" IS NOT NULL 
                                THEN json_build_object(
                                    'valueInteger', imagingstudy."series_extension_rows",
                                    'url', 'rows'
                                ) END,
                            CASE WHEN
                                imagingstudy."series_extension_columns" IS NOT NULL 
                                THEN json_build_object(
                                    'valueInteger', imagingstudy."series_extension_columns",
                                    'url', 'columns'
                                ) END,
                            json_build_object(
                                'valueReference', json_build_object(
                                    'reference', fhir_ref(
                                        'MedicationAdministration',
                                        '"osiris_master_tab_MedicationAdministration"',
                                        imagingstudy."id_medication_administration"::varchar
                                    )
                                ),
                                'url', 'imaging_injection'
                            ),
                            CASE
                                WHEN
                                    imagingstudy."series_modality_code" = 'CT' 
                                    THEN json_build_object(
                                        'extension', json_build_array(
                                            json_build_object(
                                                'url', 'kvp',
                                                'valueInteger',
                                                imagingstudy."series_extension_ctimage_kvp"
                                            ),
                                            json_build_object(
                                                'url', 'xray_tube_current',
                                                'valueInteger',
                                                imagingstudy."series_extension_ctimage_xray_tube_current"
                                            ),
                                            json_build_object(
                                                'url', 'exposure_time',
                                                'valueInteger',
                                                imagingstudy."series_extension_ctimage_exposure_time"
                                            ),
                                            json_build_object(
                                                'url', 'spiral_pitch_factor',
                                                'valueDecimal',
                                                "series_extension_ctimage_spiral_pitch_factor"
                                            ),
                                            json_build_object(
                                                'url', 'filter_type',
                                                'valueString',
                                                imagingstudy."series_extension_ctimage_filter_type"
                                            ),
                                            json_build_object(
                                                'url', 'convolution_kernel',
                                                'valueString',
                                                imagingstudy."series_extension_ctimage_convolution_kernel"
                                            )
                                        ),
                                        'url', 'ct_image'
                                    ) END,
                            CASE
                                WHEN
                                    "imagingstudy"."series_modality_code" = 'MR'
                                    THEN json_build_object(
                                        'extension', json_build_array(
                                            json_build_object(
                                                'url', 'sequence_name',
                                                'valueString',
                                                imagingstudy."series_extention_mrimage_sequence_name"
                                            ),
                                            json_build_object(
                                                'url', 'magnetic_field_strength',
                                                'valueDecimal',
                                                imagingstudy."series_extention_mrimage_magnetic_field_strength"
                                            ),
                                            json_build_object(
                                                'url', 'mr_acquisition_type',
                                                'valueString',
                                                imagingstudy."series_extention_mrimage_mr_acquisition_type"
                                            ),
                                            json_build_object(
                                                'url', 'repetition_time',
                                                'valueDecimal',
                                                imagingstudy."series_extention_mrimage_repetition_time"
                                            ),
                                            json_build_object(
                                                'url', 'echo_time',
                                                'valueDecimal',
                                                imagingstudy."series_extention_mrimage_echo_time"
                                            ),
                                            json_build_object(
                                                'url', 'imaging_frequency',
                                                'valueDecimal',
                                                imagingstudy."series_extention_mrimage_imaging_frequency"
                                            ),
                                            json_build_object(
                                                'url', 'flip_angle',
                                                'valueDecimal',
                                                imagingstudy."series_extention_mrimage_flip_angle"
                                            ),
                                            json_build_object(
                                                'url', 'inversion_time',
                                                'valueDecimal',
                                                imagingstudy."series_extention_mrimage_inversion_time"
                                            ),
                                            json_build_object(
                                                'url', 'receive_coil_name',
                                                'valueString',
                                                imagingstudy."series_extention_mrimage_receive_coil_name"
                                            )
                                        ),
                                        'url', 'mr_image'
                                    ) END,
                            CASE
                                WHEN
                                    "imagingstudy"."series_modality_code" = 'DX'
                                    THEN json_build_object(
                                        'extension', json_build_array(
                                            json_build_object(
                                                'url', 'image_laterality',
                                                'valueString',
                                                imagingstudy."series_extension_dximage_image_laterality"
                                            ),
                                            json_build_object(
                                                'url', 'patient_orientation',
                                                'valueString',
                                                imagingstudy."series_extension_dximage_patient_orientation"
                                            ),
                                            json_build_object(
                                                'url', 'kvp',
                                                'valueInteger',
                                                imagingstudy."series_extension_dximage_kvp"
                                            ),
                                            json_build_object(
                                                'url', 'exposure',
                                                'valueInteger',
                                                imagingstudy."series_extension_dximage_exposure"
                                            ),
                                            json_build_object(
                                                'url', 'exposure_time',
                                                'valueInteger',
                                                imagingstudy."series_extension_dximage_exposure_time"
                                            )
                                        ),
                                        'url', 'dx_image'
                                    ) END,
                            CASE WHEN
                                "imagingstudy"."series_modality_code" = 'PT'
                                OR "imagingstudy"."series_modality_code" = 'NM'
                                THEN json_build_object(
                                    'extension', json_build_array(
                                        json_build_object(
                                            'url', 'attenuation_correction_method',
                                            'valueString',
                                            imagingstudy."series_extension_nmimage_attenuation_correction_method"
                                        ),
                                        json_build_object(
                                            'url', 'reconstruction_method',
                                            'valueString',
                                            imagingstudy."series_extension_nmimage_reconstruction_method"
                                        ),
                                        json_build_object(
                                            'url', 'scatter_correction_method',
                                            'valueString',
                                            imagingstudy."series_extension_nmimage_scatter_correction_method"
                                        )
                                    ),
                                    'url', 'pt_nm_image'
                                ) END
                        ),
                        'url', 'http://fhir.arkhn.com/osiris/StructureDefinition/imaging-settings'
                    ) END,
                CASE WHEN
                    "series_extension_patient_height" IS NOT NULL
                    OR "series_extension_patient_height" IS NOT NULL
                    THEN json_build_object(
                        'extension', json_build_array(  -- height/weight extension array
                            CASE
                                WHEN
                                    "series_extension_patient_height" IS NOT NULL
                                    THEN json_build_object(
                                        'url', 'patient_height',
                                        'valueDecimal',
                                        imagingstudy."series_extension_patient_height"
                                    ) END,
                            CASE
                                WHEN
                                    "series_extension_patient_weight" IS NOT NULL
                                    THEN json_build_object(
                                        'url', 'patient_weight',
                                        'valueDecimal',
                                        imagingstudy."series_extension_patient_weight"
                                    ) END
                        ),
                        'url', 'http://fhir.arkhn.com/osiris/StructureDefinition/series-weightheigt'
                    ) END
            ),
            'uid', imagingstudy."series_uid",
            'number', imagingstudy."series_number",
            'modality', json_build_object(
                'system', imagingstudy_codeableconcept_series_modality."code_system",
                'code', imagingstudy."series_modality_code",
                'display', imagingstudy_codeableconcept_series_modality."display"
            ),
            'description', imagingstudy."series_description",
            'numberOfInstances', imagingstudy."series_numberOfInstances",
            'bodySite', json_build_object(
                'system', imagingstudy_codeableconcept_bodysite."code_system",
                'code', imagingstudy_codeableconcept_bodysite."code",
                'display', imagingstudy_codeableconcept_bodysite."display"
            ),
            'started', imagingstudy."series_started",
            'performer', json_build_array(
                json_build_object(
                    'actor', json_build_object(
                        'reference', fhir_ref(
                            'Device',
                            '"osiris_master_tab_Device"',
                            imagingstudy."series_performer_actor"::varchar
                        )
                    )
                )
            ),
            'instance', instances_array.fhir
        ) AS fhir
    FROM
        {{ ref('osiris_master_tab_ImagingStudy') }} AS imagingstudy
    LEFT JOIN
        {{ ref('osiris_master_tab_ImagingStudy_codeableConcept') }} 
        AS imagingstudy_codeableconcept_series_modality
        ON imagingstudy."series_modality_code" = imagingstudy_codeableconcept_series_modality."code"
    LEFT JOIN
        {{ ref('osiris_master_tab_ImagingStudy_codeableConcept') }} 
        AS imagingstudy_codeableconcept_bodysite
        ON imagingstudy."series_bodySite_code" = imagingstudy_codeableconcept_bodysite."code_dicom"
    LEFT JOIN
        instances_array
        ON imagingstudy."id_series" = instances_array."id_series"
), -- creation of the json object of the series attribute for each instance 

series_array AS (
    SELECT
        id,
        json_agg(fhir) AS fhir
    FROM series_object
    GROUP BY id
), -- aggregation by id to obtain an array of the series attribute containing the objects of the series of the same study

imagingstudy AS (
    SELECT DISTINCT ON ("id_imagingstudy")
        "id_imagingstudy" AS id,
        json_build_object(
            'resourceType', 'ImagingStudy',
            'id', fhir_id(
                '{{ ref("osiris_master_tab_ImagingStudy") }}', "id_imagingstudy"::text),
            'meta', json_build_object(
                'profile', json_build_array(
                    'http://fhir.arkhn.com/osiris/StructureDefinition/onco-imagingstudy'
                )
            ),
            'status', 'available',
            'identifier', json_build_array(
                json_build_object(
                    'value', "identifier_value"
                )
            ),
            'modality', json_build_array(
                json_build_object(
                    'system', imagingstudy_codeableconcept_modality."code_system",
                    'code', imagingstudy."modality",
                    'display', imagingstudy_codeableconcept_modality."display"
                )
            ),
            'subject', json_build_object(
                'reference', fhir_ref(
                    'Patient',
                    '"osiris_master_tab_Patient"',
                    "subject"
                )
            ),
            'started', "started",
            'endpoint', json_build_array(
                json_build_object(
                    'reference', fhir_ref(
                        'Endpoint',
                        '"osiris_master_tab_Endpoint"',
                        "endpoint")
                )
            ),
            'location', json_build_object(
                'reference', fhir_ref(
                    'Location',
                    '"osiris_master_tab_Location"',
                    "location")
            ),
            'numberOfSeries', "numberOfSeries",
            'reasonReference', json_build_array(
                json_build_object(
                    'reference', fhir_ref(
                        'Observation',
                        '"osiris_master_tab_Observation_analysis"',
                        "reasonreference"::varchar)
                )
            ),
            'description', "description",
            'series', series_array."fhir"
        ) AS fhir
    FROM
        {{ ref('osiris_master_tab_ImagingStudy') }} 
        AS imagingstudy
    LEFT JOIN
        {{ ref('osiris_master_tab_ImagingStudy_codeableConcept') }} 
        AS imagingstudy_codeableconcept_modality
        ON 
            imagingstudy."modality" = imagingstudy_codeableconcept_modality."code"
    LEFT JOIN
        series_array
        ON 
            imagingstudy."id_imagingstudy" = series_array."id"
) -- join to link the different parts: study, series, instances

SELECT *
FROM
    imagingstudy
