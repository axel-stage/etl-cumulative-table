INSERT INTO sales.daily
SELECT
  product_id,
  COUNT(product_id) AS num_events,
  COUNT(CASE WHEN event_type = 'sell' THEN 1 END) AS num_sell,
  COUNT(CASE WHEN event_type = 'reorder' THEN 1 END) AS num_reorder,
  COUNT(CASE WHEN event_type = 'return' THEN 1 END) AS num_return,
  '{{ ds }}'::DATE AS snapshot_date
FROM sales.events
WHERE event_date = '{{ ds }}'
GROUP BY product_id;