--baitap1--
SELECT extract(year from transaction_date) as year,product_id, 
spend as curr_year_spend,
lag(spend) over (partition by product_id order by transaction_date) as prev_year_spend,
round( (spend - lag(spend) over (partition by product_id order by transaction_date))*100/ lag(spend) over (partition by product_id order by transaction_date),2)
 FROM user_transactions
--baitap2--
SELECT card_name,
min(issued_amount) as issued_amount
from monthly_cards_issued
group by card_name 
ORDER BY card_name desc
--baitap3--
with cte1 as
(SELECT user_id, spend, transaction_date,
rank() over(partition by user_id order by transaction_date ) as hehe
FROM transactions
ORDER BY user_id, transaction_date) 
select user_id, spend, transaction_date
from cte1
where hehe =3
--baitap4--
with cte1 as  
(SELECT user_id,
transaction_date,
RANK() over (partition by user_id order by transaction_date desc) as rank_id
from user_transactions)
SELECT user_id, transaction_date,
count(*) as purchase_count
from cte1
where rank_id =1
group by user_id, transaction_date
ORDER BY transaction_date
--BAITAP5--
SELECT user_id, tweet_date,
case 
   WHEN lag(tweet_count) over(PARTITION BY user_id order by tweet_date) is null
       and  lag(tweet_count,2) over(PARTITION BY user_id order by tweet_date) is null then round(tweet_count,2)
   WHEN lag(tweet_count) over(PARTITION BY user_id order by tweet_date) is not null
       and lag(tweet_count,2) over(PARTITION BY user_id order by tweet_date) is null then 
       round ( (tweet_count+ lag(tweet_count) over(PARTITION BY user_id order by tweet_date))::decimal/2 ,2 )
    else round ((tweet_count+lag(tweet_count) over(PARTITION BY user_id order by tweet_date)+
               lag(tweet_count,2) over(PARTITION BY user_id order by tweet_date))::decimal /3,2)
    end as rolling_avg_3d
FROM tweets

--baitap6--
with cte1 as 
(SELECT 
merchant_id, credit_card_id,  amount,
EXTRACT( hour from transaction_timestamp - lag(transaction_timestamp) over (PARTITION BY merchant_id, credit_card_id,  amount))*60+
EXTRACT(minute from transaction_timestamp - lag(transaction_timestamp) over (PARTITION BY merchant_id, credit_card_id,  amount)) as time
FROM transactions)
select count(*) payment_count from cte1
where time BETWEEN 0 and 10
 
-- baitap7--
with cte1 as
(SELECT CATEGORY,PRODUCT,SUM(SPEND) AS TOTAL_SPEND,
RANK() OVER(PARTITION BY CATEGORY ORDER BY SUM(SPEND) DESC) AS rank_id
FROM product_spend
WHERE EXTRACT(YEAR FROM TRANSACTION_DATE)=2022
GROUP BY  CATEGORY,PRODUCT)
SELECT CATEGORY, PRODUCT,TOTAL_SPEND
from cte1
where rank_id <3
--baitap8--
with cte1 as
(SELECT a.artist_name as artist_name,
count(c.rank) as count_rank,
dense_rank() over(order by count(c.rank) desc) as artist_rank
FROM artists as a
join songs  as b on a. artist_id=b.artist_id
join global_song_rank  as c on c.song_id=b.song_id
where c.rank <=10
group by a.artist_name)
select artist_name,artist_rank 
from cte1
where artist_rank <6




