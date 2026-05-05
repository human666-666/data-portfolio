SELECT
  SUM(google_cost) / SUM(google_clicks) AS google_cpc,
  SUM(google_clicks) / SUM(google_impressions) AS google_ctr,
  SUM(meta_cost) / SUM(meta_clicks) AS meta_cpc,
  SUM(meta_clicks) / SUM(meta_impressions) AS meta_ctr,
  SUM(criteo_cost) / SUM(criteo_clicks) AS criteo_cpc,
  SUM(criteo_clicks) / SUM(criteo_impressions) AS criteo_ctr,
  SUM(rtbhouse_cost) / SUM(rtbhouse_clicks) AS rtbhouse_cpc,
  SUM(rtbhouse_clicks) / SUM(rtbhouse_impressions) AS rtbhouse_ctr,
  SUM(tiktok_cost) / SUM(tiktok_clicks) AS tiktok_cpc,
  SUM(tiktok_clicks) / SUM(tiktok_impressions)
  
FROM `warehouse.adplatform_data`;
