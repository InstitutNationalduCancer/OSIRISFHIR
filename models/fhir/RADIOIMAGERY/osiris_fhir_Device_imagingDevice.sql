SELECT
    "id_device" AS id,
    json_build_object(
        'resourceType', 'Device',
        'id', fhir_id(
            '{{ ref("osiris_master_tab_Device") }}', "id_device"::TEXT),
        'meta', json_build_object(
            'profile', json_build_array(
                'http://fhir.arkhn.com/osiris/StructureDefinition/imaging-device'
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
    ) AS fhir
FROM
    {{ ref('osiris_master_tab_Device') }}
