SELECT
    "Patient_Id" || '-' || "Instance_Id" AS "id_device",
    "Equipment_ModelName" AS "deviceName_name",
    "Equipment_Manufacturer" AS "manufacturer",
    CASE
        WHEN "Equipment_SoftwareVersion"::text = 'UMLS:C0439673' THEN 'Unknown'
        ELSE "Equipment_SoftwareVersion"::text
    END AS "version"
FROM
    {{ ref("OSIRIS_pivot_Equipment") }}
