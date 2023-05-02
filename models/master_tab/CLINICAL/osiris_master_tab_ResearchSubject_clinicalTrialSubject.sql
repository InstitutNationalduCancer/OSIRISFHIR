SELECT
    'researchsubject_identifier' || row_number() OVER () AS id_researchsubject,
    treatment."subject" AS "individual",
    researchstudy."identifier_value" AS "study"
FROM
    {{ ref('osiris_clean_treatment_CarePlan') }} AS treatment
LEFT JOIN
    {{ ref('osiris_master_tab_ResearchStudy') }} AS researchstudy
    ON treatment."supportinginfo" = researchstudy."identifier_value"
WHERE treatment."Treatment_ClinicalTrialContext" = 1
