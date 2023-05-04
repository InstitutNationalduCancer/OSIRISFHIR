SELECT
    biomarker."id_biomarker" AS id,
    json_build_object(
        'resourceType',
        'Observation',
        'id', fhir_id('{{ ref("osiris_master_tab_Observation_biomarker") }}', biomarker."id_biomarker"::TEXT),
        'meta', json_build_object(
            'profile', json_build_array(
                'https://build.fhir.org/ig/arkhn/arkhn-ig-osiris/StructureDefinition/biomarker'
            )
        ),
        'code', json_build_object(
            'coding', json_build_array(
                json_build_object(
                    'system', biomarker_cc."code_system",
                    'code', biomarker."code",
                    'display', biomarker_cc."display"
                )
            )
        ),
        'status', 'final',
        'subject', json_build_object(
            'reference', fhir_ref(
                'Patient',
                '{{ ref("osiris_master_tab_Patient") }}',
                biomarker."subject"::VARCHAR
            )
        ),
        'valueQuantity', CASE WHEN biomarker."value_unit" IS NOT NULL
            THEN json_build_object(
                'value', biomarker."value"::INT,
                'unit', biomarker."value_unit",
                'system', 'http://unitsofmeasure.org'
            ) END,
        'valueString', CASE WHEN biomarker."value_unit" IS NULL THEN biomarker."value"::VARCHAR END,
        'derivedFrom', json_build_array(
            json_build_object(
                'reference', fhir_ref(
                    'Observation',
                    '{{ ref("osiris_master_tab_Observation_analysis") }}',
                    biomarker."derivedfrom"::VARCHAR
                )
            )
        )
    ) AS fhir
FROM
    {{ ref('osiris_master_tab_Observation_biomarker') }} AS biomarker
LEFT JOIN
    {{ ref('osiris_master_tab_Observation_codeableConcept') }} AS biomarker_cc
    ON biomarker."code" = biomarker_cc."code"
