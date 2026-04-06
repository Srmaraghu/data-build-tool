WITH returns_data AS (
    SELECT
        CAST(sales_id AS INT) AS sales_id,
        CAST(date_sk AS INT) AS date_sk,
        CAST(store_sk AS INT) AS store_sk,
        CAST(product_sk AS INT) AS product_sk,
        CAST(returned_qty AS INT) AS returned_qty,
        CAST(refund_amount AS DECIMAL(18, 2)) AS refund_amount,
        CASE
            WHEN LOWER(TRIM(return_reason)) = 'damaged' THEN 'Damaged'
            WHEN LOWER(TRIM(return_reason)) = 'defective' THEN 'Defective'
            WHEN LOWER(TRIM(return_reason)) = 'late delivery' THEN 'Late Delivery'
            WHEN LOWER(TRIM(return_reason)) = 'wrong item' THEN 'Wrong Item'
            WHEN LOWER(TRIM(return_reason)) = 'changed mind' THEN 'Changed Mind'
            ELSE TRIM(return_reason)
        END AS return_reason
    FROM {{ ref('bronze_returns') }}
),
product AS (
    SELECT product_sk, category
    FROM {{ ref('bronze_product') }}
),
joined_query AS (
    SELECT
        r.sales_id,
        r.date_sk,
        r.store_sk,
        r.product_sk,
        r.returned_qty,
        r.return_reason,
        r.refund_amount,
        p.category
    FROM returns_data r
    LEFT JOIN product p ON r.product_sk = p.product_sk
)

SELECT
    category,
    return_reason,
    SUM(returned_qty) AS total_returned_qty,
    SUM(refund_amount) AS total_refund_amount,
    COUNT(*) AS total_return_records
FROM joined_query
GROUP BY category, return_reason
ORDER BY total_refund_amount DESC