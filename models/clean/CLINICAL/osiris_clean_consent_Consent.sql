SELECT
    "Patient_Id" || '-' || "Instance_Id" AS "id_consent",
    "Patient_Id" AS "patient",
    "Consent_Date" AS "dateTime",
    CASE
        WHEN "Consent_GeneticAnalysisAuthorization" = 0 THEN 'deny'
        WHEN "Consent_GeneticAnalysisAuthorization" = 1 THEN 'permit'
    END AS "provision_type"
FROM
    {{ ref('OSIRIS_pivot_Consent') }}
