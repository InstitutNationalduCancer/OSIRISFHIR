with add_unknown as (select "name"
    from
        {{ ref("osiris_clean_study_Endpoint") }}
    union
    select 'Unknown' as "name"
)

select
    "name",
    'endpoint_identifier' || ROW_NUMBER() over () as id_endpoint
from
    add_unknown
