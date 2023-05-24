SELECT
    "id_device" AS id,
    json_build_object(
        'resourceType', 'Device',
        'id', fhir_id(
            '{{ ref("osiris_master_tab_Device") }}', "id_device"::TEXT),
        'meta', json_build_object(
            'profile', json_build_array(
                'https://build.fhir.org/ig/arkhn/arkhn-ig-osiris/StructureDefinition/imaging-device'
            )
        ),
        'manufacturer', "manufacturer",
        'deviceName', json_build_array(
            json_build_object(
                'name', "deviceName_name",
                'type', 'manufacturer-name'
            )
        ),
        'version', json_build_array(
            json_build_object(
                'value', "version"
            )
        )
    ) AS fhir,
    false as is_deleted,
    (now()::DATE - INTERVAL '1 day')::DATE as partition_date
FROM
    {{ ref('osiris_master_tab_Device') }}
