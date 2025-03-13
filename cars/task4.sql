WITH AveragePositions AS (
    SELECT 
        res.car AS car_name,           -- Название автомобиля
        c.class AS car_class,          -- Класс автомобиля
        AVG(res.position) AS average_position, -- Средняя позиция
        COUNT(res.race) AS race_count  -- Количество гонок
    FROM Results res
    JOIN Cars c ON res.car = c.name
    JOIN Races r ON res.race = r.name
    GROUP BY res.car, c.class
),
ClassAverage AS (
    SELECT 
        c.class AS car_class,            -- Класс автомобиля
        AVG(res.position) AS class_average_position -- Средняя позиция для класса
    FROM Results res
    JOIN Cars c ON res.car = c.name
    GROUP BY c.class
    HAVING COUNT(res.car) > 1  -- Классы, где более одного автомобиля
)
SELECT 
    ap.car_name, 
    ap.car_class, 
    ap.average_position, 
    ap.race_count,
    cl.country AS car_country
FROM AveragePositions ap
JOIN ClassAverage ca ON ap.car_class = ca.car_class
JOIN Classes cl ON ap.car_class = cl.class
WHERE ap.average_position < ca.class_average_position  -- Автомобили с лучшей позицией в своем классе
ORDER BY ap.car_class, ap.average_position;
