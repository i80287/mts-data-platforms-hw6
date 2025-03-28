# mts-data-platforms-hw6

----------------------------------------------------------

### 1. create external table

Скрипт `remote_create_xtable.bash`:
- Создаст на машине папку `/home/user/team-5-data`, если её ещё нет
- Загрузит на машину файлы `.env`, `detail/for_spark.csv` и `detail/create_xtable.bash` в папку `/home/user/team-5-data`
- Выполнит на машине скрипт `detail/create_xtable.bash`, который:
- - Запустит `gpfdist` на порте `8807` (переменная `GPFDIST_PORT` в `.env`) в бэкграунде (или перезапустит, если `gpfdist` на порте `8807` уже был запущен)
- - Создаст `EXTERNAL TABLE` (предварительно дропнув, если уже существует) `team_5_external_table_for_spark_csv` при помощи команды

```sql
DROP EXTERNAL TABLE IF EXISTS team_5_external_table_for_spark_csv;
CREATE EXTERNAL TABLE team_5_external_table_for_spark_csv (
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
FORMAT 'CSV' (HEADER);
```

- - Сделает select при помощи команды

```sql
SELECT * FROM team_5_external_table_for_spark_csv LIMIT 15;
```

Выполнение скрипта: (при выполнении важно находиться в папке `scripts`)
```bash
cd scripts
./remote_create_xtable.bash
```
