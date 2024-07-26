@echo off
rem Get or update Composer.phar

rem Load setup for CLI & batch usages
call "%~dp0\env.bat" -q

setlocal

rem Check environment for PHP
if not defined PHPRC goto ErrorPhpEnv
if not exist "%PHPRC%" goto ErrorPhpEnv
set phprc_cli_ini_filepath=%PHPRC%\php-cli.ini
if not exist "%phprc_cli_ini_filepath%" goto ErrorPhpEnv

rem Destination directory
:DstDir
set composer_destination_dirpath=%project_dirpath%\var\composer
if not exist "%composer_destination_dirpath%" mkdir %composer_destination_dirpath%

rem Destination file
:DstFile
set composer_installer_destination_filename=composer-setup.php
set composer_installer_destination_filepath=%composer_destination_dirpath%\%composer_installer_destination_filename%

rem Download Composer installer
set composer_installer_download_url=https://getcomposer.org/installer
powershell -ExecutionPolicy Bypass -File bin\download-file.ps1 -url '%composer_installer_download_url%' -filepath '%composer_installer_destination_filepath%' -caption "Composer"

rem Install Composer
php %composer_installer_destination_filepath% --install-dir=%composer_destination_dirpath% --quiet

rem Install dependencies with Composer 
set composer_phar_filepath=%composer_destination_dirpath%\composer.phar
if not exist "%composer_phar_filepath%" goto End
php "%composer_phar_filepath%" --quiet --no-interaction --no-cache install
goto End

rem Missing or wrong config\php-env.bat
:ErrorPhpEnv
powershell write-host -fore DarkRed 'Missing or wrong \"config\php-env.bat\" file.'
powershell write-host -fore DarkYellow 'Call \"bin\get-php\" to download and setup PHP for Windows.'
goto End

rem End
:End
endlocal
cd %current_dirpath%