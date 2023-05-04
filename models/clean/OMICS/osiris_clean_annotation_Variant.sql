WITH clean_temp AS (
    SELECT
        "Patient_Id" || '-' || "Instance_Id" AS "id_annotation",
        "Patient_Id" AS "subject",
        "Alteration_Ref" AS "alteration",
        CASE
            WHEN "AlterationOnSample_AlterationType" = 'Genetic variant' THEN 'O15-5'
            ELSE RIGHT("AlterationOnSample_AlterationType", -POSITION(':' IN "AlterationOnSample_AlterationType"))
        END AS "component_dna_chg_type",
        CASE
            WHEN "GenomeEntity_Type" IS NULL THEN 'C0439673'
            ELSE RIGHT("GenomeEntity_Type", -POSITION(':' IN "GenomeEntity_Type"))
        END AS "genome_entity_type",
        COALESCE(RIGHT("GenomeEntity_Database"::text, -POSITION(':' IN "GenomeEntity_Database"::text)), 'unknown') AS "repository_genome_entity_db_name",
        COALESCE("GenomeEntity_Id"::text, 'unknown') AS "repository_genome_entity_db_datasetid",
        "GenomeEntity_Symbol" AS "component_gene_studied",
        CASE
            WHEN "Annotation_ReferenceType" IS NULL THEN 'C0439673'
            ELSE RIGHT("Annotation_ReferenceType", -POSITION(':' IN "Annotation_ReferenceType"))
        END AS "referenceseq_referenceseqid",
        COALESCE("Annotation_ReferenceDatabase", 'unknown') AS "repository_reference_db_name",
        COALESCE("Annotation_ReferenceValue", 'unknown') AS "repository_reference_db_datasetid",
        RIGHT("Annotation_MutationPredictionAlgorithm", -POSITION(':' IN "Annotation_MutationPredictionAlgorithm")) AS "component_mutation_prediction_software",
        "Annotation_MutationPredictionValue" AS "component_mutation_prediction_evidence_value",
        "Annotation_MutationPredictionScore" AS "component_mutation_prediction_score",
        "Annotation_PfamDomain" AS "repository_pfam_domain_readsetid",
        "Annotation_PfamId" AS "repository_pfam_domain_datasetid",
        "Annotation_DNARegionName" AS "component_cytogenetic_location",
        trim("Annotation_DNASequenceVariation") AS "component_dna_chg",
        replace("Annotation_AminoAcidChange", ' ', '') AS "component_amino_acid_chg",
        "Annotation_GenomicSequenceVariation" AS "component_genomic_dna_chg",
        "Annotation_RNASequenceVariation" AS "component_rna_chg",
        CASE 
            WHEN RIGHT("Annotation_AminoAcidChangeType"::text, -POSITION(':' IN "Annotation_AminoAcidChangeType"::text))='C0439673' THEN NULL
            ELSE RIGHT("Annotation_AminoAcidChangeType"::text, -POSITION(':' IN "Annotation_AminoAcidChangeType"::text))
        END AS "component_amino_acid_chg_type",
        "Annotation_FusionPrimeEnd" AS "derived_fusion_molecular_sequences",
        CASE 
            WHEN RIGHT("Annotation_Strand"::text, -POSITION(':' IN "Annotation_Strand"::text))='C0439673' THEN NULL
            ELSE RIGHT("Annotation_Strand"::text, -POSITION(':' IN "Annotation_Strand"::text))
        END AS "referenceseq_orientation"
    FROM
        {{ ref('OSIRIS_pivot_Annotation') }}
)

SELECT
    "id_annotation" || '-' || "component_dna_chg_type" AS "id_annotation",
    "subject",
    "alteration",
    "component_dna_chg_type",
    "genome_entity_type",
    "repository_genome_entity_db_name",
    "repository_genome_entity_db_datasetid",
    "component_gene_studied",
    "referenceseq_referenceseqid",
    "repository_reference_db_name",
    "repository_reference_db_datasetid",
    "component_mutation_prediction_software",
    "component_mutation_prediction_evidence_value",
    "component_mutation_prediction_score",
    "repository_pfam_domain_readsetid",
    "repository_pfam_domain_datasetid",
    "component_cytogenetic_location",
    "component_dna_chg",
    "component_amino_acid_chg",
    "component_genomic_dna_chg",
    "component_rna_chg",
    "component_amino_acid_chg_type",
    "derived_fusion_molecular_sequences",
    "referenceseq_orientation"
FROM
    clean_temp
