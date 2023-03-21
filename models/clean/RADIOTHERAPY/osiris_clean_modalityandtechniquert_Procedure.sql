SELECT
    "Instance_Id" AS "id_modality_technique",
    "ModalityAndTechnique_Technique" AS "extension_modandtech_radiotherapyModality",
    "ModalityAndTechnique_Modality" AS "extension_modandtech_radiotherapyTechnique",
    CASE WHEN "ModalityAndTechnique_TreatmentMachinePlanned" = 'UMLS:C0439673' THEN 'Unknown'
    END AS "extension_modandtech_radiotherapyTreatmentMachinePlanned"
FROM
    {{ ref('OSIRIS_pivot_ModalityAndTechniqueRT') }}
