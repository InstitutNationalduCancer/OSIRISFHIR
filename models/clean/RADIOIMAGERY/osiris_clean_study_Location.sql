with
"location" as (
    select distinct case
        when "Study_InstitutionName" = 'UMLS:C0439673'
            or "Study_InstitutionName" is null then 'Unknown'
        else "Study_InstitutionName"
        end as "name"
    from
        {{ ref('OSIRIS_pivot_Study') }}
)

select
    *,
    'location_identifier' || ROW_NUMBER() over () as id_location
from
    "location"
