WITH RECURSIVE EmployeeHierarchy AS (
    -- Базовый запрос: извлекаем менеджеров (сотрудников с ролью "Менеджер")
    SELECT e.EmployeeID, e.Name AS EmployeeName, e.ManagerID, e.DepartmentID, e.RoleID
    FROM Employees e
    JOIN Roles r ON e.RoleID = r.RoleID
    WHERE r.RoleName = 'Менеджер'

    UNION ALL

    -- Рекурсивно извлекаем всех подчиненных сотрудников
    SELECT e.EmployeeID, e.Name AS EmployeeName, e.ManagerID, e.DepartmentID, e.RoleID
    FROM Employees e
    INNER JOIN EmployeeHierarchy eh ON e.ManagerID = eh.EmployeeID
)
-- Основной запрос для получения данных о менеджерах, их проектах, задачах и подчиненных
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
    -- Общее количество подчиненных для менеджера, включая их подчиненных
    COUNT(DISTINCT e2.EmployeeID) AS TotalSubordinates
FROM 
    EmployeeHierarchy eh
JOIN Departments d ON eh.DepartmentID = d.DepartmentID
JOIN Roles r ON eh.RoleID = r.RoleID
LEFT JOIN Tasks t ON t.AssignedTo = eh.EmployeeID
LEFT JOIN Projects p ON t.ProjectID = p.ProjectID
LEFT JOIN Employees e2 ON e2.ManagerID = eh.EmployeeID  -- Подсчитываем подчиненных для каждого менеджера
GROUP BY 
    eh.EmployeeID, eh.EmployeeName, eh.ManagerID, d.DepartmentName, r.RoleName
HAVING 
    COUNT(DISTINCT e2.EmployeeID) > 0  -- Оставляем только тех, у кого есть подчиненные
ORDER BY 
    eh.EmployeeName;
