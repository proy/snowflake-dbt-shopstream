with source as (

    select * from {{ source('ecommerce', 'raw_products') }}

),

renamed as (

    select
        product_id,
        supplier_id,
        cost_price::number as cost_price,
        selling_price::number as selling_price,
        weight_kg::number as weight_kg,
        is_active::boolean as is_active,
        created_at::timestamp as created_at,
        'raw_products' as _source_table,
        upper(trim(product_name)) as product_name,
        upper(trim(category)) as category,

        -- audit columns
        upper(trim(subcategory)) as sub_category,
        current_timestamp() as _loaded_at

    from source

)

select * from renamed
