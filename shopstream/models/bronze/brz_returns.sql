with source as (

    select * from {{ source('ecommerce', 'raw_returns') }}

),

renamed as (

    select
        return_id,
        order_id,
        product_id,
        customer_id,
        refund_amount::number as refund_amount,
        return_date::date as return_date,
        created_at::timestamp as created_at,
        'raw_returns' as _source_table,
        upper(trim(return_reason)) as return_reason,
        upper(trim(return_status)) as return_status,
        -- audit columns
        upper(trim(return_method)) as refund_method,
        current_timestamp() as _loaded_at

    from source

)

select * from renamed
