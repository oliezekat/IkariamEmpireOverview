@echo off
rem Get or update, and setup PHP for CLI & built-in server usages

rem Load setup for CLI & batch usages
call "%~dp0\env.bat" -q

setlocal

rem PHP binaries source
goto LatestPhp81x
:LatestPhp83x
set php_download_url=https://windows.php.net/downloads/releases/latest/php-8.3-nts-Win32-vs16-x64-latest.zip
set php_destination_dirname=php-8.3-nts-Win32-vs16-x64-latest
goto CheckPhpEnvExists
:LatestPhp82x
set php_download_url=https://windows.php.net/downloads/releases/latest/php-8.2-nts-Win32-vs16-x64-latest.zip
set php_destination_dirname=php-8.2-nts-Win32-vs16-x64-latest
goto CheckPhpEnvExists
:LatestPhp81x
set php_download_url=https://windows.php.net/downloads/releases/latest/php-8.1-nts-Win32-vs16-x64-latest.zip
set php_destination_dirname=php-8.1-nts-Win32-vs16-x64-latest
goto CheckPhpEnvExists
:LatestPhp80x
set php_download_url=https://windows.php.net/downloads/releases/latest/php-8.0-nts-Win32-vs16-x64-latest.zip
set php_destination_dirname=php-8.0-nts-Win32-vs16-x64-latest
goto CheckPhpEnvExists
:LatestPhp74x
set php_download_url=https://windows.php.net/downloads/releases/latest/php-7.4-nts-Win32-vc15-x64-latest.zip
set php_destination_dirname=php-7.4-nts-Win32-vc15-x64-latest
goto CheckPhpEnvExists

rem Check if environment for PHP already exists
:CheckPhpEnvExists
if not exist "%project_dirpath%\config\php-env.bat" goto DstDir
powershell write-host -fore DarkRed 'Replace current environment for PHP in \"config\php-env.bat\" ?'
choice /c yn /n /m "[Y]es or [N]o : "
if errorlevel 2 goto End
if errorlevel 1 goto DstDir
goto End

rem PHP destination directory
:DstDir
set php_destination_dirpath=%project_dirpath%\var\%php_destination_dirname%
if not exist "%php_destination_dirpath%" goto MakeDestDir
powershell write-host -fore DarkRed 'Replace current PHP release in \"%php_destination_dirname%\" ?'
choice /c yn /n /m "[Y]es or [N]o : "
if errorlevel 2 goto SetupPhpEnv
if errorlevel 1 goto ClearDestDir
goto End
:ClearDestDir
del /s /q %php_destination_dirpath%\* >NUL
goto DstFile
:MakeDestDir
mkdir %php_destination_dirpath%

rem PHP archive destination file
:DstFile
set php_destination_filename=%php_destination_dirname%.zip
set php_destination_filepath=%project_dirpath%\var\tmp\%php_destination_filename%
if exist "%php_destination_filepath%" del /q %php_destination_filepath% >NUL

rem Download PHP archive file
:DownloadZipFile
powershell -ExecutionPolicy Bypass -File bin\download-file.ps1 -url '%php_download_url%' -filepath '%php_destination_filepath%' -caption "PHP for Windows"

rem Unzip PHP archive file
:UnzipFile
powershell Expand-Archive '%php_destination_filepath%' -DestinationPath '%php_destination_dirpath%' -Force
if exist "%php_destination_filepath%" del /q %php_destination_filepath% >NUL

rem Setup config\php-env.bat
:SetupPhpEnv
powershell write-host -fore DarkBlue 'Setup PHP environment in \"config\php-env.bat\"... ' -NoNewline
if "%~1" == "-vv" powershell write-host ''
set php_env_filepath=%project_dirpath%\config\php-env.bat
copy /y %project_dirpath%\config\php-env.bat.dist %php_env_filepath% >NUL
powershell -ExecutionPolicy Bypass -File bin\bat-set.ps1 -filepath '%php_env_filepath%' -name 'php_dirpath' -value '%php_destination_dirpath%'
if "%~1" == "-vv" powershell write-host -fore DarkGray "php_dirpath = %php_destination_dirpath%"
set php_ini_dev_filepath=%php_destination_dirpath%\php.ini-development
powershell -ExecutionPolicy Bypass -File bin\bat-set.ps1 -filepath '%php_env_filepath%' -name 'php_ini_filepath' -value '%php_ini_dev_filepath%'
if "%~1" == "-vv" powershell write-host -fore DarkGray "php_ini_filepath = %php_ini_dev_filepath%"
set php_destination_extensions_dirpath=%php_destination_dirpath%\ext
powershell -ExecutionPolicy Bypass -File bin\bat-set.ps1 -filepath '%php_env_filepath%' -name 'php_extensions_dirpath' -value '%php_destination_extensions_dirpath%'
if "%~1" == "-vv" powershell write-host -fore DarkGray "php_extensions_dirpath = %php_destination_extensions_dirpath%"
rem Setup PHP extensions to load
:PhpExtensionCurl
powershell -ExecutionPolicy Bypass -File bin\bat-set.ps1 -filepath '%php_env_filepath%' -name 'php_extension_curl_name' -value 'curl'
if "%~1" == "-vv" powershell write-host -fore DarkGray "php_extension_curl_name = curl"
:PhpExtensionOpenssl
powershell -ExecutionPolicy Bypass -File bin\bat-set.ps1 -filepath '%php_env_filepath%' -name 'php_extension_openssl_name' -value 'openssl'
if "%~1" == "-vv" powershell write-host -fore DarkGray "php_extension_openssl_name = openssl"
:PhpExtensionZip
powershell -ExecutionPolicy Bypass -File bin\bat-set.ps1 -filepath '%php_env_filepath%' -name 'php_extension_zip_name' -value 'zip'
if "%~1" == "-vv" powershell write-host -fore DarkGray "php_extension_zip_name = zip"
powershell write-host -fore DarkGreen 'Done.'
goto ReloadEnv

rem Reload environment
:ReloadEnv
endlocal
cd %current_dirpath%
call "%project_dirpath%\bin\get-ca-bundle.bat"
call "%project_dirpath%\bin\get-composer.bat"
call "%project_dirpath%\bin\env.bat"

rem Check new PHP environment
if not defined PHPRC goto ErrorPhpEnv
if not exist "%PHPRC%\php-cli.ini" goto ErrorPhpEnv
powershell write-host -fore DarkYellow 'Call \"bin\php-server\" to start it.'
goto End

rem Missing or wrong config\php-env.bat
:ErrorPhpEnv
powershell write-host -fore DarkRed 'Wrong new PHP environment.'
goto End

rem End
:End
endlocal
cd %current_dirpath%