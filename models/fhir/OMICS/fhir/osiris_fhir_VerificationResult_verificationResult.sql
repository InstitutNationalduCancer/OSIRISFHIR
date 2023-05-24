SELECT
    verification."id_verificationresult" AS "id",
    json_build_object(
        'resourceType', 'VerificationResult',
        'meta', json_build_object(
            'profile', json_build_array(
                'https://build.fhir.org/ig/arkhn/arkhn-ig-osiris/StructureDefinition/data-validation'
            )
        ),
        'id', fhir_id(
            '{{ ref("osiris_master_tab_VerificationResult_verificationResult") }}',
            verification."id_verificationresult"::TEXT
        ),
        'target', json_build_array(
            json_build_object(
                'reference', fhir_ref(
                    'Observation',
                    '{{ ref("osiris_master_tab_Variant_snp") }}',
                    verification."target"::VARCHAR)
            )
        ),
        'status', verification."status",
        'validationType', json_build_object(
            'coding', json_build_array(
                json_build_object(
                    'system', validationtype_cc."code_system",
                    'code', verification."validationType_coding",
                    'display', validationtype_cc."display"
                )
            )
        ),
        'validationProcess', json_build_array(
            json_build_object(
                'text', verification."validationProcess_text"
            )
        )
    ) AS fhir,
    false as is_deleted, 
    (now()::DATE - INTERVAL '1 day')::DATE as partition_date
FROM
    {{ ref('osiris_master_tab_VerificationResult_verificationResult') }} AS verification
LEFT JOIN
    {{ ref('osiris_master_tab_VerificationResult_codeableconcept') }} AS validationtype_cc
    ON verification."validationType_coding" = validationtype_cc."code"
