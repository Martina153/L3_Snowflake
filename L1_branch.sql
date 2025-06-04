SELECT 
  CAST(id_branch AS INT) AS branch_id --převádí datový typ nějaké hodnoty na jiný
  ,LOWER(branch_name) AS  branch_name
  ,DATE(TIMESTAMP(PARSE_DATE('%m/%d/%Y', date_update)), "Europe/Prague") AS branch_update_date
FROM `airy-bit-456310-c2.L0_google_sheets.branch`
WHERE id_branch IS NOT NULL
AND id_branch != 'NULL'