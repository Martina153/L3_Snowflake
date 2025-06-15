--L2_contract 

CREATE OR REPLACE VIEW `airy-bit-456310-c2.L2.L2_contract` AS 
SELECT 
  contract.contract_id,
  contract.branch_id,
  contract.contract_valid_from,
  contract.contract_valid_to,
  contract.date_registered,
  contract.prolongation_date,
  contract.registration_end_reason,
  contract.contract_status,
  contract.activation_process_date,
  contract.date_signed,
  contract.flag_send_email,

  -- Pridanie flagu, či existuje prolongation_date pokial je klient si predlzil zmluvu
  CASE 
    WHEN contract.prolongation_date IS NOT NULL THEN TRUE
    ELSE FALSE
  END AS flag_prolongation

FROM `airy-bit-456310-c2.L1.L1_contract` contract;

--L2_branch

CREATE OR REPLACE VIEW `airy-bit-456310-c2.L2.L2_branch` AS 
SELECT 
  branch.branch_id,
  branch.branch_name
FROM `airy-bit-456310-c2.L1.L1_branch` branch
WHERE branch.branch_name != 'unknown';

--L2_product

CREATE OR REPLACE VIEW `airy-bit-456310-c2.L2.L2_product` AS 
SELECT 
  product.product_id as product_id,
  product.product_name as product_name,
  product.product_category as product_category,
  product.product_type as product_type
FROM `airy-bit-456310-c2.L1.L1_product` product
WHERE product.product_category IN ('rent', 'product');

--L2_invoice

CREATE OR REPLACE VIEW `airy-bit-456310-c2.L2.L2_invoice` AS 
SELECT 
  invoice.invoice_id,
  invoice.invoice_previous_id,
  invoice.contract_id,
  invoice.invoice_type,
  invoice.amount_w_vat,
  invoice.return_w_vat,
  invoice.invoice_status_id,

  --invoice.amount_wo_vat,
  CASE 
    WHEN invoice.amount_w_vat <= 0 THEN 0 
    ELSE ROUND(invoice.amount_w_vat / 1.2, 2)
  END AS amount_wo_vat,

  invoice.date_issue,
  invoice.due_date,
  invoice.paid_date,
  invoice.start_date,
  invoice.end_date,
  invoice.insert_date,
  invoice.update_date,

 -- Pořadí faktury v rámci kontraktu podle data vystavení
ROW_NUMBER() OVER (PARTITION BY invoice.contract_id ORDER BY invoice.date_issue) AS invoice_order
  
FROM `airy-bit-456310-c2.L1.L1_invoice` invoice

-- Filtrování jen vystavených faktur typu 'invoice'
WHERE invoice.invoice_type = 'invoice'
  AND invoice.flag_invoice_issued = TRUE;

--L2_product_purchase

CREATE OR REPLACE VIEW `airy-bit-456310-c2.L2.L2_product_purchase` AS 
SELECT
  purchase.product_purchase_id,
  purchase.product_id,
  purchase.contract_id,
  purchase.product_category,
  purchase.product_status,
  purchase.price_wo_vat,

--price_w_vat
  
  CASE 
    WHEN purchase.price_wo_vat <= 0 THEN 0 
    ELSE ROUND(purchase.price_wo_vat * 1.2, 2)
  END AS price_w_vat,

    -- Flag pro neomezený produkt
  CASE 
    WHEN purchase.product_valid_from = DATE('2035-12-31') THEN TRUE 
    ELSE FALSE 
  END AS flag_unlimited_product,

  purchase.product_valid_from,
  purchase.product_valid_to,
  purchase.unit,
  purchase.product_name,
  purchase.product_type,
  purchase.create_date,
  purchase.date_update,

FROM `airy-bit-456310-c2.L1.L1_product_purchase` purchase

WHERE 
  purchase.product_category IN ('rent', 'product')
  AND purchase.product_status IS NOT NULL
  AND LOWER(purchase.product_status) NOT IN ('canceled', 'disconnected');




