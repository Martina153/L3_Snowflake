SELECT 
  CAST(id_product AS INT) AS product_id
  ,TRIM(LOWER(name)) AS product_name
  ,TRIM(LOWER(type)) AS product_type
  ,TRIM(LOWER(category)) AS product_category
  ,is_vat_applicable
  ,DATE(TIMESTAMP(date_update), "Europe/Prague") AS product_update_date
FROM `airy-bit-456310-c2.L0_google_sheets.product`
WHERE id_product IS NOT NULL
AND name IS NOT NULL
QUALIFY ROW_NUMBER() OVER(PARTITION BY product_id) = 1