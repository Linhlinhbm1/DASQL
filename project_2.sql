--1--
select 
count(order_id) as total_order,
count(distinct user_id) as total_user,
FORMAT_DATE('%Y-%m', delivered_at) as month_year
from bigquery-public-data.thelook_ecommerce.order_items
where FORMAT_DATE('%Y-%m', delivered_at) between '2019-01'and '2022-04' 
group by 3
order by 3

--2--
 
select count(distinct user_id) as distinct_users,
sum(sale_price )/count(order_id) as average_order_value,
FORMAT_DATE('%Y-%m', delivered_at) as month_year
from bigquery-public-data.thelook_ecommerce.order_items
where FORMAT_DATE('%Y-%m', delivered_at) between '2019-01'and '2022-04' 
group by 3
order by 3

 
--3--

select first_name,last_name,age, gender,
case when age = 12 then 'youngest' else 'oldest' end tag
from bigquery-public-data.thelook_ecommerce.users 
where  FORMAT_DATE('%Y-%m', created_at) between '2019-01'and '2022-04' and age in (12,70)
order by 3,4

--4--

with cte1 as (
select sum(b.sale_price- a.cost) as profit,
 a.product_id, a.product_name, 
FORMAT_DATE('%Y-%m', b.delivered_at) as month_year 
from bigquery-public-data.thelook_ecommerce.inventory_items as a
join bigquery-public-data.thelook_ecommerce.order_items as b on a.id=b.id
join bigquery-public-data.thelook_ecommerce.products as c on a.id=c.id
where FORMAT_DATE('%Y-%m', b.delivered_at) is not null and b.status ='Complete'
group by 2,3,4),
cte2 as (
select *, dense_rank() over (partition by month_year order by profit desc ) as rank_per_month from cte1)
select * from cte2
where rank_per_month <=5
order by month_year asc , rank_per_month asc 

--5--

with cte1 as (
select a.category as category,FORMAT_DATE('%Y-%m-%d', b.delivered_at) as dates, b.sale_price as sale_price
from bigquery-public-data.thelook_ecommerce.products as a
 join bigquery-public-data.thelook_ecommerce.order_items as b  on a.id=b.id
 where FORMAT_DATE('%Y-%m-%d', b.delivered_at) between '2022-01-15' and '2022-04-15'and b.status ='Complete' )
 select category,dates,
 sum(sale_price) as revenue from cte1
 group by 1,2
 order by 2







