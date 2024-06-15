
--1--

ALTER TABLE public.sales_dataset_rfm_prj
ALTER COLUMN ordernumber TYPE integer USING (trim(ordernumber)::integer);

ALTER TABLE public.sales_dataset_rfm_prj
ALTER COLUMN quantityordered TYPE numeric USING (trim(quantityordered)::numeric);

ALTER TABLE public.sales_dataset_rfm_prj
ALTER COLUMN priceeach TYPE numeric USING (trim(priceeach)::numeric);

ALTER TABLE public.sales_dataset_rfm_prj
ALTER COLUMN orderlinenumber TYPE integer USING (trim(orderlinenumber)::integer);

ALTER TABLE public.sales_dataset_rfm_prj
ALTER COLUMN sales TYPE numeric USING (trim(sales)::numeric);

ALTER TABLE public.sales_dataset_rfm_prj
ALTER COLUMN orderdate TYPE date USING (trim(orderdate)::date);

ALTER TABLE public.sales_dataset_rfm_prj
ALTER COLUMN msrp TYPE integer USING (trim(msrp)::integer);


--2--


--3--
alter table public.sales_dataset_rfm_prj
add column CONTACTFIRSTNAME varchar(50);

update public.sales_dataset_rfm_prj
set CONTACTFIRSTNAME = upper(left (contactfullname,1))||
right( left (contactfullname, position('-' in contactfullname )-1), position('-' in contactfullname )-2)
where CONTACTFIRSTNAME  is null;

update public.sales_dataset_rfm_prj
set CONTACTLASTNAME  = upper( left( right (contactfullname, length(contactfullname)-position('-' in contactfullname )),1)) || 
  right (contactfullname, length(contactfullname)-position('-' in contactfullname )-1)
where CONTACTLASTNAME  is null;


--4--

alter table sales_dataset_rfm_prj
add column MONTH_ID numeric;
update public.sales_dataset_rfm_prj
set MONTH_ID = extract(month from orderdate )
where MONTH_ID is null;

alter table sales_dataset_rfm_prj
add column YEAR_ID  numeric;
update public.sales_dataset_rfm_prj
set YEAR_ID  = extract(year from orderdate )
where YEAR_ID  is null;

alter table sales_dataset_rfm_prj
add column QTR_ID  numeric;
update public.sales_dataset_rfm_prj
set QTR_ID  = case 
                    when MONTH_ID in (1,2,3) then 1
				            when MONTH_ID in (4,5,6) then 2
				          	when MONTH_ID in (7,8,9) then 3
				           	when MONTH_ID in (10,11,12) then 4
				end
where QTR_ID  is null


--5--
with cte1 as (
select Q1-1.5*IQR as min_value,
	Q3 + 1.5*IQR as max_value
from (
select
percentile_cont(0.25) within group ( order by QUANTITYORDERED ) as Q1 
percentile_cont(0.75) within group ( order by QUANTITYORDERED ) as Q3 
percentile_cont(0.75) within group ( order by QUANTITYORDERED ) - percentile_cont(0.25) within group ( order by QUANTITYORDERED ) as IQR 
from sales_dataset_rfm_prj) as a)
select * from sales_dataset_rfm_prj 
where QUANTITYORDERED < (select min_value from cte1) or QUANTITYORDERED > (select max_value from cte1)













