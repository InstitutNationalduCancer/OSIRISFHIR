SELECT
    "Patient_Id" || '-' || "Instance_Id" AS "id_observation",
    "Patient_Id" AS "subject",
    "Patient_Id" || '-' || "TumorPathologyEvent_Ref" AS "focus",
    "Patient_Id" || '-' || "BiologicalSample_Ref" AS "specimen",
    "Analysis_Code" AS "category_text",
    RIGHT("Analysis_Type", -POSITION(':' IN "Analysis_Type")) AS "code_coding_code",
    "Analysis_Date" AS "effectiveDateTime",
    RIGHT("Technology_TechnicalProtocol", -POSITION(':' IN "Technology_TechnicalProtocol")) AS "method",
    CASE 
        WHEN "Technology_PlatformName" = 'IDYLLA' THEN 'O7-OTH'
        WHEN "Technology_PlatformName" = 'COBAS' THEN 'O7-OTH'
        ELSE REPLACE(RIGHT("Technology_PlatformName", -POSITION(':' IN "Technology_PlatformName")),'_','-') 
    END AS "device",
    "Technology_PlatformAccession" AS "device_identifier",
    "Technology_DateOfExperiment" AS "component_date_of_experiment",
    CASE 
        WHEN "Panel_Name" = 'OSIRIS:O10-0' THEN '010-OTH'
        ELSE REPLACE(RIGHT("Panel_Name", -POSITION(':' IN "Panel_Name")), '.2', '') 
    END AS "device_version_type_coding",
    "AnalysisProcess_AnalyticPipelineCode" AS "component_analytic_pipeline_code",
    "OmicAnalysis_AlgorithmicCellularity" AS "component_algorithmic_cellularity",
    RIGHT("OmicAnalysis_AlgorithmicPloidy", -POSITION(':' IN "OmicAnalysis_AlgorithmicPloidy")) AS "component_algorithmic_ploidy",
    "OmicAnalysis_NumberOfBreakPoints" AS "component_number_of_breakpoints"
FROM
    {{ ref('OSIRIS_pivot_Analysis') }}
