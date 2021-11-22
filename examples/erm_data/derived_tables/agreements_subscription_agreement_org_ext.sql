DROP TABLE IF EXISTS folio_derived.agreements_subscription_agreement_org_ext;

-- Creates a derived table on subscription_agreement_org joins related values from org and
-- resolves values and labels from erm_agreements_refdata_value for sao_role
CREATE TABLE folio_derived.agreements_subscription_agreement_org_ext AS
SELECT
    sao.orgs__id AS sao_id,
    sao.id AS subscription_agreement_id,
    sao.orgs__org__id AS sao_org_id,
    sao.orgs__org__name AS sao_org_name,
    sao.orgs__role__id AS sao_role_id,
    sao.orgs__role__value AS sao_role_value,
    sao.orgs__role__label AS sao_role_label,
    sao.license_note AS sao_note,
    sao.orgs__org__orgs_uuid AS org_orgs_uuid
FROM
    folio_agreements.subscription_agreement__t__orgs AS sao;

CREATE INDEX ON folio_derived.agreements_subscription_agreement_org_ext (sao_id);

CREATE INDEX ON folio_derived.agreements_subscription_agreement_org_ext (subscription_agreement_id);

CREATE INDEX ON folio_derived.agreements_subscription_agreement_org_ext (sao_org_id);

CREATE INDEX ON folio_derived.agreements_subscription_agreement_org_ext (sao_org_name);

CREATE INDEX ON folio_derived.agreements_subscription_agreement_org_ext (sao_role_id);

CREATE INDEX ON folio_derived.agreements_subscription_agreement_org_ext (sao_role_value);

CREATE INDEX ON folio_derived.agreements_subscription_agreement_org_ext (sao_role_label);

CREATE INDEX ON folio_derived.agreements_subscription_agreement_org_ext (sao_note);

CREATE INDEX ON folio_derived.agreements_subscription_agreement_org_ext (org_orgs_uuid);

