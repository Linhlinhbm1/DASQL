--baitap1--
WITH cmn_ii as (
SELECT 
count( job_id) as duplicate_companies
from job_listings 
group by company_id
having count(DISTINCT job_id) >= 2)
SELECT count(*) as duplicate_companies from cmn_ii
  
--baitap2--
WITH appliance_spend as
(SELECT category,product, SUM (spend) as total_spend
FROM product_spend
WHERE EXTRACT( year from transaction_date) = 2022 AND 
category= 'appliance'
group by category,product
ORDER BY  total_spend DESC
LIMIT 2), 
electronics_spend as
(SELECT category,product, SUM (spend) as total_spend
FROM product_spend
WHERE EXTRACT( year from transaction_date) = 2022 AND 
category= 'electronics'
group by category,product
ORDER BY total_spend desc
LIMIT 2)
select category,product, total_spend from appliance_spend
union all select category,product,total_spend  from electronics_spend
  
--baitap3--
With hehe as (
SELECT  count (case_id) 
from callers 
group by policy_holder_id 
having count (policy_holder_id) >=3)
SELECT count (*) policy_holder_count from hehe
  
--baitap4--
SELECT a.page_id
FROM pages as a
left join page_likes as b
on a.page_id=b.page_id
WHERE b.liked_date is null
ORDER BY a.page_id
  
--baitap5--
WITH july AS 
(SELECT user_id, 
EXTRACT(month from event_date) AS month
FROM user_actions
WHERE EXTRACT(month from event_date) = 7),
june AS
(SELECT user_id
FROM user_actions
WHERE EXTRACT(month from event_date) = 6)
SELECT month,
    COUNT(DISTINCT july.user_id) AS monthly_active_users
FROM july
JOIN june
ON june.user_id = july.user_id
GROUP BY month

--baitap6--
with 
cte1 as
(select to_char(trans_date,'yyyy-mm') as month, country,
sum(amount ) as trans_total_amount ,
count (state ) as trans_count 
from Transactions
group by to_char(trans_date,'yyyy-mm') ,country),
cte2 as
(select to_char(trans_date,'yyyy-mm') as month, country,
sum(amount ) as approved_total_amount ,
count (state ) as approved_count 
from Transactions
where state='approved'
group by to_char(trans_date,'yyyy-mm') ,country) 
select a.month, a.country, a.trans_total_amount, a.trans_count, b.approved_total_amount, b.approved_count 
from cte1 as a 
join cte2 as b
on a.country=b.country and a.month=b.month

--baitap7--
SELECT product_id, year as first_year, quantity,price
FROM Sales
WHERE (product_id,year) in
(SELECT product_id,MIN(year)
FROM Sales
GROUP BY product_id)
  
--baitap8--
select customer_id
from Customer
group by customer_id
having count(distinct product_key)=2
  
--baitap9--
select employee_id from Employees where salary <30000
and manager_id not in (select employee_id from Employees)
order by employee_id 
  
--baitap11--
with cte1 as
(select a.name as results
 from Users as a
join MovieRating as b on a.user_id=b.user_id 
join Movies  as c on b.movie_id=c.movie_id
group by a.name
having  sum(b.movie_id )=6 
order by a.name
limit 1 ),
cte2 as
(select c.title
from Users as a
join MovieRating as b on a.user_id=b.user_id 
join Movies  as c on b.movie_id=c.movie_id
where to_char(created_at,'yyyy-mm')='2020-02'
group by c.title
order by  avg(b.rating) desc, c.title 
limit 1)
select *  from cte1 union all select * from cte2

--baitap12--
with a as
(select requester_id as id from RequestAccepted
union all
select accepter_id as id from RequestAccepted)
select id, count(id) as num
from a
group by id
order by num desc
limit 1
