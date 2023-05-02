SELECT
    "adverseevent"."id_adverseevent" AS id,
    json_build_object(
        'resourceType', 'AdverseEvent',
        'id', fhir_id('{{ ref("osiris_master_tab_AdverseEvent_oncoAdverseEvent") }}', "adverseevent"."id_adverseevent"::TEXT),
        'meta', json_build_object(
            'profile', json_build_array(
                'https://build.fhir.org/ig/arkhn/arkhn-ig-osiris/StructureDefinition/onco-adverse-event'
            )
        ),
        'subject', json_build_object(
            'reference', fhir_ref(
                'Patient',
                '{{ ref("osiris_master_tab_Patient") }}',
                adverseevent."subject"::VARCHAR
            )
        ),
        'actuality', 'actual',
        'event', json_build_object(
            'coding', json_build_array(
                json_build_object(
                    'system', event_cc."code_system",
                    'version', event_cc."version",
                    'code', adverseevent."event"::VARCHAR,
                    'display', event_cc."display"
                )
            )
        ),
        'date', adverseevent."date",
        'seriousness', json_build_object(
            'coding', json_build_array(
                json_build_object(
                    'system', seriousness_cc."code_system",
                    'version', seriousness_cc."version",
                    'code', adverseevent."seriousness_coding_code",
                    'display', seriousness_cc."display"
                )
            )
        ),
        'suspectEntity', json_build_array(
            json_build_object(
                'instance', json_build_object(
                    'reference', fhir_ref(
                        'MedicationStatement',
                        '{{ ref("osiris_master_tab_MedicationStatement_oncoMedicationStatement") }}',
                        adverseevent."suspectentity_instance"::VARCHAR
                    )
                )
            )
        ),
        'subjectMedicalHistory', json_build_array(
            json_build_object(
                'reference', fhir_ref(
                    'Condition',
                    '{{ ref("osiris_master_tab_Condition_tumorPathologyEvent") }}',
                    adverseevent."subjectmedicalhistory"::VARCHAR
                )
            )
        ),
        'extension', json_build_array(
            json_build_object(
                'url', 'https://build.fhir.org/ig/arkhn/arkhn-ig-osiris/StructureDefinition/adverse-event-end-date',
                'valueDateTime', adverseevent."extension_enddate"
            )
        )
    ) AS fhir
FROM
    {{ ref('osiris_master_tab_AdverseEvent_oncoAdverseEvent') }} AS adverseevent
LEFT JOIN
    {{ ref('osiris_master_tab_AdverseEvent_codeableConcept') }} AS seriousness_cc
    ON adverseevent."seriousness_coding_code"::VARCHAR = seriousness_cc."code"
LEFT JOIN
    {{ ref('osiris_master_tab_AdverseEvent_codeableConcept') }} AS event_cc
    ON adverseevent."event"::VARCHAR = event_cc."code"
