SELECT
    "Patient_Id" || '-' || "Instance_Id" AS "id_oncomedicalstatement",
    "Patient_Id" AS "subject",
    "Patient_Id" || '-' || "Treatment_Ref" AS "basedon",
    "Drug_Code" AS "medicationCodeableConcept_coding_code",
    "Drug_Name" AS "medicationCodeableConcept_text"
FROM
    {{ ref('OSIRIS_pivot_Drug') }}
