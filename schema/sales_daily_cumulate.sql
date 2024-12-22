CREATE TABLE IF NOT EXISTS sales.daily_cumulate
(
  product_id      INTEGER         NOT NULL,
  sell_array      INTEGER ARRAY,
  return_array    INTEGER ARRAY,
  reorder_array   INTEGER ARRAY,
  total_sell_7d     INTEGER,
  total_return_7d   INTEGER,
  total_reorder_7d  INTEGER,
  snapshot_date   DATE
);