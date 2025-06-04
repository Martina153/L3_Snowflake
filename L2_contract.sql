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

  -- Pridanie flagu, či existuje prolongation_date
  CASE 
    WHEN contract.prolongation_date IS NOT NULL THEN TRUE
    ELSE FALSE
  END AS flag_prolongation

FROM `airy-bit-456310-c2.L1.L1_contract` contract