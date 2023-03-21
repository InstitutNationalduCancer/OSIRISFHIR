SELECT
    "id_endpoint" AS id,
    json_build_object(
        'resourceType', 'Endpoint',
        'id', fhir_id(
            '{{ ref("osiris_master_tab_Endpoint") }}', "id_endpoint"::TEXT),
        'meta', json_build_object(
            'profile', json_build_array(
                'http://fhir.arkhn.com/osiris/StructureDefinition/imaging-pacs'
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
    ) AS fhir
FROM
    {{ ref('osiris_master_tab_Endpoint') }}
