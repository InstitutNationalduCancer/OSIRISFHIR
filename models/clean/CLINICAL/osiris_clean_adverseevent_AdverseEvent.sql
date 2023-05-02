SELECT
    "Patient_Id" || '-' || "Instance_Id" AS "id_adverseevent",
    "Patient_Id" AS "subject",
    "Patient_Id" || '-' || "Treatment_Ref" AS "suspectentity_instance",
    "Patient_Id" || '-' || "TumorPathologyEvent_Ref" AS "subjectmedicalhistory",
    RIGHT("AdverseEvent_Code", -POSITION(':' IN "AdverseEvent_Code")) AS "event",
    "AdverseEvent_Date" AS "date",
    "AdverseEvent_EndDate" AS "extension_enddate",
    CASE 
        WHEN "AdverseEvent_Grade" IS NULL THEN 'C0439673'
        ELSE RIGHT("AdverseEvent_Grade", -POSITION(':' IN "AdverseEvent_Grade"))
    END AS "seriousness_coding_code"
FROM
    {{ ref('OSIRIS_pivot_AdverseEvent') }}
