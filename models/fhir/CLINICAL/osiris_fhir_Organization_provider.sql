SELECT
    "id_organization" AS id,
    json_build_object(
        'resourceType', 'Organization',
        'id', fhir_id(
            '{{ ref("osiris_master_tab_Organization") }}', "id_organization"::TEXT),
        'meta', json_build_object(
            'profile', json_build_array(
                'http://fhir.arkhn.com/osiris/StructureDefinition/onco-organization'
            )
        ),
        'identifier', json_build_array(
            json_build_object(
                'system', "identifier_finess_system",
                'value', "identifier_finess_value"
            )

        ),
        'name', "name"
    )
    AS fhir
FROM
    {{ ref('osiris_master_tab_Organization') }}
