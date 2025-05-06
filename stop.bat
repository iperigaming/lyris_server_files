@echo off
echo Starte MariaDB und Redis Container...

docker-compose -f ./mysql/docker-compose.yml -f ./redis/docker-compose.yml down

if %ERRORLEVEL% EQU 0 (
    echo ✅ Alle Container wurden erfolgreich heruntergefahren.
) else (
    echo ❌ Fehler beim herunterfahren der Container.
)

pause