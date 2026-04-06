WITH sales AS (
    SELECT 
    sales_id,
    product_sk, 
    customer_sk,
    {{ multiply('unit_price', 'quantity') }} as calculated_gross_amount,
    payment_method
    FROM {{ ref('bronze_sales') }}
),
product AS (
    SELECT product_sk, category
    FROM {{ ref('bronze_product') }}
),
customer AS (
    SELECT customer_sk, gender
    FROM {{ ref('bronze_customer') }}
)
,
joined_query as (
SELECT
    s.sales_id,
    s.product_sk,
    s.customer_sk,
    s.payment_method,
    s.calculated_gross_amount,
    p.category,
    c.gender
LEFT JOIN product p ON s.product_sk = p.product_sk
LEFT JOIN customer c ON s.customer_sk = c.customer_sk
)

SELECT 
    category,
    gender,
    sum( calculated_gross_amount) as total_gross_amount
FROM joined_query
GROUP BY category, gender
ORDER BY total_gross_amount DESC

