SELECT
    "id_medication" AS id,
    json_build_object(
        'resourceType', 'Medication',
        'id', fhir_id(
            '{{ ref("osiris_master_tab_Medication") }}', "id_medication"::TEXT),
        'meta', json_build_object(
            'profile', json_build_array(
                'https://build.fhir.org/ig/arkhn/arkhn-ig-osiris/StructureDefinition/onco-biological-contrast'
            )
        ),
        'code', json_build_object(
            'text', "code_text"
        )
    ) AS fhir,
    false as is_deleted,
    (now()::DATE - INTERVAL '1 day')::DATE as partition_date
FROM
    {{ ref('osiris_master_tab_Medication') }}
