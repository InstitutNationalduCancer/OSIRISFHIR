WITH
unnest_identifier_dicom AS ( --division of multiple values in differents rows
    SELECT
        unnest(string_to_array("identifier_dicom_value", ',')) AS identifier_dicom_value,
        id_roisegmentation
    FROM
        {{ ref('osiris_clean_roisegmentation_Observation') }}
),

unnest_identifier_dicom_not_null AS ( --UNION between all type of identifiers
    SELECT
        id_roisegmentation,
        identifier_dicom_value,
        'dicom_reference' AS "type"
    FROM
        unnest_identifier_dicom
    WHERE
        identifier_dicom_value != ''
    UNION
    SELECT
        id_roisegmentation,
        identifier_roi_value,
        'roi' AS "type"
    FROM
        {{ ref('osiris_master_tab_Observation_roisegmentation') }}
    UNION ALL
    SELECT
        id_roisegmentation,
        identifier_file_value,
        'file' AS "type"
    FROM
        {{ ref('osiris_master_tab_Observation_roisegmentation') }}
    UNION ALL
    SELECT
        id_roisegmentation,
        "series_uid",
        'series_reference' AS "type"
    FROM
        {{ ref('osiris_master_tab_Observation_roisegmentation') }}

),

json_identifier_dicom AS (
    -- creation of the value and type for the attribut 
    -- identifier:dicom value unnested + other identifiers
    SELECT
        id_roisegmentation,
        json_build_object(
            'value', "identifier_dicom_value",
            'type', json_build_object(
                'text', "type"
            )
        ) AS identifier_dicom_value
    FROM unnest_identifier_dicom_not_null
),

json_identifier_dicom_agg AS (
    SELECT
        id_roisegmentation,
        json_agg(identifier_dicom_value) AS identifier_dicom_value
    FROM
        json_identifier_dicom
    GROUP BY id_roisegmentation
)

SELECT
    roisegmentation."id_roisegmentation" AS "id",
    json_build_object(
        'resourceType', 'Observation',
        'id',
        fhir_id(
            '{{ ref("osiris_master_tab_Observation_roisegmentation") }}',
            roisegmentation."id_roisegmentation"::TEXT
        ),
        'meta',
        json_build_object(
            'profile', json_build_array(
                'http://fhir.arkhn.com/osiris/StructureDefinition/roi-segmentation'
            )
        ),
        'text', json_build_object(
            'status', 'additional',
            'div', roisegmentation."text"
        ),
        'identifier', json_identifier_dicom_agg."identifier_dicom_value",
        'partOf', json_build_array(
            json_build_object(
                'reference', fhir_ref(
                    'ImagingStudy',
                    '"osiris_master_tab_ImagingStudy"',
                    roisegmentation."id_imagingstudy"::VARCHAR
                )
            )
        ),
        'status', 'registered',
        'note', json_build_array(
            json_build_object(
                'text', roisegmentation."note"
            )
        ),
        'code', json_build_object(
            'coding', json_build_array(
                json_build_object(
                    'system', observation_codeableconcept_code."code_system",
                    'code', roisegmentation."code",
                    'display', observation_codeableconcept_code."display"
                )
            )
        ),
        'subject', json_build_object(
            'reference', fhir_ref(
                'Patient',
                '"osiris_master_tab_Patient"',
                roisegmentation."subject"::VARCHAR
            )
        )
    ) AS fhir
FROM
    {{ ref('osiris_master_tab_Observation_roisegmentation') }}
    AS roisegmentation
LEFT JOIN
    json_identifier_dicom_agg
    ON roisegmentation.id_roisegmentation = json_identifier_dicom_agg.id_roisegmentation
LEFT JOIN
    {{ ref('osiris_master_tab_Observation_roisegmentation_codeableconcept') }}
    AS observation_codeableconcept_code
    ON
        roisegmentation."code" = observation_codeableconcept_code."code"
