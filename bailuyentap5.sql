--baitap1--
select b.continent, 
floor(avg(a.population))  
from city as a
inner join country as b
on a.countrycode=b.code
group by b.continent
--baitap2--
