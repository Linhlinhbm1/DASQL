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
