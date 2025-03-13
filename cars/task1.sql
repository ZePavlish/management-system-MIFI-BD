WITH AveragePositions AS (
    SELECT 
        res.car AS car_name,          -- Исправлено: использован res.car вместо r.car
        c.class AS car_class,
        AVG(res.position) AS average_position,
        COUNT(res.race) AS race_count
    FROM Results res
    JOIN Cars c ON res.car = c.name
    JOIN Races r ON res.race = r.name
    GROUP BY res.car, c.class
),
MinAveragePositions AS (
    SELECT 
        car_class,
        MIN(average_position) AS min_avg_position
    FROM AveragePositions
    GROUP BY car_class
)
SELECT 
    ap.car_name,
    ap.car_class,
    ap.average_position,
    ap.race_count
FROM AveragePositions ap
JOIN MinAveragePositions map ON ap.car_class = map.car_class 
                             AND ap.average_position = map.min_avg_position
ORDER BY ap.average_position;
