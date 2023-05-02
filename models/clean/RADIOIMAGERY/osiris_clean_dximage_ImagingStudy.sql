SELECT
    "Patient_Id" || '-' || "Instance_Id" AS "id_dximage",
    "Patient_Id" AS "subject",
    "Patient_Id" || '-' || "CommonImage_Ref" AS "commonimage",
    "DXImage_PatientOrientation" AS "series_extension_dximage_patient_orientation",
    "DXImage_KVP" AS "series_extension_dximage_kvp",
    "DXImage_Exposure" AS "series_extension_dximage_exposure",
    "DXImage_ExposureTime" AS "series_extension_dximage_exposure_time",
    CASE
        WHEN "DXImage_ImageLaterality"::text = 'UMLS:C0439673' THEN 'Unknown'
        ELSE "DXImage_ImageLaterality"::text
    END AS "series_extension_dximage_image_laterality"
FROM
    {{ ref ('OSIRIS_pivot_DXImage') }}
