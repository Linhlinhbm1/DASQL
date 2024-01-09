--baitap1--
SELECT 
  SUM(CASE WHEN device_type = 'laptop' THEN 1 ELSE 0 END) AS laptop_views, 
  SUM(CASE WHEN device_type IN ('tablet', 'phone') THEN 1 ELSE 0 END) AS mobile_views 
FROM viewership;
--baitap2--
select * ,
   case
       when x+y>z and y+z>x and z+x>y then 'Yes'
       else 'No'
   end as triangle 
from Triangle
--baitap3--
--baitap4--
--baitap5--
select survived, 
  sum (case
    when pclass = '1' then 1
  end) as first_class, 
  sum (case
    when pclass = '2' then 1
  end) as second_class,
  sum (case
    when pclass = '3' then 1
  end) as second_class
from titanic
group by  survived
