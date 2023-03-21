SELECT
    "Instance_Id" AS "id_volume",
    "Volume_Identifier" AS "identifier_value",
    "Volume_Location" AS "location_coding_code",
    "Volume_LocationQualifier " AS "locationQualifier_coding_code",
    "Volume_Description " AS "description"
FROM
    {{ ref('OSIRIS_pivot_VolumeRT') }}
