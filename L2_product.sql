SELECT 
  product.product_id as product_id,
  product.product_name as product_name,
  product.product_category as product_category,
  product.product_type as product_type
FROM `airy-bit-456310-c2.L1.L1_product` product
WHERE product.product_category IN ('rent', 'product')