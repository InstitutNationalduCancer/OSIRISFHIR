SELECT
    seq_analysis."id_sequencinganalysis" AS "id",
    json_build_object(
        'resourceType', 'Observation',
        'meta', json_build_object(
            'profile', json_build_array(
                'https://build.fhir.org/ig/arkhn/arkhn-ig-osiris/StructureDefinition/sequencing-analysis'
            )
        ),
        'id', fhir_id(
            '{{ ref("osiris_master_tab_Observation_sequencingAnalysis") }}',
            seq_analysis."id_sequencinganalysis"::TEXT
        ),
        'subject', json_build_object(
            'reference', fhir_ref(
                'Patient',
                '{{ ref("osiris_master_tab_Patient") }}',
                seq_analysis."subject"::VARCHAR)
        ),
        'status', 'final',
        'specimen', json_build_object(
            'reference', fhir_ref(
                'Specimen',
                '{{ ref("osiris_master_tab_Specimen_specimen") }}',
                seq_analysis."specimen"::VARCHAR
            )
        ),
        'device', json_build_object(
            'reference', fhir_ref(
                'Device',
                '{{ ref("osiris_master_tab_Device_sequencingDevice") }}',
                seq_analysis."device"::VARCHAR
            )
        ),
        'category', json_build_array(
            json_build_object(
                'text', seq_analysis."category_text"
            )
        ),
        'method', json_build_object(
            'coding', json_build_array(
                json_build_object(
                    'system', method_cc."code_system",
                    'code', seq_analysis."method",
                    'display', method_cc."display"
                )
            )
        ),
        'code', json_build_object(
            'coding', json_build_array(
                json_build_object(
                    'system', observation_codeableconcept_code."code_system",
                    'code', seq_analysis."code_coding_code",
                    'display', observation_codeableconcept_code."display"
                )
            )
        ),
        'focus', json_build_array(
            json_build_object(
                'reference', fhir_ref(
                    'Condition',
                    '{{ ref("osiris_master_tab_Condition_tumorPathologyEvent") }}',
                    seq_analysis."focus"::VARCHAR
                )
            )
        ),
        'effectiveDateTime', seq_analysis."effectiveDateTime",
        'component', json_build_array(
            json_build_object(
                'code', json_build_object(
                    'coding', json_build_array(
                        json_build_object(
                            'system', 'http://terminology.hl7.org/CodeSystem/umls',
                            'code', 'C0162801'
                        )
                    ),
                    'text', 'Name of the analysis software'
                ),
                'valueString', seq_analysis."component_analytic_pipeline_code"
            ),
            json_build_object(
                'code', json_build_object(
                    'coding', json_build_array(
                        json_build_object(
                            'system', 'http://terminology.hl7.org/CodeSystem/umls',
                            'code', 'C0032246'
                        )
                    ),
                    'text', 'Ploidy'
                ),
                'valueCodeableConcept', json_build_object(
                    'coding', json_build_array(
                        json_build_object(
                            'system', ploidy_cc."code_system",
                            'code', seq_analysis."component_algorithmic_ploidy",
                            'display', ploidy_cc."display"
                        )
                    )
                )
            ),
            json_build_object(
                'code', json_build_object(
                    'coding', json_build_array(
                        json_build_object(
                            'system', 'http://loinc.org',
                            'code', 'LA26327-9'
                        )
                    ),
                    'text', 'Genomic complexity - Number of breakpoints'
                ),
                'valueQuantity', json_build_object(
                    'value', seq_analysis."component_number_of_breakpoints"
                )
            ),
            json_build_object(
                'code', json_build_object(
                    'coding', json_build_array(
                        json_build_object(
                            'system', 'http://terminology.hl7.org/CodeSystem/umls',
                            'code', 'C3260254'
                        )
                    ),
                    'text', 'Percentage of tumor cells'
                ),
                'valueQuantity', json_build_object(
                    'value', seq_analysis."component_algorithmic_cellularity"
                )
            ),
            json_build_object(
                'code', json_build_object(
                    'coding', json_build_array(
                        json_build_object(
                            'system', 'http://terminology.hl7.org/CodeSystem/umls',
                            'code', '258049002'
                        )
                    ),
                    'text', 'Sequencing date'
                ),
                'valueDateTime', seq_analysis."component_date_of_experiment"
            )
        )
    ) AS fhir,
    false as is_deleted, 
    (now()::DATE - INTERVAL '1 day')::DATE as partition_date
FROM
    {{ ref('osiris_master_tab_Observation_sequencingAnalysis') }} AS seq_analysis
LEFT JOIN
    {{ ref('osiris_master_tab_Observation_codeableConcept') }} AS observation_codeableconcept_code
    ON
        seq_analysis."code_coding_code" = observation_codeableconcept_code."code"
LEFT JOIN
    {{ ref('osiris_master_tab_Observation_codeableConcept') }} AS ploidy_cc
    ON
        seq_analysis."component_algorithmic_ploidy" = ploidy_cc."code"
LEFT JOIN
    {{ ref('osiris_master_tab_Observation_codeableConcept') }} AS method_cc
    ON
        seq_analysis."method" = method_cc."code"
