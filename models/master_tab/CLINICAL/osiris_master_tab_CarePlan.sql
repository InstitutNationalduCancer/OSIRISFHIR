SELECT
    careplan."id_treatment" AS "id_careplan",
    careplan."subject" AS "subject",
    careplan."period_start" AS "period_start",
    careplan."period_end" AS "period_end",
    researchstudy."id_researchstudy" AS "supportinginfo",
    careplan."activity_activity_code" AS "activity_activity_code",
    careplan."activity_detail_reasonreference" AS "activity_detail_reasonreference",
    careplan."extension_treatment_line" AS "extension_treatment_line",
    RIGHT(
        careplan."category_coding_code", -POSITION(':' IN careplan."category_coding_code")
    ) AS "category_coding_code"
FROM
    {{ ref('osiris_clean_treatment_CarePlan') }} AS careplan
LEFT JOIN
    {{ ref('osiris_clean_treatment_ResearchStudy') }} AS researchstudy
    ON careplan."supportinginfo"::VARCHAR = researchstudy."identifier_value"
