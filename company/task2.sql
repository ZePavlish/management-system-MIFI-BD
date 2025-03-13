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
    COALESCE(string_agg(t.TaskName, ', '), 'NULL') AS TaskNames,
    -- Общее количество задач для сотрудника
    COUNT(t.TaskID) AS TotalTasks,
    -- Общее количество подчиненных для сотрудника, исключая подчиненных их подчиненных
    COUNT(DISTINCT e2.EmployeeID) AS TotalSubordinates
FROM 
    EmployeeHierarchy eh
JOIN Departments d ON eh.DepartmentID = d.DepartmentID
JOIN Roles r ON eh.RoleID = r.RoleID
LEFT JOIN Tasks t ON t.AssignedTo = eh.EmployeeID
LEFT JOIN Projects p ON t.ProjectID = p.ProjectID
LEFT JOIN Employees e2 ON e2.ManagerID = eh.EmployeeID  -- Получаем подчиненных сотрудника
GROUP BY 
    eh.EmployeeID, eh.EmployeeName, eh.ManagerID, d.DepartmentName, r.RoleName
ORDER BY 
    eh.EmployeeName;
