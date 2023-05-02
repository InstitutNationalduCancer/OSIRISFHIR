SELECT
    "Patient_Id" || '-' || "Instance_Id" AS "id_specimen",
    "Patient_Id" AS "subject",
    "Patient_Id" || '-' || "TumorPathologyEvent_Ref" AS "extension_basedoncondition",
    "Patient_Id" || '-' || "Consent_Ref" AS "specimen_provision_data_reference",
    "BiologicalSample_ExternalAccession" AS "identifier",
    "Patient_Id" || '-' || "BiologicalSample_ParentExternalAccession" AS "parent",
    "BiologicalSample_CollectDate" AS "collection_collectedDateTime",
    RIGHT("BiologicalSample_TopographyCode", -POSITION(':' IN "BiologicalSample_TopographyCode")) AS "collection_bodySite",
    RIGHT("BiologicalSample_Nature", -POSITION(':' IN "BiologicalSample_Nature")) AS "type",
    RIGHT("BiologicalSample_Origin", -POSITION(':' IN "BiologicalSample_Origin")) AS "extension_biologicalsampleorigine",
    RIGHT("BiologicalSample_StorageTemperature", -POSITION(':' IN "BiologicalSample_StorageTemperature")) AS "condition_storage_temperature",
    "BiologicalSample_TumorCellularity" AS "collection_quantity_value"
FROM
    {{ ref('OSIRIS_pivot_BiologicalSample') }}
