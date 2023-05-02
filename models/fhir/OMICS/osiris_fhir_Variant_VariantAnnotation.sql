SELECT
    variantannotation."id_annotation" AS id,
    json_build_object(
        'resourceType', 'Observation',
        'id', fhir_id(
            '{{ ref("osiris_master_tab_Variant_VariantAnnotation") }}',
            variantannotation."id_annotation"::TEXT
        ),
        'meta', json_build_object(
            'profile', json_build_array(
                'https://build.fhir.org/ig/arkhn/arkhn-ig-osiris/StructureDefinition/variant-annotation'
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
                    'code', '69548-6'
                )
            )
        ),
        'subject', json_build_object(
            'reference', fhir_ref(
                'Patient',
                '{{ ref("osiris_master_tab_Patient") }}',
                variantannotation."subject"::VARCHAR
            )
        ),
        'hasMember', json_build_array(
            json_build_object(
                'reference', fhir_ref(
                    'MolecularSequence',
                    '{{ ref("osiris_master_tab_MolecularSequence_genomeEntity") }}',
                    variantannotation."id_genomeentity"::VARCHAR
                )
            ),
            json_build_object(
                'reference', fhir_ref(
                    'MolecularSequence',
                    '{{ ref("osiris_master_tab_MolecularSequence_referenceAnnotation") }}',
                    variantannotation."id_referenceannotation"::VARCHAR
                )
            )
        ),
        'derivedFrom', json_build_array(
            json_build_object(
                'reference', fhir_ref(
                    'Observation',
                    '{{ ref("osiris_master_tab_Variant_snp") }}',
                    variantannotation."alteration"::VARCHAR
                )
            )
        ),
        'valueCodeableConcept', json_build_object(
            'coding', json_build_array(
                json_build_object(
                    'system', 'http://loinc.org',
                    'code', 'LA9633-4'
                )
            )
        ),
        'component', json_build_array(
            json_build_object(
                'code', json_build_object(
                    'coding', json_build_array(
                        json_build_object(
                            'system', 'http://loinc.org',
                            'code', '48018-6',
                            'display', 'gene-studied'
                        )
                    )
                ),
                'valueCodeableConcept', json_build_object(
                    'coding', json_build_array(
                        json_build_object(
                            'system', 'https://www.genenames.org/',
                            'code', variantannotation."component_gene_studied"
                        )
                    )
                )
            ),
            CASE 
                WHEN variantannotation."component_cytogenetic_location" IS NOT NULL THEN
                    json_build_object(
                        'code', json_build_object(
                            'coding', json_build_array(
                                json_build_object(
                                    'system', 'http://loinc.org',
                                    'code', '48001-2',
                                    'display', 'cytogenetic-location'
                                )
                            )
                        ),
                        'valueCodeableConcept', json_build_object(
                            'text', variantannotation."component_cytogenetic_location"::VARCHAR
                        )
                    )
            END,
            json_build_object(
                'code', json_build_object(
                    'coding', json_build_array(
                        json_build_object(
                            'system', 'http://loinc.org',
                            'code', '48004-6',
                            'display', 'dna-chg'
                        )
                    )
                ),
                'valueCodeableConcept', json_build_object(
                    'coding', json_build_array(
                        json_build_object(
                            'system', 'http://varnomen.hgvs.org',
                            'code', variantannotation."component_dna_chg"::VARCHAR
                        )
                    )
                )
            ),
            json_build_object(
                'code', json_build_object(
                    'coding', json_build_array(
                        json_build_object(
                            'system', 'http://loinc.org',
                            'code', '48019-4',
                            'display', 'dna-chg-type'
                        )
                    )
                ),
                'valueCodeableConcept', json_build_object(
                    'coding', json_build_array(
                        json_build_object(
                            'system', dnachgtype_cc."code_system",
                            'code', variantannotation."component_dna_chg_type"::VARCHAR,
                            'display', dnachgtype_cc."display"
                        )
                    )
                )
            ),
            json_build_object(
                'code', json_build_object(
                    'coding', json_build_array(
                        json_build_object(
                            'system', 'http://loinc.org',
                            'code', 'LP232001-0',
                            'display', 'rna-chg'
                        )
                    ),
                    'text', 'Incidence on the transcript'
                ),
                'valueCodeableConcept', json_build_object(
                    'coding', json_build_array(
                        json_build_object(
                            'code', variantannotation."component_rna_chg"::VARCHAR
                        )
                    )
                )
            ),
            json_build_object(
                'code', json_build_object(
                    'coding', json_build_array(
                        json_build_object(
                            'system', 'http://loinc.org',
                            'code', '81290-9',
                            'display', 'genomic-dna-chg'
                        )
                    )
                ),
                'valueCodeableConcept', json_build_object(
                    'coding', json_build_array(
                        json_build_object(
                            'system', 'http://terminology.hl7.org/CodeSystem/umls',
                            'code', variantannotation."component_genomic_dna_chg"::VARCHAR
                        )
                    )
                )
            ),
            json_build_object(
                'code', json_build_object(
                    'coding', json_build_array(
                        json_build_object(
                            'system', 'http://loinc.org',
                            'code', '48005-3',
                            'display', 'amino-acid-chg'
                        )
                    )
                ),
                'valueCodeableConcept', json_build_object(
                    'coding', json_build_array(
                        json_build_object(
                            'system', 'http://varnomen.hgvs.org',
                            'code', variantannotation."component_amino_acid_chg"
                        )
                    )
                )
            ),
            CASE 
                WHEN variantannotation."component_amino_acid_chg_type" IS NOT NULL THEN 
                    json_build_object(
                        'code', json_build_object(
                            'coding', json_build_array(
                                json_build_object(
                                    'system', 'http://loinc.org',
                                    'code', '48006-1',
                                    'display', 'amino-acid-chg-type'
                                )
                            )
                        ),
                        'valueCodeableConcept', json_build_object(
                            'coding', json_build_array(
                                json_build_object(
                                    'system', aminoacidtype_cc."code_system",
                                    'code', variantannotation."component_amino_acid_chg_type",
                                    'display', aminoacidtype_cc."display"
                                )
                            )
                        )
                    )
            END,
            json_build_object(
                'code', json_build_object(
                    'coding', json_build_array(
                        json_build_object(
                            'system', 'http://loinc.org',
                            'code', 'LP91038-7'
                        )
                    ),
                    'text', 'Prediction software'
                ),
                'valueCodeableConcept', json_build_object(
                    'coding', json_build_array(
                        json_build_object(
                            'system', mutationprediction_cc."code_system",
                            'code', variantannotation."component_mutation_prediction_software"::VARCHAR,
                            'display', mutationprediction_cc."display"
                        )
                    )
                )
            ),
            json_build_object(
                'code', json_build_object(
                    'coding', json_build_array(
                        json_build_object(
                            'system', 'http://loinc.org',
                            'code', 'LP70194-3'
                        )
                    ),
                    'text', 'Prediction of the variation effect over the protein'
                ),
                'valueQuantity', json_build_object(
                    'value', variantannotation."component_mutation_prediction_score"::numeric
                )
            ),
            json_build_object(
                'code', json_build_object(
                    'coding', json_build_array(
                        json_build_object(
                            'system', 'http://loinc.org',
                            'code', '93044-6'
                        )
                    ),
                    'text', 'Confidence score'
                ),
                'valueString', variantannotation."component_mutation_prediction_evidence_value"::VARCHAR
            )
        )
    ) AS fhir
FROM
    {{ ref('osiris_master_tab_Variant_VariantAnnotation') }} AS variantannotation
LEFT JOIN {{ ref('osiris_master_tab_Variant_codeableconcept') }} AS aminoacidtype_cc
    ON variantannotation."component_amino_acid_chg_type" = aminoacidtype_cc."code"
LEFT JOIN {{ ref('osiris_master_tab_Variant_codeableconcept') }} AS dnachgtype_cc
    ON variantannotation."component_dna_chg_type" = dnachgtype_cc."code"
LEFT JOIN {{ ref('osiris_master_tab_Variant_codeableconcept') }} AS mutationprediction_cc
    ON variantannotation."component_mutation_prediction_software" = mutationprediction_cc."code"
