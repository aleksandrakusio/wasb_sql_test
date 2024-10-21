USE memory.default;

--create companies_invoices table which will help me with populating both supplier and invoice tables
CREATE TABLE companies_invoices (name VARCHAR, invoice_amount DECIMAL(8, 2), due_date VARCHAR);

--values substracted from .txt files from invoices_due folder
INSERT INTO companies_invoices
SELECT * FROM (
WITH txt AS (
    SELECT * FROM
storage.txt."https://raw.githubusercontent.com/aleksandrakusio/wasb_sql_test/refs/heads/main/finance/invoices_due/awesome_animals.txt"
), arrays AS (
SELECT
    filter(array_agg(split_part(value, ': ', 2)), x->x IS NOT NULL) AS feed
FROM txt
)
SELECT 
    feed[1] AS name, 
    CAST(element_at(feed, -2) AS DECIMAL(8,2)) AS invoice_amount, 
    element_at(feed, -1) AS due_date
FROM arrays
);

INSERT INTO companies_invoices
SELECT * FROM (
WITH txt AS (
    SELECT * FROM
storage.txt."https://raw.githubusercontent.com/aleksandrakusio/wasb_sql_test/refs/heads/main/finance/invoices_due/brilliant_bottles.txt"
), arrays AS (
SELECT
    filter(array_agg(split_part(value, ': ', 2)), x->x IS NOT NULL) AS feed
FROM txt
)
SELECT 
    feed[1] AS name, 
    CAST(element_at(feed, -2) AS DECIMAL(8,2)) AS invoice_amount, 
    element_at(feed, -1) AS due_date
FROM arrays
);

INSERT INTO companies_invoices
SELECT * FROM (
WITH txt AS (
    SELECT * FROM
storage.txt."https://raw.githubusercontent.com/aleksandrakusio/wasb_sql_test/refs/heads/main/finance/invoices_due/crazy_catering.txt"
), arrays AS (
SELECT
    filter(array_agg(split_part(value, ': ', 2)), x->x IS NOT NULL) AS feed
FROM txt
)
SELECT 
    feed[1] AS name, 
    CAST(element_at(feed, -2) AS DECIMAL(8,2)) AS invoice_amount, 
    element_at(feed, -1) AS due_date
FROM arrays
);

INSERT INTO companies_invoices
SELECT * FROM (
WITH txt AS (
    SELECT * FROM
storage.txt."https://raw.githubusercontent.com/aleksandrakusio/wasb_sql_test/refs/heads/main/finance/invoices_due/disco_dj.txt"
), arrays AS (
SELECT
    filter(array_agg(split_part(value, ': ', 2)), x->x IS NOT NULL) AS feed
FROM txt
)
SELECT 
    feed[1] AS name, 
    CAST(element_at(feed, -2) AS DECIMAL(8,2)) AS invoice_amount, 
    element_at(feed, -1) AS due_date
FROM arrays
);

INSERT INTO companies_invoices
SELECT * FROM (
WITH txt AS (
    SELECT * FROM
storage.txt."https://raw.githubusercontent.com/aleksandrakusio/wasb_sql_test/refs/heads/main/finance/invoices_due/excellent_entertainment.txt"
), arrays AS (
SELECT
    filter(array_agg(split_part(value, ': ', 2)), x->x IS NOT NULL) AS feed
FROM txt
)
SELECT 
    feed[1] AS name, 
    CAST(element_at(feed, -2) AS DECIMAL(8,2)) AS invoice_amount, 
    element_at(feed, -1) AS due_date
FROM arrays
);

INSERT INTO companies_invoices
SELECT * FROM (
WITH txt AS (
    SELECT * FROM
storage.txt."https://raw.githubusercontent.com/aleksandrakusio/wasb_sql_test/refs/heads/main/finance/invoices_due/fantastic_ice_sculptures.txt"
), arrays AS (
SELECT
    filter(array_agg(split_part(value, ': ', 2)), x->x IS NOT NULL) AS feed
FROM txt
)
SELECT 
    feed[1] AS name, 
    CAST(element_at(feed, -2) AS DECIMAL(8,2)) AS invoice_amount, 
    element_at(feed, -1) AS due_date
FROM arrays
);

--create table supplier_names to get distinct names from companies_invoices
CREATE TABLE supplier_names (name VARCHAR);

INSERT INTO supplier_names
SELECT 
    DISTINCT name 
FROM companies_invoices;

--create supplier table with proper data types for each column
CREATE TABLE supplier (supplier_id TINYINT, name VARCHAR);

--insert suppliers names and create supplier_id based on companies names sorted alphabetically
INSERT INTO supplier
SELECT 
    RANK() OVER (ORDER BY name) AS supplier_id,
    name
FROM supplier_names;

--drop table supplier_names as it is no longer needed
DROP TABLE supplier_names;

--create final invoice table with proper data types for each column
CREATE TABLE invoice (supplier_id TINYINT, invoice_amount DECIMAL(8, 2), due_date DATE);

--populate invoice table with data
INSERT INTO invoice
SELECT * FROM(
WITH months AS (
SELECT
    name,
    invoice_amount,
    due_date,
    CAST(split(due_date,' ')[1] AS TINYINT) AS months_no
FROM companies_invoices
)
SELECT
    s.supplier_id,
    c.invoice_amount,
    last_day_of_month(date_add('month', c.months_no, current_date)) AS due_date
FROM months AS c
JOIN supplier AS s ON s.name=c.name
WHERE c.months_no IS NOT NULL
);

--drop companies_names table as it is no longer needed
DROP TABLE companies_names;