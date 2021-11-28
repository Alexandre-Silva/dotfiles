#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

function main() {
    local db_name="$1"
    local new_owner="$2"

    psql -c "GRANT CONNECT ON DATABASE $db_name TO $new_owner" $db_name
    psql -c "GRANT ALL ON DATABASE $db_name TO $new_owner" $db_name
    psql -c "GRANT ALL ON SCHEMA public TO $new_owner" $db_name

    psql -c "ALTER DATABASE $db_name OWNER TO $new_owner" $db_name
    psql -c "ALTER SCHEMA public OWNER TO $new_owner" $db_name

    for tbl in `psql -qAt -c "select tablename from pg_tables where schemaname = 'public';" $db_name`; do
        psql -c "alter table \"$tbl\" owner to $new_owner" $db_name
    done

    for seq in `psql -qAt -c "select sequence_name from information_schema.sequences where sequence_schema = 'public';" $db_name`; do
        psql -c "alter sequence \"$seq\" owner to $new_owner" $db_name
    done

    for view in `psql -qAt -c "select table_name from information_schema.views where table_schema = 'public';" $db_name`; do
        psql -c "alter view \"$view\" owner to $new_owner" $db_name
    done
}

main "$@"
