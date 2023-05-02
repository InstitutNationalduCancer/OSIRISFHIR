WITH
radiopharmaceutical AS (
    SELECT
        "Patient_Id" || '-' || "Instance_Id" AS id_medication_administration,
        "Patient_Id" || '-' || "Series_Ref" AS series,
        "Patient_Id"::VARCHAR AS subject,
        "Injection_Radiopharmaceutical"::text AS "medication",
        NULL::text AS "effectivePeriod_start",
        NULL::text AS "effectivePeriod_end",
        CASE
            WHEN "Injection_RadiopharmaceuticalStartTime"::text = 'UMLS:C0439673' THEN '1000-01-01'
            ELSE substring("Injection_RadiopharmaceuticalStartTime"::text, 1, 2) || ':'
                || substring("Injection_RadiopharmaceuticalStartTime"::text, 3, 2) || ':'
                || substring("Injection_RadiopharmaceuticalStartTime"::text, 5, 2)
        END AS "effectiveDateTime",
        CASE
            WHEN
                "Injection_RadionuclideTotalDose"::text LIKE '%E%' THEN substring(
                    "Injection_RadionuclideTotalDose"::text, 1, 9
                )::FLOAT * 100000000
            ELSE "Injection_RadionuclideTotalDose"::INTEGER
        END AS "dosage_dose"
    FROM
        {{ ref('OSIRIS_pivot_Injection') }}
    WHERE
        "Injection_Radiopharmaceutical"::text != 'UMLS:C0439673'
),

constrast_agent AS (
    SELECT
        "Patient_Id" || '-' || "Instance_Id" AS id_medication_administration,
        "Patient_Id" || '-' || "Series_Ref" AS series,
        "Patient_Id"::VARCHAR AS subject,
        "Injection_ContrastBolusAgent"::text AS "medication",
        CASE
            WHEN "Injection_ContrastBolusStartTime"::text = 'UMLS:C0439673' THEN '1000-01-01'
            ELSE substring("Injection_ContrastBolusStartTime"::text, 1, 2) || ':'
                || substring("Injection_ContrastBolusStartTime"::text, 3, 2) || ':'
                || substring("Injection_ContrastBolusStartTime"::text, 5, 2)
        END AS "effectivePeriod_start",
        CASE
            WHEN "Injection_ContrastBolusStopTime"::text = 'UMLS:C0439673' THEN '1000-01-01'
            ELSE substring("Injection_ContrastBolusStopTime"::text, 1, 2) || ':'
                || substring("Injection_ContrastBolusStopTime"::text, 3, 2) || ':'
                || substring("Injection_ContrastBolusStopTime"::text, 5, 2)
        END AS "effectivePeriod_end",
        NULL::text AS "effectiveDateTime",
        NULL::INTEGER AS "dosage_dose"
    FROM
        {{ ref('OSIRIS_pivot_Injection') }}
    WHERE
        "Injection_ContrastBolusAgent"::text != 'UMLS:C0439673'
),

unknown AS (
    SELECT
        "Patient_Id" || '-' || "Instance_Id" AS id_medication_administration,
        "Patient_Id" || '-' || "Series_Ref" AS series,
        "Patient_Id"::VARCHAR AS subject,
        'Unknown' AS "medication",
        NULL::text AS "effectivePeriod_start",
        NULL::text AS "effectivePeriod_end",
        '1000-01-01' AS "effectiveDateTime",
        NULL::INTEGER AS "dosage_dose"
    FROM
        {{ ref('OSIRIS_pivot_Injection') }}
    WHERE
        "Injection_Radiopharmaceutical"::text = 'UMLS:C0439673'
        AND "Injection_ContrastBolusAgent"::text = 'UMLS:C0439673'
)

SELECT *
FROM
    radiopharmaceutical
WHERE
    "series" IN (
        SELECT id_series
        FROM
            {{ ref('osiris_clean_series_ImagingStudy') }}
    )
UNION
SELECT *
FROM
    constrast_agent
WHERE
    "series" IN (
        SELECT id_series
        FROM
            {{ ref('osiris_clean_series_ImagingStudy') }}
    )
UNION
SELECT *
FROM
    unknown
WHERE
    "series" IN (
        SELECT id_series
        FROM
            {{ ref('osiris_clean_series_ImagingStudy') }}
    )
