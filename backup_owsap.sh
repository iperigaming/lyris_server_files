#!/bin/sh

CONFIG="../config.ini"

DATE=`date "+%Y.%m.%d"`
TIME=`date "+%H.%M.%S"`

SERVER_DUMP_PATH="../backup/server/${DATE}.${TIME}"
mkdir -p $SERVER_DUMP_PATH

tar -zcvf "$SERVER_DUMP_PATH/server.tar.gz" "/home/nuyah/game"

DB_DUMP_PATH="../backup/mysql/${DATE}.${TIME}"
mkdir -p $DB_DUMP_PATH

echo "Dumping $DB_DUMP_PATH/account.sql..."
mysqldump --login-path={$CONFIG} --set-gtid-purged=OFF "account" -r "$DB_DUMP_PATH/account.sql"

echo "Dumping $DB_DUMP_PATH/common.sql..."
mysqldump --login-path={$CONFIG} --set-gtid-purged=OFF "common" -r "$DB_DUMP_PATH/common.sql"

echo "Dumping $DB_DUMP_PATH/hotbackup.sql..."
mysqldump --login-path={$CONFIG} --set-gtid-purged=OFF "hotbackup" -r "$DB_DUMP_PATH/hotbackup.sql"

echo "Dumping $DB_DUMP_PATH/player.sql..."
mysqldump --login-path={$CONFIG} --set-gtid-purged=OFF "player" -r "$DB_DUMP_PATH/player.sql"

echo "Dumping $DB_DUMP_PATH/log.sql..."
mysqldump --login-path={$CONFIG} --set-gtid-purged=OFF "log" -r  "$DB_DUMP_PATH/log.sql"
