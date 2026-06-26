PROBLEM 1: What is the total amount each customer spent at the restaurant?
SOLUTION 1:
SELECT s.customer_id as Customer_id, sum(m.price) AS Amount_Spent            
FROM sales s JOIN menu m ON (s.product_id=m.product_id)
GROUP BY Customer_id;

╭─────────────┬──────────────╮
│ Customer_id │ Amount_Spent │
╞═════════════╪══════════════╡
│ A           │           76 │
│ B           │           74 │
│ C           │           36 │
╰─────────────┴──────────────╯

PROBLEM 2: How many days has each customer visited the restaurant?
SOLUTION 2:
SELECT customer_id, count(DISTINCT order_date) AS Visit_Count
FROM sales
GROUP BY customer_id;

╭─────────────┬─────────────╮
│ customer_id │ Visit_Count │
╞═════════════╪═════════════╡
│ A           │           4 │
│ B           │           6 │
│ C           │           2 │
╰─────────────┴─────────────╯

PROBLEM 3: What was the first item from the menu purchased by each customer?
SOLUTION 3:
WITH Summary AS (
SELECT s.customer_id AS CustomerID, m.product_name AS Product, s.order_date AS Purchase_Date, RANK() OVER(PARTITION BY s.customer_id ORDER BY s.order_date ASC) AS rank
FROM sales s JOIN menu m ON (s.product_id=m.product_id)) 
SELECT CustomerID, Product
FROM Summary              
WHERE rank=1;   

╭────────────┬─────────╮
│ CustomerID │ Product │
╞════════════╪═════════╡
│ A          │ sushi   │
│ A          │ curry   │
│ B          │ curry   │
│ C          │ ramen   │
│ C          │ ramen   │
╰────────────┴─────────╯

PROBLEM 4: What is the most purchased item on the menu and how many times was it purchased by all customers?
SOLUTION 4:
SELECT m.product_name AS Product, COUNT(*) AS Purchase_Count
FROM sales s JOIN menu m ON s.product_id = m.product_id
GROUP BY m.product_name
ORDER BY Purchase_Count DESC
LIMIT 1;

╭─────────┬───────────────╮
│ Product │ Purchase_Count│
╞═════════╪═══════════════╡
│ ramen   │       8       │
╰─────────┴───────────────╯

PROBLEM 5: Which item was the most popular for each customer?
SOLUTION 5:
WITH Summary AS (SELECT s.customer_id AS CustomerID, m.product_name AS Product, count(s.order_date) AS Purchase_Count, RANK() OVER(PARTITION BY s.customer_id ORDER BY count(s.order_date) DESC) AS rank
FROM sales s JOIN menu m ON (s.product_id=m.product_id)
GROUP BY s.customer_id, m.product_name)
SELECT CustomerID, Product
FROM Summary
WHERE rank=1;

╭────────────┬─────────╮
│ CustomerID │ Product │
╞════════════╪═════════╡
│ A          │ ramen   │
│ B          │ sushi   │
│ B          │ ramen   │
│ B          │ curry   │
│ C          │ ramen   │
╰────────────┴─────────╯

PROBLEM 6: Which item was purchased first by the customer after they became a member?
SOLUTION 6:
WITH Summary as (SELECT mem.customer_id AS CustomerID, m.product_name AS Product, s.order_date AS Purchase_date, ROW_NUMBER() OVER(PARTITION BY mem.customer_id ORDER BY s.order_date ASC)  as rn
FROM members mem JOIN sales s ON (mem.customer_id=s.customer_id) JOIN menu m ON (m.product_id=s.product_id)
WHERE mem.join_date<s.order_date)
SELECT CustomerID, Product
FROM Summary
WHERE rn=1;

╭────────────┬─────────╮
│ CustomerID │ Product │
╞════════════╪═════════╡
│ A          │ ramen   │
│ B          │ sushi   │
╰────────────┴─────────╯

PROBLEM 7: Which item was purchased just before the customer became a member?
SOLUTION 7:
WITH Summary as (SELECT mem.customer_id AS CustomerID, m.product_name AS Product, s.order_date AS Purchase_date, RANK() OVER(PARTITION BY mem.customer_id ORDER BY s.order_date DESC)  as rank
FROM members mem JOIN sales s ON (mem.customer_id=s.customer_id) JOIN menu m ON (m.product_id=s.product_id)
WHERE mem.join_date>s.order_date)
SELECT CustomerID, Product
FROM Summary
WHERE rank=1;

╭────────────┬─────────╮
│ CustomerID │ Product │
╞════════════╪═════════╡
│ A          │ sushi   │
│ A          │ curry   │
│ B          │ sushi   │
╰────────────┴─────────╯

PROBLEM 8:What is the total items and amount spent for each member before they became a member?
SOLUTION 8:
SELECT s.customer_id AS CustomerID, count(m.product_name) AS Product_Count, SUM(m.price) AS Price
FROM members mem JOIN sales s ON (mem.customer_id=s.customer_id) JOIN menu m ON (m.product_id=s.product_id)
WHERE mem.join_date>s.order_date
GROUP BY CustomerID;

╭────────────┬───────────────┬───────╮
│ CustomerID │ Product_Count │ Price │
╞════════════╪═══════════════╪═══════╡
│ A          │             2 │    25 │
│ B          │             3 │    40 │
╰────────────┴───────────────┴───────╯

PROBLEM 9: If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
SOLUTION 9:
WITH Summary AS (SELECT s.customer_id as CustomerID, m.product_name AS Product, m.price AS Product_Cost, CASE WHEN m.product_name='sushi' THEN m.price*20 ELSE m.price*10 END AS Points
FROM sales s JOIN menu m ON (m.product_id=s.product_id))
SELECT CustomerID, SUM(Points) AS Points
FROM Summary
GROUP BY CustomerID;

╭────────────┬────────╮
│ CustomerID │ Points │
╞════════════╪════════╡
│ A          │    860 │
│ B          │    940 │
│ C          │    360 │
╰────────────┴────────╯

PROBLEM 10: In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?
SOLUTION 10:
WITH Summary AS 
(SELECT mem.customer_id AS CustomerID, mem.join_date AS Joining_Date, s.order_date AS Order_date, m.product_name AS Product, m.price AS Amount_Spent,
        CASE
        WHEN s.order_date>=mem.join_date AND s.order_date<=date(mem.join_date, '+6 days') THEN m.price*20
        WHEN m.product_name = 'sushi' THEN  m.price*20
        ELSE m.price*10
        END AS Points
FROM members mem JOIN sales s ON (mem.customer_id=s.customer_id) JOIN menu m ON (m.product_id = s.product_id)
WHERE s.order_date<='2021-01-31')
SELECT CustomerID, SUM(Points) AS Total_Points
FROM Summary
GROUP BY CustomerID

╭────────────┬──────────────╮
│ CustomerID │ Total_Points │
╞════════════╪══════════════╡
│ A          │         1370 │
│ B          │          820 │
╰────────────┴──────────────╯