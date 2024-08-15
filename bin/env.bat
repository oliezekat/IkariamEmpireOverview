@echo off
rem Setup project & PHP for CLI

rem Save current paths environment
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
set Path=%project_dirpath%\bin;%Path%
for %%I in (.) do set project_dirname=%%~nxI
if not "%~1" == "-q" powershell write-host -fore DarkBlue 'Setup \"%project_dirname%\" as project directory... ' -NoNewline
if not exist "%project_dirpath%\var" mkdir %project_dirpath%\var
if not exist "%project_dirpath%\var\logs" mkdir %project_dirpath%\var\logs
if not exist "%project_dirpath%\var\tmp" mkdir %project_dirpath%\var\tmp
set env_errors_log_filepath=%project_dirpath%\var\logs\env-errors.log
if exist "%env_errors_log_filepath%" del /q %env_errors_log_filepath% >NUL
if not "%~1" == "-q" powershell write-host -fore DarkGreen ' Done.'

rem Check environment for PHP
set php_env_filepath=%project_dirpath%\config\php-env.bat
if not exist "%project_dirpath%\config\php-env.bat" goto ErrorPhpEnv
call "%project_dirpath%\config\php-env.bat"
if not defined php_dirpath goto ErrorPhpEnv
if not exist "%php_dirpath%\php.exe" goto ErrorPhpEnv
if defined php_ini_filepath goto CheckPhpIni
if not exist "%php_dirpath%\php.ini-development" goto ErrorPhpEnv
set php_ini_filepath=%php_dirpath%\php.ini-development
:CheckPhpIni
if not exist "%php_ini_filepath%" goto ErrorPhpEnv

rem Setup PHPRC
set Path=%php_dirpath%;%Path%
set PHPRC=%project_dirpath%\var\php
if not exist "%PHPRC%" mkdir %PHPRC%
copy /y %php_ini_filepath% %PHPRC%\php.ini >NUL

setlocal

rem Overwrite PHP INI for CLI usage
set phprc_cli_ini_filepath=%project_dirpath%\var\php\php-cli.ini
copy /y %php_ini_filepath% %phprc_cli_ini_filepath% >NUL
powershell -ExecutionPolicy Bypass -File bin\ini-set.ps1 -filepath '%phprc_cli_ini_filepath%' -name 'allow_url_fopen' -value 'On'
set php_temp_dirpath=%project_dirpath%\var\php\tmp
if not exist "%php_temp_dirpath%" mkdir %php_temp_dirpath%
powershell -ExecutionPolicy Bypass -File bin\ini-set.ps1 -filepath '%phprc_cli_ini_filepath%' -name 'sys_temp_dir' -value '\"%php_temp_dirpath%\"'
set php_logs_dirpath=%project_dirpath%\var\php\logs
if not exist "%php_logs_dirpath%" mkdir %php_logs_dirpath%
powershell -ExecutionPolicy Bypass -File bin\ini-set.ps1 -filepath '%phprc_cli_ini_filepath%' -name 'error_log' -value '\"%php_logs_dirpath%\cli-errors.log\"'
if not defined php_extensions_dirpath goto CheckPhpConfig
if not exist "%php_extensions_dirpath%" goto ErrorPhpEnv
powershell -ExecutionPolicy Bypass -File bin\ini-set.ps1 -filepath '%phprc_cli_ini_filepath%' -name 'extension_dir' -value '\"%php_extensions_dirpath%\"'
:PhpExtensionCurl
if not defined php_extension_curl_name goto PhpExtensionOpenssl
powershell -ExecutionPolicy Bypass -File bin\ini-enable-extension.ps1 -filepath '%phprc_cli_ini_filepath%' -name '%php_extension_curl_name%'
if not defined php_extension_curl_cainfo goto PhpExtensionOpenssl
if not exist "%php_extension_curl_cainfo%" goto ErrorPhpEnv
powershell -ExecutionPolicy Bypass -File bin\ini-set.ps1 -filepath '%phprc_cli_ini_filepath%' -name 'curl.cainfo' -value '\"%php_extension_curl_cainfo%\"'
:PhpExtensionOpenssl
if not defined php_extension_openssl_name goto PhpExtensionZip
powershell -ExecutionPolicy Bypass -File bin\ini-enable-extension.ps1 -filepath '%phprc_cli_ini_filepath%' -name '%php_extension_openssl_name%'
if not defined php_extension_openssl_cafile goto PhpExtensionZip
if not exist "%php_extension_openssl_cafile%" goto ErrorPhpEnv
powershell -ExecutionPolicy Bypass -File bin\ini-set.ps1 -filepath '%phprc_cli_ini_filepath%' -name 'openssl.cafile' -value '\"%php_extension_openssl_cafile%\"'
:PhpExtensionZip
if not defined php_extension_zip_name goto CheckPhpConfig
powershell -ExecutionPolicy Bypass -File bin\ini-enable-extension.ps1 -filepath '%phprc_cli_ini_filepath%' -name '%php_extension_zip_name%'

rem Check PHP requirements
:CheckPhpConfig
php -r "if (empty(ini_get('extension_dir')) or (file_exists(ini_get('extension_dir')) === false)) { file_put_contents('%env_errors_log_filepath%', 'Missing or wrong extension_dir parameter.'.PHP_EOL, FILE_APPEND); }"
php -r "if (extension_loaded('openssl') === false) { file_put_contents('%env_errors_log_filepath%', 'Missing OpenSSL extension.'.PHP_EOL, FILE_APPEND); }"
if not "%~1" == "-q" goto ReportPhpConfig
if exist "%env_errors_log_filepath%" goto ErrorPhpEnv
goto CheckComposer

rem Report PHP configuration
:ReportPhpConfig
powershell write-host -fore DarkBlue 'Check PHP requirements... ' -NoNewline
if exist "%env_errors_log_filepath%" goto ReportPhpConfigWrong
powershell write-host -fore DarkGreen 'OK.'
if "%~1" == "-vv" goto ReportFullPhpConfig
goto CheckComposer

:ReportPhpConfigWrong
powershell write-host -fore DarkRed 'WRONG'

:ReportFullPhpConfig
php -v
php -r "echo('Parameter \'extension_dir\' ');"
php -r "echo((empty(ini_get('extension_dir')) ? 'REQUIRED' : '= \''.ini_get('extension_dir').'\' '.(file_exists(ini_get('extension_dir')) ? 'OK' : 'WRONG')).PHP_EOL);"
php -r "echo('Extension \'curl\' ');"
php -r "echo((extension_loaded('curl') ? 'OK' : 'NONE').PHP_EOL);"
php -r "echo('Parameter \'curl.cainfo\' ');"
php -r "echo((empty(ini_get('curl.cainfo')) ? 'NONE' : '= \''.ini_get('curl.cainfo').'\' '.(file_exists(ini_get('curl.cainfo')) ? 'OK' : 'WRONG')).PHP_EOL);"
php -r "echo('Extension \'openssl\' ');"
php -r "echo((extension_loaded('openssl') ? 'OK' : 'REQUIRED').PHP_EOL);"
php -r "echo('Parameter \'openssl.cafile\' ');"
php -r "echo((empty(ini_get('openssl.cafile')) ? 'NONE' : '= \''.ini_get('openssl.cafile').'\' '.(file_exists(ini_get('openssl.cafile')) ? 'OK' : 'WRONG')).PHP_EOL);"
php -r "echo('Extension \'zip\' ');"
php -r "echo((extension_loaded('zip') ? 'OK' : 'NONE').PHP_EOL);"
if exist "%env_errors_log_filepath%" goto ErrorPhpEnv

rem Check Composer
:CheckComposer
set composer_phar_filepath=%project_dirpath%\var\composer\composer.phar
if not exist "%composer_phar_filepath%" goto End

rem Setup Composer
:SetupComposer
endlocal
set Path=%project_dirpath%\bin\composer;%Path%
goto End

rem Missing or wrong config\php-env.bat
:ErrorPhpEnv
if exist "%project_dirpath%\var\php\php-cli.ini" del /q "%project_dirpath%\var\php\php-cli.ini" >NUL
endlocal
set PHPRC=
set Path=%project_dirpath%\bin;%system_dirpaths%
if "%~1" == "-q" goto End
powershell write-host -fore DarkRed 'Missing or wrong \"config\php-env.bat\" file.'
powershell write-host -fore DarkYellow 'Call \"bin\get-php\" to download and setup PHP for Windows.'

rem End
:End
endlocal
rem Clear useless variables
set bin_dirpath=
set project_drive_letter=
set env_errors_log_filepath=
rem Clear useless variables from config\php-env.bat
set php_dirpath=
set php_ini_filepath=
set php_extensions_dirpath=
set php_extension_curl_name=
set php_extension_curl_cainfo=
set php_extension_openssl_name=
set php_extension_openssl_cafile=
set php_extension_zip_name=
if not "%~1" == "-q" cd %current_dirpath%