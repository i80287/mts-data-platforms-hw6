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

table_name=team_5_external_table_for_spark_csv
echo "> Creating external table $table_name..."
psql -d idp -c "DROP EXTERNAL TABLE IF EXISTS $table_name;"
psql -d idp -c "CREATE EXTERNAL TABLE $table_name (
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

echo "> Selecting 15 rows from the $table_name..."
psql -d idp -c "SELECT * FROM $table_name LIMIT 15;"
