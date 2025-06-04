SELECT
  purchase.product_purchase_id,
  purchase.product_id,
  purchase.contract_id,
  purchase.product_category,
  purchase.product_status,
  purchase.price_wo_vat,

--price_w_vat
  
  CASE 
    WHEN purchase.price_wo_vat <= 0 THEN 0 
    ELSE ROUND(purchase.price_wo_vat * 1.2, 2)
  END AS price_w_vat,

    -- Flag pro neomezený produkt
  CASE 
    WHEN purchase.product_valid_from = DATE('2035-12-31') THEN TRUE 
    ELSE FALSE 
  END AS flag_unlimited_product,

  purchase.product_valid_from,
  purchase.product_valid_to,
  purchase.unit,
  purchase.product_name,
  purchase.product_type,
  purchase.create_date,
  purchase.date_update,

FROM `airy-bit-456310-c2.L1.L1_product_purchase` purchase

WHERE 
  purchase.product_category IN ('rent', 'product')
  AND purchase.product_status IS NOT NULL
  AND LOWER(purchase.product_status) NOT IN ('canceled', 'disconnected')