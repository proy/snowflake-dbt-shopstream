with source as (

    select * from {{ source('ecommerce', 'raw_order_items') }}

),

renamed as (

    select
        order_item_id,
        order_id,
        product_id,
        quantity::number as quantity,
        unit_price::number as unit_price,
        discount_amount::number as discount_amount,
        total_amount::number as total_amount,

        created_at::timestamp as created_at,

        -- audit columns
        'raw_order_items' as _source_table,
        current_timestamp() as _loaded_at

    from source

)

select * from renamed
