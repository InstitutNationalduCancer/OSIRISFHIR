WITH unique_modand_tech AS (
    SELECT DISTINCT
        "id_planrt",
        "extension_modandtech_radiotherapyModality",
        "extension_modandtech_radiotherapyTechnique",
        "extension_modandtech_radiotherapyTreatmentMachinePlanned"
    FROM
        {{ ref('osiris_master_tab_Procedure_radiotherapyplan') }}
),

extension_extension_modandtech AS (
    SELECT
        unique_modand_tech."id_planrt",
        json_build_object(
            'extension', json_build_array(
                json_build_object(
                    'url', 'radiotherapyModality',
                    'valueCodeableConcept', json_build_object(
                        'coding', json_build_array(
                            json_build_object(
                                'system', codeableconcept_modality."code_system",
                                'code',
                                unique_modand_tech."extension_modandtech_radiotherapyModality"::VARCHAR,
                                'display', codeableconcept_modality."display"
                            )
                        )
                    )
                ),
                json_build_object(
                    'url', 'radiotherapyTechnique',
                    'valueCodeableConcept', json_build_object(
                        'coding', json_build_array(
                            json_build_object(
                                'system', codeableconcept_technique."code_system",
                                'code',
                                unique_modand_tech."extension_modandtech_radiotherapyTechnique"::VARCHAR,
                                'display', codeableconcept_technique."display"
                            )
                        )
                    )
                ),
                json_build_object(
                    'url', 'radiotherapyTreatmentMachinePlanned',
                    'valueString',
                    unique_modand_tech."extension_modandtech_radiotherapyTreatmentMachinePlanned"
                )
            ),
            'url', 'https://build.fhir.org/ig/arkhn/arkhn-ig-osiris/StructureDefinition/modalityAndTechnique'
        ) AS fhir
    FROM
        unique_modand_tech
    LEFT JOIN
        {{ ref('osiris_master_tab_Procedure_radiotherapy_codeableconcept') }}
        AS codeableconcept_modality
        ON
            unique_modand_tech."extension_modandtech_radiotherapyModality"::VARCHAR = codeableconcept_modality."code"
    LEFT JOIN
        {{ ref('osiris_master_tab_Procedure_radiotherapy_codeableconcept') }}
        AS codeableconcept_technique
        ON
            unique_modand_tech."extension_modandtech_radiotherapyTechnique"::VARCHAR = codeableconcept_technique."code"
),

extension_extension_volume AS (
    SELECT
        "id_planrt",
        json_build_object(
            'extension', json_build_array(
                json_build_object(
                    'url', 'rtDoseUID',
                    'valueString', "extension_dosetovolume_rtdoseuid"
                ),
                json_build_object(
                    'url', 'volume',
                    'valueReference', json_build_object(
                        'reference', fhir_ref(
                            'BodyStructure',
                            '{{ ref("osiris_master_tab_BodyStructure_radiotherapyvolume") }}',
                            planrt."volume"::VARCHAR
                        )
                    )
                ),
                json_build_object(
                    'url', 'fractionDose',
                    'valueString', planrt."extension_dosetovolume_fractionDose"::VARCHAR
                ),
                json_build_object(
                    'url', 'numberOfFractions',
                    'valueUnsignedInt', planrt."extension_dosetovolume_numberOfFractions"
                ),
                json_build_object(
                    'url', 'totalDose',
                    'valueString', planrt."extension_dosetovolume_totalDose"::VARCHAR
                )
            ),
            'url', 'https://build.fhir.org/ig/arkhn/arkhn-ig-osiris/StructureDefinition/doseToVolume'
        )
        AS fhir
    FROM
        {{ ref('osiris_master_tab_Procedure_radiotherapyplan') }} AS planrt
),

unique_energyorisotope AS (
    SELECT DISTINCT
        "id_planrt",
        "extension_energyisotope_quantityEnergyOrIsotope",
        "extension_energyisotope_nameEnergyOrIsotope"
    FROM
        {{ ref('osiris_master_tab_Procedure_radiotherapyplan') }}
),

extension_extension_energyorisotope AS (
    SELECT
        "id_planrt",
        json_build_object(
            'extension', json_build_array(
                json_build_object(
                    'url', 'quantityEnergyOrIsotope',
                    'valueQuantity', json_build_object(
                        'value', "extension_energyisotope_quantityEnergyOrIsotope"
                    )
                ),
                json_build_object(
                    'url', 'nameEnergyOrIsotope',
                    'valueString', "extension_energyisotope_nameEnergyOrIsotope"
                )
            ),
            'url', 'https://build.fhir.org/ig/arkhn/arkhn-ig-osiris/StructureDefinition/energyOrIsotope'
        ) AS fhir
    FROM
        unique_energyorisotope
),

unique_basedon AS (
    SELECT DISTINCT
        "id_planrt",
        "extension_basedon_imagingstudyref",
        "extension_basedon_seriesuid",
        "extension_basedon_rtstructuid"
    FROM
        {{ ref('osiris_master_tab_Procedure_radiotherapyplan') }}
),

extension_extension_basedon AS (
    SELECT
        "id_planrt",
        json_build_object(
            'extension', json_build_array(
                CASE WHEN "extension_basedon_imagingstudyref" IS NOT NULL THEN json_build_object(
                    'url', 'imagingStudyRef',
                    'valueReference', fhir_ref(
                        'ImagingStudy',
                        '{{ ref("osiris_master_tab_ImagingStudy") }}',
                        "extension_basedon_imagingstudyref"::VARCHAR
                    )
                    ) END,
                json_build_object(
                    'url', 'seriesUID',
                    'valueString', "extension_basedon_seriesuid"
                ),
                json_build_object(
                    'url', 'rtStructUID',
                    'valueReference', json_build_object(
                        'reference', fhir_ref(
                            'Observation',
                            '{{ ref("osiris_master_tab_Observation_roisegmentation") }}',
                            "extension_basedon_rtstructuid"::VARCHAR
                        )
                    )
                )
            ),
            'url', 'https://build.fhir.org/ig/arkhn/arkhn-ig-osiris/StructureDefinition/basedOn'
        ) AS fhir
    FROM
        unique_basedon
),

unique_extension AS (
    SELECT DISTINCT
        "id_planrt",
        "extension_numberOfFractions",
        "extension_AlgorithName",
        "extension_reasonReplanification"
    FROM
        {{ ref('osiris_master_tab_Procedure_radiotherapyplan') }}
),

extension AS (
    SELECT
        unique_extension."id_planrt",
        json_build_object(
            'url', 'https://build.fhir.org/ig/arkhn/arkhn-ig-osiris/StructureDefinition/numberOfFractions',
            'valueUnsignedInt', unique_extension."extension_numberOfFractions"
        ) AS fhir
    FROM
        unique_extension
    UNION ALL
    SELECT
        unique_extension."id_planrt",
        CASE
            WHEN
                unique_extension."extension_reasonReplanification" IS NOT NULL THEN json_build_object(
                    'url', 'https://build.fhir.org/ig/arkhn/arkhn-ig-osiris/StructureDefinition/reasonReplanification',
                    'valueCodeableConcept', json_build_object(
                        'coding', json_build_array(
                            json_build_object(
                                'system', codeableconcept_terminationreason."code_system",
                                'code', unique_extension."extension_reasonReplanification",
                                'display', codeableconcept_terminationreason."display"
                            )
                        )
                    )
                ) END AS fhir
    FROM
        unique_extension
    LEFT JOIN
        {{ ref('osiris_master_tab_Procedure_radiotherapy_codeableconcept') }}
        AS codeableconcept_terminationreason
        ON
            unique_extension."extension_reasonReplanification" = codeableconcept_terminationreason."code"
    UNION ALL
    SELECT
        unique_extension."id_planrt",
        json_build_object(
            'url', 'https://build.fhir.org/ig/arkhn/arkhn-ig-osiris/StructureDefinition/algorithmName',
            'valueString', unique_extension."extension_AlgorithName"
        ) AS fhir
    FROM
        unique_extension
    UNION ALL
    SELECT
        "id_planrt",
        "fhir"
    FROM
        extension_extension_modandtech
    UNION ALL
    SELECT
        "id_planrt",
        "fhir"
    FROM
        extension_extension_volume
    UNION ALL
    SELECT
        "id_planrt",
        "fhir"
    FROM
        extension_extension_energyorisotope
    UNION ALL
    SELECT
        "id_planrt",
        "fhir"
    FROM
        extension_extension_basedon
),

extension_agg AS (
    SELECT
        "id_planrt",
        json_agg("fhir") AS fhir
    FROM
        extension
    GROUP BY
        "id_planrt"
),

unique_fhir_base AS (
    SELECT DISTINCT
        "id_planrt",
        "identifier_value",
        "subject",
        "partof",
        "category_coding_code",
        "code_coding_code",
        "performedPeriod_start",
        "performedPeriod_end"
    FROM
        {{ ref('osiris_master_tab_Procedure_radiotherapyplan') }}
)

SELECT
    planrt."id_planrt" AS id,
    json_build_object(
        'resourceType', 'Procedure',
        'id', fhir_id(
            '{{ ref("osiris_master_tab_Procedure_radiotherapyphase") }}',
            planrt."id_planrt"::TEXT
        ),
        'meta', json_build_object(
            'profile', json_build_array(
                'https://build.fhir.org/ig/arkhn/arkhn-ig-osiris/StructureDefinition/radiotherapy-plan'
            )
        ),
        'identifier', json_build_array(
            json_build_object(
                'value', planrt."identifier_value",
                'type', json_build_object(
                    'coding', json_build_array(
                        json_build_object(
                            'code', 'MR'
                        )
                    )
                )
            )
        ),
        'subject', json_build_object(
            'reference', fhir_ref(
                'Patient',
                '{{ ref("osiris_master_tab_Patient") }}',
                planrt."subject"::VARCHAR
            )
        ),
        'partOf', json_build_array(
            json_build_object(
                'reference', fhir_ref(
                    'Procedure',
                    '{{ ref("osiris_master_tab_Procedure_radiotherapyphase") }}',
                    planrt."partof"::VARCHAR
                )
            )
        ),
        'status', 'completed',
        'category', json_build_object(
            'coding', json_build_array(
                json_build_object(
                    'system', codeableconcept_category."code_system",
                    'code', planrt."category_coding_code",
                    'display', codeableconcept_category."display"
                )
            )
        ),
        'code', json_build_object(
            'coding', json_build_array(
                json_build_object(
                    'system', codeableconcept_code."code_system",
                    'code', planrt."code_coding_code",
                    'display', codeableconcept_code."display"
                )
            )
        ),
        'performedPeriod', json_build_object(
            'start', planrt."performedPeriod_start",
            'end', planrt."performedPeriod_end"
        ),
        'extension', extension_agg."fhir"
    ) AS fhir,
    false as is_deleted,
    (now()::DATE - INTERVAL '1 day')::DATE as partition_date
FROM
    unique_fhir_base AS planrt
LEFT JOIN
    {{ ref('osiris_master_tab_Procedure_radiotherapy_codeableconcept') }}
    AS codeableconcept_category
    ON planrt."category_coding_code"::text = codeableconcept_category."code"
LEFT JOIN
    {{ ref('osiris_master_tab_Procedure_radiotherapy_codeableconcept') }}
    AS codeableconcept_code
    ON planrt."code_coding_code" = codeableconcept_code."code"
LEFT JOIN
    extension_agg
    ON planrt."id_planrt" = extension_agg."id_planrt"
