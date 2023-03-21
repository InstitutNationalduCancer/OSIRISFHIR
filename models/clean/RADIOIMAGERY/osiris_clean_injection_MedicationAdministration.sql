WITH
radiopharmaceutical AS (
    SELECT
        "Instance_Id" AS id_medication_administration,
        "Series_Ref" AS series,
        "Patient_Id" AS subject,
        "Injection_Radiopharmaceutical" AS "medication",
        NULL AS "effectivePeriod_start",
        NULL AS "effectivePeriod_end",
        CASE
            WHEN "Injection_RadiopharmaceuticalStartTime" = 'UMLS:C0439673' THEN '1000-01-01'
            ELSE substring("Injection_RadiopharmaceuticalStartTime", 1, 2) || ':'
                || substring("Injection_RadiopharmaceuticalStartTime", 3, 2) || ':'
                || substring("Injection_RadiopharmaceuticalStartTime", 5, 2)
        END AS "effectiveDateTime",
        CASE
            WHEN
                "Injection_RadionuclideTotalDose" LIKE '%E%' THEN substring(
                    "Injection_RadionuclideTotalDose", 1, 9
                )::float * 100000000
            ELSE "Injection_RadionuclideTotalDose"::integer
        END AS "dosage_dose"
    FROM
        {{ ref('OSIRIS_pivot_Injection') }}
    WHERE
        "Injection_Radiopharmaceutical" != 'UMLS:C0439673'
),

constrast_agent AS (
    SELECT
        "Instance_Id" AS id_medication_administration,
        "Series_Ref" AS series,
        "Patient_Id" AS subject,
        "Injection_ContrastBolusAgent" AS "medication",
        CASE
            WHEN "Injection_ContrastBolusStartTime" = 'UMLS:C0439673' THEN '1000-01-01'
            ELSE substring("Injection_ContrastBolusStartTime", 1, 2) || ':'
                || substring("Injection_ContrastBolusStartTime", 3, 2) || ':'
                || substring("Injection_ContrastBolusStartTime", 5, 2)
        END AS "effectivePeriod_start",
        CASE
            WHEN "Injection_ContrastBolusStopTime" = 'UMLS:C0439673' THEN '1000-01-01'
            ELSE substring("Injection_ContrastBolusStopTime", 1, 2) || ':'
                || substring("Injection_ContrastBolusStopTime", 3, 2) || ':'
                || substring("Injection_ContrastBolusStopTime", 5, 2)
        END AS "effectivePeriod_end",
        NULL AS "effectiveDateTime",
        NULL::integer AS "dosage_dose"
    FROM
        {{ ref('OSIRIS_pivot_Injection') }}
    WHERE
        "Injection_ContrastBolusAgent" != 'UMLS:C0439673'
),

unknown AS (
    SELECT
        "Instance_Id" AS id_medication_administration,
        "Series_Ref" AS series,
        "Patient_Id" AS subject,
        'Unknown' AS "medication",
        NULL AS "effectivePeriod_start",
        NULL AS "effectivePeriod_end",
        '1000-01-01' AS "effectiveDateTime",
        NULL::integer AS "dosage_dose"
    FROM
        {{ ref('OSIRIS_pivot_Injection') }}
    WHERE
        "Injection_Radiopharmaceutical" = 'UMLS:C0439673'
        AND "Injection_ContrastBolusAgent" = 'UMLS:C0439673'
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
