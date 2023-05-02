SELECT
    consent."id_consent" || '-' || specimen."id_specimen" AS "id_consent",
    consent."patient",
    consent."dateTime",
    consent."provision_type",
    specimen."id_specimen" AS "provision_data_reference"
FROM
    {{ ref('osiris_clean_consent_Consent') }} AS consent
LEFT JOIN
    {{ ref('osiris_clean_biologicalsample_Specimen') }} AS specimen
    ON consent."id_consent" = specimen."specimen_provision_data_reference"
