@echo off
set GAME_FILE=.\bin\game_d.exe
set DB_FILE=.\bin\db_d.exe

start "" /D ".\srv1\db" "%DB_FILE%"
echo Database started!

start "" /D ".\srv1\auth" "%GAME_FILE%"
start "" /D ".\srv1\chan\ch1\core1" "%GAME_FILE%"

pause