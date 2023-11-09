#!/bin/sh

CHANNELS=4
CORES=4
CONFIG="share/config.ini"

#
# Database
#

echo -e "This will drop all data from your database."
read -p "Proceed with this action? [y/N]: " opt

if [ "$opt" == "y" ]; then
	echo -e "Creating account database"
	mysql --login-path={$CONFIG} "account" < "/var/db/mysql/account.sql"
	sleep 1

	echo -e "Creating common database"
	mysql --login-path={$CONFIG} "common" < "/var/db/mysql/common.sql"
	sleep 1

	echo -e "Creating hotbackup database"
	mysql --login-path={$CONFIG} "hotbackup" < "/var/db/mysql/hotbackup.sql"
	sleep 1

	echo -e "Creating player database"
	mysql --login-path={$CONFIG} "player" < "/var/db/mysql/player.sql"
	sleep 1

	echo -e "Creating log database"
	mysql --login-path={$CONFIG} "log" < "/var/db/mysql/log.sql"
	sleep 1
else
	exit 0
fi

echo -e "Creating symbolic links"

#
# Database Cache Server
#

ln -s /var/db/mysql/ db/
ln -s $PWD/share/LICENSE db/
ln -s $PWD/share/db db/
ln -s $PWD/share/vrunner db/

#
# Auth (Single Core)
#

ln -s $PWD/share/data/ auth/
ln -s $PWD/share/locale/ auth/
ln -s $PWD/share/mark auth/
ln -s $PWD/share/package auth/
ln -s $PWD/share/LICENSE auth/
ln -s $PWD/share/cmd auth/
ln -s $PWD/share/game auth/
ln -s $PWD/share/vrunner auth/
mv $PWD/auth/game $PWD/auth/auth

for CH in $(seq 1 $CHANNELS)
do
	#
	# Game $CH
	#
	for CORE in $(seq 1 $CORES)
	do
		ln -s $PWD/share/data/ game/channel${CH}/core${CORE}/
		ln -s $PWD/share/locale/ game/channel${CH}/core${CORE}/
		ln -s $PWD/share/mark game/channel${CH}/core${CORE}/
		ln -s $PWD/share/package game/channel${CH}/core${CORE}/
		ln -s $PWD/share/LICENSE game/channel${CH}/core${CORE}/
		ln -s $PWD/share/cmd game/channel${CH}/core${CORE}/
		ln -s $PWD/share/game game/channel${CH}/core${CORE}/
		ln -s $PWD/share/vrunner game/channel${CH}/core${CORE}/
	done
done

#
# Game 99 (Single Core)
#

ln -s $PWD/share/data/ game/channel99/
ln -s $PWD/share/locale/ game/channel99/
ln -s $PWD/share/mark game/channel99/
ln -s $PWD/share/package game/channel99/
ln -s $PWD/share/LICENSE game/channel99/
ln -s $PWD/share/cmd game/channel99/
ln -s $PWD/share/game game/channel99/
ln -s $PWD/share/vrunner game/channel99/

#
# Miscellaneous
#

ln -s $PWD/share/locale/europe share/locale/_master
ln -s /var/db/mysql/ mysql

chmod -R 770 $PWD
