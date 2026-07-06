with source as (

    select * from {{ source('ecommerce', 'raw_inventory') }}

),

renamed as (

    select
        inventory_id,
        product_id,
        store_id,
        quantity_available::number as quantity_available,
        quantity_reserved::number as quantity_reserved,
        reorder_level::number as reorder_level,
        last_restocked_date::date as last_restocked_date,
        snapshot_date::date as snapshot_date,
        -- audit columns
        'raw_inventory' as _source_table,
        current_timestamp() as _loaded_at

    from source

)

select * from renamed
