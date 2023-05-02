SELECT
    "Patient_Id" || '-' || "Instance_Id" AS "id_imagefilter",
    "Patient_Id" AS "subject",
    "Patient_Id" || '-' || "Series_Ref" AS "series",
    "RadiomicsImageFilter_SoftwareName" AS "extension_softwareName_valueString",
    "RadiomicsImageFilter_SoftwareVersion" AS "extension_softwareVersion_valueString",
    "RadiomicsImageFilter_FilterMethod" AS "extension_filterMethod_valueString",
    "RadiomicsImageFilter_FilterType" AS "extension_filterType_valueString",
    "RadiomicsImageFilter_FilterInterpolation" AS "extension_filterInterpolation_valueString",
    "RadiomicsImageFilter_IntensityRounding" AS
    "extension_intensityRounding_extension_valueString_valueString",
    "RadiomicsImageFilter_BoundaryCondition" AS "extension_boundaryCondition_valueString"
FROM
    {{ ref('OSIRIS_pivot_RadiomicsImageFilter') }}
