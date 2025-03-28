#! /usr/bin/env bash

gpfdist -p 8807 -d /home/user/team-5-data &

psql -d idp -c "DROP EXTERNAL TABLE IF EXISTS team_5_external_table_for_spark_csv;"

psql -d idp -c "CREATE EXTERNAL TABLE team_5_external_table_for_spark_csv (
    brand text,
    item_id bigint,
    ram_gb bigint,
    storage_gb bigint,
    price_rs numeric(20, 5),
    cpu_speed_ghz numeric(20, 5),
    touch text,
    color text,
    weight numeric(20, 5),
    display_size_inch numeric(20, 5)
)
LOCATION ('gpfdist://localhost:8807/for_spark.csv')
FORMAT 'CSV' (HEADER);"

psql -d idp -c "SELECT * FROM team_5_external_table_for_spark_csv LIMIT 15;"

pgrep --full "gpfdist -p 8807" | xargs kill
