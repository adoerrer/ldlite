DROP TABLE IF EXISTS folio_derived.agreements_subscription_agreement;

-- Creates a derived table on agreements_subscription_agreement 
-- custom_properties will be added soon

CREATE TABLE folio_derived.agreements_subscription_agreement AS
SELECT
	json_extract_path_text(sa.jsonb::json, 'id') AS sa_id,
	json_extract_path_text(sa.jsonb::json, 'renewalPriority', 'id') AS sa_renewal_priority,
    json_extract_path_text(sa.jsonb::json, 'renewalPriority', 'value') AS sa_renewal_priority_value,
    json_extract_path_text(sa.jsonb::json, 'renewalPriority', 'label') AS sa_renewal_priority_label,
    json_extract_path_text(sa.jsonb::json, 'isPerpetual', 'id') AS sa_is_perpetual,
    json_extract_path_text(sa.jsonb::json, 'isPerpetual', 'value') AS  sa_is_perpetual_value,
    json_extract_path_text(sa.jsonb::json, 'isPerpetual', 'label') AS sa_is_perpetual_label,
    json_extract_path_text(sa.jsonb::json, 'name') AS sa_name,
    json_extract_path_text(sa.jsonb::json, 'localReference') AS sa_local_reference, -- not found
    json_extract_path_text(sa.jsonb::json, 'agreementStatus', 'id') AS sa_agreement_status,
    json_extract_path_text(sa.jsonb::json, 'agreementStatus', 'value') AS sa_agreement_status_value,
    json_extract_path_text(sa.jsonb::json, 'agreementStatus', 'label') AS sa_agreement_status_label,
    json_extract_path_text(sa.jsonb::json, 'description') AS sa_description,
    json_extract_path_text(sa.jsonb::json, 'licenseNote') AS  sa_license_note,
    json_extract_path_text(sa.jsonb::json, 'reasonForClosure', 'id') AS sa_reason_for_closure,
    json_extract_path_text(sa.jsonb::json, 'reasonForClosure', 'value') AS sa_reason_for_closure_value,
    json_extract_path_text(sa.jsonb::json, 'reasonForClosure', 'label') AS sa_reason_for_closure_label,
    
	/*
    agreements_custom_property.note AS custom_property_note,
    agreements_custom_property.public_note AS custom_property_public_note,
    agreements_custom_property_definition.pd_id AS custom_property_definition_uuid,
    agreements_custom_property_definition.pd_name AS custom_property_definition_pd_name,
    agreements_custom_property_definition.pd_type AS custom_property_definition_pd_type,
    agreements_custom_property_definition.pd_description AS custom_property_definition_pd_description,
    agreements_custom_property_definition.pd_label AS custom_property_definition_pd_label,
    agreements_custom_property_integer.id AS custom_property_integer_id,
    agreements_custom_property_integer.value AS custom_property_integer_value,
    agreements_custom_property_text.id AS custom_property_text_id,
    agreements_custom_property_text.value AS custom_property_text_value,
    agreements_custom_property.id AS sa_custom_properties_id
    */
    'not_available' AS sa_custom_properties_id

FROM
    folio_agreements.subscription_agreement AS sa;

CREATE INDEX ON folio_derived.agreements_subscription_agreement (sa_id);

CREATE INDEX ON folio_derived.agreements_subscription_agreement (sa_renewal_priority);

CREATE INDEX ON folio_derived.agreements_subscription_agreement (sa_renewal_priority_value);

CREATE INDEX ON folio_derived.agreements_subscription_agreement (sa_renewal_priority_label);

CREATE INDEX ON folio_derived.agreements_subscription_agreement (sa_is_perpetual);

CREATE INDEX ON folio_derived.agreements_subscription_agreement (sa_is_perpetual_value);

CREATE INDEX ON folio_derived.agreements_subscription_agreement (sa_is_perpetual_label);

CREATE INDEX ON folio_derived.agreements_subscription_agreement (sa_name);

CREATE INDEX ON folio_derived.agreements_subscription_agreement (sa_local_reference);

CREATE INDEX ON folio_derived.agreements_subscription_agreement (sa_agreement_status);

CREATE INDEX ON folio_derived.agreements_subscription_agreement (sa_agreement_status_value);

CREATE INDEX ON folio_derived.agreements_subscription_agreement (sa_agreement_status_label);

CREATE INDEX ON folio_derived.agreements_subscription_agreement (sa_description);

CREATE INDEX ON folio_derived.agreements_subscription_agreement (sa_license_note);

CREATE INDEX ON folio_derived.agreements_subscription_agreement (sa_reason_for_closure);

CREATE INDEX ON folio_derived.agreements_subscription_agreement (sa_reason_for_closure_value);

CREATE INDEX ON folio_derived.agreements_subscription_agreement (sa_reason_for_closure_label);

CREATE INDEX ON folio_derived.agreements_subscription_agreement (sa_custom_properties_id);

