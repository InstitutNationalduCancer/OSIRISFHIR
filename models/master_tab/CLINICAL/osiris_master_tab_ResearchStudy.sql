SELECT DISTINCT
    "clinical_trial_title" AS "title",
    "supportinginfo" AS "identifier_value"
FROM
    {{ ref('osiris_clean_treatment_CarePlan') }}
WHERE "Treatment_ClinicalTrialContext" = 1
