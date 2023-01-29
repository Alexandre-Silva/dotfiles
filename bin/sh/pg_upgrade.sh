#!/bin/bash

set -e

if [[ $USER != root ]]; then
  echo Must run as root
  exit 1;
fi

if [[ ! -e "/opt/pgsql-$1" ]]; then
  echo "Old pgsql doest not exist: /opt/pgsql-$1"
  echo "Is provided version the correct one?"
  echo "Should run as '$0 14' for ugprading from version 14 fro example"
  exit 1;
fi

echo "Upgrading from $1"
echo ""


echo "Preparing"
# mv /var/lib/postgres/data /var/lib/postgres/olddata
mkdir /var/lib/postgres/data
# mkdir /var/lib/postgres/tmp
chown postgres:postgres /var/lib/postgres/data /var/lib/postgres/tmp

echo "Creating new DB cluster"
cd /var/lib/postgres/tmp
sudo -u postgres initdb -D /var/lib/postgres/data --encoding=UTF8

echo "Copying configs"
sudo -u postgres mv /var/lib/postgres/data/pg_hba.conf{,.pacnew}
sudo -u postgres mv /var/lib/postgres/data/postgresql.conf{,.pacnew}
sudo -u postgres cp -v /var/lib/postgres/olddata/pg_hba.conf /var/lib/postgres/data/
sudo -u postgres cp -v /var/lib/postgres/olddata/postgresql.conf /var/lib/postgres/data/

echo "Upgrading"
sudo -u postgres pg_upgrade -b "/opt/pgsql-$1/bin" -B /usr/bin -d /var/lib/postgres/olddata -D /var/lib/postgres/data -O "-c timescaledb.restoring='on'"

echo "Starting new version server"
systemctl start postgresql.service
sleep 1

echo "Running vacuum"
sudo -u postgres /usr/bin/vacuumdb --all --analyze-in-stages

echo Dont forget to remove /var/lib/postgres/olddata and /var/lib/postgres/tmp

exit 0
