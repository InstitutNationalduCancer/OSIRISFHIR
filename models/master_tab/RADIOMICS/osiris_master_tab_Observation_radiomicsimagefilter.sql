SELECT
    radiomicsimagefilter."id_imagefilter",
    radiomicsimagefilter."subject",
    imagingstudy."id_imagingstudy",
    imagingstudy."series_uid" AS "note",
    radiomicsimagefilter."extension_softwareName_valueString",
    radiomicsimagefilter."extension_softwareVersion_valueString",
    radiomicsimagefilter."extension_filterMethod_valueString",
    radiomicsimagefilter."extension_filterType_valueString",
    radiomicsimagefilter."extension_filterInterpolation_valueString",
    radiomicsimagefilter."extension_intensityRounding_extension_valueString_valueString",
    '52' AS "extension_intensityRounding_extension_valueCode_code",
    radiomicsimagefilter."extension_boundaryCondition_valueString"
FROM
    {{ ref('osiris_clean_radiomicsimagefilter_Observation') }} AS radiomicsimagefilter
LEFT JOIN
    {{ ref('osiris_master_tab_ImagingStudy') }} AS imagingstudy
    ON
        radiomicsimagefilter."series" = imagingstudy."id_series"
