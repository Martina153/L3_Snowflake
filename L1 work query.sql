-- L1_status

CREATE OR REPLACE VIEW `airy-bit-456310-c2.L1.L1_status` AS 
SELECT 
  CAST(id_status AS INT) AS product_status_id --převádí datový typ nějaké hodnoty na jiný
  ,LOWER(status_name) AS  product_status_name
  ,DATE(TIMESTAMP(date_update), "Europe/Prague") AS product_status_update_date
FROM `airy-bit-456310-c2.L0_google_sheets.status`
WHERE id_status IS NOT NULL
 AND status_name IS NOT NULL
QUALIFY ROW_NUMBER() OVER(PARTITION BY product_status_id) = 1 --unique id
;

--ok

-- L1_invoice

CREATE OR REPLACE VIEW `airy-bit-456310-c2.L1.L1_invoice` AS 
SELECT 
  id_invoice AS invoice_id
  ,id_invoice_old AS invoice_previous_id
  ,invoice_id_contract AS contract_id --FK
  ,status AS invoice_status_id
  ,id_branch AS branch_id --FK
  --Invoice status <1000 have been issued >= not issued 
  ,IF (status < 100, TRUE, FALSE) AS flag_invoice_issued
  ,DATE(date, "Europe/Prague") AS date_issue
  ,DATE(scadent, "Europe/Prague") AS due_date
  ,DATE(date_paid, "Europe/Prague") AS paid_date
  ,DATE(start_date, "Europe/Prague") AS start_date
  ,DATE(end_date, "Europe/Prague") AS end_date
  ,DATE(date_insert, "Europe/Prague") AS insert_date
  ,DATE(date_update, "Europe/Prague") AS update_date
  ,value AS amount_w_vat
  ,payed AS amount_payed
  ,flag_paid_currier
  ,invoice_type AS invoice_type_id -- Invoice_type: 1 - invoice, 3 - credit note, 2 - return, 4 - other 
  ,CASE --will switch number to text 
    WHEN invoice_type = 1 THEN 'invoice'
    WHEN invoice_type = 2 THEN 'return' 
    WHEN invoice_type = 3 THEN 'credit_note'
    WHEN invoice_type = 4 THEN 'other'
  END AS invoice_type 
  ,number AS invoice_number
  ,value_storno AS return_w_vat
  FROM `airy-bit-456310-c2.L0_accounting_system.invoice`
  ;

--ok

-- L1_branch

CREATE OR REPLACE VIEW `airy-bit-456310-c2.L1.L1_branch` AS 
SELECT 
  CAST(id_branch AS INT) AS branch_id --převádí datový typ nějaké hodnoty na jiný
  ,LOWER(branch_name) AS  branch_name
  ,DATE(TIMESTAMP(PARSE_DATE('%m/%d/%Y', date_update)), "Europe/Prague") AS branch_update_date
FROM `airy-bit-456310-c2.L0_google_sheets.branch`
WHERE id_branch IS NOT NULL
AND id_branch != 'NULL'
--AND branch_name != 'unknown'
--QUALIFY ROW_NUMBER() OVER(PARTITION BY id_branch) = 1 --unique id
;

--ok
-- L1_contract

CREATE OR REPLACE VIEW `airy-bit-456310-c2.L1.L1_contract` AS 
SELECT 
  CAST(id_contract AS INT) AS contract_id
  ,CAST(id_branch AS INT) AS branch_id
  ,DATE(TIMESTAMP(date_contract_valid_from), "Europe/Prague") AS contract_valid_from
  ,DATE(TIMESTAMP(date_contract_valid_to), "Europe/Prague") AS contract_valid_to
  ,DATE(TIMESTAMP(date_registered), "Europe/Prague") AS date_registered
  ,DATE(TIMESTAMP(date_signed), "Europe/Prague") AS date_signed
  ,DATE(TIMESTAMP(activation_process_date), "Europe/Prague") AS activation_process_date
  ,DATE(TIMESTAMP(prolongation_date), "Europe/Prague") AS prolongation_date
  ,registration_end_reason,
flag_send_inv_email AS flag_send_email,
contract_status AS contract_status,
DATE(load_date) AS load_date
FROM `airy-bit-456310-c2.L0_crm.contract` 
WHERE date_contract_valid_to IS NOT NULL  --chcem kontrakty ktore maju hodnotu vo valid to aby sa dali urcit ktore su aktivne a ktore uz nie su aktivne 
;

-- L1_product

CREATE OR REPLACE VIEW `airy-bit-456310-c2.L1.L1_product` AS 
SELECT 
  CAST(id_product AS INT) AS product_id
  --lower zabezpeci konzistentnost udajov 
  ,TRIM(LOWER(name)) AS product_name
  ,TRIM(LOWER(type)) AS product_type
  ,TRIM(LOWER(category)) AS product_category
  ,is_vat_applicable
  ,DATE(TIMESTAMP(date_update), "Europe/Prague") AS product_update_date
FROM `airy-bit-456310-c2.L0_google_sheets.product`
WHERE id_product IS NOT NULL
AND name IS NOT NULL
QUALIFY ROW_NUMBER() OVER(PARTITION BY product_id) = 1 --unique id
;

--ok

-- L1_product_purchase

CREATE OR REPLACE VIEW `airy-bit-456310-c2.L1.L1_product_purchase` AS 
SELECT 
  packages.id_package as product_purchase_id,
  packages.id_contract as contract_id,
  packages.id_package_template as product_id,
  DATE(TIMESTAMP(packages.date_insert), "Europe/Prague") AS create_date,
  DATE(TIMESTAMP(packages.start_date), "Europe/Prague") AS product_valid_from,
  DATE(TIMESTAMP(packages.end_date), "Europe/Prague") AS product_valid_to,
  packages.fee as price_wo_vat,
  DATE(TIMESTAMP(packages.date_update), "Europe/Prague") AS date_update,
  CASE
    WHEN packages.measure_unit IN ('mesia','měsíce','mesiace','mesice','měsice') THEN 'month'
    WHEN packages.measure_unit = 'kus' THEN 'item'
    WHEN packages.measure_unit = 'den' THEN 'day'
    WHEN packages.measure_unit = '0' THEN NULL
    ELSE measure_unit
  END AS unit,
  packages.package_status as product_status_id,
  status.product_status_name as product_status,
  product.product_name,
  product.product_type,
  product.product_category,
FROM `airy-bit-456310-c2.L0_crm.product_purchase` packages
LEFT JOIN `airy-bit-456310-c2.L1.L1_status` status
  ON packages.package_status = status.product_status_id
LEFT JOIN `airy-bit-456310-c2.L1.L1_product` product
  ON packages.id_package_template = product.product_id;

--ok

-- L1_invoice_load
create or replace view `airy-bit-456310-c2.L1.L1_invoice_load` as
select
id_load as invoices_load_id,
id_contract as contract_id,
id_package as package_id,
id_invoice as invoice_id,
id_package_template as product_id,
notlei as price_wo_vat_usd,
tva as vat_rate,
value as price_w_vat_usd,
payed as paid_w_vat_usd,
case 
    when um IN ('mesia','m?síce','m?si?1ce','měsice','mesiace','měsíce','mesice') then  'month'
    when um = "kus" then "item"
    when um = "den" then 'day'
    when um = '0' then null 
    else um end AS unit
,quantity,
DATE(TIMESTAMP(start_date), "Europe/Prague") as start_date,
DATE(TIMESTAMP(end_date), "Europe/Prague") as end_date,
DATE(TIMESTAMP(date_insert), "Europe/Prague") as date_insert,
DATE(TIMESTAMP(date_update), "Europe/Prague") as date_update,
from `airy-bit-456310-c2.L0_accounting_system.invoice_load` ;

--ok











