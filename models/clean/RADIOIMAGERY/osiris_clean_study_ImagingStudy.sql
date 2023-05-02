SELECT
    "Patient_Id" || '-' || "Instance_Id" AS "id_imagingstudy",
    "Study_StudyInstanceUID" AS "identifier_value",
    "Study_ModalitiesInStudy" AS "modality",
    "Patient_Id" AS "subject",
    "Study_Location" AS "endpoint",
    "Patient_Id" || '-' || "Analysis_Ref" AS "reasonreference",
    CASE
        WHEN "Study_AcquisitionDate"::text = 'UMLS:C0439673' THEN '1000-01-01'
        WHEN LENGTH("Study_AcquisitionDate"::text) = 8 THEN
            SUBSTRING("Study_AcquisitionDate"::text, 1, 4) || '-'
            || SUBSTRING("Study_AcquisitionDate"::text, 5, 2) || '-'
            || SUBSTRING("Study_AcquisitionDate"::text, 7, 2)
        ELSE SUBSTRING("Study_AcquisitionDate"::text, 1, 4) || '-'
            || SUBSTRING("Study_AcquisitionDate"::text, 5, 2) || '-'
            || SUBSTRING("Study_AcquisitionDate"::text, 7, 2) || 'T'
            || SUBSTRING("Study_AcquisitionDate"::text, 10, 2) || ':'
            || SUBSTRING("Study_AcquisitionDate"::text, 12, 2) || ':'
            || SUBSTRING("Study_AcquisitionDate"::text, 14, 2) || 'Z'
    END AS "started",
    CASE
        WHEN "Study_NbStudyRelatedSeries"::text = 'UMLS:C0439673' THEN 999999
        ELSE "Study_NbStudyRelatedSeries"::int
    END AS "numberOfSeries",
    CASE
        WHEN "Study_InstitutionName"::text = 'UMLS:C0439673' THEN 'Unknown'
        ELSE "Study_InstitutionName"::text
    END AS "location",
    CASE
        WHEN "Study_StudyDescription"::text = 'UMLS:C0439673' THEN 'Unknown'
        ELSE "Study_StudyDescription"::text
    END AS "description"
FROM
    {{ ref('OSIRIS_pivot_Study') }}
