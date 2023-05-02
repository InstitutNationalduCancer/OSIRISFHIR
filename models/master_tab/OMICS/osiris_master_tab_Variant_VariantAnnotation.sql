SELECT
    "id_annotation",
    "id_annotation" AS "id_referenceannotation",
    "id_annotation" AS "id_genomeentity",
    CASE
        WHEN "component_dna_chg_type" = 'O15-5' THEN "subject" || '-variant-' || "alteration"
        WHEN "component_dna_chg_type" = 'O15-4' THEN "subject" || '-copynumber-' || "alteration"
        WHEN "component_dna_chg_type" = 'O15-3' THEN "subject" || '-fusion-' || "alteration"
        WHEN "component_dna_chg_type" = 'C0439673' THEN 'Unknown'
    END AS "alteration",
    "subject",
    "component_dna_chg_type",
    "component_gene_studied",
    "component_mutation_prediction_software",
    "component_mutation_prediction_evidence_value",
    "component_mutation_prediction_score",
    "component_cytogenetic_location",
    "component_dna_chg",
    "component_amino_acid_chg",
    "component_genomic_dna_chg",
    "component_rna_chg",
    "component_amino_acid_chg_type",
    "derived_fusion_molecular_sequences"
FROM
    {{ ref('osiris_clean_annotation_Variant') }}
