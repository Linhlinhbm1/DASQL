--baitap1--
select b.continent, 
floor(avg(a.population))  
from city as a
inner join country as b
on a.countrycode=b.code
group by b.continent
--baitap2--

--baitap3--
SELECT 
    b.age_bucket,
    round( 100* sum(a.time_spent) filter (WHERE a.activity_type='send')/sum(a.time_spent),2) AS send_perc,
    round( 100* sum(a.time_spent) filter (WHERE a.activity_type='open')/sum(a.time_spent),2) AS open_perc
FROM activities as a
inner join age_breakdown as b 
on a.user_id=b.user_id
where a.activity_type in ('open','send')
GROUP BY b.age_bucket
--baitap4--
SELECT a.customer_id 
FROM customer_contracts as a  
left join products as b 
on a.product_id=b.product_id
group by a.customer_id
having count (DISTINCT b.product_category) =3

--baitap5--
select  a.product_name,
sum(unit) as unit                        
from Products as a
inner join Orders as b
on a.product_id = b.product_id 
where month(b.order_date )=2
group by a.product_name
having sum(unit) >=100 


