INSERT INTO sales.daily
SELECT
  product_id,
  COUNT(product_id) AS num_events,
  COUNT(CASE WHEN event_type = 'sell' THEN 1 END) AS num_sell,
  COUNT(CASE WHEN event_type = 'reorder' THEN 1 END) AS num_reorder,
  COUNT(CASE WHEN event_type = 'return' THEN 1 END) AS num_return,
  '2020-03-20'::DATE AS snapshot_date
FROM sales.events
WHERE event_date = '2020-03-20'
GROUP BY product_id;