SELECT
    planrt."id_planrt",
    planrt."subject",
    planrt."partof",
    series."imagingstudy" AS "extension_basedon_imagingstudyref",
    planrt."category_coding_code",
    planrt."extension_numberOfFractions",
    planrt."performedPeriod_start",
    planrt."performedPeriod_end",
    planrt."extension_reasonReplanification",
    planrt."extension_AlgorithName",
    planrt."extension_basedon_seriesuid",
    planrt."extension_basedon_rtstructuid",
    planrt."extension_dosetovolume_rtdoseuid",
    planrt."identifier_value",
    modalityandtechnique."extension_modandtech_radiotherapyModality",
    modalityandtechnique."extension_modandtech_radiotherapyTechnique",
    modalityandtechnique."extension_modandtech_radiotherapyTreatmentMachinePlanned",
    energyorisotope."extension_energyisotope_quantityEnergyOrIsotope",
    energyorisotope."extension_energyisotope_nameEnergyOrIsotope",
    dosetovolume."volume",
    dosetovolume."extension_dosetovolume_fractionDose",
    dosetovolume."extension_dosetovolume_numberOfFractions",
    dosetovolume."extension_dosetovolume_totalDose",
    '1255724003' AS "code_coding_code"
FROM
    {{ ref('osiris_clean_planrt_Procedure') }} AS planrt
LEFT JOIN
    {{ ref('osiris_clean_energyorisotopert_Procedure') }} AS energyorisotope
    ON planrt."id_planrt" = energyorisotope."plan"
LEFT JOIN
    {{ ref('osiris_clean_dosetovolumert_Procedure') }} AS dosetovolume
    ON planrt."id_planrt" = dosetovolume."plan"
LEFT JOIN
    {{ ref('osiris_clean_modalityandtechniquert_Procedure') }} AS modalityandtechnique
    ON planrt."modalityandtechnique" = modalityandtechnique."id_modality_technique"
LEFT JOIN
    {{ ref('osiris_clean_series_ImagingStudy') }} AS series
    ON planrt."extension_basedon_seriesuid"::VARCHAR = series."id_series"::VARCHAR
