SELECT
    "Patient_Id" || '-' || "Instance_Id" AS "id_series",
    "Patient_Id" AS "subject",
    "Patient_Id" || '-' || "Equipment_Ref" AS "series_performer_actor",
    "Patient_Id" || '-' || "Study_Ref" AS "imagingstudy",
    "Series_SeriesNumber" AS "series_number",
    "Series_SeriesInstanceUID" AS "series_uid",
    "Series_Modality" AS "series_modality_code",
    "Series_Description" AS "series_description",
    "Series_BodyPartExamined" AS "series_bodySite_code",
    CASE
        WHEN "Series_AcquisitionDate"::text = 'UMLS:C0439673' THEN '1000-01-01'
        WHEN LENGTH("Series_AcquisitionDate"::text) = 8 THEN
            SUBSTRING("Series_AcquisitionDate"::text, 1, 4) || '-'
            || SUBSTRING("Series_AcquisitionDate"::text, 5, 2) || '-'
            || SUBSTRING("Series_AcquisitionDate"::text, 7, 2)
        ELSE SUBSTRING("Series_AcquisitionDate"::text, 1, 4) || '-'
            || SUBSTRING("Series_AcquisitionDate"::text, 5, 2) || '-'
            || SUBSTRING("Series_AcquisitionDate"::text, 7, 2) || 'T'
            || SUBSTRING("Series_AcquisitionDate"::text, 10, 2) || ':'
            || SUBSTRING("Series_AcquisitionDate"::text, 12, 2) || ':'
            || SUBSTRING("Series_AcquisitionDate"::text, 14, 2) || 'Z'
    END AS "series_started",
    CASE
        WHEN "Series_NbSeriesRelatedInstances"::text = 'UMLS:C0439673' THEN 999999
        ELSE "Series_NbSeriesRelatedInstances"::integer
    END AS "series_numberOfInstances",
    CASE
        WHEN "Series_PatientWeight"::text = 'UMLS:C0439673' THEN null
        ELSE "Series_PatientWeight"::decimal
    END AS "series_extension_patient_weight",
    CASE
        WHEN "Series_PatientSize"::text = 'UMLS:C0439673' THEN null
        ELSE "Series_PatientSize"::decimal
    END AS "series_extension_patient_height"
FROM
    {{ ref('OSIRIS_pivot_Series') }}
