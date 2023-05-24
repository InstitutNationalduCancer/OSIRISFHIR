SELECT
    "id_location" AS id,
    json_build_object(
        'resourceType', 'Location',
        'id', fhir_id(
            '{{ ref("osiris_master_tab_Location") }}', "id_location"::TEXT),
        'meta', json_build_object(
            'profile', json_build_array(
                'https://build.fhir.org/ig/arkhn/arkhn-ig-osiris/StructureDefinition/imaging-service'
            )
        ),
        'name', "name"
    ) AS fhir,
    false as is_deleted,
    (now()::DATE - INTERVAL '1 day')::DATE as partition_date
FROM
    {{ ref('osiris_master_tab_Location') }}
