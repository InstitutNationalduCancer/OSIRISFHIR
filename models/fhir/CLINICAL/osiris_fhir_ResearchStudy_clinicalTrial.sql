SELECT
    "identifier_value" AS "id",
    json_build_object(
        'resourceType', 'ResearchStudy',
        'id', fhir_id('{{ ref("osiris_master_tab_ResearchStudy") }}', "identifier_value"::TEXT),
        'meta', json_build_object(
            'profile', json_build_array(
                'https://build.fhir.org/ig/arkhn/arkhn-ig-osiris/StructureDefinition/clinical-trial'
            )
        ),
        'status', 'approved',
        'identifier', json_build_array(
            json_build_object(
                'value', "identifier_value"
            )
        ),
        'title', "title"
    ) AS "fhir"
FROM
    {{ ref('osiris_master_tab_ResearchStudy') }}
