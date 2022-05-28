#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

VOLD="$1"

if [[ ! -d /opt/pgsql-$VOLD/ ]]; then
  echo "postgresql-old-upgrade not installed"
  exit 1
fi

systemctl stop postgresql


echo 'creating backup/upgrade dirs'
mv /var/lib/postgres/data /var/lib/postgres/olddata
mkdir /var/lib/postgres/tmp
mkdir /var/lib/postgres/data
chown postgres:postgres /var/lib/postgres/data /var/lib/postgres/tmp

echo 'Creating new DB in new version'
cd /var/lib/postgres/tmp
sudo -u postgres initdb -D /var/lib/postgres/data  --encoding=UTF8 
sudo -u postgres pg_upgrade -b /opt/pgsql-$VOLD/bin -B /usr/bin -d /var/lib/postgres/olddata -D /var/lib/postgres/data

echo 'Starting'
systemctl start postgresql

echo "The DB should have been successfully upgraded"
echo "You can now run 'rm -rf /var/lib/postgres/olddata /var/lib/postgres/tmp'"
