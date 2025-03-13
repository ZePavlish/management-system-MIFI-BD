WITH AveragePositions AS (
    SELECT 
        res.car AS car_name,          -- Название автомобиля
        c.class AS car_class,         -- Класс автомобиля
        AVG(res.position) AS average_position,  -- Средняя позиция
        COUNT(res.race) AS race_count -- Количество гонок
    FROM Results res
    JOIN Cars c ON res.car = c.name
    JOIN Races r ON res.race = r.name
    GROUP BY res.car, c.class
),
MinAveragePosition AS (
    SELECT 
        MIN(average_position) AS min_avg_position  -- Наименьшая средняя позиция
    FROM AveragePositions
)
SELECT 
    ap.car_name, 
    ap.car_class, 
    ap.average_position, 
    ap.race_count,
    cl.country AS car_country
FROM AveragePositions ap
JOIN MinAveragePosition map ON ap.average_position = map.min_avg_position
JOIN Classes cl ON ap.car_class = cl.class
ORDER BY ap.car_name
LIMIT 1;
