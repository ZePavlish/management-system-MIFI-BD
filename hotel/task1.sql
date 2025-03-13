SELECT 
    c.name, 
    c.email, 
    c.phone, 
    COUNT(b.ID_booking) AS total_bookings,
    STRING_AGG(DISTINCT h.name, ', ') AS hotel_list,  -- Список отелей через запятую
    AVG(b.check_out_date - b.check_in_date) AS avg_stay_duration -- Средняя длительность пребывания
FROM 
    Customer c
JOIN 
    Booking b ON c.ID_customer = b.ID_customer
JOIN 
    Room r ON b.ID_room = r.ID_room
JOIN 
    Hotel h ON r.ID_hotel = h.ID_hotel
GROUP BY 
    c.ID_customer
HAVING 
    COUNT(DISTINCT r.ID_hotel) > 1  -- Сделали бронирования в разных отелях
    AND COUNT(b.ID_booking) > 2  -- Сделали более двух бронирований
ORDER BY 
    total_bookings DESC;  -- Сортировка по количеству бронирований в убывающем порядке
