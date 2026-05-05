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
