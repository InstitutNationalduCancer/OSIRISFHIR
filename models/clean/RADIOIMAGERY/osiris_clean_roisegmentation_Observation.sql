SELECT
    "Patient_Id" || '-' || "Instance_Id" AS "id_roisegmentation",
    "Patient_Id" || '-' || "Series_Ref" AS "series",
    "Patient_Id" AS "subject",
    "ROISegmentation_ROINumber" AS "identifier_roi_value",
    CASE
        WHEN "ROISegmentation_ReferencedSOPInstanceUID" IS NULL THEN 'Unknown'
        ELSE replace("ROISegmentation_ReferencedSOPInstanceUID"::text, ' ', ',')
    END AS "identifier_dicom_value",
    CASE
        WHEN "ROISegmentation_ROIName"::text = 'UMLS:C0439673' THEN '<div> Unknown </div>'
        ELSE '<div xmlns="http://www.w3.org/1999/xhtml">' || "ROISegmentation_ROIName" || '</div>'
    END AS "text",
    CASE
        WHEN "ROISegmentation_ROIDescription"::text = 'UMLS:C0439673' THEN 'Unknown'
        ELSE "ROISegmentation_ROIDescription"::text
    END AS "note",
    CASE
        WHEN "ROISegmentation_ROIType"::text = 'UMLS:C0439673' THEN 'C0439673'
        ELSE "ROISegmentation_ROIType"::text
    END AS "code",
    CASE
        WHEN "ROISegmentation_ROIFilename"::text = 'UMLS:C0439673' THEN 'Unknown'
        ELSE "ROISegmentation_ROIFilename"::text
    END AS "identifier_file_value"
FROM
    {{ ref ('OSIRIS_pivot_ROISegmentation') }}
