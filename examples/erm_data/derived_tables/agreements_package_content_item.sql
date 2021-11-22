DROP TABLE IF EXISTS folio_derived.agreements_package_content_item;

-- Creates a derived table on all needed data of package_content_items that either
-- are linked directly to an entitlement or have an package linked that is linked to an entitlement
CREATE TABLE folio_derived.agreements_package_content_item AS
WITH identifiers AS (
    SELECT
        json_extract_path_text(pci.jsonb::json, 'id') AS pci_id,    
        'not_available' AS id_id,
        json_extract_path_text(ids.data, 'identifier', 'value') AS identifier_value,
        'not_available' AS identifier_namespace_id,
        json_extract_path_text(ids.data, 'identifier', 'ns', 'value') AS identifiernamespace_name
    FROM
        folio_agreements.package_content_item AS pci
        CROSS JOIN  json_array_elements(json_extract_path(pci.jsonb::json, 'pti', 'titleInstance', 'identifiers')) AS ids(data)
)
SELECT
    pci_list.pci_id,
    pci_list.pci_access_start,
    pci_list.pci_access_end,
    pci_list.pci_package_id,
    pci_list.pci_removed_ts,
    pci_list.package_source,
    pci_list.package_vendor_id,
    pci_list.org_vendor_name,
    pci_list.package_remote_kb_id,
    pci_list.remotekb_remote_kb_name,
    pci_list.package_reference,
    pci_list.pci_platform_title_instance_id,
    pci_list.pti_platform_id,
    pci_list.pt_platform_name,
    pci_list.pti_title_instance_id,
    pci_list.pti_url,
    pci_list.ti_id,
    pci_list.ti_work_id,
    pci_list.ti_date_monograph_published,
    pci_list.ti_first_author,
    pci_list.ti_monograph_edition,
    pci_list.ti_monograph_volume,
    pci_list.ti_first_editor,
    pci_list.identifier_id,
    pci_list.identifier_value,
    pci_list.identifier_namespace_id,
    pci_list.identifiernamespace_name,
    pci_list.entitlement_id,
    pci_list.res_name,
    pci_list.res_sub_type_fk,
    pci_list.res_sub_type_value,
    pci_list.res_sub_type_label,
    pci_list.res_sub_type_category,
    pci_list.res_type_fk,
    pci_list.res_type_value,
    pci_list.res_type_label,
    pci_list.res_type_category,
    pci_list.res_publication_type_fk,
    pci_list.res_publication_type_value,
    pci_list.res_publication_type_label,
    pci_list.res_publication_type_category
FROM (
	SELECT
        json_extract_path_text(ent.jsonb::json, 'id') AS entitlement_id,
        ids.id_id AS identifier_id,
        ids.identifier_value AS identifier_value,
        ids.identifier_namespace_id AS identifier_namespace_id,
        ids.identifiernamespace_name AS identifiernamespace_name,
        json_extract_path_text(pci.jsonb::json, 'pkg', 'vendor', 'name') AS org_vendor_name,
        json_extract_path_text(pci.jsonb::json, 'pkg', 'reference') AS package_reference,
        json_extract_path_text(pci.jsonb::json, 'pkg', 'remoteKb', 'id') AS package_remote_kb_id,
        json_extract_path_text(pci.jsonb::json, 'pkg', 'source') AS package_source,
        json_extract_path_text(pci.jsonb::json, 'pkg', 'vendor', 'id') AS package_vendor_id,
        json_extract_path_text(pci.jsonb::json, 'id') AS pci_id,
        json_extract_path_text(pci.jsonb::json, 'accessStart') AS pci_access_start,
        json_extract_path_text(pci.jsonb::json, 'accessEnd') AS pci_access_end, 
        json_extract_path_text(pci.jsonb::json, 'pkg', 'id') AS pci_package_id,
        NULL AS pci_removed_ts, -- not found
        json_extract_path_text(pci.jsonb::json, 'pti', 'id') AS pci_platform_title_instance_id,
        json_extract_path_text(pci.jsonb::json, 'pti', 'platform', 'name') AS pt_platform_name,
        json_extract_path_text(pci.jsonb::json, 'pti', 'platform', 'id') AS pti_platform_id,
        json_extract_path_text(pci.jsonb::json, 'pti', 'titleInstance', 'id') AS pti_title_instance_id,
        json_extract_path_text(pci.jsonb::json, 'pti', 'url') AS pti_url,
        json_extract_path_text(pci.jsonb::json, 'pkg', 'remoteKb', 'name') AS remotekb_remote_kb_name,
        json_extract_path_text(pci.jsonb::json, 'pti', 'titleInstance', 'name') AS res_name,
        json_extract_path_text(pci.jsonb::json, 'pti', 'titleInstance', 'publicationType', 'id') AS res_publication_type_fk,
        json_extract_path_text(pci.jsonb::json, 'pti', 'titleInstance', 'subType', 'id') AS res_sub_type_fk,
        json_extract_path_text(pci.jsonb::json, 'pti', 'titleInstance', 'type', 'id') AS res_type_fk,
        json_extract_path_text(pci.jsonb::json, 'pti', 'titleInstance', 'publicationType', 'value') AS res_publication_type_value,
        json_extract_path_text(pci.jsonb::json, 'pti', 'titleInstance', 'publicationType', 'label') AS res_publication_type_label,
        'not_available' AS res_publication_type_category, -- not exported in ref_data table
        json_extract_path_text(pci.jsonb::json, 'pti', 'titleInstance', 'subType', 'value') AS res_sub_type_value,
        json_extract_path_text(pci.jsonb::json, 'pti', 'titleInstance', 'subType', 'label') AS res_sub_type_label,
        'not_available' res_sub_type_category, -- not exported in ref_data table
        json_extract_path_text(pci.jsonb::json, 'pti', 'titleInstance', 'type', 'value') AS res_type_value,
        json_extract_path_text(pci.jsonb::json, 'pti', 'titleInstance', 'type', 'label') AS res_type_label,
        'not_available' AS res_type_category, -- not exported in ref_data table
        json_extract_path_text(pci.jsonb::json, 'pti', 'titleInstance', 'id') AS ti_id, 
        'not_available' AS ti_date_monograph_published, -- not found
        'not_available' AS ti_first_author, -- not found
        'not_available' AS ti_first_editor, -- not found
        'not_available' AS ti_monograph_edition, -- not found
        'not_available' AS ti_monograph_volume, -- not found
        json_extract_path_text(pci.jsonb::json, 'pti', 'titleInstance', 'work', 'id') AS ti_work_id
    FROM
        folio_agreements.package_content_item AS pci
        INNER JOIN folio_agreements.entitlement AS ent ON json_extract_path_text(pci.jsonb::json, 'id') = json_extract_path_text(ent.jsonb::json, 'resource', 'id')
		LEFT JOIN identifiers AS ids ON ids.pci_id = json_extract_path_text(pci.jsonb::json, 'id')
UNION
	SELECT
        json_extract_path_text(ent.jsonb::json, 'id') AS entitlement_id,
        ids.id_id AS identifier_id,
        ids.identifier_value AS identifier_value,
        ids.identifier_namespace_id AS identifier_namespace_id,
        ids.identifiernamespace_name AS identifiernamespace_name,
        json_extract_path_text(pci.jsonb::json, 'pkg', 'vendor', 'name') AS org_vendor_name,
        json_extract_path_text(pci.jsonb::json, 'pkg', 'reference') AS package_reference,
        json_extract_path_text(pci.jsonb::json, 'pkg', 'remoteKb', 'id') AS package_remote_kb_id,
        json_extract_path_text(pci.jsonb::json, 'pkg', 'source') AS package_source,
        json_extract_path_text(pci.jsonb::json, 'pkg', 'vendor', 'id') AS package_vendor_id,
        json_extract_path_text(pci.jsonb::json, 'id') AS pci_id,
        json_extract_path_text(pci.jsonb::json, 'accessStart') AS pci_access_start,
        json_extract_path_text(pci.jsonb::json, 'accessEnd') AS pci_access_end, 
        json_extract_path_text(pci.jsonb::json, 'pkg', 'id') AS pci_package_id,
        NULL AS pci_removed_ts, -- not found
        json_extract_path_text(pci.jsonb::json, 'pti', 'id') AS pci_platform_title_instance_id,
        json_extract_path_text(pci.jsonb::json, 'pti', 'platform', 'name') AS pt_platform_name,
        json_extract_path_text(pci.jsonb::json, 'pti', 'platform', 'id') AS pti_platform_id,
        json_extract_path_text(pci.jsonb::json, 'pti', 'titleInstance', 'id') AS pti_title_instance_id,
        json_extract_path_text(pci.jsonb::json, 'pti', 'url') AS pti_url,
        json_extract_path_text(pci.jsonb::json, 'pkg', 'remoteKb', 'name') AS remotekb_remote_kb_name,
        json_extract_path_text(pci.jsonb::json, 'pti', 'titleInstance', 'name') AS res_name,
        json_extract_path_text(pci.jsonb::json, 'pti', 'titleInstance', 'publicationType', 'id') AS res_publication_type_fk,
        json_extract_path_text(pci.jsonb::json, 'pti', 'titleInstance', 'subType', 'id') AS res_sub_type_fk,
        json_extract_path_text(pci.jsonb::json, 'pti', 'titleInstance', 'type', 'id') AS res_type_fk,
        json_extract_path_text(pci.jsonb::json, 'pti', 'titleInstance', 'publicationType', 'value') AS res_publication_type_value,
        json_extract_path_text(pci.jsonb::json, 'pti', 'titleInstance', 'publicationType', 'label') AS res_publication_type_label,
        'not_available' AS res_publication_type_category, -- not exported in ref_data table
        json_extract_path_text(pci.jsonb::json, 'pti', 'titleInstance', 'subType', 'value') AS res_sub_type_value,
        json_extract_path_text(pci.jsonb::json, 'pti', 'titleInstance', 'subType', 'label') AS res_sub_type_label,
        'not_available' res_sub_type_category, -- not exported in ref_data table
        json_extract_path_text(pci.jsonb::json, 'pti', 'titleInstance', 'type', 'value') AS res_type_value,
        json_extract_path_text(pci.jsonb::json, 'pti', 'titleInstance', 'type', 'label') AS res_type_label,
        'not_available' AS res_type_category, -- not exported in ref_data table
        json_extract_path_text(pci.jsonb::json, 'pti', 'titleInstance', 'id') AS ti_id, 
        'not_available' AS ti_date_monograph_published, -- not found
        'not_available' AS ti_first_author, -- not found
        'not_available' AS ti_first_editor, -- not found
        'not_available' AS ti_monograph_edition, -- not found
        'not_available' AS ti_monograph_volume, -- not found
        json_extract_path_text(pci.jsonb::json, 'pti', 'titleInstance', 'work', 'id') AS ti_work_id
    FROM
        folio_agreements.package_content_item AS pci
        INNER JOIN folio_agreements.entitlement AS ent ON json_extract_path_text(pci.jsonb::json, 'pkg', 'id') = json_extract_path_text(ent.jsonb::json, 'resource', 'id')
		LEFT JOIN identifiers AS ids ON ids.pci_id = json_extract_path_text(pci.jsonb::json, 'id')
	) AS pci_list;

CREATE INDEX ON folio_derived.agreements_package_content_item (pci_id);

CREATE INDEX ON folio_derived.agreements_package_content_item (pci_access_start);

CREATE INDEX ON folio_derived.agreements_package_content_item (pci_access_end);

CREATE INDEX ON folio_derived.agreements_package_content_item (pci_package_id);

CREATE INDEX ON folio_derived.agreements_package_content_item (pci_removed_ts);

CREATE INDEX ON folio_derived.agreements_package_content_item (package_source);

CREATE INDEX ON folio_derived.agreements_package_content_item (package_vendor_id);

CREATE INDEX ON folio_derived.agreements_package_content_item (org_vendor_name);

CREATE INDEX ON folio_derived.agreements_package_content_item (package_remote_kb_id);

CREATE INDEX ON folio_derived.agreements_package_content_item (remotekb_remote_kb_name);

CREATE INDEX ON folio_derived.agreements_package_content_item (package_reference);

CREATE INDEX ON folio_derived.agreements_package_content_item (pci_platform_title_instance_id);

CREATE INDEX ON folio_derived.agreements_package_content_item (pti_platform_id);

CREATE INDEX ON folio_derived.agreements_package_content_item (pt_platform_name);

CREATE INDEX ON folio_derived.agreements_package_content_item (pti_title_instance_id);

CREATE INDEX ON folio_derived.agreements_package_content_item (pti_url);

CREATE INDEX ON folio_derived.agreements_package_content_item (ti_id);

CREATE INDEX ON folio_derived.agreements_package_content_item (ti_work_id);

CREATE INDEX ON folio_derived.agreements_package_content_item (ti_date_monograph_published);

CREATE INDEX ON folio_derived.agreements_package_content_item (ti_first_author);

CREATE INDEX ON folio_derived.agreements_package_content_item (ti_monograph_edition);

CREATE INDEX ON folio_derived.agreements_package_content_item (ti_monograph_volume);

CREATE INDEX ON folio_derived.agreements_package_content_item (ti_first_editor);

CREATE INDEX ON folio_derived.agreements_package_content_item (identifier_id);

CREATE INDEX ON folio_derived.agreements_package_content_item (identifier_value);

CREATE INDEX ON folio_derived.agreements_package_content_item (identifier_namespace_id);

CREATE INDEX ON folio_derived.agreements_package_content_item (identifiernamespace_name);

CREATE INDEX ON folio_derived.agreements_package_content_item (entitlement_id);

CREATE INDEX ON folio_derived.agreements_package_content_item (res_name);

CREATE INDEX ON folio_derived.agreements_package_content_item (res_sub_type_fk);

CREATE INDEX ON folio_derived.agreements_package_content_item (res_sub_type_value);

CREATE INDEX ON folio_derived.agreements_package_content_item (res_sub_type_label);

CREATE INDEX ON folio_derived.agreements_package_content_item (res_sub_type_category);

CREATE INDEX ON folio_derived.agreements_package_content_item (res_type_fk);

CREATE INDEX ON folio_derived.agreements_package_content_item (res_type_value);

CREATE INDEX ON folio_derived.agreements_package_content_item (res_type_label);

CREATE INDEX ON folio_derived.agreements_package_content_item (res_type_category);

CREATE INDEX ON folio_derived.agreements_package_content_item (res_publication_type_fk);

CREATE INDEX ON folio_derived.agreements_package_content_item (res_publication_type_value);

CREATE INDEX ON folio_derived.agreements_package_content_item (res_publication_type_label);

CREATE INDEX ON folio_derived.agreements_package_content_item (res_publication_type_category);

