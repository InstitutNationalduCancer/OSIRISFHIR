SELECT
    snp."id_variant" AS "id",
    json_build_object(
        'resourceType', 'Observation',
        'id', fhir_id(
            '{{ ref("osiris_master_tab_Variant_snp") }}',
            snp."id_variant"::TEXT
        ),
        'meta', json_build_object(
            'profile', json_build_array(
                'https://build.fhir.org/ig/arkhn/arkhn-ig-osiris/StructureDefinition/snp'
            )
        ),
        'subject', json_build_object(
            'reference', fhir_ref(
                'Patient',
                '{{ ref("osiris_master_tab_Patient") }}',
                snp."subject"::VARCHAR)
        ),
        'derivedFrom', json_build_array(
            json_build_object(
                'reference', fhir_ref(
                    'Observation',
                    '{{ ref("osiris_master_tab_Observation_sequencingAnalysis") }}',
                    snp."derivedfrom_analysis"::VARCHAR)
            )
        ),
        'status', 'final',
        'category', json_build_array(
            json_build_object(
                'coding', json_build_array(
                    json_build_object(
                        'system', 'http://terminology.hl7.org/CodeSystem/observation-category',
                        'code', 'laboratory'
                    )
                )
            )
        ),
        'code', json_build_object(
            'coding', json_build_array(
                json_build_object(
                    'system', 'http://loinc.org',
                    'code', '69548-6',
                    'display', 'Genetic variant assessment'
                )
            )
        ),
        'valueCodeableConcept', json_build_object(
            'coding', json_build_array(
                json_build_object(
                    'system', 'http://loinc.org',
                    'code', 'LA9633-4',
                    'display', 'Present'
                )
            )
        ),
        'component', json_build_array(
            json_build_object(
                'code', json_build_object(
                    'coding', json_build_array(
                        json_build_object(
                            'system', 'http://loinc.org',
                            'code', '62374-4'
                        )
                    ),
                    'text', 'Human reference sequence assembly version'
                ),
                'valueCodeableConcept', json_build_object(
                    'coding', json_build_array(
                        json_build_object(
                            'system', genomebuild_cc."code_system",
                            'code', snp."component_ref_sequence_assembly_valueCodeableConcept",
                            'display', genomebuild_cc."display"
                        )
                    )
                )
            ),
            json_build_object(
                'code', json_build_object(
                    'coding', json_build_array(
                        json_build_object(
                            'system', 'http://loinc.org',
                            'code', '48019-4'
                        )
                    ),
                    'text', 'DNA change type'
                ),
                'valueCodeableConcept', json_build_object(
                    'coding', json_build_array(
                        json_build_object(
                            'system', dna_change_type_cc."code_system",
                            'code', snp."component_dna_chg_type_valueCodeableConcept",
                            'display', dna_change_type_cc."display"
                        )
                    )
                )
            ),
            json_build_object(
                'code', json_build_object(
                    'coding', json_build_array(
                        json_build_object(
                            'system', 'http://loinc.org',
                            'code', '48002-0'
                        )
                    ),
                    'text', 'Genomic source class'
                ),
                'valueCodeableConcept', json_build_object(
                    'coding', json_build_array(
                        json_build_object(
                            'system', genomic_source_class_cc."code_system",
                            'code', snp."component_genomic_source_class_valueCodeableConcept",
                            'display', genomic_source_class_cc."display"
                        )
                    )
                )
            ),
            json_build_object(
                'code', json_build_object(
                    'coding', json_build_array(
                        json_build_object(
                            'system', 'http://loinc.org',
                            'code', '82121-5'
                        )
                    ),
                    'text', 'Allelic read depth'
                ),
                'valueQuantity', json_build_object(
                    'value', snp."component_allelic_read_depth_valueQuantity"
                )
            ),
            json_build_object(
                'code', json_build_object(
                    'coding', json_build_array(
                        json_build_object(
                            'system', 'http://loinc.org',
                            'code', '69547-8'
                        )
                    ),
                    'text', 'Genomic ref allele'
                ),
                'valueString', snp."component_ref_allele_valueString"
            ),
            json_build_object(
                'code', json_build_object(
                    'coding', json_build_array(
                        json_build_object(
                            'system', 'http://loinc.org',
                            'code', '69551-0'
                        )
                    ),
                    'text', 'Genomic alt allele'
                ),
                'valueString', snp."component_alt_allele_valueString"
            ),
            json_build_object(
                'code', json_build_object(
                    'coding', json_build_array(
                        json_build_object(
                            'system', 'http://loinc.org',
                            'code', '81254-5'
                        )
                    ),
                    'text', 'Genomic start and stop'
                ),
                'valueRange', json_build_object(
                    'low', json_build_object(
                        'value', snp."component_exact_start_end_valueRange_low"
                    ),
                    'high', json_build_object(
                        'value', snp."component_exact_start_end_valueRange_high"
                    )
                )
            ),
            CASE
                WHEN snp."component_allelic_state_valueCodeableConcept" IS NOT NULL
                    THEN json_build_object(
                        'code', json_build_object(
                            'coding', json_build_array(
                                json_build_object(
                                    'system', 'http://loinc.org',
                                    'code', '53034-5'
                                )
                            ),
                            'text', 'Allelic state'
                        ),
                        'valueCodeableConcept', json_build_object(
                            'coding', json_build_array(
                                json_build_object(
                                    'system', allelic_state_cc."code_system",
                                    'code', snp."component_allelic_state_valueCodeableConcept",
                                    'display', allelic_state_cc."display"
                                )
                            )
                        )
                    ) END,
            CASE WHEN snp."component_cytogenetic_location_valueCodeableConcept" IS NOT NULL
                THEN json_build_object(
                    'code', json_build_object(
                        'coding', json_build_array(
                            json_build_object(
                                'system', 'http://loinc.org',
                                'code', '48001-2'
                            )
                        ),
                        'text', 'Cytogenetic (chromosome) location'
                    ),
                    'valueCodeableConcept', json_build_object(
                        'coding', json_build_array(
                            json_build_object(
                                'system', cytogenetic_location_cc."code_system",
                                'code', snp."component_cytogenetic_location_valueCodeableConcept",
                                'display', cytogenetic_location_cc."display"
                            )
                        )
                    )
                ) END,
            json_build_object(
                'code', json_build_object(
                    'coding', json_build_array(
                        json_build_object(
                            'system', 'http://loinc.org',
                            'code', 'LP232001-0'
                        )
                    ),
                    'text', 'Alternative allele depth'
                ),
                'valueQuantity', json_build_object(
                    'value', snp."component_variant_read_depth_valueQuantity"
                )
            ),
            json_build_object(
                'code', json_build_object(
                    'coding', json_build_array(
                        json_build_object(
                            'system', 'http://loinc.org',
                            'code', '48000-4'
                        )
                    ),
                    'text', 'Chromosome'
                ),
                'valueCodeableConcept', json_build_object(
                    'coding', json_build_array(
                        json_build_object(
                            'system', chromosome_cc."code_system",
                            'code', snp."component_chromosome_valueCodeableConcept",
                            'display', chromosome_cc."display"
                        )
                    )
                )
            ),
            json_build_object(
                'code', json_build_object(
                    'coding', json_build_array(
                        json_build_object(
                            'system', 'http://loinc.org',
                            'code', '74019-1'
                        )
                    ),
                    'text', 'Pathogenicity'
                ),
                'valueCodeableConcept', json_build_object(
                    'coding', json_build_array(
                        json_build_object(
                            'system', pathogenicity_cc."code_system",
                            'code', snp."component_pathogenicity",
                            'display', pathogenicity_cc."display"
                        )
                    )
                )
            ),
            json_build_object(
                'code', json_build_object(
                    'coding', json_build_array(
                        json_build_object(
                            'system', 'http://loinc.org',
                            'code', '93348-1'
                        )
                    ),
                    'text', 'Impact on patient treatment'
                ),
                'valueBoolean', snp."component_actionability_valueBoolean"
            ),
            json_build_object(
                'code', json_build_object(
                    'coding', json_build_array(
                        json_build_object(
                            'system', 'http://terminology.hl7.org/CodeSystem/umls',
                            'code', 'C0449889'
                        )
                    ),
                    'text', 'Impact on the choice of therapy'
                ),
                'valueBoolean', snp."component_proposed_for_orientation_valueBoolean"
            )
        ),
        'extension', json_build_array(
            CASE 
                WHEN snp."extension_strand_biais_valueBoolean" IS NOT NULL THEN json_build_object(
                'url', 'https://build.fhir.org/ig/arkhn/arkhn-ig-osiris/StructureDefinition/strand-bias',
                'valueBoolean', snp."extension_strand_biais_valueBoolean"
                )
            END
        )
    ) AS fhir
FROM
    {{ ref('osiris_master_tab_Variant_snp') }} AS snp
LEFT JOIN
    {{ ref('osiris_master_tab_Variant_codeableconcept') }} AS genomebuild_cc
    ON snp."component_ref_sequence_assembly_valueCodeableConcept" = genomebuild_cc."code"
LEFT JOIN
    {{ ref('osiris_master_tab_Variant_codeableconcept') }} AS dna_change_type_cc
    ON snp."component_dna_chg_type_valueCodeableConcept" = dna_change_type_cc."code"
LEFT JOIN
    {{ ref('osiris_master_tab_Variant_codeableconcept') }} AS genomic_source_class_cc
    ON snp."component_genomic_source_class_valueCodeableConcept" = genomic_source_class_cc."code"
LEFT JOIN
    {{ ref('osiris_master_tab_Variant_codeableconcept') }} AS allelic_state_cc
    ON snp."component_allelic_state_valueCodeableConcept" = allelic_state_cc."code"
LEFT JOIN
    {{ ref('osiris_master_tab_Variant_codeableconcept') }} AS cytogenetic_location_cc
    ON snp."component_cytogenetic_location_valueCodeableConcept"::VARCHAR = cytogenetic_location_cc."code"
LEFT JOIN
    {{ ref('osiris_master_tab_Variant_codeableconcept') }} AS chromosome_cc
    ON snp."component_chromosome_valueCodeableConcept" = chromosome_cc."code"
LEFT JOIN
    {{ ref('osiris_master_tab_Variant_codeableconcept') }} AS pathogenicity_cc
    ON snp."component_pathogenicity"::VARCHAR = pathogenicity_cc."code"
