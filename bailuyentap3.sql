--baitap1--
select name
from students
where marks > 75
order by right (name,3),
id
--baitap2--
select user_id, 
concat( upper(left(name,1)) , lower( right(name, length(name)-1 ))) as name
from users
--baitap3--
SELECT manufacturer,
'$' || ROUND(sum( total_sales)/1000000,0) || ' ' || 'million' AS sale
FROM pharmacy_sales
GROUP BY manufacturer
ORDER BY 
sum( total_sales) DESC,
manufacturer 
--baitap4--
SELECT  product_id,
round( AVG(stars),2) as avg_stars,
EXTRACT( month from submit_date ) as mth
FROM reviews
GROUP BY EXTRACT( month from submit_date ),product_id
ORDER BY EXTRACT( month from submit_date ), product_id
--baitap5--
SELECT  sender_id,
 count(message_id)
FROM messages 
where EXTRACT(month from sent_date) = 8
and EXTRACT(year from sent_date) = 2022
group by sender_id
ORDER BY count(message_id) DESC
limit 2
--baitap6--
select tweet_id from Tweets 
where length(content) > 15    
--baitap8--
select 
count (id)
from employees
where extract (month from joining_date) between 1 and 7
and extract (year from joining_date) = 2022
--baitap9--
select position( 'a' in first_name)
from worker
where first_name = 'Amitah'
--baitap10--
select substring (title from  position ('2' in title) for 4)
from winemag_p2
where country ='Macedonia'


