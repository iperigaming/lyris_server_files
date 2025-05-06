@echo off
echo Starte MariaDB und Redis Container...

docker-compose -f ./mysql/docker-compose.yml -f ./redis/docker-compose.yml up -d

if %ERRORLEVEL% EQU 0 (
    echo ✅ Alle Container wurden erfolgreich gestartet.
) else (
    echo ❌ Fehler beim Starten der Container.
)

pause