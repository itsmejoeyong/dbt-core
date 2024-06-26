-- comments are for seeds demo, but there's a right join error but some reason:
/*
Database Error in model customers (models\marts\core\customers.sql)
  Column customer_id in USING clause not found on right side of join at [44:32]
  compiled Code at target\run\jaffle_shop\models\marts\core\customers.sql
*/
with customers as (
    select * from {{ ref('stg_customers')}}
),
employees as(
    select * from {{ ref('employees') }}
),
orders as (
    select * from {{ ref('fct_orders')}}
),
customer_orders as (
    select
        customer_id,
        min(order_date) as first_order_date,
        max(order_date) as most_recent_order_date,
        count(order_id) as number_of_orders,
        sum(amount) as lifetime_value
    from orders
    group by 1
),
final as (
    select
        customers.customer_id,
        customers.first_name,
        customers.last_name,
--        employees.employee_id is not null as is_employee,
        customer_orders.first_order_date,
        customer_orders.most_recent_order_date,
        coalesce(customer_orders.number_of_orders, 0) as number_of_orders,
        customer_orders.lifetime_value
    from customers
    left join customer_orders using (customer_id)
--    left join employees using (customer_id)
)
select * from final