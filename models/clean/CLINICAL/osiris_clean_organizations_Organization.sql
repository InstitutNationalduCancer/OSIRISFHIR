SELECT
    organizations.finess::varchar AS "id_organization",
    organizations.org_name AS "name",
    organizations.finess::varchar AS "identifier_finess_value"
FROM
    {{ ref('organizations') }}
