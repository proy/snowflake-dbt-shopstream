with source as (

    select * from {{ source('ecommerce', 'raw_suppliers') }}

),

renamed as (

    select
        supplier_id,
        supplier_name,
        contact_email,
        lead_time_days::number as lead_time_days,
        rating::number as rating,
        is_active::boolean as is_active,
        created_at::timestamp as created_at,
        'raw_suppliers' as _source_table,
        upper(trim(country)) as country,
        upper(trim(city)) as city,
        current_timestamp() as _loaded_at

    from source

)

select * from renamed
