USE memory.default;

--create expense table which includes employee ID, unit price and quantity with proper data types for each column
CREATE TABLE expense (employee_id TINYINT, unit_price DECIMAL(8, 2), quantity TINYINT);

--expense feeding with data from .txt files; there probably is a way to automate it so there will be no need to use the query for all file separately, but so far I did my best
INSERT INTO expense
( SELECT * FROM(
WITH txt AS (
    SELECT * FROM
storage.txt."https://raw.githubusercontent.com/aleksandrakusio/wasb_sql_test/refs/heads/main/finance/receipts_from_last_night/drinkies.txt"
), arrays AS (
SELECT
    array_agg(split_part(value, ': ', 2)) AS feed
FROM txt
), expense_names as (
SELECT 
    split_part(feed[1], ' ', 1) AS first_name, 
    split_part(feed[1], ' ', 2) AS last_name, 
    CAST(feed[3] AS DECIMAL(8,2)) AS unit_price, 
    CAST (feed[4] AS TINYINT) AS quantity
FROM arrays
)
SELECT
    a.employee_id,
    b.unit_price,
    b.quantity
FROM expense_names b
JOIN employee a ON (a.first_name=b.first_name AND a.last_name=b.last_name)
));

INSERT INTO expense
( SELECT * FROM(
WITH txt AS (
    SELECT * FROM
storage.txt."https://raw.githubusercontent.com/aleksandrakusio/wasb_sql_test/refs/heads/main/finance/receipts_from_last_night/drinks.txt"
), arrays AS (
SELECT
    array_agg(split_part(value, ': ', 2)) AS feed
FROM txt
), expense_names as (
SELECT 
    split_part(feed[1], ' ', 1) AS first_name, 
    split_part(feed[1], ' ', 2) AS last_name, 
    CAST(feed[3] AS DECIMAL(8,2)) AS unit_price, 
    CAST (feed[4] AS TINYINT) AS quantity
FROM arrays
)
SELECT
    a.employee_id,
    b.unit_price,
    b.quantity
FROM expense_names b
JOIN employee a ON (a.first_name=b.first_name AND a.last_name=b.last_name)
));

INSERT INTO expense
( SELECT * FROM(
WITH txt AS (
    SELECT * FROM
storage.txt."https://raw.githubusercontent.com/aleksandrakusio/wasb_sql_test/refs/heads/main/finance/receipts_from_last_night/drinkss.txt"
), arrays AS (
SELECT
    array_agg(split_part(value, ': ', 2)) AS feed
FROM txt
), expense_names as (
SELECT 
    split_part(feed[1], ' ', 1) AS first_name, 
    split_part(feed[1], ' ', 2) AS last_name, 
    CAST(feed[3] AS DECIMAL(8,2)) AS unit_price, 
    CAST (feed[4] AS TINYINT) AS quantity
FROM arrays
)
SELECT
    a.employee_id,
    b.unit_price,
    b.quantity
FROM expense_names b
JOIN employee a ON (a.first_name=b.first_name AND a.last_name=b.last_name)
));

INSERT INTO expense
( SELECT * FROM(
WITH txt AS (
    SELECT * FROM
storage.txt."https://raw.githubusercontent.com/aleksandrakusio/wasb_sql_test/refs/heads/main/finance/receipts_from_last_night/duh_i_think_i_got_too_many.txt"
), arrays AS (
SELECT
    array_agg(split_part(value, ': ', 2)) AS feed
FROM txt
), expense_names as (
SELECT 
    split_part(feed[1], ' ', 1) AS first_name, 
    split_part(feed[1], ' ', 2) AS last_name, 
    CAST(feed[3] AS DECIMAL(8,2)) AS unit_price, 
    CAST (feed[4] AS TINYINT) AS quantity
FROM arrays
)
SELECT
    a.employee_id,
    b.unit_price,
    b.quantity
FROM expense_names b
JOIN employee a ON (a.first_name=b.first_name AND a.last_name=b.last_name)
));

INSERT INTO expense
( SELECT * FROM(
WITH txt AS (
    SELECT * FROM
storage.txt."https://raw.githubusercontent.com/aleksandrakusio/wasb_sql_test/refs/heads/main/finance/receipts_from_last_night/i_got_lost_on_the_way_home_and_now_im_in_mexico.txt"
), arrays AS (
SELECT
    array_agg(split_part(value, ': ', 2)) AS feed
FROM txt
), expense_names as (
SELECT 
    split_part(feed[1], ' ', 1) AS first_name, 
    split_part(feed[1], ' ', 2) AS last_name, 
    CAST(feed[3] AS DECIMAL(8,2)) AS unit_price, 
    CAST (feed[4] AS TINYINT) AS quantity
FROM arrays
)
SELECT
    a.employee_id,
    b.unit_price,
    b.quantity
FROM expense_names b
JOIN employee a ON (a.first_name=b.first_name AND a.last_name=b.last_name)
));

INSERT INTO expense
( SELECT * FROM(
WITH txt AS (
    SELECT * FROM
storage.txt."https://raw.githubusercontent.com/aleksandrakusio/wasb_sql_test/refs/heads/main/finance/receipts_from_last_night/ubers.txt"
), arrays AS (
SELECT
    array_agg(split_part(value, ': ', 2)) AS feed
FROM txt
), expense_names as (
SELECT 
    split_part(feed[1], ' ', 1) AS first_name, 
    split_part(feed[1], ' ', 2) AS last_name, 
    CAST(feed[3] AS DECIMAL(8,2)) AS unit_price, 
    CAST (feed[4] AS TINYINT) AS quantity
FROM arrays
)
SELECT
    a.employee_id,
    b.unit_price,
    b.quantity
FROM expense_names b
JOIN employee a ON (a.first_name=b.first_name AND a.last_name=b.last_name)
));

INSERT INTO expense
( SELECT * FROM(
WITH txt AS (
    SELECT * FROM
storage.txt."https://raw.githubusercontent.com/aleksandrakusio/wasb_sql_test/refs/heads/main/finance/receipts_from_last_night/we_stopped_for_a_kebabs.txt"
), arrays AS (
SELECT
    array_agg(split_part(value, ': ', 2)) AS feed
FROM txt
), expense_names as (
SELECT 
    split_part(feed[1], ' ', 1) AS first_name, 
    split_part(feed[1], ' ', 2) AS last_name, 
    CAST(feed[3] AS DECIMAL(8,2)) AS unit_price, 
    CAST (feed[4] AS TINYINT) AS quantity
FROM arrays
)
SELECT
    a.employee_id,
    b.unit_price,
    b.quantity
FROM expense_names b
JOIN employee a ON (a.first_name=b.first_name AND a.last_name=b.last_name)
));