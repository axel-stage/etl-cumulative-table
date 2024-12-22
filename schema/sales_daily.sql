CREATE TABLE IF NOT EXISTS sales.daily
(
  product_id      INTEGER         NOT NULL,
  num_events      INTEGER,
  num_sell        INTEGER,
  num_reorder     INTEGER,
  num_return      INTEGER,
  snapshot_date   DATE
);