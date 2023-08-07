select
    id_organization,
    'http://finess.sante.gouv.fr' as "identifier_finess_system",
    "identifier_finess_value",
    "name" as "name"
from
    {{ ref('osiris_clean_organizations_Organization') }}
