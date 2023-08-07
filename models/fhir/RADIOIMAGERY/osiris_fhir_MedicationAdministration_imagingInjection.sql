SELECT
    "id_medication_administration" AS id,
    json_build_object(
        'resourceType', 'MedicationAdministration',
        'id', fhir_id(
            '{{ ref("osiris_master_tab_MedicationAdministration") }}',
            "id_medication_administration"::TEXT
        ),
        'meta', json_build_object(
            'profile', json_build_array(
                'http://fhir.arkhn.com/osiris/StructureDefinition/onco-imagingstudy-injection'
            )
        ),

        'subject', json_build_object(
            'reference', fhir_ref(
                'Patient',
                '{{ ref("osiris_master_tab_Patient") }}',
                "subject"
            )
        ),
        'status', 'completed',
        'medicationReference', json_build_object(
            'reference', fhir_ref(
                'Medication',
                '{{ ref("osiris_master_tab_Medication") }}',
                "medication"
            )
        ),
        'effectivePeriod', json_build_object(
            'start', "effectivePeriod_start",
            'end', "effectivePeriod_end"
        ),
        'effectiveDateTime', "effectiveDateTime",
        'dosage', json_build_object(
            'dose', json_build_object(
                'value', "dosage_dose"
            )
        )
    ) AS fhir
FROM
    {{ ref('osiris_master_tab_MedicationAdministration') }}
