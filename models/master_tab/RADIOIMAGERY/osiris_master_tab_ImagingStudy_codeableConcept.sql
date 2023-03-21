SELECT
    "code" || '-' || "code_dicom" AS "id",
    *
FROM
    {{ ref("code_system_imagingstudy") }}
