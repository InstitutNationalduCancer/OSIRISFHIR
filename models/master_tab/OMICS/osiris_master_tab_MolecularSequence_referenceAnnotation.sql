SELECT
    "id_annotation" AS "id_referenceannotation",
    "subject",
    "referenceseq_orientation",
    "referenceseq_referenceseqid",
    "repository_reference_db_name",
    "repository_reference_db_datasetid",
    "repository_pfam_domain_readsetid",
    "repository_pfam_domain_datasetid"
FROM
    {{ ref('osiris_clean_annotation_Variant') }}
