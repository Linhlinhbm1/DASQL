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
