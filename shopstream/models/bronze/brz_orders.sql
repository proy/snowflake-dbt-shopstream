with source as (

    select * from {{ source('ecommerce', 'raw_orders') }}

),

renamed as (

    select
        order_id,
        customer_id,
        store_id,

        order_date::date as order_date,
        total_amount::number as total_amount,
        discount_amount::number as discount_amount,
        shipping_amount::number as shipping_amount,
        created_at::timestamp as created_at,
        updated_at::timestamp as updated_at,

        'raw_orders' as _source_table,
        upper(trim(order_status)) as order_status,
        upper(trim(order_channel)) as order_channel,
        current_timestamp() as _loaded_at

    from source

)

select * from renamed
