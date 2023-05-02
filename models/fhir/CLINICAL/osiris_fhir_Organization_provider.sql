SELECT
    "identifier_finess_value" AS id,
    json_build_object(
        'resourceType', 'Organization',
        'id', fhir_id(
            '{{ ref("osiris_master_tab_Organization") }}', "identifier_finess_value"::TEXT),
        'meta', json_build_object(
            'profile', json_build_array(
                'https://build.fhir.org/ig/arkhn/arkhn-ig-osiris/StructureDefinition/onco-organization'
            )
        ),
        'identifier', json_build_array(
            json_build_object(
                'system', "identifier_finess_system",
                'value', "identifier_finess_value"
            )

        )
    )
    AS fhir
FROM
    {{ ref('osiris_master_tab_Organization') }}
