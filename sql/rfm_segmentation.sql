CREATE OR REPLACE VIEW public.v_rfm_segmentation AS

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
        um.last_order_date,
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
		NTILE(5) OVER (ORDER BY recency DESC) r_score,
		
		CASE
			WHEN frequency = 1 THEN 1
			WHEN frequency = 2 THEN 3
			ELSE 5
		END AS f_score,
		
		NTILE(5) OVER (ORDER BY monetary ASC) AS m_score
	FROM 
		rfm_raw
)

SELECT 
	*,
	CONCAT(r_score, f_score, m_score) AS rfm_index,
	CASE
		WHEN r_score = 5 AND f_score IN (4, 5) THEN 'Champions'
		WHEN r_score IN (4, 5) AND f_score IN (2, 3) THEN 'Potential Loyalists'
		WHEN r_score = 5 AND f_score = 1 THEN 'New Customers'
		WHEN r_score = 4 AND f_score = 1 THEN 'Promising'
		WHEN r_score IN (3, 4) AND f_score IN (4, 5) THEN 'Loyal Customers'
		WHEN r_score = 3 AND f_score = 3 THEN 'Needs Attention'
		WHEN r_score = 3 AND f_score IN (1, 2) THEN 'About to Sleep'
		WHEN r_score IN (1, 2) AND f_score = 5 THEN 'Can''t Lose Them'
		WHEN r_score IN (1, 2) AND f_score IN (3, 4) THEN 'At Risk'
		WHEN r_score IN (1, 2) AND f_score IN (1, 2) THEN 'Hibernating'
	END AS segment
FROM 
	rfm_score
