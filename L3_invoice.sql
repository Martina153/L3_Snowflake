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
  ON invoice.contract_id = pp.contract_ids