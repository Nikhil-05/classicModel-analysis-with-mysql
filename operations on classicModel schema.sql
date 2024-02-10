SELECT email, jobTitle FROM classicmodels.employees
where jobTitle='Sales Rep';

select * 
from classicmodels.employees
where lower(FirstName)='leslie';

select * 
from classicmodels.employees
where upper(email)='DMURPHY@CLASSICMODELCARS.COM';

select *, upper(firstname) as uppercasename
from classicmodels.employees;

select *
from classicmodels.employees
where lower(email) in
('pmarsh@classicmodelcars.com',
'gbondur@classicmodelcars.com',
'abow@classicmodelcars.com');

select *
from classicmodels.employees
where lower(email) not in
('pmarsh@classicmodelcars.com',
'gbondur@classicmodelcars.com',
'abow@classicmodelcars.com');

select distinct country
from classicmodels.customers;

select * 
from classicmodels.customers
where city 
like '%New%';

select distinct country
from classicmodels.customers
where city
like '%New%';

select distinct country
from classicmodels.customers
where country
like '%New%';

select * 
from classicmodels.employees
order by lastname;

select * 
from classicmodels.employees
order by lastname desc;

select * 
from classicmodels.orders t1
inner join classicmodels.customers t2
on t1.customerNumber = t2.customerNumber;


select * 
from classicmodels.orders t1
inner join classicmodels.customers t2
on t1.customerNumber = t2.customerNumber
where t1.customerNumber = 141;

select firstname, lastname, customername, employeeNumber
from classicmodels.employees t1
left join classicmodels.customers t2
on t1.employeeNumber = t2.salesRepEmployeeNumber;

select firstname, lastname, customername, salesRepEmployeeNumber
from classicmodels.customers t1
right join classicmodels.employees t2
on t1.salesRepEmployeeNumber = t2.employeeNumber;


select t2.contactFirstName, t2.contactLastName, t1.orderDate, t1.status
from classicmodels.orders t1
inner join classicmodels.customers t2
on t1.customerNumber = t2.customerNumber;

select  t1.contactFirstName, t1.contactLastName, t2.orderDate, t2.status
from classicmodels.customers t1 
left join classicmodels.orders t2 
on t1.customerNumber = t2.customerNumber;

select 
'customer' as type,
contactFirstName,contactLastName
from classicmodels.customers
union 
select 
'employee' as type,
firstName as contactFirstName,
lastName as contactLastname
from classicmodels.employees;

select 
'customer' as type,
contactFirstName,contactLastName
from classicmodels.customers
union all
select 
'employee' as type,
firstName as contactFirstName,
lastName as contactLastname
from classicmodels.employees;


select paymentDate, sum(amount)
as total_payments
from classicmodels.payments
group by paymentDate;

select paymentDate, round(sum(amount),1)
as total_payments
from classicmodels.payments
group by paymentDate;

select paymentDate, round(sum(amount),1)
as total_payments
from classicmodels.payments
group by paymentDate
having total_payments > 50000
order by total_payments desc;

select count(ordernumber) as orders
from classicmodels.orders;

select productcode, count(ordernumber) as orders
from classicmodels.orderdetails
group by productCode;

select paymentdate,
max(amount) as highest_payment,
min(amount) as lowest_payment
from classicmodels.payments
group by paymentDate
having paymentDate = '2003-12-09';

/* show the customer name of company which made the most amount of order*/

select customerName, count(orderNumber) as orders
from classicmodels.orders t1
inner join classicmodels.customers t2
on t1.customerNumber = t2.customerNumber
group by customerName
order by orders desc
limit 1 ;

/* display each customers first and last order date */
select customerName, min(orderDate) as first_order, max(orderDate) as last_order
from classicmodels.orders t1
inner join classicmodels.customers t2
on t1.customerNumber = t2.customerNumber
group by customerName;

/* subquery */
select * 
from 
(select orderdate, count(ordernumber) as orders
from classicmodels.orders
group by orderDate)t1;


select avg(orders)
from 
(select orderdate, count(ordernumber) as orders
from classicmodels.orders
group by orderDate)t1;

/* cte - common table expression */
with cte_orders as 
(select orderdate, count(ordernumber) as orders
from classicmodels.orders
group by orderDate)
select * 
from cte_orders;

/*case statement*/
select 
case 
when creditlimit < 75000 then 'a: less than $75k'
when creditlimit between 75000 and 100000 then 'b:$75k-$100k'
when creditlimit between 100000 and 150000 then 'c:$100k-150k'
when creditlimit > 150000 then 'd: over 150k'
else 'other' end as credit_limit_grp,
count(distinct customernumber) as customers
from classicmodels.customers
group by 1 ;

/* case statement analyzation*/

select t1.ordernumber, orderdate,quantityordered,productname,productline,
case
when quantityordered > 40 and productline='motorcycles' then 1 
else 0 
end as ordered_above_40_motorcycles
from classicmodels.orders t1
join classicmodels.orderdetails t2 
on t1.orderNumber = t2.orderNumber
join classicmodels.products t3
on t2.productCode = t3.productCode;


with main_cte as 
(
select t1.ordernumber, orderdate,quantityordered,productname,productline,
case
when quantityordered > 40 and productline='motorcycles' then 1 
else 0 
end as ordered_above_40_motorcycles
from classicmodels.orders t1
join classicmodels.orderdetails t2 
on t1.orderNumber = t2.orderNumber
join classicmodels.products t3
on t2.productCode = t3.productCode
)
select orderdate, sum(ordered_above_40_motorcycles) 
as over_40_bike_sale
from main_cte
group by orderdate;

/* we want to see each customers orders in a result set, ordered by date from oldest to newest */

select customernumber, t1.ordernumber,
row_number() over (partition by customernumber order by orderdate) as purchase_number
from classicmodels.orders t1
order by customerNumber, t1.orderNumber;


select 
distinct 
t3.customername, t1.customernumber, t1.ordernumber, orderdate, productcode,
row_number()
over
(partition by t3.customernumber order by orderdate) 
as purchase_number
from classicmodels.orders t1
join classicmodels.orderdetails t2
on t1.orderNumber = t2.orderNumber
join classicmodels.customers t3 
on t1.customerNumber = t3.customerNumber
order by t3.customerName;

/* access data in the next row of ordered output */
select customernumber, paymentdate, amount,
lead(amount)
over
(partition by customernumber
order by paymentdate)
as next_payments
from classicmodels.payments;

/* access data in the previous row of ordered output */
select customernumber, paymentdate, amount,
lag(amount)
over
(partition by customernumber
order by paymentdate)
as prev_payments
from classicmodels.payments;

/* display the orderdate, ordernumber, salesrepemployeenumber for each sales reps second order */
with cte 
as
(select t1.orderdate, t1.ordernumber, t2.salesrepemployeenumber,
row_number()
over
(partition by salesRepEmployeeNumber
order by orderDate)
as repordernumber
from classicmodels.orders t1
join classicmodels.customers t2
on t1.customerNumber = t2.customerNumber
join classicmodels.employees t3
on t2.salesRepEmployeeNumber = t3.employeeNumber)
select *
from cte
where repordernumber=2;

/* return the date part each in different colomn as date, month and year */
select ordernumber,orderdate,
year(orderdate) 
as year,
month(orderdate) 
as month,
day(orderdate)
as day 
from classicmodels.orders;

/* show difference b/w two dates*/
select ordernumber,
datediff(requireddate,orderdate) days_until_required
from classicmodels.orders;

/* add days, months or years from a date coloumn using this function*/
select ordernumber, orderdate,
date_add(requireddate,interval 1 year) as one_year_from_order
from classicmodels.orders;

/* change datatype of any coloumn */
select *,
cast(paymentdate as datetime) as datetime_type
from classicmodels.payments;

/* substring */
select customernumber, paymentdate,
substring(paymentdate, 1,7) as month_key
from classicmodels.payments;

/*  concat first name and lastname */
select employeenumber,lastname,firstname,
concat(firstname,' ',lastname) as fullname
from classicmodels.employees;


select * from classicmodels.customers
where contactLastName = 'Young';

select * from classicmodels.customers
where contactLastName <> 'Young';

select customerName, contactFirstName, contactLastName, phone, city, country
from classicmodels.customers
where contactFirstName = 'Julie' and country= 'USA';

select contactFirstname, contactLastName, country
from classicmodels.customers
where country='Norway' or country='Sweden';

select * from classicmodels.customers
where contactLastName='Brown' and country='USA';



