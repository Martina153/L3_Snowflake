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
  AND invoice.flag_invoice_issued = TRUE