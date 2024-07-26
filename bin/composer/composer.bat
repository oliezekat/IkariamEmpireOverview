@echo off
rem Local Composer command line

rem Setup for CLI & batch usages
call "%~dp0\..\env.bat" -q

setlocal

rem Check environment for PHP
if not defined PHPRC goto ErrorPhpEnv
if not exist "%PHPRC%" goto ErrorPhpEnv
set phprc_cli_ini_filepath=%PHPRC%\php-cli.ini
if not exist "%phprc_cli_ini_filepath%" goto ErrorPhpEnv

rem Check Composer
set composer_phar_filepath=%project_dirpath%\var\composer\composer.phar
if not exist "%composer_phar_filepath%" goto ErrorComposerPhar

rem Use composer.phar
php "%composer_phar_filepath%" %*
goto End

rem Missing or wrong config\php-env.bat
:ErrorPhpEnv
powershell write-host -fore DarkRed 'Missing or wrong \"config\php-env.bat\" file.'
powershell write-host -fore DarkYellow 'Call \"bin\get-php\" to download and setup PHP for Windows.'
goto End

rem Missing composer.phar
:ErrorComposerPhar
powershell write-host -fore DarkRed 'Missing \"composer.phar\" file.'
powershell write-host -fore DarkYellow 'Call \"bin\get-composer\" to download and setup Composer.'
goto End

rem End
:End
endlocal
cd %current_dirpath%