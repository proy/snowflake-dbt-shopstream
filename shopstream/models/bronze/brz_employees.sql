with source as (

    select * from {{ source('ecommerce', 'raw_employees') }}

),

renamed as (

    select
        employee_id,
        first_name,
        last_name,
        email,
        phone,
        store_id,
        salary,
        hire_date::date as hire_date,
        is_active::boolean as is_active,
        created_at::timestamp as created_at,
        -- timestamps
        updated_at::timestamp as updated_at,
        'raw_employees' as _source_table,

        -- audit columns
        TRIIM(role) as role,
        CURRENT_TIMESTAMP() as _loaded_at

    from source

)

select * from renamed
