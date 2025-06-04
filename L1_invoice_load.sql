select
id_load as invoices_load_id,
id_contract as contract_id,
id_package as package_id,
id_invoice as invoice_id,
id_package_template as product_id,
notlei as price_wo_vat_usd,
tva as vat_rate,
value as price_w_vat_usd,
payed as paid_w_vat_usd,
case 
    when um IN ('mesia','m?síce','m?si?1ce','měsice','mesiace','měsíce','mesice') then  'month'
    when um = "kus" then "item"
    when um = "den" then 'day'
    when um = '0' then null 
    else um end AS unit
,quantity,
DATE(TIMESTAMP(start_date), "Europe/Prague") as start_date,
DATE(TIMESTAMP(end_date), "Europe/Prague") as end_date,
DATE(TIMESTAMP(date_insert), "Europe/Prague") as date_insert,
DATE(TIMESTAMP(date_update), "Europe/Prague") as date_update,
from `airy-bit-456310-c2.L0_accounting_system.invoice_load`