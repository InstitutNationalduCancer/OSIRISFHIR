SELECT
    consent."id_consent" AS id,
    json_build_object(
        'resourceType',
        'Consent',
        'id', fhir_id(
            '{{ ref("osiris_master_tab_Consent_consent") }}', consent."id_consent"::TEXT
        ),
        'meta',
        json_build_object(
            'profile', json_build_array(
                'https://build.fhir.org/ig/arkhn/arkhn-ig-osiris/StructureDefinition/genetic-consent'
            )
        ),
        'status', 'active',
        'scope', json_build_object(
            'coding', json_build_array(
                json_build_object(
                    'system', 'http://terminology.hl7.org/CodeSystem/consentscope',
                    'code', 'patient-privacy'
                )
            )
        ),
        'category', json_build_array(
            json_build_object(
                'coding', json_build_array(
                    json_build_object(
                        'system', 'http://terminology.hl7.org/CodeSystem/v3-ActCode',
                        'code', 'RESEARCH'
                    )
                )
            )
        ),
        'patient', json_build_object(
            'reference', fhir_ref(
                'Patient',
                '{{ ref("osiris_master_tab_Patient") }}',
                consent."patient"::VARCHAR
            )
        ),
        'dateTime', consent."dateTime",
        'provision', json_build_object(
            'type', consent."provision_type",
            'class', json_build_array(
                json_build_object(
                    'system', 'http://hl7.org/fhir/resource-types',
                    'code', 'MolecularSequence'
                )
            ),
            'data', json_build_array(
                json_build_object(
                    'meaning', 'instance',
                    'reference', json_build_object(
                        'reference', fhir_ref(
                            'Specimen',
                            '{{ ref("osiris_master_tab_Specimen_specimen") }}',
                            consent."provision_data_reference"::VARCHAR
                        )
                    )
                )
            )
        ),
        'policy', json_build_array(
            json_build_object(
                'authority',
                'https://build.fhir.org/ig/arkhn/arkhn-ig-osiris/policy-authority'
            )
        )
    ) AS fhir
FROM
    {{ ref('osiris_master_tab_Consent_consent') }} AS consent
