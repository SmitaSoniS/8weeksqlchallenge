PROBLEM 1: What is the total amount each customer spent at the restaurant?
SOLUTION 1:
SELECT s.customer_id as Customer_id, sum(m.price) AS Amount_Spent            
FROM sales s JOIN menu m ON (s.product_id=m.product_id)
GROUP BY Customer_id;

Customer_id  Amount_Spent
-----------  ------------
A                      76
B                      74
C                      36

PROBLEM 2: How many days has each customer visited the restaurant?
SOLUTION 2:
SELECT customer_id, count(DISTINCT order_date) AS Visit_Count
FROM sales
GROUP BY customer_id;

customer_id  Visit_Count
-----------  -----------
A                      4
B                      6
C                      2

PROBLEM 3: What was the first item from the menu purchased by each customer?
SOLUTION 3:
WITH Summary AS (
SELECT s.customer_id AS CustomerID, m.product_name AS Product, s.order_date AS Purchase_Date, ROW_NUMBER() OVER(PARTITION BY s.customer_id ORDER BY s.order_date ASC) AS rn
FROM sales s JOIN menu m ON (s.product_id=m.product_id)) 
SELECT CustomerID, Product
FROM Summary              
WHERE rn=1;   
 
CustomerID  Product
----------  -------
A           sushi
B           curry
C           ramen

PROBLEM 4: What is the most purchased item on the menu and how many times was it purchased by all customers?
SOLUTION 4:
SELECT m.product_name AS Product, COUNT(*) AS Purchase_Count
FROM sales s JOIN menu m ON s.product_id = m.product_id
GROUP BY m.product_name
ORDER BY order_count DESC
LIMIT 1;

╭─────────┬───────────────╮
│ Product │ Purchase_Count│
╞═════════╪═══════════════╡
│ ramen   │       8       │
╰─────────┴───────────────╯

PROBLEM 5: Which item was the most popular for each customer?
SOLUTION 5:
WITH Summary AS (SELECT s.customer_id AS CustomerID, m.product_name AS Product, count(s.order_date) AS Purchase_Count, ROW_NUMBER() OVER(PARTITION BY s.customer_id ORDER BY count(s.order_date)) AS rn
FROM sales s JOIN menu m ON (s.product_id=m.product_id)
GROUP BY s.customer_id, m.product_name)
SELECT CustomerID, Product
FROM Summary
WHERE rn=1;

╭────────────┬─────────╮
│ CustomerID │ Product │
╞════════════╪═════════╡
│ A          │ sushi   │
│ B          │ curry   │
│ C          │ ramen   │
╰────────────┴─────────╯

PROBLEM 6: Which item was purchased first by the customer after they became a member?
SOLUTION 6:

SELECT m.customer_id AS CustomerID, m.product_name AS Product, s.order_date AS Purchase_date, ROW_NUMBER() OVER(PARTITION BY m.customer_id ORDER BY s.order_date ASC) 
FROM members m JOIN sales s ON (m.customer_id=s.customer_id) JOIN menu m ON (m.product_id=s.product_id)
WHERE m.join_date<s.order_date

PROBLEM 7: Which item was purchased just before the customer became a member?
SOLUTION 7:

PROBLEM 8:What is the total items and amount spent for each member before they became a member?
SOLUTION 8:

PROBLEM 9: If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
SOLUTION 9:

PROBLEM 10: In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?
SOLUTION 10:

