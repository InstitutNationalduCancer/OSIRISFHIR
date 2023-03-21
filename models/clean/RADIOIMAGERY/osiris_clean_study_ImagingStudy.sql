SELECT
    "Instance_Id" AS "id_imagingstudy",
    "Study_StudyInstanceUID" AS "identifier_value",
    "Study_ModalitiesInStudy" AS "modality",
    "Patient_Id" AS "subject",
    "Study_Location" AS "endpoint",
    "Analysis_Ref" AS "reasonreference",
    CASE
        WHEN "Study_AcquisitionDate" = 'UMLS:C0439673' THEN '1000-01-01'
        WHEN LENGTH("Study_AcquisitionDate") = 8 THEN
            SUBSTRING("Study_AcquisitionDate", 1, 4) || '-'
            || SUBSTRING("Study_AcquisitionDate", 5, 2) || '-'
            || SUBSTRING("Study_AcquisitionDate", 7, 2)
        ELSE SUBSTRING("Study_AcquisitionDate", 1, 4) || '-'
            || SUBSTRING("Study_AcquisitionDate", 5, 2) || '-'
            || SUBSTRING("Study_AcquisitionDate", 7, 2) || 'T'
            || SUBSTRING("Study_AcquisitionDate", 10, 2) || ':'
            || SUBSTRING("Study_AcquisitionDate", 12, 2) || ':'
            || SUBSTRING("Study_AcquisitionDate", 14, 2) || 'Z'
    END AS "started",
    CASE
        WHEN "Study_NbStudyRelatedSeries" = 'UMLS:C0439673' THEN 999999
        ELSE "Study_NbStudyRelatedSeries"::int
    END AS "numberOfSeries",
    CASE
        WHEN "Study_InstitutionName" = 'UMLS:C0439673' THEN 'Unknown'
        ELSE "Study_InstitutionName"
    END AS "location",
    CASE
        WHEN "Study_StudyDescription" = 'UMLS:C0439673' THEN 'Unknown'
        ELSE "Study_StudyDescription"
    END AS "description"
FROM
    {{ ref('OSIRIS_pivot_Study') }}
