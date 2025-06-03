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
WHERE pp.product_valid_from IS NOT NULL 
  AND pp.product_valid_to IS NOT NULL