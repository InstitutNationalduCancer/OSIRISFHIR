SELECT
    "Instance_Id" AS "id_device",
    "Equipment_ModelName" AS "deviceName_name",
    "Equipment_Manufacturer" AS "manufacturer",
    CASE
        WHEN "Equipment_SoftwareVersion" = 'UMLS:C0439673' THEN 'Unknown'
        ELSE "Equipment_SoftwareVersion"
    END AS "version"
FROM
    {{ ref("OSIRIS_pivot_Equipment") }}
