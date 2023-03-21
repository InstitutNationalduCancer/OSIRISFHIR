SELECT
    "OSIRIS_pivot_Analysis"."Instance_Id" AS "id_observation",
    "OSIRIS_pivot_Analysis"."Patient_Id" AS "subject",
    "OSIRIS_pivot_Analysis"."Technology_PlatformAccession" AS "identifier_value",
    "OSIRIS_pivot_Analysis"."Analysis_Type" AS "category_coding_code",
    "OSIRIS_pivot_Analysis"."Analysis_Code" AS "code_coding_code",
    "OSIRIS_pivot_Analysis"."TumorPathologyEvent_Ref" AS "focus",
    "OSIRIS_pivot_Analysis"."Analysis_Date" AS "effectiveDateTime",
    'final' AS "status"
FROM
    {{ ref('OSIRIS_pivot_Analysis') }}
