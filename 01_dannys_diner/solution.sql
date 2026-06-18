PROBLEM 1: What is the total amount each customer spent at the restaurant?
SOLUTION 1:
SELECT s.customer_id as Customer_id, sum(m.price) AS Amount_Spent            
   ...> FROM sales s JOIN menu m ON (s.product_id=m.product_id)
   ...> GROUP BY Customer_id
   ...> ;

Customer_id  Amount_Spent
-----------  ------------
A                      76
B                      74
C                      36

PROBLEM 2: How many days has each customer visited the restaurant?
SOLUTION 2:
SELECT customer_id, count(DISTINCT order_date) AS Visit_Count
   ...> FROM sales
   ...> GROUP BY customer_id;

customer_id  Visit_Count
-----------  -----------
A                      4
B                      6
C                      2

PROBLEM 3: What was the first item from the menu purchased by each customer?
SOLUTION 3:
WITH Summary AS (
(x1...> SELECT s.customer_id AS CustomerID, m.product_name AS Product, s.order_date AS Purchase_Date, ROW_NUMBER() OVER(PARTITION BY s.customer_id ORDER BY s.order_date ASC) AS rank
(x1...> FROM sales s JOIN menu m ON (s.product_id=m.product_id)) 
   ...> SELECT CustomerID, Product
   ...> FROM Summary              
   ...> WHERE rank=1;    
CustomerID  Product
----------  -------
A           sushi
B           curry
C           ramen
