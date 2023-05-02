SELECT
    roisegmentation.*,
    COALESCE(imagingstudy.id_imagingstudy, 'Unknown') AS id_imagingstudy,
    series.series_uid
FROM
    {{ ref('osiris_clean_roisegmentation_Observation') }} AS roisegmentation
LEFT JOIN
    {{ ref('osiris_master_tab_ImagingStudy') }} AS imagingstudy
    ON roisegmentation.series::VARCHAR = imagingstudy.id_series
LEFT JOIN
    {{ ref('osiris_clean_series_ImagingStudy') }} AS series
    ON roisegmentation.series = series.id_series
