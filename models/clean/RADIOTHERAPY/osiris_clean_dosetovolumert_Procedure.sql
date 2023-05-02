SELECT
    ROW_NUMBER() OVER(ORDER BY "Instance_Id") AS "pk",
    "Instance_Id" AS "id_dosetovolume",
    "Patient_Id" AS "subject",
    "Patient_Id" || '-' || "PlanRT_Ref" AS "plan",
    "VolumeRT_Ref" AS "volume",
    "DoseToVolume_FractionDose" AS "extension_dosetovolume_fractionDose",
    "DoseToVolume_NumberOfFractions" AS "extension_dosetovolume_numberOfFractions",
    "DoseToVolume_TotalDose" AS "extension_dosetovolume_totalDose"
FROM
    {{ ref('OSIRIS_pivot_DoseToVolumeRT') }}
