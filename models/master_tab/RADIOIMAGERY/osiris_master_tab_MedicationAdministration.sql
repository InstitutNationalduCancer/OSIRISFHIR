WITH medication AS (
    SELECT
        medication_administration."id_medication_administration",
        medication_administration."subject",
        medication."id_medication" AS "medication",
        CASE
            WHEN
                medication_administration."effectivePeriod_start" = 'UMLS:C0439673'
                THEN '01-01-1000'
            ELSE medication_administration."effectivePeriod_start"
        END AS "effectivePeriod_start",
        CASE
            WHEN
                medication_administration."effectivePeriod_end" = 'UMLS:C0439673'
                THEN '01-01-1000'
            ELSE medication_administration."effectivePeriod_end"
        END AS "effectivePeriod_end",
        CASE
            WHEN
                medication_administration."effectiveDateTime" = 'UMLS:C0439673'
                THEN '01-01-1000'
            ELSE medication_administration."effectiveDateTime"
        END AS "effectiveDateTime",
        medication_administration."dosage_dose"
    FROM
        {{ ref('osiris_clean_injection_MedicationAdministration') }} AS medication_administration
    LEFT JOIN
        {{ ref('osiris_clean_injection_Medication') }} AS medication
        ON
            medication_administration."medication" = medication."code_text"
)

SELECT *
FROM
    medication
