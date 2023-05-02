SELECT
    "id_treatment" AS "id_careplan",
    "subject" AS "subject",
    "period_start" AS "period_start",
    "period_end" AS "period_end",
    "supportinginfo" AS "supportinginfo",
    "activity_detail_code" AS "activity_detail_code",
    "activity_detail_reasonreference" AS "activity_detail_reasonreference",
    "extension_treatment_line" AS "extension_treatment_line",
    "category_coding_code"
FROM
    {{ ref('osiris_clean_treatment_CarePlan') }}
