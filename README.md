# sqlcasestudy_Flights

This project is a collection of SQL queries designed to analyze a simulated aviation database.
The goal is to answer real-world airline business questions related to operations, passengers, and revenue.



---

# SQL Case Study: Aviation & Airline Data Analysis

## ✈️ Project Overview

This project contains a comprehensive set of SQL queries designed to analyze a simulated aviation database. The analysis covers flight operations, passenger behavior, airline revenue, and airport efficiency. The goal was to solve real-world business questions using advanced MySQL techniques.

## 🛠️ Tech Stack

* **Database:** MySQL
* **Language:** SQL
* **Key SQL Concepts:**
* **CTEs (Common Table Expressions):** For modular and readable query logic.
* **Window Functions:** `RANK()` and `PARTITION BY` for complex ranking.
* **Advanced Joins:** Multi-way joins to connect flights, passengers, and airlines.
* **Date/Time Manipulation:** `TIMESTAMPDIFF` and `DATEDIFF` for duration analysis.
* **Aggregations:** `SUM`, `COUNT`, `MIN/MAX` for business reporting.



---

## 📊 Key Business Questions Addressed

### 1. Operational Efficiency

* **Busiest Hubs:** Identified airports with the highest volume of take-offs to understand traffic load.
* **Flight Categorization:** Automated the classification of flights into **Short, Medium, or Long-haul** based on calculated flight duration.
* **Route Analysis:** Found the most expensive tickets sold for every specific route (Origin ➔ Destination).

### 2. Passenger Insights

* **Frequent Flyer Behavior:** Identified the top-spending passenger within each loyalty tier (Gold, Silver, etc.).
* **Loyalty Analysis:** Determined the most frequently used airline for every passenger to understand brand loyalty.
* **Travel History:** Captured the first and last travel dates for all passengers along with their total flight frequency.

### 3. Financial Performance

* **Revenue Ranking:** Calculated total revenue and ticket sales for each airline, ranking them to identify market leaders.
* **Sales Volume:** Analyzed ticket sales per airline to correlate volume with total revenue.

---

## 🚀 Featured Query Logic

Goal: Identify the airline operating the most flights from each airport.
Method: Aggregate flight counts per airline and rank them using a window function.

One of the most complex challenges in this study was identifying the "Top Airline per Airport." This required a nested aggregation and a window function:

```sql
WITH cte_r AS (
    SELECT origin, airlineid, noofflights, 
           RANK() OVER(PARTITION BY origin ORDER BY noofflights DESC) AS rn
    FROM (
        SELECT origin, airlineid, COUNT(*) Noofflights
        FROM flights
        GROUP BY origin, airlineid
    ) t
)
SELECT a.name AS AirportName, al.name AS AirlineName, r.noofflights
FROM cte_r r
JOIN airlines al ON r.airlineid = al.airlineid
JOIN airports a ON r.origin = a.airportid
WHERE rn = 1;

```

---

## 📂 Database Schema

The analysis is performed across the following tables:

* `Airports`: Airport details and IDs.
* `Airlines`: Airline names and carrier codes.
* `Flights`: Scheduling data, origins, and destinations.
* `Passengers`: Customer names and frequent flyer status.
* `Tickets`: Pricing and booking links between passengers and flights.

## 📈 Conclusion

Through this case study, I successfully transformed raw flight and transaction data into actionable insights. These queries can help an airline optimize its routes, target high-value passengers, and understand its competitive ranking in the market.

---

### How to use this as a template:

1. **Create a new Repository** on GitHub named `Aviation-Data-Analysis`.
2. **Upload your `.sql` script** file.
3. **Paste the text above** into the `README.md` file.

**Would you like me to add a section to the README explaining the specific 1064 syntax errors we fixed today? It might show future employers how well you understand debugging!**
