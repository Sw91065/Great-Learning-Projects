-- Datasets Used: cust_dimen.csv
-- 1.	Convert all decimal values in MonthlyServiceCharges to the smallest integer value that is greater than or equal to number.
select * from churn1;

select customerID,gender,ceiling(Monthlyservicecharges) from churn1;
select customerid,gender,ceiling(monthlyservicecharges) from churn1;

-- 2.	Convert SeniorCitizen (1 and 0) values to true and  false respectively.
select if(seniorcitizen=1,'True','False') from churn1;
select seniorcitizen,if(seniorcitizen=1,'True','False') as bool from churn1;

-- 3.	Combine Year Date Month in one new column as DateDemo.
select * from ecommerce_new;
select *,str_to_date(demo,'%YYYY-%m-%d') from
(select Product_ID,retail_price,concat(year,'-',Month,'-',date) as demo from ecommerce_new) as ff;

select * from ecommerce_new;
select * ,str_to_date(demodate,'%d-%m-%YYYY') as realdate from
(select year,month,date,concat(date,'-',month,'-',year) as Demodate from ecommerce_new) as gg;


-- Datasets Used: Names_Sub.csv
-- 1.	Get names and number of characters in the name string where the number of characters in the name is an even number.
select * from names_sub;
select name,year,len_n from
(select *,length(name) as len_n from names_sub) as pp where len_n%2=0;

select * from
(select name,length(name) as cnt from names_sub) as df where cnt%2=0;

-- 2.	Which is the most unique name used in Canada? 
select * from names_sub;
select distinct (name) from names_sub where 
select distinct(name) from names_sub where state like '%ca%';
select * from
(select *,count(name) over (partition by name order by name) as cnt from names_sub where state like '%ca%') as pp where cnt>1 ;

-- Datasets Used: products_u.csv, purchase_u.csv, user_data_u.csv
#Create database blackfridaysales;
select * from products_u;
select * from purchase_u;
select * from user_data_u;
-- 1.	What is the product id of the most expensive product purchased by the user? 


select *,max(Purchase) over(partition by User_ID order by Purchase)from purchase_u;

select user_id,product_id,Purchase from purchase_u order by Purchase desc;

-- 2.	Extract rows having null values in the product category 2 column. Replace the empty strings with NULL.

select *,if(product_category_2 is null,'Null',product_category_2) from
(select * from products_u where Product_Category_2 is null) as df;

select *,if(product_category_2 is null,'NULL','NULL') from
(select * from products_u where Product_Category_2 is null) as ff;

select *,if (product_category_2 is null,'Null','Null') str from 
(select * from products_u where Product_Category_2 is null) as hj;

-- 3.	People from which city category spent more during Black Friday Sales?
select * from products_u;
select * from purchase_u;
select * from user_data_u;

select user_id,City_Category,sum(sum1) as Total from
(select a.User_ID,City_Category,sum(purchase) over(partition by City_Category order by Purchase desc)as sum1 from user_data_u as a join purchase_u as b
using(user_id) group by a.User_ID) as gg group by City_Category order by Total desc;

select a.user_id,a.city_category,purchase from user_data_u as a join purchase_u as b using(user_id) group by City_Category order by Purchase desc;
select a.user_id,a.city_category,sum(purchase) over(partition by a.city_category order by purchase desc) as total from user_data_u as a join purchase_u as b using(user_id)
group by City_Category;

select a.User_ID, City_Category,sum(Purchase) over(partition by city_category order by Purchase desc ) as ggh from purchase_u as a join
user_data_u as b using(user_id) group by City_Category order by GGH desc;

-- 4.	Categorize the users like; 
# Total purchase of users > 200000  : Platinum Members
# Total purchase of users in the range (50000, 200000)  : Gold Members
# Total purchase of users < 50000  : Casual Members
# Also sort the users in descending order according to their total purchases. ***

select *,if(sum1>200000,'Platinum',if(sum1 between 50000 and 200000,'Gold','casual')) as cat from
(select *,sum(purchase) as sum1 from purchase_u group by User_ID) as gg order by cat desc;

-- 5.	If the marital status is 0 then show 'Single' else show 'Married' in a new column. Group the rows by user id. 
-- People from which age group spent more during the black friday sales?  
select * from products_u;
select * from purchase_u;
select * from user_data_u;


select a.user_id,age,if(marital_status=0,'Single','Married') as Status_,sum(Purchase) as Sum1 from user_data_u as a join purchase_u as b using(user_id) group by age order by sum1 desc;

select * from
(select a.user_id,gender,age,sum(purchase) as sum1,if(marital_status=0,'Single','Married') as status_bool from user_data_u as a join purchase_u as b 
using(user_id) group by a.User_ID order by sum1 desc) as pp group by age order by sum1 desc;

-- Datasets Used: HR Schema

-- 6.	Write a Query to find the last day of the most recent job of every employee.
select * from employees;
select * from job_history;
select *,day(lst) from
(select *,last_value(end_date) over(partition by employee_id) as lst from job_history group by employee_id) as fg;

select *,last_value(end_date) over(partition by employee_id order by end_date) as lst from job_history group by employee_id;

select *,day(lst) as last_day from
(select *,first_value(end_date) over(partition by employee_id order by end_date desc  ) as lst from job_history as a join employees as b
using (employee_id)) as gg group by employee_id; 
-- 7.	Write a Query to find the maximum salary of the most recent job that every employee holds. 

select *,last_value(start_date) over(partition by employee_id order by start_date) 
select *,last_value(start_date) over(partition by employee_id order by start_date ) as sst,a.job_id,max(salary) as max from job_history as a right join employees as b using(employee_id)
group by  employee_id order by max desc;

-- 8.	Write a Query to List the first designation and next promoted designation of all the employees in the company.

select a.employee_id,a.first_name,b.job_id,lead(b.job_id) over(partition by employee_id ) as nxt from employees as a join job_history as b using(employee_id);

-- 9.	Write a Query to calculate the cumulative distribution of Salary in the employees table.

select *,round(cume_dist() over(order by salary desc),4) as cmt from employees;

-- 10.	Write a Query to find the maximum salary of the most recent job that every employee holds. 

select *,last_value(start_date) over(partition by employee_id order by start_date ) as sst,max(salary) as max from job_history as a join employees as b using(employee_id)
group by  employee_id order by max desc;

