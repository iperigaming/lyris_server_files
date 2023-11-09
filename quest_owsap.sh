#!/bin/sh

echo -e "Making quests"

# Quest
if [ $# -eq 0 ]
then
	cd share/locale/_master/quest/ && python2 make_quest.py
else
	cd share/locale/_master/quest/ && ./pre_qc "$1"
fi
