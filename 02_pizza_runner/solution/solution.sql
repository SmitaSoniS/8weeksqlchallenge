PROBLEM 1: How many pizzas were ordered?
SOLUTION 1
SELECT COUNT(pizza_id) AS PizzaCount
FROM customer_orders;
╭────────────╮
│ PizzaCount │
╞════════════╡
│         14 │
╰────────────╯

PROBLEM 2: How many unique customer orders were made?
SOLUTION 2
SELECT COUNT(DISTINCT order_id) AS Unique_Order_Count
FROM customer_orders;
╭────────────────────╮
│ Unique_Order_Count │
╞════════════════════╡
│                 10 │
╰────────────────────╯

PROBLEM 3: How many successful orders were delivered by each runner?
SOLUTION 3
SELECT runner_id as RunnerID, COUNT(*) AS Order_Completed
FROM runner_orders
WHERE (cancellation IS NULL) OR (cancellation ='')
GROUP BY runner_id;
╭──────────┬─────────────────╮
│ RunnerID │ Order_Completed │
╞══════════╪═════════════════╡
│        1 │               4 │
│        2 │               3 │
│        3 │               1 │
╰──────────┴─────────────────╯

PROBLEM 4: How many of each type of pizza was delivered?
SOLUTION 4
SELECT pn.pizza_name as PizzaName, count(co.order_id) AS Delivered_Count
FROM runner_orders ro JOIN customer_orders co ON (ro.order_id = co.order_id) JOIN pizza_names pn ON (co.pizza_id=pn.pizza_id)
WHERE (ro.cancellation IS NULL) OR (ro.cancellation ='')
GROUP BY pn.pizza_name;
╭────────────┬─────────────────╮
│ PizzaName  │ Delivered_Count │
╞════════════╪═════════════════╡
│ Meatlovers │               9 │
│ Vegetarian │               3 │
╰────────────┴─────────────────╯

PROBLEM 5: How many Vegetarian and Meatlovers pizzas were ordered by each customer?
SOLUTION 5
SELECT co.customer_id as CustomerID, pn.pizza_name AS PizzaName, count(*) AS PizzaCount
FROM customer_orders co JOIN pizza_names pn ON (co.pizza_id =pn.pizza_id)
GROUP BY co.customer_id, pn.pizza_name;
╭────────────┬────────────┬────────────╮
│ CustomerID │ PizzaName  │ PizzaCount │
╞════════════╪════════════╪════════════╡
│        101 │ Meatlovers │          2 │
│        101 │ Vegetarian │          1 │
│        102 │ Meatlovers │          2 │
│        102 │ Vegetarian │          1 │
│        103 │ Meatlovers │          3 │
│        103 │ Vegetarian │          1 │
│        104 │ Meatlovers │          3 │
│        105 │ Vegetarian │          1 │
╰────────────┴────────────┴────────────╯

PROBLEM 6: What was the maximum number of pizzas delivered in a single order?
SOLUTION 6
SELECT count(*) AS PizzaCount
FROM customer_orders
GROUP BY order_id
ORDER BY count(*) DESC
LIMIT 1;

SELECT max(Pizzas) AS PizzaCount
FROM (SELECT count(*) AS Pizzas
      FROM customer_orders
      GROUP BY order_id);

WITH Summary AS (SELECT order_id AS OrderID, count(*) as PizzaCount, RANK() OVER(ORDER BY count(*) DESC) AS rn
FROM customer_orders
GROUP BY order_id
)
SELECT PizzaCount
FROM Summary
WHERE rn=1;
╭────────────╮
│ PizzaCount │
╞════════════╡
│          3 │
╰────────────╯

PROBLEM 7: For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
SOLUTION 7:
SELECT co.customer_id AS CustomerID,
       SUM(CASE WHEN (co.exclusions IS NOT NULL AND co.exclusions != '') OR (co.extras IS NOT NULL AND co.extras != '') THEN 1 ELSE 0 END) AS AtleastOneChange,
       SUM(CASE WHEN (co.exclusions IS NULL OR co.exclusions = '') AND (co.extras IS NULL OR co.extras = '') THEN 1 ELSE 0 END) AS NoChange
FROM customer_orders co JOIN runner_orders ro ON co.order_id=ro.order_id
WHERE ro.cancellation IS NULL OR ro.cancellation=''
GROUP BY co.customer_id;
╭────────────┬────────────────┬──────────╮
│ CustomerID │ AtLeast1Change │ NoChange │
╞════════════╪════════════════╪══════════╡
│        101 │              0 │        2 │
│        102 │              0 │        3 │
│        103 │              3 │        0 │
│        104 │              2 │        1 │
│        105 │              1 │        0 │
╰────────────┴────────────────┴──────────╯

PROBLEM 8: How many pizzas were delivered that had both exclusions and extras?
SELECT count(*) AS Pizza_Count
FROM customer_orders co
  JOIN runner_orders ro
  ON (co.order_id=ro.order_id)
WHERE (co.exclusions IS NOT NULL AND co.exclusions != '')
  AND (co.extras IS NOT NULL AND co.extras != '')
  AND (ro.cancellation IS NULL OR ro.cancellation = '');
╭─────────────╮
│ Pizza_Count │
╞═════════════╡
│           1 │
╰─────────────╯

PROBLEM 9: What was the total volume of pizzas ordered for each hour of the day?
SELECT CAST(strftime('%H', order_time) AS Integer) AS Hour,
                                   count(order_id) AS PizzaCount
FROM customer_orders
GROUP BY strftime('%H', order_time)
ORDER BY Hour;
╭──────┬────────────╮
│ Hour │ PizzaCount │
╞══════╪════════════╡
│   11 │          1 │
│   13 │          3 │
│   18 │          3 │
│   19 │          1 │
│   21 │          3 │
│   23 │          3 │
╰──────┴────────────╯

PROBLEM 10: What was the volume of orders for each day of the week?
SELECT CAST(strftime('%w',order_time) AS Integer) AS Day, count(order_id) AS Order_Count
FROM customer_orders
GROUP BY strftime('%w',order_time)
ORDER BY Day;
╭─────┬─────────────╮
│ Day │ Order_Count │
╞═════╪═════════════╡
│   0 │           1 │
│   1 │           5 │
│   5 │           5 │
│   6 │           3 │
╰─────┴─────────────╯

PROBLEM 11: How many runners signed up for each 1 week period?
SELECT count(runner_id), ((min(registration_date))+6)%7 AS Week
FROM runners
GROUP BY runner_id;
╭──────┬──────────────╮
│ Week │ runner_count │
╞══════╪══════════════╡
│    0 │            2 │
│    1 │            1 │
│    2 │            1 │
╰──────┴──────────────╯

PROBLEM 12: What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pick up the order?
SELECT runner_id,
       ROUND(AVG((strftime('%s', ro.pickup_time) - strftime('%s', co.order_time)) / 60.0),2) AS avg_time_min
FROM runner_orders ro JOIN customer_orders co ON (ro.order_id=co.order_id)
WHERE (ro.pickup_time IS NOT NULL) AND (co.order_time IS NOT NULL)
GROUP BY runner_id;
╭───────────┬──────────────╮
│ runner_id │ avg_time_min │
╞═══════════╪══════════════╡
│         1 │        15.68 │
│         2 │        23.72 │
│         3 │        10.47 │
╰───────────┴──────────────╯

PROBLEM 13: Is there any relationship between the number of pizzas and how long the order takes to prepare?

PROBLEM 14: What was the average distance travelled for each customer?
SELECT 
    co.customer_id,
    ROUND(AVG(CAST(SUBSTR(ro.distance, 1, 2) AS INT)), 2)
        AS Average_Distance_Travelled
FROM customer_orders co
JOIN runner_orders ro 
    ON co.order_id = ro.order_id
WHERE ro.distance IS NOT NULL
GROUP BY co.customer_id
ORDER BY co.customer_id;
╭─────────────┬──────────────────────╮
│ customer_id │ Average_Distance_... │
╞═════════════╪══════════════════════╡
│         101 │                 20.0 │
│         102 │                16.33 │
│         103 │                 23.0 │
│         104 │                 10.0 │
│         105 │                 25.0 │
╰─────────────┴──────────────────────╯

PROBLEM 15: What was the difference between the longest and shortest delivery times for all orders?
SELECT (MAX(substr(duration,1,2)) - MIN(substr(duration,1,2))) AS Diff
FROM runner_orders
WHERE duration IS NOT NULL;
╭──────╮
│ Diff │
╞══════╡
│   30 │
╰──────╯

PROBLEM 16: What was the average speed for each runner for each delivery?
SELECT 
    runner_id,
    order_id,
    ROUND(
        SUM(CAST(SUBSTR(distance, 1, 2) AS FLOAT)) /
        SUM(CAST(SUBSTR(duration, 1, 2) AS FLOAT)),
        2
    ) AS speed
FROM runner_orders
WHERE distance IS NOT NULL
  AND duration IS NOT NULL
GROUP BY runner_id, order_id
ORDER BY runner_id, order_id;
╭───────────┬──────────┬───────╮
│ runner_id │ order_id │ speed │
╞═══════════╪══════════╪═══════╡
│         1 │        1 │  0.63 │
│         1 │        2 │  0.74 │
│         1 │        3 │  0.65 │
│         1 │       10 │   1.0 │
│         2 │        4 │  0.57 │
│         2 │        7 │   1.0 │
│         2 │        8 │  1.53 │
│         3 │        5 │  0.67 │
╰───────────┴──────────┴───────╯

PROBLEM 17: What is the successful delivery percentage for each runner?