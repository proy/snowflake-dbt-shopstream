with source as (

    select * from {{ source('ecommerce', 'raw_shipments') }}

),

renamed as (

    select
        shipment_id,
        order_id,
        upper(trim(carrier)) as carrier,
        upper(trim(tracking_number)) as tracking_number,
        upper(trim(shipment_status)) as shipment_status,
        shipped_date::date as shipped_date,
        estimated_delivery::date as estimated_delivery,
        actual_delivery::date as actual_delivery,

        created_at::timestamp as created_at,
        -- audit columns
        current_timestamp()     as _loaded_at,
        'raw_shipments'         as _source_table

    from source

)

select * from renamed
