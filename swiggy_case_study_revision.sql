# 1. Find The customers have never ordered
select *  from users
where user_id not in (select user_id from orders);

# 2. Average Price of Dish
select f.f_name,avg(m.price) as Avg_price from menu m
join food f on f.f_id = m.f_id
group by f_name
order by Avg_price desc;

# 3.Find top restaurant in terms of numbers of orders for a given month

select r.r_name, count(o.order_id ) as no_of_orders
from orders o 
join restaurants r on r.r_id = o.r_id
where monthname(date) = 'June'
group by r.r_name
order by no_of_orders desc
limit 1;

# 4 find restaurants name whose monthly sales > X amount

select r.r_name,sum(amount) as revenue from orders o 
join restaurants r on r.r_id = o.r_id
where monthname(date) = 'June'
group by r.r_name
having sum(amount) > 500;



# 5 . write name of  top number user from each restaurant

with cte as(select * from (select o.r_id,o.user_id ,count(*) as repeated_customer,
dense_rank() over(partition by o.r_id order by count(*) desc) as rnk from orders o

group by o.r_id,o.user_id) x
where x.rnk =1)

select r.r_name,u.name from cte c
join users u on  u.user_id = c.user_id
join restaurants r on r.r_id = c.r_id;



# 6. find the month over month revenue growth of swiggy

select monthname(date),
round((sum(amount)-lag(sum(amount)) over(order by month(date))) / (lag(sum(amount)) over(order by month(date)))*100 ,2)as MoM_growth
from orders o 
group by monthname(date)
order by month(date);

# 7. find the each customers -> favorite food 

with cte as (select * from (select o.user_id,od.f_id ,count(*) as frequency,
dense_rank() over(partition by o.user_id order by count(*) desc) as rnk
from orders o
join order_details od on od.order_id = o.order_id
group by od.f_id ,o.user_id
) x
where x.rnk =1
)

select u.name,f.f_name from cte c 
join users u on u.user_id = c.user_id
join food f on f.f_id = c.f_id
