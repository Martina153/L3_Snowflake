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
--IF(flag_invoice_issued < 100, TRUE, FALSE) AS flag_prolongation,
flag_send_inv_email AS flag_send_email,
contract_status AS contract_status,
DATE(load_date) AS load_date
FROM `airy-bit-456310-c2.L0_crm.contract` 
WHERE date_contract_valid_to IS NOT NULL