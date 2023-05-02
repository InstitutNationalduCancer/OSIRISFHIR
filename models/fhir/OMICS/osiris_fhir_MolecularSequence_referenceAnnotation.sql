SELECT
    refannotation."id_referenceannotation" AS id,
    json_build_object(
        'resourceType', 'MolecularSequence',
        'id', fhir_id(
            '{{ ref("osiris_master_tab_MolecularSequence_referenceAnnotation") }}',
            refannotation."id_referenceannotation"::TEXT
        ),
        'meta', json_build_object(
            'profile', json_build_array(
                'https://build.fhir.org/ig/arkhn/arkhn-ig-osiris/StructureDefinition/annotation-reference'
            )
        ),
        'coordinateSystem', 0,
        'patient', json_build_object(
            'reference', fhir_ref(
                'Patient',
                '{{ ref("osiris_master_tab_Patient") }}',
                refannotation."subject"::VARCHAR
            )
        ),
        'referenceSeq', json_build_object(
            'orientation', refannotation."referenceseq_orientation"::VARCHAR,
            'referenceSeqId', json_build_object(
                'coding', json_build_array(
                    json_build_object(
                        'system', molecularsequence_cc."code_system",
                        'code', refannotation."referenceseq_referenceseqid"::TEXT,
                        'display', molecularsequence_cc."display"
                    )
                )
            )
        ),
        'repository', json_build_array(
            json_build_object(
                'type', 'other',
                'name', refannotation."repository_reference_db_name"::VARCHAR,
                'datasetId', refannotation."repository_reference_db_datasetid"::VARCHAR
            ),
            json_build_object(
                'type', 'directlink',
                'url', 'http://pfam.xfam.org/',
                'name', 'pfam',
                'datasetId', refannotation."repository_pfam_domain_readsetid"::VARCHAR,
                'readsetId', refannotation."repository_pfam_domain_datasetid"::VARCHAR
            )
        )
    ) AS fhir
FROM
    {{ ref('osiris_master_tab_MolecularSequence_referenceAnnotation') }} AS refannotation
LEFT JOIN {{ ref('osiris_master_tab_MolecularSequence_codeableconcept') }} AS molecularsequence_cc
    ON refannotation."referenceseq_referenceseqid" = molecularsequence_cc."code"
