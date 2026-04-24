WITH    
user_metrics AS (    
    SELECT
        orders.customer_id,
        COUNT(DISTINCT orders.order_id) AS orders_count,
        MAX(orders.order_created_time) :: DATE AS last_order_date,
        SUM(order_items.price) AS revenue
    FROM
        orders
    INNER JOIN order_items ON orders.order_id = order_items.order_id
    WHERE 
        order_status = 'Delivered'
    GROUP BY 
        orders.customer_id
),
        
max_date AS (
    SELECT
        MAX(order_created_time)::DATE AS max_date
    FROM
        orders
),

rfm_raw AS (        
    SELECT
        um.customer_id,
        md.max_date - um.last_order_date AS recency,
        um.orders_count AS frequency,
        um.revenue AS monetary
    FROM
        user_metrics AS um
    CROSS JOIN max_date AS md
),

rfm_score AS (
    SELECT
        *,
        NTILE(5) OVER (ORDER BY recency DESC) AS r_score,
        NTILE(5) OVER (ORDER BY frequency ASC) AS f_score,
        NTILE(5) OVER (ORDER BY monetary ASC) AS m_score
    FROM
        rfm_raw
)

SELECT
    *,
    CASE
        WHEN r_score = 5 AND f_score = 5 AND m_score = 5 THEN 'VIP'
        WHEN m_score = 5 THEN 'High value'
        WHEN r_score >= 4 AND f_score >= 4 THEN 'Loyal'
        WHEN r_score >= 4 AND f_score >= 2 THEN 'Potential loyal'
        WHEN r_score >= 4 AND f_score = 1 THEN 'Promising'
        WHEN r_score <= 2 AND f_score >= 4 THEN 'At risk'
        WHEN r_score BETWEEN 2 AND 3 AND f_score <= 2 THEN 'Slipping away'
        WHEN r_score = 1 AND f_score = 1 THEN 'Dormant'
        ELSE 'Needing attention'
    END AS customer_segment
FROM
    rfm_score
ORDER BY r_score DESC, f_score DESC, m_score DESC;
