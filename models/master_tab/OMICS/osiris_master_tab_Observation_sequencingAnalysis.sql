WITH device AS (
    SELECT
        device.*,
        analysis."id_observation"
    FROM
        {{ ref('osiris_master_tab_Device_sequencingDevice') }} AS device
    FULL JOIN
        {{ ref('osiris_clean_analysis_Observation' ) }} AS analysis
        ON device."id_sequencingdevice" = analysis."id_observation"

)

SELECT
    seq_analysis."id_observation" AS "id_sequencinganalysis",
    seq_analysis."subject",
    seq_analysis."focus",
    seq_analysis."specimen",
    seq_analysis."category_text",
    seq_analysis."code_coding_code",
    seq_analysis."effectiveDateTime",
    seq_analysis."method",
    device."id_sequencingdevice" AS "device",
    seq_analysis."component_date_of_experiment",
    seq_analysis."component_analytic_pipeline_code",
    seq_analysis."component_algorithmic_cellularity",
    seq_analysis."component_algorithmic_ploidy",
    seq_analysis."component_number_of_breakpoints"
FROM
    {{ ref('osiris_clean_analysis_Observation') }} AS seq_analysis
LEFT JOIN device
    ON seq_analysis."id_observation" = device."id_observation"
WHERE
    seq_analysis."code_coding_code" = 'C37-3' -- only for omics analysis #}
