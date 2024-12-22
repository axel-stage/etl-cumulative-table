CREATE TABLE IF NOT EXISTS sales.events
(
  event_id      INTEGER         NOT NULL,
  product_id    INTEGER         NOT NULL,
  event_type    VARCHAR(256),
  event_date    DATE
);