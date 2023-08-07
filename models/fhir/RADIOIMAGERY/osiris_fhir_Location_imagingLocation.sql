SELECT
    "id_location" AS id,
    json_build_object(
        'resourceType', 'Location',
        'id', fhir_id(
            '{{ ref("osiris_master_tab_Location") }}', "id_location"::TEXT),
        'meta', json_build_object(
            'profile', json_build_array(
                'http://fhir.arkhn.com/osiris/StructureDefinition/imaging-service'
            )
        ),
        'name', "name"
    ) AS fhir
FROM
    {{ ref('osiris_master_tab_Location') }}
