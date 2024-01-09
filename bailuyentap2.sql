--baitap1--
SELECT DISTINCT CITY FROM STATION
WHERE ID LIKE '%0' OR ID LIKE '%2' OR ID LIKE '%4'
OR ID LIKE '%6' OR ID LIKE '%8'
--baitap2--
select count(city) - count( distinct city ) from station
--baitap3--

--baitap4--
SELECT round( cast( sum ( item_count * order_occurrences ) / sum ( order_occurrences)  as 
decimal ) , 1) as mean
from items_per_order
--baitap5--
SELECT candidate_id	 FROM candidates
where skill in( 'Python', 'Tableau', 'PostgreSQL' )
GROUP BY candidate_id
having count(skill)= 3
-- baitap6--
SELECT user_id, DATE(max(post_date)) - DATE( min(post_date)) as days_between
FROM posts
WHERE post_date >= '2021-01-01' and post_date < '2022-01-01'
group by user_id
having count ( user_id) >=2
--baitap7--
SELECT card_name, max(issued_amount)- min(issued_amount) as difference
FROM monthly_cards_issued
group by card_name
order BY difference DESC
-- BAITAP8-- 
SELECT manufacturer,
COUNT(DRUG) AS drug_count,
ABS ( SUM(cogs-total_sales)) AS total_loss
FROM pharmacy_sales
WHERE total_sales< cogs
GROUP BY manufacturer
ORDER BY total_loss DESC
--baitap9--
select * from cinema
where id%2=1 and description <> 'boring'
order by rating  desc
-- baitap10-- 
select teacher_id, 
count(distinct subject_id ) as cnt from teacher
group by teacher_id
--baitap11--
select class from courses
group by class
having count(student) >=5
