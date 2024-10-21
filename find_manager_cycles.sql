USE memory.default;

--loop to detect cycle where the person who approves other one's expenses is the same as the first employee
WITH RECURSIVE working(employee_id, last_visited, already_visited, cycle_detected) AS (
  SELECT 
    employee_id, 
    manager_id, 
    ARRAY[employee_id], 
    false 
  FROM employee AS e
  UNION ALL
  SELECT 
    e.employee_id, 
    e.manager_id, 
    already_visited || e.employee_id, 
    CASE 
        WHEN already_visited[1]=e.employee_id THEN true 
        ELSE false 
    END
  FROM employee AS e
  JOIN working AS w ON w.last_visited = e.employee_id
  WHERE NOT cycle_detected
)
SELECT 
    employee_id, 
    already_visited AS cycle 
FROM working 
WHERE cycle_detected;