with source as (

    select * from {{ ref('brz_customers') }}

),

deduped as (

    select
        *,
        row_number() over (
            partition by customer_id
            order by updated_at desc, _loaded_at desc
        ) as row_num

    from source

),

final as (

    select
        -- identifiers
        customer_id,

        -- customer attributes
        first_name,
        last_name,
        email,
        phone,

        -- classification
        segment,
        region,
        country,

        -- timestamps
        created_at,
        updated_at,

        -- audit columns
        _loaded_at,
        _source_table

    from deduped
    where row_num = 1

)

select * from final
