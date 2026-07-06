with source as (

    select * from {{ source('ecommerce', 'raw_payments') }}

),

renamed as (

    select
        payment_id,
        order_id,
        upper(trim(payment_method)) as payment_method,
        upper(trim(payment_status)) as payment_status,
        amount::number as amount
        upper(trim(currency)) as currency,
        transaction_id,
        payment_date::timestamp as payment_date,
        created_at::timestamp as created_at,


        -- audit columns
        current_timestamp()     as _loaded_at,
        'raw_payments'         as _source_table

    from source

)

select * from renamed
