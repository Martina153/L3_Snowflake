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
  AND contract.contract_valid_to >= contract.contract_valid_from