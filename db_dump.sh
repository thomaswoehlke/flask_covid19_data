#!/usr/bin/env bash
TZ='Europe/Berlin'
HEUTE=`date '+%Y%m%d_%H%m%S'`


databases="flask_covid19 flask_covid19_db_schema_evolution flask_covid19_integration flask_covid19_production "
databases="$databases flask_covid19_release flask_covid19_owid flask_covid19_rki flask_covid19_who"

hosts="tw-thinkpad tw-asus7"

function dump_database(){
  database=$1
  host=$2
  echo "$HEUTE--$database--$host"
  subdir="db/db_dump--$HEUTE"
  mkdir -p $subdir
  dumpfile="./$db/$subdir/db_dump--$HEUTE--$database--$host.sql"
  mysqldump -h $host -u flask_covid19 $database --password='flask_covid19pwd' > $dumpfile
}

function dump_all_databases(){
  echo "$HEUTE"
  for host in $hosts
  do
    for database in $databases
    do
      dump_database $database $host
    done
  done
}

function make_tar() {
  echo "$HEUTE"
  cd db
  subdir="db_dump--$HEUTE"
  echo "$subdir"
  tar cvf $subdir.tar $subdir
  7z a $subdir.tar.7z $subdir.tar
  cd ..
  git add *
}

function main() {
  dump_all_databases
  make_tar
}

main
