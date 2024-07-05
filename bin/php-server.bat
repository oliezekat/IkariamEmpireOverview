@echo off
rem Start PHP built-in server

rem Load setup for CLI & batch usages
call "%~dp0\env.bat" -q

setlocal

rem Check environment for PHP
if not defined PHPRC goto ErrorPhpEnv
if not exist "%PHPRC%" goto ErrorPhpEnv
set phprc_cli_ini_filepath=%PHPRC%\php-cli.ini
if not exist "%phprc_cli_ini_filepath%" goto ErrorPhpEnv

rem Setup built-in server
set phprc_cli_server_ini_filepath=%PHPRC%\php-cli-server.ini
copy /y %phprc_cli_ini_filepath% %phprc_cli_server_ini_filepath% >NUL
if not defined builtin_server_document_root set builtin_server_document_root=%project_dirpath%\public
if not exist "%builtin_server_document_root%" goto ErrorPhpEnv
if not defined builtin_server_host set builtin_server_host=localhost
if not defined builtin_server_port set builtin_server_port=80

rem Start PHP built-in server
powershell write-host -fore DarkBlue 'Start PHP built-in server...'
powershell write-host -fore DarkGray "builtin_server_document_root = %builtin_server_document_root%"
powershell write-host -fore DarkYellow "Press Ctrl+C to stop it."
php -S %builtin_server_host%:%builtin_server_port% -t %builtin_server_document_root%
del /q %phprc_cli_server_ini_filepath% >NUL
goto End

rem Missing or wrong config\php-env.bat
:ErrorPhpEnv
powershell write-host -fore DarkRed 'Missing or wrong \"config\php-env.bat\" file.'
powershell write-host -fore DarkYellow 'Call \"bin\get-php\" to download and setup PHP built-in web server.'
goto End

:End
endlocal
cd %current_dirpath%