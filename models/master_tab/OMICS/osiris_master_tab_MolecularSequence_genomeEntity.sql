SELECT
    "id_annotation" AS "id_genomeentity",
    "subject",
    "genome_entity_type",
    "repository_genome_entity_db_name",
    "repository_genome_entity_db_datasetid"
FROM
    {{ ref('osiris_clean_annotation_Variant') }}
