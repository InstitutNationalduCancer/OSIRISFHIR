SELECT
    "responseevaluation"."id_responseevaluation" AS id,
    json_build_object(
        'resourceType', 'Observation',
        'id', fhir_id('{{ ref("osiris_master_tab_Observation_responseEvaluation") }}', "responseevaluation"."id_responseevaluation"::TEXT),
        'meta', json_build_object(
            'profile', json_build_array(
                'https://build.fhir.org/ig/arkhn/arkhn-ig-osiris/StructureDefinition/response-evaluation'
            )
        ),
        'status', 'final',
        'code', json_build_object(
            'coding', json_build_array(
                json_build_object(
                    'system', 'http://terminology.hl7.org/CodeSystem/umls',
                    'code', '370807008',
                    'display', 'Evaluation of response to medications'
                )
            )
        ),
        'subject', json_build_object(
           'reference', fhir_ref(
                'Patient',
                '{{ ref("osiris_master_tab_Patient") }}',
                responseevaluation."subject"::VARCHAR)
        ),
        'basedOn', json_build_array(
            json_build_object(
            'reference', fhir_ref(
                'CarePlan',
                '{{ ref("osiris_master_tab_CarePlan") }}',
                responseevaluation."basedon"::VARCHAR)
            )
        ),
        'effectiveDateTime', responseevaluation."effectiveDateTime",
        'valueCodeableConcept', json_build_object(
            'coding' , json_build_array(
                json_build_object(
                'code' , responseevaluation."valueCodableConcept", 
                'system', cc.code_system, 
                'display', cc.display
            ))
        )
    ) AS fhir
FROM
    {{ ref('osiris_master_tab_Observation_responseEvaluation') }} AS responseevaluation
    left join {{ ref('osiris_master_tab_Observation_codeableConcept') }} as cc 
    on responseevaluation."valueCodableConcept" = cc.code