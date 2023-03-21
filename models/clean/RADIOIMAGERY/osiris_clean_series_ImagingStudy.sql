SELECT
    "Instance_Id" AS "id_series",
    "Equipment_Ref" AS "series_performer_actor",
    "Study_Ref" AS "imagingstudy",
    "Series_SeriesNumber" AS "series_number",
    "Series_SeriesInstanceUID" AS "series_uid",
    "Series_Modality" AS "series_modality_code",
    "Series_Description" AS "series_description",
    "Series_BodyPartExamined" AS "series_bodySite_code",
    CASE
        WHEN "Series_AcquisitionDate" = 'UMLS:C0439673' THEN '1000-01-01'
        WHEN LENGTH("Series_AcquisitionDate") = 8 THEN
            SUBSTRING("Series_AcquisitionDate", 1, 4) || '-'
            || SUBSTRING("Series_AcquisitionDate", 5, 2) || '-'
            || SUBSTRING("Series_AcquisitionDate", 7, 2)
        ELSE SUBSTRING("Series_AcquisitionDate", 1, 4) || '-'
            || SUBSTRING("Series_AcquisitionDate", 5, 2) || '-'
            || SUBSTRING("Series_AcquisitionDate", 7, 2) || 'T'
            || SUBSTRING("Series_AcquisitionDate", 10, 2) || ':'
            || SUBSTRING("Series_AcquisitionDate", 12, 2) || ':'
            || SUBSTRING("Series_AcquisitionDate", 14, 2) || 'Z'
    END AS "series_started",
    CASE
        WHEN "Series_NbSeriesRelatedInstances" = 'UMLS:C0439673' THEN 999999
        ELSE "Series_NbSeriesRelatedInstances"::integer
    END AS "series_numberOfInstances",
    CASE
        WHEN "Series_PatientWeight" = 'UMLS:C0439673' THEN null
        ELSE "Series_PatientWeight"::decimal
    END AS "series_extension_patient_weight",
    CASE
        WHEN "Series_PatientSize" = 'UMLS:C0439673' THEN null
        ELSE "Series_PatientSize"::decimal
    END AS "series_extension_patient_height"
FROM
    {{ ref('OSIRIS_pivot_Series') }}
WHERE
    "Study_Ref" IN (
        SELECT "Instance_Id"
        FROM
            {{ ref('OSIRIS_pivot_Study') }}
    )
