--L3 product 

CREATE OR REPLACE VIEW `airy-bit-456310-c2.L3_Snowflake.L3_product` AS 
SELECT 
  product.product_id, --not unique
  product.product_name,
  product.product_type,
  pp.product_valid_from,
  pp.product_valid_to,
  pp.product_purchase_id,
  pp.unit,
  pp.flag_unlimited_product,
FROM `airy-bit-456310-c2.L2.L2_product_purchase` pp --pp is the main table (unique IDs)
LEFT JOIN `airy-bit-456310-c2.L2.L2_product` product
  ON pp.product_id = product.product_id
WHERE pp.product_valid_from IS NOT NULL --chceme vsetky aktivne produkty ktore maju datum validity
  AND pp.product_valid_to IS NOT NULL;

--L3_branch

CREATE OR REPLACE VIEW `airy-bit-456310-c2.L3_Snowflake.L3_branch` AS 
SELECT 
branch.branch_id,
branch.branch_name 
FROM `airy-bit-456310-c2.L2.L2_branch` branch;

--L3_invoice
CREATE OR REPLACE VIEW `airy-bit-456310-c2.L3_Snowflake.L3_invoice` AS 
SELECT 
  invoice.invoice_id,
  invoice.contract_id,
  pp.product_purchase_id,
  invoice.amount_w_vat, 
  invoice.return_w_vat,
  -- total amount
  (invoice.amount_w_vat - invoice.return_w_vat) AS total_paid,
  invoice.paid_date
FROM `airy-bit-456310-c2.L2.L2_invoice` invoice
LEFT JOIN `airy-bit-456310-c2.L2.L2_product_purchase` pp 
  ON invoice.contract_id = pp.contract_id;


--L3_contract

CREATE OR REPLACE VIEW `airy-bit-456310-c2.L3_Snowflake.L3_contract` AS 
SELECT 
  contract.contract_id,
  contract.branch_id,
  contract.contract_valid_from,
  contract.contract_valid_to,
  contract.registration_end_reason,
  contract.contract_status,
  contract.flag_prolongation,
  EXTRACT(YEAR FROM contract.contract_valid_from) AS start_year_of_contract,
  CASE 
    WHEN DATE_DIFF(contract.contract_valid_to, contract.contract_valid_from, MONTH) < 6 THEN 'less than half year'
    WHEN DATE_DIFF(contract.contract_valid_to, contract.contract_valid_from, YEAR) = 1 THEN '1 year'
    WHEN DATE_DIFF(contract.contract_valid_to, contract.contract_valid_from, YEAR) = 2 THEN '2 years'
    WHEN DATE_DIFF(contract.contract_valid_to, contract.contract_valid_from, YEAR) > 2 THEN 'more than 2 years'
    ELSE 'unknown'
  END AS contract_duration_group

FROM `airy-bit-456310-c2.L2.L2_contract` contract
WHERE contract.contract_valid_from IS NOT NULL
  AND contract.contract_valid_to IS NOT NULL
  AND contract.contract_valid_to >= contract.contract_valid_from;






