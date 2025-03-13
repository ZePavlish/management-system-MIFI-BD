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
MinAveragePosition AS (
    SELECT 
        MIN(average_position) AS min_avg_position -- Наименьшая средняя позиция
    FROM AveragePositions
),
ClassRaces AS (
    SELECT 
        c.class AS car_class,            -- Класс автомобиля
        cl.country AS car_country,       -- Страна производства класса
        COUNT(DISTINCT res.race) AS total_races -- Общее количество гонок в этом классе
    FROM Results res
    JOIN Cars c ON res.car = c.name
    JOIN Classes cl ON c.class = cl.class
    GROUP BY c.class, cl.country
)
SELECT 
    ap.car_name, 
    ap.car_class, 
    ap.average_position, 
    ap.race_count,
    cr.car_country,
    cr.total_races
FROM AveragePositions ap
JOIN MinAveragePosition map ON ap.average_position = map.min_avg_position
JOIN ClassRaces cr ON ap.car_class = cr.car_class
ORDER BY ap.car_class, ap.car_name;
