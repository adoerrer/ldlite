DROP TABLE IF EXISTS folio_derived.agreements_subscription_agreement_entitlement;

-- Creates a derived table on subscription_agreement with entitlement and 
-- order_line to add po_line_id
CREATE TABLE folio_derived.agreements_subscription_agreement_entitlement AS
SELECT
	json_extract_path_text(sa.jsonb::json, 'id') AS subscription_agreement_id,
	json_extract_path_text(sa.jsonb::json, 'name') AS subscription_agreement_name,
	json_extract_path_text(sa.jsonb::json, 'localReference') AS subscription_agreement_local_reference,-- not found
    json_extract_path_text(sa.jsonb::json, 'agreementType', 'id') AS subscription_agreement_type,
    json_extract_path_text(sa.jsonb::json, 'agreementType', 'value') AS subscription_agreement_type_value,
    json_extract_path_text(sa.jsonb::json, 'agreementType', 'label') AS subscription_agreement_type_label,
	json_extract_path_text(sa.jsonb::json, 'agreementStatus', 'id') AS subscription_agreement_status,
    json_extract_path_text(sa.jsonb::json, 'agreementStatus', 'value') AS subscription_agreement_status_value,
    json_extract_path_text(sa.jsonb::json, 'agreementStatus', 'label') AS subscription_agreement_status_label,
    json_extract_path_text(ent.jsonb::json, 'id') AS entitlement_id,  
    json_extract_path_text(ent.jsonb::json, 'activeTo') AS entitlement_active_to,
    json_extract_path_text(ent.jsonb::json, 'activeFrom') AS entitlement_active_from, 
    json_extract_path_text(ent.jsonb::json, 'owner', 'id') AS entitlement_subscription_agreement_id,
    json_extract_path_text(ent.jsonb::json, 'resource', 'id') AS entitlement_resource_fk,
    json_extract_path_text(ent.jsonb::json, 'authority') AS entitlement_authority, -- not found
    json_extract_path_text(ent.jsonb::json, 'reference') AS entitlement_reference, -- not found  
    json_extract_path_text(pol.data, 'poLineId') AS po_line_id
FROM
    folio_agreements.subscription_agreement AS sa
    LEFT JOIN folio_agreements.entitlement AS ent ON json_extract_path_text(sa.jsonb::json, 'id') = json_extract_path_text(ent.jsonb::json, 'owner', 'id')
    CROSS JOIN  json_array_elements(json_extract_path(ent.jsonb::json, 'poLines')) AS pol(data);

CREATE INDEX ON folio_derived.agreements_subscription_agreement_entitlement (subscription_agreement_id);

CREATE INDEX ON folio_derived.agreements_subscription_agreement_entitlement (subscription_agreement_name);

CREATE INDEX ON folio_derived.agreements_subscription_agreement_entitlement (subscription_agreement_local_reference);

CREATE INDEX ON folio_derived.agreements_subscription_agreement_entitlement (subscription_agreement_type);

CREATE INDEX ON folio_derived.agreements_subscription_agreement_entitlement (subscription_agreement_type_value);

CREATE INDEX ON folio_derived.agreements_subscription_agreement_entitlement (subscription_agreement_type_label);

CREATE INDEX ON folio_derived.agreements_subscription_agreement_entitlement (subscription_agreement_status);

CREATE INDEX ON folio_derived.agreements_subscription_agreement_entitlement (subscription_agreement_status_value);

CREATE INDEX ON folio_derived.agreements_subscription_agreement_entitlement (subscription_agreement_status_label);

CREATE INDEX ON folio_derived.agreements_subscription_agreement_entitlement (entitlement_id);

CREATE INDEX ON folio_derived.agreements_subscription_agreement_entitlement (entitlement_active_to);

CREATE INDEX ON folio_derived.agreements_subscription_agreement_entitlement (entitlement_active_from);

CREATE INDEX ON folio_derived.agreements_subscription_agreement_entitlement (entitlement_subscription_agreement_id);

CREATE INDEX ON folio_derived.agreements_subscription_agreement_entitlement (entitlement_resource_fk);

CREATE INDEX ON folio_derived.agreements_subscription_agreement_entitlement (entitlement_authority);

CREATE INDEX ON folio_derived.agreements_subscription_agreement_entitlement (entitlement_reference);

CREATE INDEX ON folio_derived.agreements_subscription_agreement_entitlement (po_line_id);

