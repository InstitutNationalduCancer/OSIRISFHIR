SELECT DISTINCT
    dosetovolume."subject",
    volume.*
FROM
    {{ ref('osiris_clean_volumert_BodyStructure') }} AS volume
LEFT JOIN
    {{ ref('osiris_clean_dosetovolumert_Procedure') }} AS dosetovolume
    ON volume."id_volume" = dosetovolume."volume"
