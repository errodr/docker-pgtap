#!/bin/sh

echo "Waiting for database..."
dockerize -timeout 240s -wait tcp://$HOST:$PORT
echo

function usage() { echo "Usage: $0 -h host -d database -p port -u username -w password" 1>&2; exit 1; }

while getopts d:h:p:u:w:b:n: OPTION
do
  case $OPTION in
    d)
      DATABASE=$OPTARG
      ;;
    h)
      HOST=$OPTARG
      ;;
    p)
      PORT=$OPTARG
      ;;
    u)
      USER=$OPTARG
      ;;
    w)
      PASSWORD=$OPTARG
      ;;
    H)
      usage
  esac
done

echo "Uninstall pgtap..."
PGPASSWORD=$PASSWORD psql -h $HOST -p $PORT -d $DATABASE -U $USER -f /pgtap/sql/uninstall_pgtap.sql > /dev/null 2>&1
exit $?
