with source as (

    select * from {{ source('ecommerce', 'raw_orders') }}

),

renamed as (

    select
        order_id,
        customer_id,
        store_id,

        order_date::DATE as order_date,
        total_amount::NUMBER as total_amount,
        discount_amount::NUMBER as discount_amount,
        shipping_amount::NUMBER as shipping_amount,
        created_at::TIMESTAMP as created_at,
        updated_at::TIMESTAMP as updated_at,

        'raw_orders' as _source_table,
        TRIM(order_status) as order_status,

        -- audit columns
        TRIM(order_channel) as order_channel,
        CURRENT_TIMESTAMP() as _loaded_at

    from source

)

select * from renamed
