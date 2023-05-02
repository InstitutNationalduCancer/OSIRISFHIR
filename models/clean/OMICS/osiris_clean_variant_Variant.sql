SELECT
    "Patient_Id" || '-' || 'variant-' || "Instance_Id" AS "id_variant",
    "Patient_Id" AS "subject",
    "Patient_Id" || '-' || "Analysis_Ref" AS "derivedfrom_analysis",
    RIGHT("AlterationOnSample_Pathogenicity"::text, -POSITION(':' IN "AlterationOnSample_Pathogenicity"::text)) AS "component_pathogenicity",
    CASE
        WHEN "AlterationOnSample_Actionability"::VARCHAR = 'OSIRIS:O82-1' THEN 'true'
        WHEN "AlterationOnSample_Actionability"::VARCHAR = 'OSIRIS:O82-2' THEN 'false'
        ELSE "AlterationOnSample_Actionability"::VARCHAR
    END AS "component_actionability_valueBoolean",
    "AlterationOnSample_ProposedForOrientation" AS "component_proposed_for_orientation_valueBoolean",
    RIGHT("Alteration_Chromosome"::text, -POSITION(':' IN "Alteration_Chromosome"::text)) AS "component_chromosome_valueCodeableConcept",
    "Alteration_GenomicStart" AS "component_exact_start_end_valueRange_low",
    "Alteration_GenomicStop" AS "component_exact_start_end_valueRange_high",
    RIGHT("Alteration_GenomeBuild"::text, -POSITION(':' IN "Alteration_GenomeBuild"::text)) AS "component_ref_sequence_assembly_valueCodeableConcept",
    CASE 
        WHEN "Alteration_Cytoband"::text = 'unknown' THEN 'C0439673'
        ELSE "Alteration_Cytoband"::text
    END AS "component_cytogenetic_location_valueCodeableConcept",
    "Variant_ReferenceAllele" AS "component_ref_allele_valueString",
    "Variant_AlternativeAllele" AS "component_alt_allele_valueString",
    RIGHT(
        "Variant_DNASequenceVariationType", -POSITION(':' IN "Variant_DNASequenceVariationType")
    ) AS "component_dna_chg_type_valueCodeableConcept",
    "VariantInSample_PositionReadDepth" AS "component_allelic_read_depth_valueQuantity",
    "VariantInSample_VariantReadDepth" AS "component_variant_read_depth_valueQuantity",
    CASE
        WHEN
            "VariantInSample_StrandBias"::VARCHAR = '0'
            OR "VariantInSample_StrandBias"::VARCHAR = 'OSIRIS:O82-2'
            OR "VariantInSample_StrandBias"::VARCHAR = 'false' THEN false
        WHEN
            "VariantInSample_StrandBias"::VARCHAR = '1'
            OR "VariantInSample_StrandBias"::VARCHAR = 'OSIRIS:O82-1'
            OR "VariantInSample_StrandBias"::VARCHAR = 'true' THEN true
    END AS "extension_strand_biais_valueBoolean",
    RIGHT(
        "VariantInSample_GenomicSourceClass", -POSITION(':' IN "VariantInSample_GenomicSourceClass")
    ) AS "component_genomic_source_class_valueCodeableConcept",
    RIGHT(
        "VariantInSample_AllelicState", -POSITION(':' IN "VariantInSample_AllelicState")
    ) AS "component_allelic_state_valueCodeableConcept",
    RIGHT(
        "Validation_Type", -POSITION(':' IN "Validation_Type")
    ) AS "validationType_coding",
    "Validation_Method" AS "validationProcess_text",
    CASE
        WHEN "Validation_Status" = 'OSIRIS:O18-1' THEN 'in-process'
        WHEN "Validation_Status" = 'OSIRIS:O18-2' THEN 'validated'
        WHEN "Validation_Status" = 'UMLS:C0439673' THEN 'in-process'
    END AS "verification_status"
FROM
    {{ ref('OSIRIS_pivot_Variant') }}
