with source as (

    select * from {{ source('ecommerce', 'raw_employees') }}

),

renamed as (

    select
        employee_id,
        first_name,
        last_name,
        email,
        store_id,
        salary::number as salary,
        hire_date::date as hire_date,
        is_active::boolean as is_active,
        'raw_employees' as _source_table,
        upper(trim(role)) as role,
        current_timestamp() as _loaded_at

    from source

)

select * from renamed
