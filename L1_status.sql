SELECT 
  CAST(id_status AS INT) AS product_status_id --převádí datový typ nějaké hodnoty na jiný
  ,LOWER(status_name) AS  product_status_name
  ,DATE(TIMESTAMP(date_update), "Europe/Prague") AS product_status_update_date
FROM `airy-bit-456310-c2.L0_google_sheets.status`
WHERE id_status IS NOT NULL
 AND status_name IS NOT NULL
QUALIFY ROW_NUMBER() OVER(PARTITION BY product_status_id) = 1