with source as (

    select * from {{ source('ecommerce', 'raw_orders') }}

),

renamed as (

    select
        -- identifiers first
        order_id,
        customer_id,
        store_id,

        -- descriptive attributes
        upper(trim(order_status))   as order_status,
        upper(trim(order_channel))  as order_channel,

        -- financial amounts
        total_amount::number        as total_amount,
        discount_amount::number     as discount_amount,
        shipping_amount::number     as shipping_amount,

        -- timestamps
        order_date::date            as order_date,
        created_at::timestamp       as created_at,
        updated_at::timestamp       as updated_at,

        -- audit columns last
        current_timestamp()         as _loaded_at,
        'raw_orders'                as _source_table

    from source

)

select * from renamed
