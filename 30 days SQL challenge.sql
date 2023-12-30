set sql_safe_updates = 0;

update movie_data
SET release_date = CASE 
	when release_date like '%/%' then date_format(str_to_date(release_date, '%d/%m/%Y'), '%Y-%m-%d')
    when release_date like '%-%' then date_format(str_to_date(release_date, '%d-%m-%Y'), '%Y-%m-%d')
    else null
    end;
    
select * from movie_data;
    
describe movie_data;
    
alter table movie_data    
modify column release_date date;

-- Question 1
-- Using the Movie Data, Write a query to show the titles and movies released in 2017 whose vote count is more than 15 and runtime is more than 100

select release_date
from movie_data
where release_date between '2017- 01- 01' and  '2017 - 12 - 31'
and vote_count > 15 
and runtime > 100
order by 1 desc;
    
-- Question 2
-- Using the Pizza Data, Write a query to show how many pizzas were ordered

select distinct count( pizza_id) total_pizza_ordered
from customer_orders;

-- Question 3
-- Using the Pizza Data, Write a query to show how many successful orders were delivered by each runner

select runner_id, 
	count(order_id) No_of_successful_orders
from runner_orders
group by 1;

-- Question 4
-- Using the Movie Data, Write a query to show the top 10 movie titles whose language is English and French and the budget is more than 1,000,000
select title
from movie_data
where original_language = 'en' and original_language = 'fr'
						AND budget > 1000000;


-- Question 5
-- Using the Pizza Data, Write a query to show the number of each type of bread delivered

select p.pizza_name, count(c.pizza_id) pizza_delivered
from customer_orders c
join runner_orders r
on r.order_id = c.order_id
join pizza_names p
on p.pizza_id = c.pizza_id
group by 1;

set sql_safe_updates= 0;

update superstore
SET order_date = CASE 
	when order_date like '%/%' then date_format(str_to_date(order_date, '%d/%m/%Y'), '%Y-%m-%d')
    when order_date like '%-%' then date_format(str_to_date(order_date, '%d-%m-%Y'), '%Y-%m-%d')
    else null
    end;
    
update superstore
SET ship_date = CASE 
	when ship_date like '%/%' then date_format(str_to_date(ship_date, '%d/%m/%Y'), '%Y-%m-%d')
    when ship_date like '%-%' then date_format(str_to_date(ship_date, '%d-%m-%Y'), '%Y-%m-%d')
    else null
    end;

describe superstore;

alter table superstore
modify column Order_Date date;

alter table superstore
modify column Ship_Date date;


-- Question 6
-- The Briggs company wants to ship some of their products to customers in selected cities but they want to know the average days it’ll take to deliver those items to Dallas, Los Angeles, Seattle, and Madison. 
-- Using the Sample superstore data, 
-- Write a query to show the average delivery days to those cities. Only show the city and average delivery days columns in your output.

select City, round(avg(delivery_day),3)
from (select city, datediff(ship_date, order_date) delivery_day
	from superstore
	where city in ('Dallas', 'Los Angeles', 'Seattle', 'Madison')
	order by 2 desc) sub
group by 1
order by 2 desc;


-- Question 7
-- It's getting to the end of the year and the Briggs company wants to reward the customer who made the highest sales ever. 
-- Using the sample superstore data, 
-- Write a query to help the company identify this customer and category of business driving the sales. Let your output show the customer Name, the Category and the total sales. Round the total sales to the nearest whole number.

select Customer_name, Category, round(sum(sales),0) total_sales
from superstore
group by 1,2
order by 3 desc
limit 1;


-- Question 8
-- The Briggs Company has 3 categories of business generating revenue for the company. They want to know which of them is driving the business. 
-- Using the sample superstore data,
-- Write a query to show the total sales and percentage contribution by each category. Show category, Total Sales and Percentage contribution columns in your output.

select Category, 
	round(sum(sales),0) total_sales,
    round((sum(sales) / (select sum(sales) from superstore) * 100),1) percentage_contribution
    from superstore
group by 1
order by 3 desc;

-- Question 9
-- After seeing the Sales by Category, the Briggs company became curious and wanted to dig deeper to see which subcategory is selling the most. They need the help of an analyst. 
-- Please help the company to write a query to show the subcategory and the Total sales of each subcategory. Let your query display only the subcategory and the Total sales columns to see which product sells the most.

select distinct Sub_Category, 
	round(sum(sales),1) total_sales
from superstore
Group by 1
Order by 2 desc;

-- Question 10
-- Now that you’ve identified phones as the business driver in terms of revenue. The company wants to know the total “phones sales” by year to understand how “each year” performed. 
-- As the Analyst, please help them to show the breakdown of the total sales by year in descending order. Let your output show only Total sales and sales year column.

select round(sum(sales),0) total_sales, extract(year from Order_Date) sales_year 
	from superstore
	where sub_category = 'phones'
	group by 2
	order by 1 desc;

-- Question 11
-- The Director of Analytics has requested a detailed analysis of the Briggs company. To fulfill this request, he needs you to generate a table that displays the profit margin of “each segment”. The table should include the segments, total sales, total profit and the profit margin. 
-- To ensure accuracy, the profit margin should be arranged in descending order.
 
select segment, 
	round(sum(sales),1) total_sales,
    round(sum(profit),1) total_profit,
    round((sum(profit)/sum(sales) * 100),2) profit_margin
from superstore
group by 1
order by 4 desc;

create table profit_margin(
	segment text,
	total_sales float,
    total_profit float,
    profit_margin float
    );

insert into profit_margin
values ( 'Home Office', 424384.4, 59485, 14.02),
		('Corporate', 690322.3, 88833.1, 12.87),
        ('Consumer', 1148813.8, 132294.7, 11.52);
        
set sql_safe_updates = 0;

Delete from marketing_data 
where  marital = 'primary';

-- Question 12
-- As we conclude the analysis for the Briggs company, they got some reviews on their website regarding their new product. 
-- Please use the Bonus table to write a query that returns only the meaningful reviews. These are reviews that are readable in English. There are two columns in the table, let your output return only the review column.

select Review
from bonus_table
where translation is Null;


-- Question 13
-- Your company started consulting for a Micro Bank who needs to analyze their marketing data to understand their customers better. This will help them plan their next marketing campaign. You are brought on board as the analyst for this job. They have an offer for customers who are divorced but they need data to back up the campaign. 
-- Using the marketing data, write a query to show the percentage of customers who are divorced and have balances greater than 2000

-- select count(marital) total_divorced
-- 		from marketing_data
-- 		where marital = 'divorced' and balance > 2000;         

select round((select count(marital) total_divorced
				from marketing_data
				where marital = 'divorced' and balance > 2000) /count(marital) * 100,2) as percentage_divorced
from marketing_data;

-- Question 14
--  Micro Bank wants to be sure they have enough data for this campaign and would like to see the total count of each job as contained in the dataset. Using the marketing data, write a query to show the count of each job, arrange the total count in descending order

select distinct job, count(*) Total_count
from marketing_data
group by 1
order by 2 desc;

-- Question 15
-- Just for clarity purposes, your company wants to see which education level got to the management job the most. Let your output show the education, job and the count of jobs columns.

select education, job, count(*) job_count  
from marketing_data
where job = 'management'
group by 1,2
order by 2 desc
limit 1;

-- Question 16
-- Write a query to show the average duration of customers’ employment in management positions. The duration should be expressed in years. (Note: the duration record is in weeks)

select round(Avg(duration / 52),1) Avg_duration_yrs
from marketing_data
where job = 'management';

-- Question 17
-- What's the total number of customers that have housing, loan and are single?

select count(housing) count_customers, housing, loan, marital
from marketing_data
where housing = 'yes' and loan = 'yes' and marital = 'single'
group by 2,3,4;
 
-- Question 18
-- Using the Movie data, write a query to show the movie title with runtime of at least 250. Show the title and runtime columns in your output

select title,runtime
from moviedata
where runtime >= 250;

-- Question 19
-- Using the Employee Data, 
-- Write a query to show all the employees first name and last name and their respective salaries. Also, show the overall average salary of the company and calculate the difference between each employee's salary and the company average salary

select  first_name, last_name, salary, 
	(select round(avg(salary),0) avg_salary from employeetable) company_average,
    (salary - (select round(avg(salary),0) avg_salary from employeetable)) salary_diff
from employeetable;

-- OR B

With origin as(
		select first_name, last_name, salary from employeetable),
	avg_sal (company_average) as(
		select round(avg(salary),0) from employeetable)
select o.*, company_average, (salary - company_average) sal_diff
from origin o, avg_sal;
        
-- Question 20
-- Using the Share price Data, 
-- Write a query to show a table that displays the highest daily decrease and the highest daily increase in share price.

select 
min(round(CASE when (_close - _open) then (_close - _open) else null end,2)) highest_daily_decrease,
max(round(CASE When (_close - _open) then (_close - _open) else null end,2)) highest_daily_increase
from shareprice;

-- Question 21
-- Our client is planning their logistics for 2024, they want to know the average number of days it takes to ship to the top 10 states. Using the sample superstore datasets, write a query to show the state and the average number of days between the order date and the ship date to the top 10 states.

 with sub as (
	select state, avg(datediff(Ship_Date, order_date)) AvgDaysBetweenOrderandShip
	from superstore
	group by 1
	order by 2
	)

select state, floor(AvgDaysBetweenOrderandShip) AvgDaysBetweenOrderandShip
from sub
limit 10;

-- Question 22
-- Your company received a lot of bad reviews about some of your products lately and the management wants to see which products have been returned so far.
-- Using the orders and returns table, 
-- Write a query to see the top 5 most returned products.

select s.product_name, s.Product_ID, count(r.returned) product_count
from returns r
join superstore s
on r.Order_ID = s.Order_ID
group by 1,2
order by 3 desc
limit 5;

-- Question 23
-- Using the Employee data,
-- Write a query to show the ratio of the analyst job title to the entire job titles

Select (select count(job_title) from employeetable where job_title = 'Analyst') Analystcount, 
	round((select count(job_title) from employeetable where job_title = 'Analyst')/ count(job_title) * 100,0) AnalystToRatio
from employeetable;

-- Quetion 24
-- Using the Sample superstore data,
-- Write a query to find the 3rd highest sales.
select Sales 
from superstore
order by Sales DESC
limit 1
offset 2;

-- Question 25
-- Using the Employee Data,
-- Write a query to show the job title and department with the highest salary

select distinct job_title, department
from employeetable
where salary = (select max(salary)
from employeetable); 

-- Question 26
-- Using the Employee Data,
-- Write a query to determine the rank of employees based on their salaries in each department. For each department, find the employee(s) with the highest salary and rank them in descending order

select first_name, last_name, department, salary,
	rank() over (partition by department order by salary desc) as department_salary_rank
from employeetable;











