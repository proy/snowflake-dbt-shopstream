with source as (

    select * from {{ source('ecommerce', 'raw_reviews') }}

),

renamed as (

    select
        review_id,
        order_id,
        product_id,
        customer_id,
        rating::number as rating,
        is_verified::boolean as is_verified,
        created_at::timestamp as created_at,
        'raw_reviews' as _source_table,
        trim(review_title) as review_title,
        -- audit columns
        trim(review_text) as review_text,
        current_timestamp() as _loaded_at

    from source

)

select * from renamed
