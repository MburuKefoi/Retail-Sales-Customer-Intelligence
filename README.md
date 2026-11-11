# RETAIL SALES & CUSTOMER INTELLIGENCE 

## Project Overview
 
Duka Smart Electronics is a growing Kenyan retailer selling phones ,laptops ,accessories,TVs and home appliances in ten towns - Nairobi ,Mombasa , Kisumu ,Nakuru , Eldoret , Thika , Nyeri , Meru , Machakos and Kiambu.
It has traded since January 2025 and keeps every order in a database.Management wants to know who  its best customers are , which products actually make money , whether sales are growin  and which customers have stopped buying 
This project required use of DBeaver and Postgres for the queries and Power BI where we visualized some of our findings

## Project Objectives

- Measure revenue, cost and profit, and track month-over-month growth
- Segment customers into High / Medium / Low value groups
- Identify which product categories contribute most to revenue
- Build reusable views and functions for ongoing reporting

## Dataset
 
|Tables | Columns |
|:------|:--------|
|'Customers'| 'customer_id' , 'customer_name' , 'gender' , 'city' , 'registration_date' , 'customer_segment' | 
|'Orders' |'order_id' , 'customer_id' , 'order_date' , 'product_name' , 'product_category' ,'quantity' , 'unit_price' , 'cost_price' ,'discount' , 'payment_method' , 'order_status, |

Above tables will lie in duka_smart schema in retail_analytics database

## Business Rules

|Measure | Formula |
|:-------|:--------|
|Revenue |quantity * unit_price * (1-discount/100) |
|Cost    |quantity * cost_price  |
|Profit  |revenue - cost |
|Profit Margin % |profit/NULLIF(revenue,0) * 100 |

For all money questions(revenue , cost , proofit, spending , averages ) we included a where filter where we only found for those that had their order status complete

## Questions Answered
 
|#     | Question | Technique |
|:-----|:---------|:----------|
|1- 10 | SQL Fundamentals | SELECT , WHERE , DISTINCT |
|11 - 20| Aggregation & Grouping | SUM , AVERAGE , COUNT , MIN , MAX , PERCENTAGES |
|21 - 28| Joins & Customer Analytics| JOIN , RIGHT JOIN , LEFT JOIN , GROUP BY |
|29 - 34| Subqueries & CTEs | WHERE Subquery , Multiple CTEs , DATE_TRUNC, HAVING |
|35 - 42| Window Functions | RANK() ,CTEs , WINDOW FUNCTIONS |
|43 - 46| Advanced Business Intelligence | Views ,Functions |

## How do i run my scripts ??

Once youve connected Postgres to Dbeaver , you then create a database for instance mine was named Retail_Analytics, reason for mainly creating a database is to keeep all your data in one container separate from the rest
After creating a database you can copy my scema.sql script that has the schema and table statements ,remember to run the statement after every semi-colon by ctrl + enter or clicking on the first orange triangular like button in your SQL editor 
The schema.sql script will specifically create schema and tables you need and later you can insert or import data.Queries.sql script is all 46 questions queries answered.

## Executive Dashboard 

<img width="747" height="366" alt="Screenshot 2026-11-11 160230" src="https://github.com/user-attachments/assets/c42125cd-9322-444a-9b3e-46acfcbf0d62" /> 

You can check insights.md to find the insights and recommendations we gave to Duka Smart Electronics 
