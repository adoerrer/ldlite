/** Documentation of ERM AGREEMENT COST QUERY

DERIVED TABLES
agreements_subscription_agreement_entitlement
agreements_erm_resource
finance_transaction_invoices

TABLES
folio_orders.po_line
folio_invoice.invoice_lines
folio_invoice.invoices 

FILTERS: FOR USERS TO SELECT
agreement_status, resource_type, resource_sub_type, resource_publication_type, po_line_order_format, invoice_line_status, payment_date

 */
WITH parameters AS (
    SELECT
		-- filters on agreement level
		''::VARCHAR AS agreement_status, -- Enter your subscription agreement status eg. 'Active', 'Closed' etc.
		-- filters on erm_resource level
		''::VARCHAR AS resource_type, -- Enter your erm resource type eg. 'monograph', 'serial' etc.
		''::VARCHAR AS resource_sub_type, -- Enter your erm resource type eg. 'electronic', 'print' etc.
		''::VARCHAR AS resource_publication_type, -- Enter your publication type eg. 'journal', 'book'  etc.
        -- filters on purchase order line level
        ''::VARCHAR AS po_line_order_format, -- Enter your po line format eg. 'Electronic Resource', 'Physical Resource', 'P/E Mix' etc.
        -- filters on invoice line level
        ''::VARCHAR AS invoice_line_status, -- Enter your invoice line status eg. 'Paid' or 'Approved'etc.
        -- filters on invoice level
        -- Please comment/uncomment one pair the these parameters if you want to define the date range of paid invoices
        NULL::DATE AS start_date,
        NULL::DATE AS end_date
        --'2021-01-01' :: DATE AS start_date, -- start date day is included in interval
        --'2022-01-01' :: DATE AS end_date, -- end date day is NOT included in interval -> enter next day
),
     invoice_detail AS (
         SELECT
             inv.id AS "invoice_id",
             json_extract_path_text(inv.data, 'paymentDate')::date AS "invoice_payment_date"
         FROM
             invoice_invoices AS inv
     )
SELECT
	sa_ent_dt.subscription_agreement_name,
	sa_ent_dt.subscription_agreement_status_label AS subscription_agreement_status,
	sa_ent_dt.entitlement_id,
	sa_ent_dt.entitlement_active_from,
	sa_ent_dt.entitlement_active_to,
	erm_resource.name AS erm_resource_name,
	erm_resource.type__label AS erm_resource_type,
	erm_resource.sub_type__label AS erm_resource_sub_type,
	erm_resource.publication_type__label AS erm_resource_publication_type,
    json_extract_path_text(pol.data, 'paymentStatus') AS "po_line_payment_status",
    json_extract_path_text(pol.data, 'isPackage') AS "po_line_is_package",	
    json_extract_path_text(pol.data, 'orderFormat') AS "po_line_order_format",   
    json_extract_path_text(invl.data, 'invoiceLineStatus') AS "invl_status",
    inv.invoice_payment_date AS "invoice_payment_date",
    json_extract_path_text(invl.data, 'subTotal') AS "invl_sub_total", -- this are costs by invoice_line in invoice currency
    json_extract_path_text(invl.data, 'total') AS "invl_total" -- this are costs by invoice_line in invoice currency
  --  cast(fintrainvl.transaction_amount AS money) AS "transactions_invl_total"  
FROM
	folio_derived.agreements_subscription_agreement_entitlement AS sa_ent_dt
		LEFT JOIN folio_agreements.erm_resource__t AS erm_resource ON erm_resource.id = sa_ent_dt.entitlement_resource_fk
		LEFT JOIN po_lines AS pol ON pol.id = sa_ent_dt.po_line_id
		LEFT JOIN invoice_lines AS invl ON json_extract_path_text(invl.data, 'poLineId') = pol.id
        LEFT JOIN invoice_detail AS inv ON json_extract_path_text(invl.data, 'invoiceId') = inv.invoice_id
     --   LEFT JOIN folio_derived.finance_transaction_invoices AS fintrainvl ON fintrainvl.invoice_line_id = invl.id
WHERE	
	((sa_ent_dt.subscription_agreement_status_label = (SELECT agreement_status FROM parameters)) OR 
		((SELECT agreement_status FROM parameters) = ''))
	AND 	
	((erm_resource.type__label = (SELECT resource_type FROM parameters)) OR 
		((SELECT resource_type FROM parameters) = ''))
	AND 	
	((erm_resource.sub_type__label = (SELECT resource_sub_type FROM parameters)) OR 
		((SELECT resource_sub_type FROM parameters) = ''))
	AND 	
	((erm_resource.publication_type__label = (SELECT resource_publication_type FROM parameters)) OR 
		((SELECT resource_publication_type FROM parameters) = ''))
	AND 	
	((json_extract_path_text(invl.data, 'invoiceLineStatus') = (SELECT invoice_line_status FROM parameters)) OR 
		((SELECT invoice_line_status FROM parameters) = ''))
	AND 	
	((json_extract_path_text(pol.data, 'orderFormat') = (SELECT po_line_order_format FROM parameters)) OR 
		((SELECT po_line_order_format FROM parameters) = ''))
	AND
    ((inv.invoice_payment_date >= (SELECT start_date FROM parameters) AND
		inv.invoice_payment_date < (SELECT end_date FROM parameters))
		OR 
		(((SELECT start_date FROM parameters) IS NULL) 
			OR ((SELECT end_date FROM parameters) IS NULL)))	
GROUP BY 
	sa_ent_dt.subscription_agreement_name,
	sa_ent_dt.subscription_agreement_status_label,
	sa_ent_dt.entitlement_id,
	sa_ent_dt.entitlement_active_from,
	sa_ent_dt.entitlement_active_to,
	erm_resource.name,
	erm_resource.type__label,
	erm_resource.sub_type__label,
	erm_resource.publication_type__label,
	json_extract_path_text(pol.data, 'paymentStatus'),
	json_extract_path_text(pol.data, 'orderFormat'),
	json_extract_path_text(invl.data, 'invoiceLineStatus'),
	json_extract_path_text(pol.data, 'isPackage'),
	inv.invoice_payment_date,
    json_extract_path_text(invl.data, 'subTotal'),
    json_extract_path_text(invl.data, 'total');
	--fintrainvl.transaction_amount;
