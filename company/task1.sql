WITH RECURSIVE EmployeeHierarchy AS (
    -- Базовый запрос: извлекаем всех сотрудников, подчиненных Ивану Иванову
    SELECT EmployeeID, Name AS EmployeeName, ManagerID, DepartmentID, RoleID
    FROM Employees
    WHERE ManagerID = 1  -- Иван Иванов имеет ManagerID = 1

    UNION ALL

    -- Рекурсивно извлекаем всех подчиненных сотрудников
    SELECT e.EmployeeID, e.Name AS EmployeeName, e.ManagerID, e.DepartmentID, e.RoleID
    FROM Employees e
    INNER JOIN EmployeeHierarchy eh ON e.ManagerID = eh.EmployeeID
)
-- Основной запрос для получения данных о сотрудниках, их проектах и задачах
SELECT 
    eh.EmployeeID,
    eh.EmployeeName,
    eh.ManagerID,
    d.DepartmentName,
    r.RoleName,
    -- Список проектов, к которым принадлежит сотрудник, через агрегирование
    COALESCE(string_agg(p.ProjectName, ', '), 'NULL') AS ProjectNames,
    -- Список задач, назначенных сотруднику
    COALESCE(string_agg(t.TaskName, ', '), 'NULL') AS TaskNames
FROM 
    EmployeeHierarchy eh
JOIN Departments d ON eh.DepartmentID = d.DepartmentID
JOIN Roles r ON eh.RoleID = r.RoleID
LEFT JOIN Tasks t ON t.AssignedTo = eh.EmployeeID
LEFT JOIN Projects p ON t.ProjectID = p.ProjectID
GROUP BY 
    eh.EmployeeID, eh.EmployeeName, eh.ManagerID, d.DepartmentName, r.RoleName
ORDER BY 
    eh.EmployeeName;
