SELECT
    "Instance_Id" AS "id_phasert",
    "Patient_Id" AS "subject",
    "CourseRT_Ref" AS "partof",
    "Phase_Type" AS "category_coding_code",
    "Phase_NumberOfFractions" AS "extension_numberOfFractions",
    "Phase_StartDate" AS "performedPeriod_start",
    "Phase_EndDate" AS "performedPeriod_end"
FROM
    {{ ref('OSIRIS_pivot_PhaseRT') }}
