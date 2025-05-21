#! /usr/bin/env bash

set -e

echo "pwd = $(pwd)"

source .env

if [ -z "$GPFDIST_PORT" ]; then
    echo "> GPFDIST_PORT is not set"
    exit 1
fi

if [[ $(pgrep --full "gpfdist -p $GPFDIST_PORT") ]]; then
    echo "> Restarting gpfdist on the port $GPFDIST_PORT..."
    pgrep --full "gpfdist -p $GPFDIST_PORT" | xargs kill
else
    echo "> Starting gpfdist on the port $GPFDIST_PORT..."
fi
gpfdist -p "$GPFDIST_PORT" -d /home/user/team-5-data &

internal_table_name=team_5_internal_managed_table_for_spark
echo "> Creating internal (managed) table $internal_table_name..."

psql -d idp -c "DROP TABLE IF EXISTS $internal_table_name;"
psql -d idp -c "CREATE TABLE $internal_table_name (
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
) DISTRIBUTED BY (brand);"

external_table_name=team_5_external_table_for_spark_csv
echo "> Creating external table $external_table_name..."

psql -d idp -c "DROP EXTERNAL TABLE IF EXISTS $external_table_name;"
psql -d idp -c "CREATE EXTERNAL TABLE $external_table_name (
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
LOCATION ('gpfdist://localhost:$GPFDIST_PORT/for_spark.csv')
FORMAT 'CSV' (HEADER);"

echo "> Copying data from the $external_table_name into the $internal_table_name..."
psql -d idp -c "INSERT INTO $internal_table_name SELECT * FROM $external_table_name;"

echo "> Selecting 15 rows from the $external_table_name..."
psql -d idp -c "SELECT * FROM $external_table_name LIMIT 15;"

echo "> Selecting 15 rows from the $internal_table_name..."
psql -d idp -c "SELECT * FROM $internal_table_name LIMIT 15;"
