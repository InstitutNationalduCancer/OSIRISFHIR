SELECT
    patient."id_patient" AS id,
    json_build_object(
        'resourceType', 'Patient',
        'id',
        fhir_id('{{ ref("osiris_master_tab_Patient") }}', patient."id_patient"::TEXT),
        'meta', json_build_object(
            'profile', json_build_array(
                'https://build.fhir.org/ig/arkhn/arkhn-ig-osiris/StructureDefinition/onco-patient'
            )
        ),
        'identifier', json_build_array(
            json_build_object(
                'value', patient."identifier_value")
        ),
        'birthDate', patient."birthdate",
        'deceasedDateTime', patient."deceaseddatetime",
        'managingOrganization', json_build_object(
            'reference', fhir_ref(
                'Organization',
                '{{ ref("osiris_master_tab_Organization") }}',
                patient."managingorganization_valuereference"
            )
        ),
        'gender', patient."gender",
        -- OSIRIS extension
        'extension',
        json_build_array(
            CASE
                WHEN patient."extension_origin_center_valuereference" IS NOT NULL
                    THEN json_build_object(
                        'url', 'https://build.fhir.org/ig/arkhn/arkhn-ig-osiris/StructureDefinition/origin-center',
                        'valueReference', json_build_object(
                            'reference', fhir_ref(
                                'Organization',
                                '{{ ref("osiris_master_tab_Organization") }}',
                                patient."extension_origin_center_valuereference")
                        )
                    ) END,
            CASE
                WHEN patient."extension_ethnicity_valueCodeableConcept_coding_code" IS NOT NULL
                    THEN json_build_object(
                        'url', 'https://build.fhir.org/ig/arkhn/arkhn-ig-osiris/StructureDefinition/ethnicity',
                        'valueCodeableConcept', json_build_object(
                            'coding', json_build_array(
                                json_build_object(
                                    'system', patient_codeableconcept."code_system",
                                    'code',
                                    patient."extension_ethnicity_valueCodeableConcept_coding_code",
                                    'display', patient_codeableconcept."display"
                                )
                            )
                        )
                    ) END
        )
    ) AS fhir,
    false as is_deleted, 
    (now()::DATE - INTERVAL '1 day')::DATE as partition_date
FROM
    {{ ref('osiris_master_tab_Patient') }} AS patient
LEFT JOIN
    {{ ref('osiris_master_tab_Patient_codeableConcept') }}
    AS patient_codeableconcept
    ON
        patient."extension_ethnicity_valueCodeableConcept_coding_code"
        = patient_codeableconcept."code"
