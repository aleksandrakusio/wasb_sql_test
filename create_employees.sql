USE memory.default;
--create employee table with proper data types for each column
CREATE TABLE employee (employee_id TINYINT, first_name VARCHAR, last_name VARCHAR, job_title VARCHAR, manager_id TINYINT);

--insert data from csv file in repo; I used trino-storage plug-in which I installed in my docker container (took it from: https://github.com/snowlift/trino-storage)
INSERT INTO employee
SELECT 
    CAST(employee_id AS TINYINT) AS employee_id, 
    first_name, 
    last_name, 
    job_title, 
    CAST(manager_id AS TINYINT) AS manager_id
FROM storage.csv."https://raw.githubusercontent.com/aleksandrakusio/wasb_sql_test/refs/heads/main/hr/employee_index.csv";