--1--
select 
count( order_id) as total_order,
count(distinct user_id) as total_user,
FORMAT_DATE('%Y-%m', delivered_at) as month_year
from bigquery-public-data.thelook_ecommerce.order_items
where FORMAT_DATE('%Y-%m', delivered_at) between '2019-01'and '2022-04' and status = 'Complete'
group by 3
order by 3

--2--
 
select count(distinct user_id) as distinct_users,
round(sum(sale_price )/count(order_id),2) as average_order_value,
FORMAT_DATE('%Y-%m', delivered_at) as month_year
from bigquery-public-data.thelook_ecommerce.order_items
where FORMAT_DATE('%Y-%m', delivered_at) between '2019-01-01 00:00:00'and '2022-05-01 00:00:00' 
group by 3
order by 3

 
--3--

select first_name,last_name,age, gender,
case when age = 12 then 'youngest' else 'oldest' end tag
from bigquery-public-data.thelook_ecommerce.users 
where  FORMAT_DATE('%Y-%m', created_at) between '2019-01'and '2022-04' and age in (12,70)
order by 3,4

 With female_age as 
(
select min(age) as min_age, max(age) as max_age
from bigquery-public-data.thelook_ecommerce.users
Where gender='F' and created_at BETWEEN '2019-01-01 00:00:00' AND '2022-05-01 00:00:00'
),
male_age as 
(
select min(age) as min_age, max(age) as max_age
from bigquery-public-data.thelook_ecommerce.users
Where gender='M' and created_at BETWEEN '2019-01-01 00:00:00' AND '2022-05-01 00:00:00'
),
young_old_group as 
(
Select t1.first_name, t1.last_name, t1.gender, t1.age
from bigquery-public-data.thelook_ecommerce.users as t1
Join female_age as t2 on t1.age=t2.min_age or t1.age=t2.max_age
Where t1.gender='F'and created_at BETWEEN '2019-01-01 00:00:00' AND '2022-05-01 00:00:00'
UNION ALL
Select t3.first_name, t3.last_name, t3.gender, t3.age
from bigquery-public-data.thelook_ecommerce.users as t3
Join female_age as t4 on t3.age=t4.min_age or t3.age=t4.max_age
Where t3.gender='M' and created_at BETWEEN '2019-01-01 00:00:00' AND '2022-05-01 00:00:00'
),
age_tag as
(
Select *, 
Case 
     when age in (select min(age) as min_age
     from bigquery-public-data.thelook_ecommerce.users
     Where gender='F' and created_at BETWEEN '2019-01-01 00:00:00' AND '2022-05-01 00:00:00') then 'Youngest'
     when age in (select min(age) as min_age
     from bigquery-public-data.thelook_ecommerce.users
     Where gender='M'and created_at BETWEEN '2019-01-01 00:00:00' AND '2022-05-01 00:00:00') then 'Youngest'
     Else 'Oldest'
END as tag
from young_old_group 
)
Select gender, tag, count(*) as user_count
from age_tag
group by gender, tag


--4--

with cte1 as (
select sum(b.sale_price- a.cost) as profit,
 a.product_id, a.product_name, 
FORMAT_DATE('%Y-%m', b.delivered_at) as month_year 
from bigquery-public-data.thelook_ecommerce.inventory_items as a
join bigquery-public-data.thelook_ecommerce.order_items as b on a.id=b.id
join bigquery-public-data.thelook_ecommerce.products as c on a.id=c.id
where  b.status ='Complete'
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


--ii--
With category_data as
(
Select 
FORMAT_DATE('%Y-%m', t1.created_at) as Month,
FORMAT_DATE('%Y', t1.created_at) as Year,
t2.category as Product_category,
round(sum(t3.sale_price),2) as TPV,
count( t3.order_id) as TPO,
round(sum(t2.cost),2) as Total_cost
from bigquery-public-data.thelook_ecommerce.orders as t1 
Join bigquery-public-data.thelook_ecommerce.products as t2 on t1.order_id=t2.id 
Join bigquery-public-data.thelook_ecommerce.order_items as t3 on t2.id=t3.id
where t3.delivered_at is not null and t3.status = 'Complete'
Group by Month, Year, Product_category
)
Select Month, Year, Product_category, TPV, TPO,
round(cast((TPV - lag(TPV) OVER(PARTITION BY Product_category ORDER BY Year, Month))
      /lag(TPV) OVER(PARTITION BY Product_category ORDER BY Year, Month) as Decimal)*100.00,2) || '%'
       as Revenue_growth,
round(cast((TPO - lag(TPO) OVER(PARTITION BY Product_category ORDER BY Year, Month))
      /lag(TPO) OVER(PARTITION BY Product_category ORDER BY Year, Month) as Decimal)*100.00,2) || '%'
       as Order_growth,
Total_cost,
round(TPV - Total_cost,2) as Total_profit,
round((TPV - Total_cost)/Total_cost,2) as Profit_to_cost_ratio
from category_data
Order by Product_category, Year, Month







