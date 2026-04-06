{# {% set fruits = [
    'apple',
    'banana',
    'cherry',
    'date',
    'elderberry'
]
%}

{% for fruit in fruits%}
SELECT '{{fruit}}' as fruit_name
{% if not loop.last %}UNION ALL{% endif %}
{% endfor %} #}



-- This SQL query selects specific columns (sales_id, date_sk, order_amount) from the 'bronze_sales' view. It uses a loop to dynamically generate the column names in the SELECT statement. Additionally, it includes a conditional statement that filters the results to only include rows where the date_sk is greater than a specified limit

{% set i=1 %}
{% set limit = 3 %}
{% set cols_list = ["sales_id", "date_sk", "gross_amount"] %}

SELECT  
    {% for col in cols_list %}
        {{col}}
        {% if not loop.last %},{% endif %}
    {% endfor %}

FROM 
    {{ref('bronze_sales')}}

{% if i == 1 %}

    WHERE date_sk >  {{ limit }}

{% endif %}