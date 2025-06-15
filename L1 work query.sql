-- L1_status

CREATE OR REPLACE VIEW `airy-bit-456310-c2.L1.L1_status` AS 
SELECT 
  CAST(id_status AS INT) AS product_status_id
  ,LOWER(status_name) AS  product_status_name
  ,DATE( date_update, "Europe/Prague") AS product_status_update_date
FROM `airy-bit-456310-c2.L0_google_sheets.status`
WHERE id_status IS NOT NULL
AND status_name IS NOT NULL
QUALIFY ROW_NUMBER() OVER(PARTITION BY product_status_id) = 1

....--podminka
--unique id
;

-- L1_invoice

CREATE OR REPLACE VIEW `airy-bit-456310-c2.L1.L1_status` AS 
SELECT 
*


--DATE(date, "Europe/Prague") AS date_issue,

--invoice_type AS invoice_type_id, 
-- -- Invoice_type: 1 - invoice, 3 - credit note, 2 - return, 4 - other 

-- CASE
--     WHEN invoice_type = 1 THEN 'invoice'
--     WHEN invoice_type = 2 THEN 'return'
--     WHEN invoice_type = 3 THEN 'credit_note'
--     WHEN invoice_type = 4 THEN 'other'
--  END AS invoice_type, 

FROM FROM `airy-bit-456310-c2.L0_accounting_system.invoice`
;

-- DATE(TIMESTAMP(start_date) "Europe/Prague") as start_date,
