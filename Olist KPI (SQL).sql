create database olist_store;

use olist_store;

create table customers(customer_id varchar(100),customer_unique_id varchar(100),customer_zip_code_prefix int,customer_city char(100),customer_state char(100));

LOAD DATA INFILE 'C:/ProgramData/MySQL/olist_customers_dataset.csv'
INTO TABLE customers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

create table sellers(seller_id varchar(100),seller_zip_code_prefix int,seller_city char(100),seller_state char(50));

LOAD DATA INFILE 'C:/ProgramData/MySQL/olist_sellers_dataset.csv'
INTO TABLE sellers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

create table orders(order_id varchar(100),
customer_id varchar(100),
order_status char(50),
order_purchase_timestamp date,
order_delivered_customer_date date);

drop table orders;

LOAD DATA INFILE 'C:/ProgramData/MySQL/olist_orders_dataset.csv'
INTO TABLE orders
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

create table item(order_id varchar(100),
order_item_id int,
product_id varchar(100),
seller_id varchar(100),
shipping_limit_date date,
price int,freight_value int);

LOAD DATA INFILE 'C:/ProgramData/MySQL/olist_order_items_dataset.csv'
INTO TABLE item
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

create table product(product_id varchar(100),product_category_name varchar(200));

LOAD DATA INFILE 'C:/ProgramData/MySQL/olist_products_dataset.csv'
INTO TABLE product
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

create table review(review_id varchar(100),order_id varchar(100),review_score int);

LOAD DATA INFILE 'C:/ProgramData/MySQL/olist_order_reviews_dataset_1.csv'
INTO TABLE review
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

create table payment(order_id varchar(100),payment_sequential int,payment_type char(50),payment_installments int,payment_value int);

LOAD DATA INFILE 'C:/ProgramData/MySQL/olist_order_payments_dataset.csv'
INTO TABLE payment
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


use olist_store;

# KPI-1
# Weekday Vs Weekend (order_purchase_timestamp) Payment Statistics
Select 
    If(weekday(o.order_purchase_timestamp) < 5, 'Weekday', 'Weekend') AS `Day_type`,
    SUM(p.payment_value) AS `Total_Payment_Value`
from orders o
join payment p
	on o.order_id = p.order_id
group by `Day_type`;


#kpi 2
#Number of Orders with review score 5 and payment type as credit card.

select  r.review_score,p.payment_type, count(r.order_id) as no_of_orders
from review r
join payment p
	on r. order_id = p. order_id
where review_score = 5 and payment_type = 'credit_card';

#kpi_3
#Average number of days taken for order_delivered_customer_date for pet_shop
select 
	avg(datediff(o.order_delivered_customer_date,o.order_purchase_timestamp)) as avg_delivery_days
from orders o
join  item i
	on o.order_id = i.order_id
join products pr
    on i.product_id = pr.product_id   
where product_category_name = 'pet_shop';

#kpi_4
#Average price and payment values from customers of sao paulo city

Select avg(i.price) AS average_price, avg(p.payment_installments*p.payment_value) AS average_payment
from item i
join payment p
	on i.order_id = p.order_id 
join sellers s
	on i.seller_id = s.seller_id 
where seller_city = 'sao paulo';

#kpi_5
#Relationship between shipping days (order_delivered_customer_date - order_purchase_timestamp) Vs review scores.
Select round(avg(Datediff(o.order_delivered_customer_date, o.order_purchase_timestamp))) as avg_shipping_days
from orders o
join review r 
	on o.order_id = r.order_id
group by review_score;


