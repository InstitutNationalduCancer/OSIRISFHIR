SELECT
    "Patient_Id" || '-' || "Instance_Id" AS "id_energy",
    "Patient_Id" AS "subject",
    "Patient_Id" || '-' || "PlanRT_Ref" AS "plan",
    CASE WHEN "EnergyOrIsotope_Quantity"::text = 'UMLS:C0439673' THEN 999999
    END AS "extension_energyisotope_quantityEnergyOrIsotope",
    CASE WHEN "EnergyOrIsotope_IsotopeName"::text = 'UMLS:C0439673' THEN 'Unknown'
    END AS "extension_energyisotope_nameEnergyOrIsotope"
FROM
    {{ ref('OSIRIS_pivot_EnergyOrIsotopeRT') }}
