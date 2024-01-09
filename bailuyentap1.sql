-- baitap1--
select name from city
where population > 120000
and CountryCode='USA'
-- baitap2--
select * from city
where countrycode='JPN'
--baitap3--
select city, state from station
--baitap4--
select distinct city from station
where city like 'a%' or city like 'e%' or city like 'i%' or city like 'o%'
or city like 'u%'
--baitap5--
select distinct city from station
where city like '%a' or city like '%e' or city like '%i' or city like '%o'
or city like '%u'
-- baitap6-
select distinct city from station
where city not like 'a%' and city not like 'e%' and city not like 'i%' 
and city not like 'o%' and city not like  'u%'

--baitap7--
select name from employee 
order by name 
--baitap8-
select name from employee
where salary > 2000 and months < 10
order by employee_id
-- baitap9--
select product_id from products
where low_fats='Y' and  recyclable='Y'
--baitap10--
select name from customer
where  not referee_id =2 or referee_id is null
-- baitap11
select name, population, area from world
where area >=3000000 or population >= 25000000
--baitap12--
select distinct author_id as id from views 
where author_id= viewer_id
order by author_id
--baitap13--
SELECT part, assembly_step FROM parts_assembly
where finish_date is null
-- baitap 14--
select * from lyft_drivers
where  yearly_salary < 30000 or yearly_salary >=70000

--baitap15
select advertising_channel from uber_advertising
where year= 2019 and money_spent > 100000
