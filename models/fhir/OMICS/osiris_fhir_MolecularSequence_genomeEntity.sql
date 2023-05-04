SELECT
    genome."id_genomeentity" AS id,
    json_build_object(
        'resourceType', 'MolecularSequence',
        'id', fhir_id(
            '{{ ref("osiris_master_tab_MolecularSequence_genomeEntity") }}',
            genome."id_genomeentity"::TEXT
        ),
        'meta', json_build_object(
            'profile', json_build_array(
                'https://build.fhir.org/ig/arkhn/arkhn-ig-osiris/StructureDefinition/genome-entity'
            )
        ),
        'coordinateSystem', 0,
        'patient', json_build_object(
            'reference', fhir_ref(
                'Patient',
                '{{ ref("osiris_master_tab_Patient") }}',
                genome."subject"::VARCHAR
            )
        ),
        'extension', json_build_array(
            json_build_object(
                'url', 'https://build.fhir.org/ig/arkhn/arkhn-ig-osiris/StructureDefinition/genomeentityType',
                'valueCodeableConcept', json_build_object(
                    'coding', json_build_array(
                        json_build_object(
                            'system', genome_cc."code_system",
                            'code', genome."genome_entity_type",
                            'display', genome_cc."display"
                        )
                    )
                )
            )
        ),
        'repository', json_build_array(
            json_build_object(
                'name', genome."repository_genome_entity_db_name"::VARCHAR,
                'datasetId', genome."repository_genome_entity_db_datasetid"::VARCHAR,
                'type', 'other'
            )
        )
    ) AS fhir
FROM
    {{ ref('osiris_master_tab_MolecularSequence_genomeEntity') }} AS genome
LEFT JOIN {{ ref('osiris_master_tab_MolecularSequence_codeableconcept') }} AS genome_cc
    ON genome."genome_entity_type" = genome_cc."code"
