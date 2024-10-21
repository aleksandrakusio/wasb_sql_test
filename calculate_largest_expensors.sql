USE memory.default;

--query to report expenses
WITH exp AS (
    SELECT 
        employee_id, 
        (unit_price*quantity) AS expensed_amount
    FROM expense
), exp_sum AS (
    SELECT 
        employee_id, 
        SUM(expensed_amount) AS total_expensed_amount
    FROM exp
    GROUP BY employee_id
), empl AS (
    SELECT 
        exp.employee_id, 
        employee.first_name, 
        employee.last_name, 
        CONCAT(employee.first_name, ' ', employee.last_name) AS employee_name, 
        employee.manager_id
    FROM exp
    JOIN employee ON exp.employee_id=employee.employee_id
), manago AS (
    SELECT 
        DISTINCT m.manager_id, 
        e.first_name, 
        e.last_name, 
        CONCAT(e.first_name, ' ', e.last_name) AS manager_name
    FROM employee m, employee e 
    WHERE e.employee_id=m.manager_id
)
SELECT DISTINCT
    exp_sum.employee_id, 
    empl.employee_name, 
    manago.manager_id, 
    manago.manager_name, 
    exp_sum.total_expensed_amount
FROM exp_sum
JOIN empl ON exp_sum.employee_id=empl.employee_id
JOIN manago ON empl.manager_id=manago.manager_id
WHERE exp_sum.total_expensed_amount>1000;