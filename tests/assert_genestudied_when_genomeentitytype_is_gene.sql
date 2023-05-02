{{ config(severity = 'warn') }}

SELECT 
    *
FROM
    {{ ref('osiris_master_tab_Variant_VariantAnnotation') }} AS variantannotation
LEFT JOIN
    {{ ref('osiris_master_tab_MolecularSequence_genomeEntity') }} AS genome
ON variantannotation."id_annotation" = genome."id_genomeentity"
WHERE
    genome."genome_entity_type" = 'O24-1'
    AND variantannotation. "component_gene_studied" IS NULL