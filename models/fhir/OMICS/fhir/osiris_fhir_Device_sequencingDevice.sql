SELECT
    seq_device."id_sequencingdevice" AS id,
    json_build_object(
        'resourceType', 'Device',
        'id', fhir_id(
            '{{ ref("osiris_master_tab_Device_sequencingDevice") }}', seq_device."id_sequencingdevice"::TEXT),
        'meta', json_build_object(
            'profile', json_build_array(
                'https://build.fhir.org/ig/arkhn/arkhn-ig-osiris/StructureDefinition/sequencing-device'
            )
        ),
        'identifier', json_build_array(
            json_build_object(
                'value', seq_device."device_identifier")
        ),
        'type', json_build_object(
            'coding', json_build_array(
                json_build_object(
                    'system', type_device."code_system",
                    'code', seq_device."type",
                    'display', type_device."display"
                )
            )
        ),
        'version', json_build_array(
            json_build_object(
                'type', json_build_object(
                    'coding', json_build_array(
                        json_build_object(
                            'system', version_device."code_system",
                            'code', seq_device."device_version_type_coding",
                            'display', version_device."display"
                        )
                    ),
                    'text', 'Name of the gene panel'
                ),
                'value', 'Not Applicable'
            )
        )

    ) AS fhir,
    false as is_deleted, 
    (now()::DATE - INTERVAL '1 day')::DATE as partition_date
FROM
    {{ ref('osiris_master_tab_Device_sequencingDevice') }} AS seq_device
LEFT JOIN
    {{ ref('osiris_master_tab_Device_codeableconcept') }} AS type_device
    ON seq_device."type" = type_device."code"
LEFT JOIN
    {{ ref('osiris_master_tab_Device_codeableconcept') }} AS version_device
    ON seq_device."device_version_type_coding" = version_device."code"
