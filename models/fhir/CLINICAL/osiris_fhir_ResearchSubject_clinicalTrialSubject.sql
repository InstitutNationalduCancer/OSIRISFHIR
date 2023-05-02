SELECT
    "id_researchsubject" AS "id",
    json_build_object(
        'resourceType', 'ResearchSubject',
        'id', fhir_id('{{ ref("osiris_master_tab_ResearchStudy") }}', "id_researchsubject"::TEXT),
        'meta', json_build_object(
            'profile', json_build_array(
                'https://build.fhir.org/ig/arkhn/arkhn-ig-osiris/StructureDefinition/clinical-trial-subject'
            )
        ),
        'individual', json_build_object(
            'reference', fhir_ref(
                'Patient',
                '{{ ref("osiris_master_tab_Patient") }}',
                "individual"::VARCHAR)
        ),
        'study', json_build_object(
            'reference', fhir_ref(
                'ResearchStudy',
                '{{ ref("osiris_master_tab_ResearchStudy") }}',
                "study"::VARCHAR)
        ),
        'status', 'on-study'
    ) AS "fhir"
FROM
    {{ ref('osiris_master_tab_ResearchSubject_clinicalTrialSubject') }}
