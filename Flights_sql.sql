use sqlcasestudies;

-- Q1 Find the busiest airport by the number of flights take off ? 

SELECT 
    a.name, COUNT(*) TotalFlights
FROM
    flights f
        JOIN
    airports a ON f.origin = a.airportid
GROUP BY a.name
ORDER BY totalflights DESC
LIMIT 1
;


-- Q2 Total number of tickets sold per airline?
SELECT 
    al.name, COUNT(t.ticketid) ticketsSold
FROM
    tickets t
        JOIN
    flights f ON t.flightid = f.flightid
        JOIN
    airlines al ON f.airlineid = al.airlineid
GROUP BY al.name
ORDER BY ticketsSold DESC
;




-- Q3 List all flights operated by IndiGo with airport names (origin and destination) ?

SELECT 
    F.FlightID,
    a.Name AS OriginAirport,
    a1.Name AS DestinationAirport
FROM
    Flights f
        JOIN
    Airlines al ON f.AirlineID = al.AirlineID
        JOIN
    Airports a ON f.Origin = a.AirportID
        JOIN
    Airports a1 ON f.Destination = a1.AirportID
WHERE
    al.Name = 'Indigo'
;




-- Q4 For each airport, show the top airline by number of flights departing from there?

with cte_r as  
(
select origin, airlineid,noofflights, rank() over(partition by origin order by noofflights desc) as rn
from (
		SELECT 
    origin, airlineid, COUNT(*) Noofflights
FROM
    flights
GROUP BY origin , airlineid
	) t
)

SELECT 
    a.name AirportName,
    al.name AirlineName,
    r.noofflights FlightCount
FROM
    cte_r r
        JOIN
    airlines al ON r.airlineid = al.airlineid
        JOIN
    airports a ON r.origin = a.airportid
WHERE
    rn = 1
;



-- Q5 For each flight, show time taken in hours and categorize it as Short (<2h), Medium (2-5h), or Long (>5h) ?

SELECT FlightID, DepartureTime, ArrivalTime, 
    ROUND(TIMESTAMPDIFF(MINUTE, DepartureTime, ArrivalTime) / 60, 1) AS DurationInHours,
    CASE 
        WHEN TIMESTAMPDIFF(minute, departuretime, arrivaltime) < 120  THEN 'Short'
        WHEN TIMESTAMPDIFF(minute, departuretime, arrivaltime) <= 300 THEN 'Medium'
        ELSE 'Long'
    END AS FlightCategory
FROM flights
;

-- Q6 Show each passenger's first and last flight dates and number of flights?
with cte_flightno as (
SELECT 
    t.passengerid,
    MIN(f.departuretime) AS FirstFlight,
    MAX(f.departuretime) AS LastFlight,
    COUNT(*) TotalFlights
FROM
    tickets t
        JOIN
    flights f ON t.flightid = f.flightid
GROUP BY t.passengerid
)
SELECT 
    p.name, fn.FirstFlight, fn.LastFlight, fn.totalflights
FROM
    cte_flightno fn
        JOIN
    passengers p ON fn.passengerid = p.passengerid
;



-- Q7 Find flights with the highest price ticket sold for each route (origin -> destination)?

with cte_r as (
 select f.origin, f.destination, t.price, rank() over(partition by f.origin, f.destination order by t.price desc) as rnk
 from flights f join tickets t on f.flightid=t.flightid
 )
 
 select a1.name Origin, a2.name Destination, r.price
 from cte_r r join airports a1 on r.origin =a1.airportid
 join airports a2 on r.destination =a2.airportid
 where r.rnk= 1
 ;


-- Q8 Find the highest spending passenger in each Frequent Flyer Status group?

with cte_r as (
SELECT *,
	RANK() OVER (PARTITION BY FrequentFlyerStatus ORDER BY TotalSpent DESC) AS rnk
	FROM (
		SELECT p.PassengerID, p.Name, p.FrequentFlyerStatus, SUM(t.Price) AS TotalSpent
		FROM Passengers p
		JOIN Tickets t 
		ON p.PassengerID = t.PassengerID
		GROUP BY p.PassengerID, p.Name, p.FrequentFlyerStatus
	) t
)
SELECT *
FROM cte_r
WHERE rnk = 1
;



-- Q9. Find the total revenue and number of tickets sold for each airline, and rank the airlines based on total revenue?

with cte_rt as (
SELECT 
    f.airlineid,
    COUNT(*) TotalTickets,
    SUM(t.price) TotalRevenue
FROM
    flights f
        JOIN
    tickets t ON f.flightid = t.flightid
GROUP BY f.airlineid
)
select rt.airlineid, al.name, rt.totaltickets, rt.TotalRevenue, 
		rank() over( order by rt.totalrevenue desc) Rank_revenue
from cte_rt rt join airlines al on rt.airlineid= al.airlineid
;


-- Q10. For each passenger, identify their most frequently used airline. If a passenger has multiple airlines with the same highest usage, show all such airlines?


with cte_ta as (
select *, rank() over (partition by passengerid order by ticketswitairlines desc) rnk
from (
		select p.passengerid, p.name PassengerName, al.airlineid, al.name AirlinesName, count(*) as ticketswitairlines
		from passengers p join tickets t on p.passengerid = t.passengerid
		join flights f on t.flightid=f.flightid 
        join airlines al on f.airlineid=al.airlineid 
		group by p.passengerid, p.name , al.airlineid,al.name
	)t 
)

select passengerid, PassengerName, AirlinesName, ticketswitairlines
from cte_ta
where rnk=1
;










































