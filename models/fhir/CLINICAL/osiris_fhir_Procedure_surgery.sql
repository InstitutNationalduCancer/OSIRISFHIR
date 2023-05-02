SELECT
    surgery."id_surgery" AS "id",
    json_build_object(
        'resourceType', 'Procedure',
        'id', fhir_id('{{ ref("osiris_master_tab_Procedure_surgery") }}', surgery."id_surgery"::TEXT),
        'meta', json_build_object(
            'profile', json_build_array(
                'https://build.fhir.org/ig/arkhn/arkhn-ig-osiris/StructureDefinition/onco-surgery'
            )
        ),
        'subject', json_build_object(
            'reference', fhir_ref(
                'Patient',
                '{{ ref("osiris_master_tab_Patient") }}',
                surgery."subject"::VARCHAR)
        ),
        'basedOn', json_build_array(
            json_build_object(
                'reference', fhir_ref(
                    'CarePlan',
                    '{{ ref("osiris_master_tab_CarePlan") }}',
                    surgery."treatment"::VARCHAR)
            )
        ),
        'status', 'completed',
        'outcome', json_build_object(
            'coding', json_build_array(
                json_build_object(
                    'system', surgery_cc."code_system",
                    'code', surgery."outcome",
                    'display', surgery_cc."display"
                )
            )
        ),
        'code', json_build_object(
            'coding', json_build_array(
                json_build_object(
                    'system', 'http://terminology.hl7.org/CodeSystem/umls',
                    'code', 'C0543467',
                    'display', 'Operative Surgical Procedures'
                )
            )
        ),
        'category', json_build_object(
            'text', surgery."category"
        )

    ) AS "fhir"
FROM
    {{ ref('osiris_master_tab_Procedure_surgery') }} AS surgery
LEFT JOIN
    {{ ref('osiris_master_tab_Procedure_codeableConcept') }} AS surgery_cc
    ON surgery."outcome" = surgery_cc."code"
