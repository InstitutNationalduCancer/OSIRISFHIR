with
unnest_locationqualifier as (--division of multiple values in differents rows
    select
        unnest(
            string_to_array("locationQualifier_coding_code", ';')
        ) as "locationQualifier_coding_code",
        "id_volume",
        "subject"
    from
        {{ ref('osiris_master_tab_BodyStructure_radiotherapyvolume') }}
),

json_locationqualifier as (
    select
        unnest_locationqualifier."id_volume",
        unnest_locationqualifier."subject",
        json_build_object(
            'coding', json_build_array(
                json_build_object(
                    'system', radiotherapy_cc."code_system",
                    'code', unnest_locationqualifier."locationQualifier_coding_code",
                    'display', radiotherapy_cc."display"
                )
            )
        ) as "locationQualifier_coding_code"
    from
        unnest_locationqualifier
    left join
        {{ ref('osiris_master_tab_Procedure_radiotherapy_codeableconcept') }} as radiotherapy_cc
        on unnest_locationqualifier."locationQualifier_coding_code" = radiotherapy_cc."code"
),

json_locationqualifier_agg as (
    select
        "id_volume",
        "subject",
        json_agg("locationQualifier_coding_code") as "locationQualifier_coding_code"
    from
        json_locationqualifier
    group by "id_volume", "subject"
)

select
    volume."id_volume" as "id",
    json_build_object(
        'resourceType', 'BodyStructure',
        'id',
        fhir_id(
            '{{ ref("osiris_master_tab_BodyStructure_radiotherapyvolume") }}',
            volume."id_volume"::TEXT
        ),
        'meta',
        json_build_object(
            'profile', json_build_array(
                'http://fhir.arkhn.com/osiris/StructureDefinition/radiotherapy-volume'
            )
        ),
        'identifier', json_build_array(
            json_build_object(
                'value', volume."identifier_value"
            )
        ),
        'location', json_build_object(
            'coding', json_build_array(
                json_build_object(
                    'system', radiotherapy_cc."code_system",
                    'code', volume."location_coding_code"::VARCHAR,
                    'display', radiotherapy_cc."display"
                )
            )
        ),
        'locationQualifier', json_locationqualifier_agg."locationQualifier_coding_code",
        'description', volume."description",
        'patient', json_build_object(
            'reference', fhir_ref(
                'Patient',
                '"osiris_master_tab_Patient"',
                volume."subject"::VARCHAR
            )
        )
    ) as fhir
from
    {{ ref('osiris_master_tab_BodyStructure_radiotherapyvolume') }} as volume
left join
    {{ ref('osiris_master_tab_Procedure_radiotherapy_codeableconcept') }} as radiotherapy_cc
    on volume."location_coding_code"::VARCHAR = radiotherapy_cc."code"
left join
    json_locationqualifier_agg
    on volume."id_volume" = json_locationqualifier_agg."id_volume"
