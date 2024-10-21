USE memory.default;

--first step is to create table 'end_of_months' where I store last day for all months where payments will happen
WITH end_of_months AS (
    WITH RECURSIVE date_series(end_of_month) AS (
    SELECT 
        last_day_of_month(current_date) AS end_of_month
    UNION ALL
    SELECT 
        last_day_of_month(end_of_month+interval '1' month)
    FROM date_series
    WHERE end_of_month < (SELECT max(due_date) FROM invoice)
)
SELECT end_of_month AS end_of_months
FROM date_series
ORDER BY end_of_month
), --table 'payments_date' stores all payments dates for every supplier and every invoice
payments_date AS (
SELECT
    i.supplier_id,
    s.name,
    i.invoice_amount,
    i.due_date,
    last_day_of_month(current_date) AS first_payment,
    date_diff('month', current_date, i.due_date) AS months_till_payment,
    e.end_of_months AS payment_date
FROM invoice i
JOIN supplier s ON s.supplier_id=i.supplier_id
CROSS JOIN end_of_months e
WHERE e.end_of_months<i.due_date
ORDER BY i.supplier_id, e.end_of_months
), --table 'payments_rate' calculates monthly payments for every supplier and every invoice
payments_rate AS (
SELECT
    supplier_id,
    name,
    invoice_amount,
    (invoice_amount/months_till_payment) AS rate,
    first_payment,
    payment_date,
    due_date
FROM payments_date
ORDER BY supplier_id, payment_date
), --table 'monthly_payment_plan' aggregates all invoices for every supplier, column 'payments_date' depends on the payment_date and displays as text, I also put the 'rate_no' column to store number of payment for each supplier
monthly_payment_plan AS (
SELECT
    supplier_id,
    name,
    SUM(rate) AS payment_amount,
    SUM(invoice_amount) AS total,
    payment_date,
    CASE 
        WHEN payment_date=last_day_of_month(current_date) THEN 'End of this month'
        WHEN date_diff('month', current_date, payment_date)=1 THEN 'End of next month'
    ELSE 'End of the month after'
    END AS payments_date,
    rank() over (partition by supplier_id order by payment_date) AS rate_no
FROM payments_rate
GROUP BY supplier_id, name, payment_date
ORDER BY supplier_id, payment_date
) --in final table balance_outstanding is being calculated - although it is not perfect solution as it does not cover case when MOD(invoice_amount/monhts_till_payment) <> 0
SELECT
    supplier_id,
    name,
    payment_amount,
    (total-payment_amount*rate_no) AS balance_outstanding,
    payments_date
FROM monthly_payment_plan
ORDER BY supplier_id, payment_date;