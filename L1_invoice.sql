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
  ,payed AS amunt_payed
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