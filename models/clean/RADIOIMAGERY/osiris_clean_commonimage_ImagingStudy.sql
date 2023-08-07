SELECT
    "Instance_Id" AS id_commonimage,
    "Series_Ref" AS "series",
    "CommonImage_SOPInstanceUID" AS "series_instance_uid",
    "CommonImage_SliceThickness" AS "series_extension_slice_thickness",
    "CommonImage_PixelSpacing" AS "series_extension_pixel_spacing",
    "CommonImage_Rows" AS "series_extension_rows",
    "CommonImage_Columns" AS "series_extension_columns",
    CASE
        WHEN "CommonImage_FieldOfView" = 'UMLS:C0439673' THEN NULL
        ELSE "CommonImage_FieldOfView"
    END AS "series_extension_field_of_view"
FROM
    {{ ref('OSIRIS_pivot_CommonImage') }}
