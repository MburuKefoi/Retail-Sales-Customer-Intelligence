create schema Duka_Smart ;
set search_path to Duka_Smart;

create table customers(
customer_id int primary key,
customer_name varchar(100) not null , 
gender varchar(10) check (gender in ('Male','Female')),
city varchar(50),
registration_date date,
customer_segment varchar(20) check (customer_segment in ('Retail','Corporate','VIP')));

create table orders(
order_id int primary key ,
customer_id int not null references customers(customer_id),
order_date date not null , 
product_name varchar(100),
product_category varchar(50),
quantity int check (quantity > 0),
unit_price numeric(12,2) check(unit_price >= 0),
cost_price numeric (12,2) check(cost_price >=0),
discount numeric(5,2) default 0 check(discount between 0 and 100),
payment_method varchar(30) check(payment_method in ('M-Pesa','Cash','Card','Bank Transfer')),
order_status varchar(20) check(order_status in ('Completed','Pending','Cancelled')));

create index if not exists idx_orders_customer on orders(customer_id);
create index if not exists idx_orders_date on orders(order_date);
