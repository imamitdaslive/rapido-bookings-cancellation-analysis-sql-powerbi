--CREATING TABLES IN POSTGRES DB
DROP TABLE IF EXISTS rapido_bookings;

CREATE TABLE rapido_bookings(
date TIMESTAMP,
time TIME, 
booking_id TEXT,
booking_status TEXT,
customer_id TEXT,
vehicle_type TEXT,
pickup_location TEXT,
drop_location TEXT,
v_tat INT,
c_tat INT,
canceled_rides_by_customer TEXT,
canceled_rides_by_driver TEXT,
incomplete_rides BOOLEAN,
incomplete_rides_reason TEXT,
booking_value INT,
payment_method TEXT,
ride_distance INT,
driver_ratings NUMERIC,
customer_rating NUMERIC,
vehicle_images TEXT
);


--LOAD the csv into this table
copy rapido_bookings FROM 'C:\Users\amit1\OneDrive\Desktop\Rapido Booking Cancelation Analysis\data\Rapido_bookings.csv' DELIMITER ',' CSV HEADER NULL 'null';


--data view
SELECT * FROM rapido_bookings
LIMIT 10;

--1. Retrieve all successful bookings:
CREATE VIEW successful_bookings AS
SELECT * FROM rapido_bookings
WHERE booking_status ='Success';

SELECT * FROM successful_bookings;


--2. Find the average ride distance for each vehicle type:
CREATE VIEW avg_ride_dis_vehicletype AS
SELECT vehicle_type, AVG(ride_distance) AS avg_ride_distance
FROM rapido_bookings
GROUP BY vehicle_type;


SELECT * FROM avg_ride_dis_vehicletype;


--3. Get the total number of cancelled rides by customers:
Create View cancelled_rides_by_customers AS
SELECT COUNT(*)
FROM rapido_bookings
WHERE booking_status = 'Canceled by Customer';


SELECT * FROM cancelled_rides_by_customers;


--4. List the top 5 customers who booked the highest number of rides:
CREATE VIEW Top_5_Customers AS
SELECT customer_id, COUNT(booking_id) AS total_rides
FROM rapido_bookings
GROUP BY customer_id
ORDER BY total_rides DESC
LIMIT 5;

SELECT * FROM Top_5_Customers;


--5. Get the number of rides cancelled by drivers due to personal and car-related issues:
CREATE VIEW Rides_cancelled_by_Drivers_P_C_Issues AS
SELECT COUNT(*)
FROM rapido_bookings
WHERE booking_status = 'Canceled by Driver' AND 
Canceled_rides_by_driver = 'Personal & Car related issue';


SELECT * FROM Rides_cancelled_by_Drivers_P_C_Issues;

--6. Find the maximum and minimum driver ratings for Prime Sedan bookings:
CREATE VIEW Max_Min_Driver_Rating As
SELECT MAX(driver_ratings) as max_rating,
MIN(driver_ratings) as min_rating
FROM rapido_bookings WHERE vehicle_type = 'Prime Sedan';


SELECT * FROM Max_Min_Driver_Rating;

--7. Retrieve all rides where payment was made using UPI:
CREATE VIEW upi_payment AS
SELECT * FROM rapido_bookings
WHERE payment_method ='UPI';


SELECT * FROM upi_payment;


--8. Find the average customer rating per vehicle type:
CREATE VIEW AVG_Cust_Rating As
SELECT Vehicle_Type, AVG(Customer_Rating) as avg_customer_rating
FROM rapido_bookings
GROUP BY Vehicle_Type;

SELECT * FROM AVG_Cust_Rating;


--9. Calculate the total booking value of rides completed successfully:
CREATE VIEW total_successful_ride_value As
SELECT SUM(Booking_Value) as total_successful_ride_value
FROM rapido_bookings
WHERE Booking_Status = 'Success';

SELECT * FROM total_successful_ride_value


--10. List all incomplete rides along with the reason:
CREATE VIEW Incomplete_Rides_Reason As
SELECT Booking_ID, Incomplete_Rides_Reason
FROM rapido_bookings
WHERE Incomplete_Rides = 'Yes';


SELECT * FROM Incomplete_Rides_Reason;


--11. hourly basis ride completed:

CREATE VIEW Complete_rides_by_hours As
SELECT EXTRACT(HOUR FROM time) AS booking_hour,
        COUNT(*) AS successful_bookings
FROM rapido_bookings
WHERE booking_status = 'Success'
AND date >= '2024-07-01'::date
AND date <= '2024-07-31'::date
GROUP BY booking_hour
ORDER BY booking_hour;


SELECT * FROM Complete_rides_by_hours;

--12. hourly basis ride cancelled:
CREATE VIEW Canceled_rides_by_hours As
SELECT EXTRACT(HOUR FROM time) AS booking_hour,
        COUNT(*) AS Canceled_bookings
FROM rapido_bookings
WHERE booking_status IN ('Canceled by Driver' , 'Canceled by Customer' )
AND date >= '2024-07-01'::date
AND date <= '2024-07-31'::date
GROUP BY booking_hour
ORDER BY booking_hour;

SELECT * FROM Canceled_rides_by_hours;


SELECT * FROM rapido_bookings
limit 10;


--12. hourly basis ride cancelled because of driver not found:

CREATE VIEW Driver_not_found_by_hours As
SELECT EXTRACT(HOUR FROM time) AS booking_hour,
        COUNT(*) AS Canceled_bookings
FROM rapido_bookings
WHERE booking_status = 'Driver Not Found'
AND date >= '2024-07-01'::date
AND date <= '2024-07-31'::date
GROUP BY booking_hour
ORDER BY booking_hour;


SELECT * FROM Driver_not_found_by_hours;
