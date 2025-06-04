SELECT 
  packages.id_package as product_purchase_id,
  packages.id_contract as contract_id,
  packages.id_package_template as product_id,
  DATE(TIMESTAMP(packages.date_insert), "Europe/Prague") AS create_date,
  DATE(TIMESTAMP(packages.start_date), "Europe/Prague") AS product_valid_from,
  DATE(TIMESTAMP(packages.end_date), "Europe/Prague") AS product_valid_to,
  packages.fee as price_wo_vat,
  DATE(TIMESTAMP(packages.date_update), "Europe/Prague") AS date_update,
  CASE
    WHEN packages.measure_unit IN ('mesia','měsíce','mesiace','mesice','měsice') THEN 'month'
    WHEN packages.measure_unit = 'kus' THEN 'item'
    WHEN packages.measure_unit = 'den' THEN 'day'
    WHEN packages.measure_unit = '0' THEN NULL
    ELSE measure_unit
  END AS unit,
  packages.package_status as product_status_id,
  status.product_status_name as product_status,
  product.product_name,
  product.product_type,
  product.product_category,
FROM `airy-bit-456310-c2.L0_crm.product_purchase` packages
LEFT JOIN `airy-bit-456310-c2.L1.L1_status` status
  ON packages.package_status = status.product_status_id
LEFT JOIN `airy-bit-456310-c2.L1.L1_product` product
  ON packages.id_package_template = product.product_id