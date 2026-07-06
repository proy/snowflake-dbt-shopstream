with source as (

    select * from {{ source('ecommerce', 'raw_stores') }}

),

renamed as (

    select
        store_id,
        store_name,
        pincode::number as pincode,
        opened_date::timestamp as opened_date,
        manager_id,
        is_active::boolean as is_active,
        'raw_stores' as _source_table,
        upper(trim(store_type)) as store_type,
        upper(trim(city)) as city,
        upper(trim(region)) as region,
        -- audit columns
        upper(trim(state)) as state,
        current_timestamp() as _loaded_at

    from source

)

select * from renamed
