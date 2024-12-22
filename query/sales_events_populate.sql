WITH dates AS (
SELECT
generate_series(
  DATE '2020-01-01',
  DATE '2020-12-31',
  INTERVAL '1 days'
)::DATE as event_date
), date_pool AS (
SELECT
row_number () OVER (ORDER BY event_date) AS id,
event_date
FROM dates
), random_base AS (
SELECT
generate_series(1, 1000, 1) AS event_id,
trunc(random() * 10 + 1) AS product_id,
trunc(random() * 3 + 1) AS random_event,
trunc(random() * 366 + 1) AS random_date
)
INSERT INTO sales.events
SELECT
event_id,
product_id,
CASE
  WHEN random_event = 1 THEN 'sell'
  WHEN random_event = 2 THEN 'reorder'
  WHEN random_event = 3 THEN 'return'
END AS event_type,
(SELECT event_date FROM date_pool WHERE id = random_date) AS event_date
FROM random_base;