-- Correlation between aquisition product & customer lifetime value (LTV)

WITH first_purchase AS (
  SELECT
    t.user_crm_id,
    ti.item_id,
    ROW_NUMBER() OVER(PARTITION BY t.user_crm_id ORDER BY t.date ASC) AS rank  -- Finding the first item purchased
  FROM `prism-insights.warehouse.transactionsanditems` ti
  JOIN `warehouse.transactions` t
    ON ti.transaction_id = t.transaction_id
),

total_user_spend AS (
  SELECT
    user_crm_id,
    SUM(transaction_total) AS lifetime_spend
  FROM `warehouse.transactions`
  GROUP BY user_crm_id
)

SELECT 
  pa.item_name AS acquisition_product,
  ROUND(AVG(tus.lifetime_spend), 2) AS avg_customer_ltv
FROM first_purchase fp
JOIN total_user_spend tus
  ON fp.user_crm_id = tus.user_crm_id
JOIN `warehouse.productattributes` pa  -- Joining pa table as it contains item names
  ON pa.item_id = fp.item_id
WHERE fp.rank = 1   -- Filtering by fp.rank from the fp CTE to get the first item purchased 
GROUP BY pa.item_name
ORDER BY avg_customer_ltv DESC;

-- --- --- OUTPUT --- --- ---
-- acquisition_product	 |   avg_customer_ltv
------------------------------------------
mixer 876.06
gentlemen only intense edt 100 ml men perfume	492.25
guilty love edition pour homme edt 90 ml perfume	446.0
l`homme intense edp 50 ml men perfume	440.94
Exceptions Smoky Fruity 80 ml Parfume	440.0
coffee machine	368.87
food processor	353.13
toaster	342.5
vacuum	342.42
l`homme sport edt 60 ml men perfume	280.0
espresso machine	279.02
cordless vacuum	254.56
pb soleil spring 16 perfume	250.5
tobacco vanilla edp 100 ml women perfume	230.0
lost cherry edp 100ml women perfume	230.0
steam generator iron	219.9
samsara eau de parfum 75 ml	216.5
fabulous edp 100 ml - unisex perfume	213.33
euphoria liquid gold edp 100 ml women perfume	181.79
