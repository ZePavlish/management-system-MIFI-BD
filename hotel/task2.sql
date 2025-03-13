WITH customer_bookings AS (
    SELECT 
        c.ID_customer,
        c.name,
        COUNT(b.ID_booking) AS total_bookings,
        COUNT(DISTINCT r.ID_hotel) AS unique_hotels,
        SUM(r.price * (b.check_out_date - b.check_in_date)) AS total_spent
    FROM 
        Customer c
    JOIN 
        Booking b ON c.ID_customer = b.ID_customer
    JOIN 
        Room r ON b.ID_room = r.ID_room
    GROUP BY 
        c.ID_customer, c.name
    HAVING 
        COUNT(b.ID_booking) > 2  -- Сделали более двух бронирований
        AND COUNT(DISTINCT r.ID_hotel) > 1  -- Забронировали номера в более чем одном отеле
),
customer_spending AS (
    SELECT 
        c.ID_customer,
        c.name,
        SUM(r.price * (b.check_out_date - b.check_in_date)) AS total_spent,
        COUNT(b.ID_booking) AS total_bookings
    FROM 
        Customer c
    JOIN 
        Booking b ON c.ID_customer = b.ID_customer
    JOIN 
        Room r ON b.ID_room = r.ID_room
    GROUP BY 
        c.ID_customer, c.name
    HAVING 
        SUM(r.price * (b.check_out_date - b.check_in_date)) > 500  -- Потратили более 500 долларов
)
SELECT 
    cb.ID_customer,
    cb.name,
    cb.total_bookings,
    cb.total_spent,
    cb.unique_hotels
FROM 
    customer_bookings cb
JOIN 
    customer_spending cs ON cb.ID_customer = cs.ID_customer
ORDER BY 
    cb.total_spent ASC;  -- Сортировка по общей сумме в порядке возрастания
