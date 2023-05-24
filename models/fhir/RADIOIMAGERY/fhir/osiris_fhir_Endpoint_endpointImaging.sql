SELECT
    "id_endpoint" AS id,
    json_build_object(
        'resourceType', 'Endpoint',
        'id', fhir_id(
            '{{ ref("osiris_master_tab_Endpoint") }}', "id_endpoint"::TEXT),
        'meta', json_build_object(
            'profile', json_build_array(
                'https://build.fhir.org/ig/arkhn/arkhn-ig-osiris/StructureDefinition/imaging-pacs'
            )
        ),
        'name', "name",
        'address', ' ',
        'status', 'active',
        'payloadType', json_build_array(
            json_build_object(
                'coding', json_build_array(
                    json_build_object(
                        'system', 'http://terminology.hl7.org/CodeSystem/umls',
                        'code', 'C0439673',
                        'display', 'Unknown'
                    )
                )
            )
        ),
        'connectionType', json_build_object(
            'system', 'http://terminology.hl7.org/CodeSystem/umls',
            'code', 'C0439673',
            'display', 'Unknown'
        )
    ) AS fhir,
    false as is_deleted,
    (now()::DATE - INTERVAL '1 day')::DATE as partition_date
FROM
    {{ ref('osiris_master_tab_Endpoint') }}
