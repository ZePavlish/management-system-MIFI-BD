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
LowPositionCars AS (
    SELECT 
        ap.car_name,
        ap.car_class,
        ap.average_position,
        ap.race_count
    FROM AveragePositions ap
    WHERE ap.average_position > 3.0  -- Выбираем автомобили с низкой средней позицией
),
ClassLowPositionCount AS (
    SELECT 
        car_class,
        COUNT(*) AS low_position_count -- Количество автомобилей с низкой средней позицией
    FROM LowPositionCars
    GROUP BY car_class
),
ClassTotalRaces AS (
    SELECT 
        c.class AS car_class,
        COUNT(DISTINCT r.name) AS total_races -- Общее количество гонок для класса
    FROM Cars c
    JOIN Results res ON c.name = res.car
    JOIN Races r ON res.race = r.name
    GROUP BY c.class
)
SELECT 
    lpc.car_name, 
    lpc.car_class, 
    lpc.average_position, 
    lpc.race_count,
    cl.country AS car_country,
    ctr.total_races,
    clpc.low_position_count  -- Исправлено на clpc для правильной ссылки на столбец
FROM LowPositionCars lpc
JOIN ClassLowPositionCount clpc ON lpc.car_class = clpc.car_class
JOIN ClassTotalRaces ctr ON lpc.car_class = ctr.car_class
JOIN Classes cl ON lpc.car_class = cl.class
ORDER BY clpc.low_position_count DESC;  -- Сортировка по количеству автомобилей с низкой средней позицией
