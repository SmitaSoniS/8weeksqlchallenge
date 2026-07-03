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

PROBLEM 6: What was the maximum number of pizzas delivered in a single order?

PROBLEM 7: For each customer, how many delivered pizzas had at least 1 change and how many had no changes?

PROBLEM 8: How many pizzas were delivered that had both exclusions and extras?

PROBLEM 9: What was the total volume of pizzas ordered for each hour of the day?

PROBLEM 10: What was the volume of orders for each day of the week?

PROBLEM 11: How many runners signed up for each 1 week period?

PROBLEM 12: What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pick up the order?

PROBLEM 13: Is there any relationship between the number of pizzas and how long the order takes to prepare?

PROBLEM 14: What was the average distance travelled for each customer?

PROBLEM 15: What was the difference between the longest and shortest delivery times for all orders?

PROBLEM 16: What was the average speed for each runner for each delivery?

PROBLEM 17: What is the successful delivery percentage for each runner?