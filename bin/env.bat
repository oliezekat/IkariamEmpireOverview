@echo off
rem Setup project & PHP for CLI, batch, built-in server usages

rem Save current environment
if defined system_dirpaths set Path=%system_dirpaths%
if not defined system_dirpaths set system_dirpaths=%Path%
set current_dirpath=%CD%

rem Setup project default environment
set bin_dirpath=%~dp0
set project_drive_letter=%bin_dirpath:~0,1%
%project_drive_letter%:
cd %bin_dirpath%
cd ..
set project_dirpath=%CD%
for %%I in (.) do set project_dirname=%%~nxI
if not "%~1" == "-q" powershell write-host -fore DarkGray "project_dirname = %project_dirname%"
if not exist "%project_dirpath%\var" mkdir %project_dirpath%\var
set Path=%project_dirpath%\bin;%Path%

rem Check environment for PHP
set PHPRC=
set php_dirpath=
set php_ini_filepath=
if not exist "%project_dirpath%\config\php-env.bat" goto ErrorPhpEnv
call "%project_dirpath%\config\php-env.bat"
if not defined php_dirpath goto ErrorPhpEnv
if not exist "%php_dirpath%" goto ErrorPhpEnv
if defined php_ini_filepath goto CheckPHPINI
if not exist "%php_dirpath%\php.ini" goto ErrorPhpEnv
set php_ini_filepath=%php_dirpath%\php.ini
:CheckPHPINI
if not exist "%php_ini_filepath%" goto ErrorPhpEnv

rem Setup PHP for CLI & built-in server usages
set Path=%php_dirpath%;%Path%
set PHPRC=%project_dirpath%\var\php
if not exist "%PHPRC%" mkdir %PHPRC%
set phprc_cli_ini_filepath=%PHPRC%\php-cli.ini
copy /y %php_ini_filepath% %phprc_cli_ini_filepath% >NUL

rem Overwrite PHP settings
set php_temp_dirpath=%project_dirpath%\var\php\tmp
if not exist "%php_temp_dirpath%" mkdir %php_temp_dirpath%
powershell -ExecutionPolicy Bypass -File bin\ini-set.ps1 -filepath '%phprc_cli_ini_filepath%' -name 'sys_temp_dir' -value '\"%php_temp_dirpath%\"'
if not "%~1" == "-q" php -v
goto End

rem Missing or wrong config\php-env.bat
:ErrorPhpEnv
set PHPRC=
if "%~1" == "-q" goto End
powershell write-host -fore DarkRed 'Missing or wrong \"config\php-env.bat\" file.'
powershell write-host -fore DarkYellow 'Call \"bin\get-php\" to download and setup PHP built-in web server.'
goto End

rem End
:End
rem Clear useless variables
set bin_dirpath=
set project_drive_letter=
set php_dirpath=
set php_ini_filepath=
set phprc_cli_ini_filepath=
set php_temp_dirpath=