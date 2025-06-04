SELECT 
  branch.branch_id,
  branch.branch_name
FROM `airy-bit-456310-c2.L1.L1_branch` branch
WHERE branch.branch_name != 'unknown'