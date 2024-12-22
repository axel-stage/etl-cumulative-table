INSERT INTO sales.daily_cumulate
WITH yesterday AS (
  SELECT * FROM sales.daily_cumulate
  WHERE snapshot_date = '2020-03-22'
),
today AS (
  SELECT * FROM sales.daily
  WHERE snapshot_date = '2020-03-23'
),
create_array AS (
  SELECT
  COALESCE(y.product_id, t.product_id) AS product_id,
  COALESCE(
    CASE
    WHEN CARDINALITY(y.sell_array) < 7
    THEN ARRAY[COALESCE(t.num_sell, 0)] || y.sell_array
    ELSE ARRAY[COALESCE(t.num_sell, 0)] || trim_array(y.sell_array, 1)
    END,
    ARRAY[t.num_sell]
  ) as sell_array,
  COALESCE(
    CASE
    WHEN CARDINALITY(y.return_array) < 7
    THEN ARRAY[COALESCE(t.num_return, 0)] || y.return_array
    ELSE ARRAY[COALESCE(t.num_return, 0)] || trim_array(y.return_array, 1)
    END,
    ARRAY[t.num_return]
  ) as return_array,
  COALESCE(
    CASE
    WHEN CARDINALITY(y.reorder_array) < 7
    THEN ARRAY[COALESCE(t.num_reorder, 0)] || y.reorder_array
    ELSE ARRAY[COALESCE(t.num_reorder, 0)] || trim_array(y.reorder_array, 1)
    END,
    ARRAY[t.num_reorder]
  ) as reorder_array,
  COALESCE(t.snapshot_date, y.snapshot_date + 1) as snapshot_date
  FROM yesterday AS y
  FULL OUTER JOIN today AS t ON y.product_id = t.product_id
)
SELECT
product_id,
sell_array,
return_array,
reorder_array,
(SELECT sum(n) FROM unnest(sell_array[0:7]) AS n) as total_sell_7d,
(SELECT sum(n) FROM unnest(return_array[0:7]) AS n) as total_return_7d,
(SELECT sum(n) FROM unnest(reorder_array[0:7]) AS n) as total_reorder_7d,
snapshot_date
FROM create_array
ORDER BY product_id;