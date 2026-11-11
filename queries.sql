-- Q1 - Retrieve all customer records 
select *
from customers;
set search_path to duka_smart;
--Q2 - Display Customer names ,cities and segments 
select c.customer_name , c.city , c.customer_segment
from customers c ;

--Q3 - Customers living in Nairobi 
select c.customer_name ,c.customer_segment 
from customers c 
where city = 'Nairobi';

--Q4 - Customers registered after jan 1
select c.customer_name ,c.registration_date 
from customers c 
where c.registration_date > '2025-01-01';

--Q5 - Display all unique customer cities 
select distinct c.city 
from customers c;

--Q6 - Retrieve the 10 most recent orders
select * from orders;
select o.order_id , o.order_date 
from orders o 
order by o.order_date desc
limit 10;

--Q7 - Orders with unit prices above Ksh 10,000
select o.order_id , o.product_name 
from orders o 
where o.unit_price > 10000;

--Q8 - Customers names start with A 
select c.customer_name 
from customers c 
where c.customer_name like 'A%';

--Q9 -Quantities between 2 and 5 
select o.order_id ,o.quantity
from orders o 
where o.quantity between 2 and 5 ;

--Q10 - Orders paid through Mpesa 
select o.order_id , o.product_name , o.unit_price
from orders o 
where o.payment_method = 'M-Pesa';

-- SECTION B
--Q11 - count all customers  
select count(distinct c.customer_id) 
from customers c ;

--Q12 - count all orders 
select count(distinct o.order_id)
from orders o ;

--Q13 - Completed-Order-Revenue
select round(sum(o.quantity* o.unit_price*(1-o.discount/100)),2) as revenue
from orders o
where order_status = 'Completed';

--Q14 - Average - Completed -value
select round(avg(o.quantity* o.unit_price*(1-o.discount/100)),2) as avg_order_value
from orders o
where order_status = 'Completed';

--Q15 - highest and lowest product prices 
select max(o.unit_price)
from orders o ;

select min(o.unit_price)
from orders o ;

--Q16 - Revenue by product category 
select o.product_category , 
round(sum(o.quantity * o.unit_price * (1- o.discount/100)),2) as total_for_category
from orders o 
where o.order_status = 'Completed'
group by o.product_category 
order by total_for_category desc ; 

--Q17 - Customers by city 
select c.city , count(c.customer_id) as customers
from customers c 
group by c.city
order by  customers desc;

--Q18 - quantity sold 
select o.product_name ,sum(o.quantity )
from orders o
group by o.product_name ;

--Q19 - categories generating more in revenue 
select o.product_category , 
round(sum(o.quantity*o.unit_price*(1-o.discount/100)),2) as revenue
from orders o 
where o.order_status = 'Completed'
group by o.product_category 
having round(sum(o.quantity*o.unit_price*(1-o.discount/100)),2) > 100000 ;

--Q20 - percentage of cancelled orders 
with cancelled_orders as(
select count(o.order_id) as cancels, (select count(o.order_id) from orders o ) as total
from orders o 
where o.order_status = 'Cancelled')
select round((cancels*100/ total),2) as pcnt
from cancelled_orders ;

select round(100.0 * sum(case when o.order_status = 'Cancelled' then 1 else 0 end)/count(*),2)
from orders o ;
 
-- SECTION C 
--Q21 - Display orders with customers names, cities 
select o.order_id , c.customer_name , c.city 
from orders o 
join customers c 
on o.customer_id = c.customer_id ;

--Q22 - Total Spending by Customer 

select c.customer_id ,c.customer_name , 
round(sum(o.quantity*o.unit_price*(1-o.discount/100)),2)as spending
from customers c
join orders o 
on c.customer_id = o.customer_id 
where o.order_status = 'Completed'
group by c.customer_id,c.customer_name 
order by c.customer_name asc;

--Q23 -Customers who never ordered 
select c.customer_id , c.customer_name 
from orders o 
right join customers c 
on o.customer_id = c.customer_id
where o.order_id is null; 

--Q24 - 10 highest spending customers 
select c.customer_id ,c.customer_name , 
round(sum(o.quantity * o.unit_price*(1-o.discount/100)),2) as spending
from orders o 
join customers c 
on o.customer_id = c.customer_id 
where o.order_status = 'Completed'
group by c.customer_id,c.customer_name
order by spending desc 
limit 10;

--Q25 - Revenue by City
select c.city , round(sum(o.quantity * o.unit_price * (1-o.discount/100)),2) as revenue
from customers c 
join orders o 
on o.customer_id = c.customer_id 
where o.order_status = 'Completed'
group by c.city
order by revenue desc;

--Q26 - Customers with more than 5 
select c.customer_id ,c.customer_name ,count(o.order_id) as total_orders 
from customers c
join orders o 
on o.customer_id = c.customer_id 
group by c.customer_id ,c.customer_name
having count(o.order_id) > 5 
order by  total_orders desc;

--Q27 - Average Customer Spending
select c.customer_segment , 
round(avg(o.quantity*o.unit_price*(1-o.discount/100)),2) as spending
from customers c 
join orders o 
on c.customer_id = o.customer_id 
where o.order_status = 'Completed'
group by c.customer_segment ;

--Q28 - Most Popular Category 

select o.product_category , count(c.customer_id) as members 
from orders o 
join customers c 
on o.customer_id = c.customer_id 
where c.customer_segment = 'VIP' 
group by o.product_category
order by members desc 
limit 1;

-- SECTION D - Subqueries and CTEs
--Q29 - customers spending above average
with spend as (
select c.customer_id ,c.customer_name ,
round(sum(o.quantity*o.unit_price*(1-o.discount/100)),2) as spending 
from customers c 
join orders o 
on o.customer_id = c.customer_id
where o.order_status = 'Completed'
group by c.customer_id , c.customer_name)
select customer_name , spending 
from spend
where spending > (select round(avg(o.quantity * o.unit_price * (1-o.discount/100)),2)
from orders o
where o.order_status = 'Completed');
--Q30 - Products priced above overall average unit price
select o.product_name , o.unit_price

from orders o 

where o.unit_price > (select avg(p.unit_price) from orders p);

--Q31 -Three highest revenue months 
with months as (
select Date_trunc('month',o.order_date):: date as month ,
round(sum(o.quantity * o.unit_price *(1-o.discount/100)),2) as revenue 

from orders o 

where o.order_status = 'Completed'

group by date_trunc('month',o.order_date)
order by revenue desc)
select month , revenue 

from months 
limit 3 ;



select * from orders ;

--Q32 -- Customer purchasing from at least three 
select c.customer_id , c.customer_name, count(distinct(o.product_category)) as categories
from customers c

join orders o 
on o.customer_id = c.customer_id 

group by c.customer_id ,c.customer_name
having count(distinct(o.product_category)) >= 3 ;


--Q33 - CTE calculating revenue ,cost, profit
with details as (
select o.product_category , 
round(sum(o.quantity*o.unit_price*(1-o.discount/100)),2) as revenue ,
round(sum(o.quantity* o.cost_price) )as cost

from orders o 
where o.order_status = 'Completed'
group by o.product_category ),
more_details as (
select product_category , revenue ,cost,(revenue-cost) as profit 
from details),
finale as (
select product_category ,revenue, cost,profit, (profit/nullif(revenue,0)*100) as profit_margin
from more_details )
select product_category ,revenue ,cost, profit , round(profit_margin,2) as prof_margin
from finale ;


--Q34 - Order Dates
with customer_orders as (
select c.customer_id ,c.customer_name, max(o.order_date) as latest_comporder,
(select max(o.order_date) as latest_order from orders o)
from customers c 
join orders o 
on c.customer_id = o.customer_id 
where o.order_status = 'Completed'
group by c.customer_id )
select co.customer_id , co.customer_name
from customer_orders co
where latest_comporder <= latest_order - interval'90 days' 
group by co.customer_id , co.customer_name;

-- SECTION E
 set search_path to duka_smart;
select count(*) from customers ;
with spend as (
select c.customer_name,c.customer_id , 
round(sum(o.quantity*o.unit_price*(1-o.discount/100)),2) as spending 
from customers c 
join orders o 
on o.customer_id = c.customer_id 
where o.order_status = 'Completed'
group by c.customer_id,c.customer_name)


select count(*) from duka_smart.customers;
select count(*) from public.customers ;

set search_path to public ; 
select * from customers ;

drop table duka_smart.customers;
drop table duka_smart.orders ;
alter table public.customers 
set schema duka_smart ;

alter table public.orders 
set schema duka_smart ; 

set search_path to duka_smart ;
select * from customers ;
select * from orders;
-- SECTION E
 set search_path to duka_smart;

--Q35 - Rank customers by spending
with spend as (
select c.customer_name,c.customer_id , 
round(sum(o.quantity*o.unit_price*(1-o.discount/100)),2) as spending 
from customers c 
join orders o 
on o.customer_id = c.customer_id 
where o.order_status = 'Completed'
group by c.customer_id,c.customer_name)
select customer_id , customer_name ,spending, rank() over(order by spending desc)
from spend ;

--Q36 - Number customers orders
select c.customer_id , c.customer_name , o.order_date ,row_number() over (order by o.order_date desc)
from customers c 
join orders o 
on c.customer_id = o.customer_id 
group by c.customer_name , c.customer_id , o.order_date ;

--Q37 - Rank products within categories 
select o.product_category , o.product_name , o.unit_price,
dense_rank() over(partition by o.product_category order by o.unit_price desc)
from orders o 
group by o.product_category ,o.product_name, o.unit_price  ; 

--Q38 - Calculate cumulative monthly revenue 
with cum_month as (
select date_trunc ('month',o.order_date):: date as month, 
round(sum(o.quantity*o.unit_price*(1-o.discount/100)),2) as spending 
from orders o 
where o.order_status = 'Completed'
group by date_trunc ('month',o.order_date):: date )
select month , spending , sum(spending) over(order by month asc) as running_total
from cum_month ;

--Q39 - Compare monthly revenue 
with cum_months as (
select date_trunc ('month',o.order_date):: date as month, 
round(sum(o.quantity*o.unit_price*(1-o.discount/100)),2) as spending 
from orders o 
where o.order_status = 'Completed'
group by date_trunc ('month',o.order_date):: date )
select month , spending , lag(spending) over (order by month asc) as previous_revenue
from cum_months ;

-- Q40- month over month revenue growth 
with cum_months as (
select date_trunc ('month',o.order_date):: date as month, 
round(sum(o.quantity*o.unit_price*(1-o.discount/100)),2) as spending 
from orders o 
where o.order_status = 'Completed'
group by date_trunc ('month',o.order_date):: date ),
previous as (
select month , spending , lag(spending) over (order by month asc) as previous_revenue
from cum_months)
select month, spending , previous_revenue, 
round(((spending - previous_revenue) *100.0/spending),2) as growth
from previous;

-- Q41- divide into four spending groups
with groupie as ( 
select c.customer_id ,c.customer_name, 
round(sum(o.quantity * o.unit_price * (1-o.discount/100)),2 ) as spending
from  customers c 
join orders o 
on o.customer_id = c.customer_id
where o.order_status = 'Completed'
group by c.customer_name , c.customer_id )
select customer_name , spending , ntile(4) over (order by spending desc)
from groupie ;

--Q42-Each category share of total revenue 

select
  o.product_category,
  round(sum(o.quantity * o.unit_price * (1 - o.discount/100)), 2) as revenue,
  round(100.0 * sum(o.quantity * o.unit_price * (1 - o.discount/100))
        / sum(sum(o.quantity * o.unit_price * (1 - o.discount/100))) over (), 2) as pct_of_total
from orders o
where o.order_status = 'Completed'
group by o.product_category
order by revenue desc;  

-- SECTION F 
--Q43 - Monthly_Sales_Summary 
create view vw_monthly_sales_summary as
select o.order_id , to_char(o.order_date,'FMonth'),
round(sum(o.quantity * o.unit_price * (1-o.discount/100)),2) as revenue,
sum(o.quantity*o.cost_price) as cost ,
(round(sum(o.quantity * o.unit_price * (1-o.discount/100)),2) - sum(o.quantity*o.cost_price)) as profit
from orders o 
group by o.order_id ;

select * from vw_monthly_sales_summary ; 

drop view if exists vw_monthly_sales_summary ; 

create view vw_monthly_sales_summary as
select o.order_id ,o.product_name , trim(to_char(o.order_date,'Month')) as month_name ,
round(sum(o.quantity * o.unit_price * (1-o.discount/100)),2) as revenue,
sum(o.quantity*o.cost_price) as cost ,
(round(sum(o.quantity * o.unit_price * (1-o.discount/100)),2) - sum(o.quantity*o.cost_price)) as profit
from orders o
where o.order_status ='Completed'
group by o.order_id
order  by o.order_id ;

--Q44 - PostgreSQL Function
create or replace function fn_completed_order_revenue(p_customer_id int) 
returns numeric 
language plpgsql 
as $$  
begin 
   return coalesce((
	select round(sum(o.quantity*o.unit_price*(1-o.discount/100.0)),2) as revenue 
	from orders o 
	where  o.customer_id = p_customer_id
	   and o.order_status = 'Completed'),0);
end;
$$;

select fn_completed_order_revenue(100);
select fn_completed_order_revenue (10000);
-- Q45 -  Thresholds
with kutumia as (
select c.customer_id, c.customer_name , 
round(sum(o.quantity*o.unit_price*(1-o.discount/100)),2) as revenue 
from customers c 
join orders o 
on o.customer_id = c.customer_id 
where o.order_status = 'Completed'
group by c.customer_id, c.customer_name ),
threshhold as(
select customer_id , customer_name , revenue,
ntile(3) over(order by revenue desc) as thresh
from kutumia)
select customer_id , customer_name ,revenue ,
case when revenue >= 179000 then 'High' 
when revenue >= 56600 then 'Medium' 
else 'Low'
end as segment
from threshhold ;

set search_path to duka_smart;
select * from customers;
select table_schema, table_name
from information_schema.tables
where table_name in ('customers', 'orders');

select current_database ();

-- Q46 - management report 
select c.customer_id , c.customer_name , 
round(sum(o.quantity * o.unit_price*(1-o.discount/100))) as total_spent 
from customers c
join orders o
on o.customer_id = c.customer_id 
where o.order_status = 'Completed'
group by c.customer_id , c.customer_name
order by total_spent desc
limit 5 ;

select o.product_category ,
round(sum(o.quantity*o.unit_price*(1-o.discount/100))) as total_spent
from orders o 
where o.order_status = 'Completed'
group by o.product_category
order by total_spent desc;

select o.product_name, 
round(sum(o.quantity*o.unit_price*(1-o.discount/100))) as total_spent
from orders o 
where o.order_status = 'Completed'
group by o.product_name
order by total_spent desc
limit 5 ;

select date_trunc('month',o.order_date):: date as month,
round(sum(o.quantity*o.unit_price*(1-o.discount/100))) as total_spent
from orders o 
where o.order_status = 'Completed'
group by date_trunc('month',o.order_date):: date 
order by total_spent asc
limit 5 ;
