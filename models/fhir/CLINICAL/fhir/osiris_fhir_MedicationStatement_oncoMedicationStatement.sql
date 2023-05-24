SELECT
    medication."id_oncomedicalstatement" AS id,
    json_build_object(
        'resourceType', 'MedicationStatement',
        'id',
        fhir_id(
            '{{ ref("osiris_master_tab_MedicationStatement_oncoMedicationStatement") }}',
            medication."id_oncomedicalstatement"::TEXT
        ),
        'meta', json_build_object(
            'profile', json_build_array(
                'https://build.fhir.org/ig/arkhn/arkhn-ig-osiris/StructureDefinition/onco-medication-statement'
            )
        ),
        'subject', json_build_object(
            'reference', fhir_ref(
                'Patient',
                '{{ ref("osiris_master_tab_Patient") }}',
                medication."subject"::VARCHAR)
        ),
        'basedOn', json_build_array(
            json_build_object(
                'reference', fhir_ref(
                    'CarePlan',
                    '{{ ref("osiris_master_tab_CarePlan") }}',
                    medication."basedon"::VARCHAR)
            )
        ),
        'status', 'unknown',
        'medicationCodeableConcept', json_build_object(
            'coding', json_build_array(
                json_build_object(
                    'system', 'http://www.whocc.no/atc',
                    'code', medication."medicationCodeableConcept_coding_code",
                    'display', medication."medicationCodeableConcept_text"
                )
            )
        )
    ) AS fhir,
    false as is_deleted, 
    (now()::DATE - INTERVAL '1 day')::DATE as partition_date
FROM
    {{ ref('osiris_master_tab_MedicationStatement_oncoMedicationStatement') }} AS medication
