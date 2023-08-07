SELECT
    "id_researchstudy" AS "id",
    json_build_object(
        'resourceType', 'ResearchStudy',
        'id', fhir_id('{{ ref("osiris_master_tab_ResearchStudy") }}', "id_researchstudy"::TEXT),
        'meta', json_build_object(
            'profile', json_build_array(
                'http://fhir.arkhn.com/osiris/StructureDefinition/clinical-trial'
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
