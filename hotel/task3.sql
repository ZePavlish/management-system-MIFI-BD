WITH hotel_categories AS (
    SELECT 
        r.ID_hotel,
        CASE
            WHEN AVG(r.price) < 175 THEN 'Дешевый'
            WHEN AVG(r.price) BETWEEN 175 AND 300 THEN 'Средний'
            ELSE 'Дорогой'
        END AS hotel_category
    FROM 
        Room r
    GROUP BY 
        r.ID_hotel
),
client_preferences AS (
    SELECT 
        c.ID_customer,
        c.name,
        MAX(CASE 
                WHEN hc.hotel_category = 'Дорогой' THEN 'Дорогой'
                WHEN hc.hotel_category = 'Средний' THEN 'Средний'
                WHEN hc.hotel_category = 'Дешевый' THEN 'Дешевый'
            END) AS preferred_hotel_type,
        STRING_AGG(DISTINCT h.name, ', ') AS visited_hotels
    FROM 
        Customer c
    JOIN 
        Booking b ON c.ID_customer = b.ID_customer
    JOIN 
        Room r ON b.ID_room = r.ID_room
    JOIN 
        hotel_categories hc ON r.ID_hotel = hc.ID_hotel
    JOIN 
        Hotel h ON r.ID_hotel = h.ID_hotel
    GROUP BY 
        c.ID_customer, c.name
)
SELECT 
    cp.ID_customer,
    cp.name,
    cp.preferred_hotel_type,
    cp.visited_hotels
FROM 
    client_preferences cp
ORDER BY 
    CASE 
        WHEN cp.preferred_hotel_type = 'Дешевый' THEN 1
        WHEN cp.preferred_hotel_type = 'Средний' THEN 2
        WHEN cp.preferred_hotel_type = 'Дорогой' THEN 3
    END;
