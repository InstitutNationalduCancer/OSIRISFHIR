SELECT
    "Patient_Id" || '-' || "Instance_Id" AS "id_coursert",
    "Patient_Id" AS "subject",
    "Patient_Id" || '-' || "Treatment_Ref" AS "basedon",
    "Course_Type" AS "category_coding_code",
    "Course_TreatmentIntent"::VARCHAR AS "extension_treatmentIntent",
    RIGHT(
        "Course_TerminationReason"::text, -POSITION(':' IN "Course_TerminationReason"::text)
    ) AS "extension_treatmentTerminationReason",
    "Course_NumberOfSessions" AS "extension_numberOfSessions",
    "Course_StartDate" AS "performedPeriod_start",
    "Course_EndDate" AS "performedPeriod_end"
FROM
    {{ ref('OSIRIS_pivot_CourseRT') }}
