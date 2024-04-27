{% set payment_method = ['bank_transfer', 'credit_card', 'coupon', 'gift_card'] %}

WITH payments AS (
    SELECT * FROM {{ ref('stg_payments') }}
),

pivoted AS (
    SELECT
        order_id,
            {% for payments in payment_method %}
                SUM(CASE WHEN payment_method = '{{ payments }}' THEN amount ELSE 0 END) AS {{payments}}_amount {% if not loop.last %}, {% endif %}
            {% endfor %}
    FROM
        payments
    WHERE
        status = 'success'
    GROUP BY
        order_id
)

SELECT * FROM pivoted
