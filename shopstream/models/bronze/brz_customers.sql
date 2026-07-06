with source as (

    select * from {{ source('ecommerce', 'raw_customers') }}

),

renamed as (

    select
        -- identifiers
        customer_id,

        -- customer attributes
        first_name,
        last_name,
        email,
        phone,

        -- classification
        created_at::timestamp as created_at,
        updated_at::timestamp as updated_at,
        'raw_customers' as _source_table,

        -- timestamps
        upper(trim(segment)) as segment,
        upper(trim(region)) as region,

        -- audit columns
        upper(trim(country)) as country,
        current_timestamp() as _loaded_at

    from source

)

select * from renamed
