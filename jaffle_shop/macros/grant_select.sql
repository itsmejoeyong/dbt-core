{% macro grant_select(schema=target.schema, role=target.role) %}

    {% set query %}
    
        GRANT usage ON SCHEMA {{ schema }} TO ROLE {{ role }};
        GRANT select ON ALL TABLES IN {{ schema }} TO ROLE {{ role }};
        GRANT select ON ALL VIEWS IN {{ schema }} TO ROLE {{ role }};
        
    {% endset %}

    {#- '~' can be used to concatenate strings in jinja -#}
    {{ log('Granting select on all table & views in schema ' ~ schema ~ ' to role ' ~ role, info=True) }}
    {% do run_query(query) %}
    {{ log('Privileges granted!', info=True) }}

{% endmacro %}
