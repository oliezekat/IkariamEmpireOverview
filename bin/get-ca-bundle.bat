@echo off
rem Get or update root certificates bundle by Curl (from Mozilla Firefox)

rem Load setup for CLI & batch usages
call "%~dp0\env.bat" -q

setlocal

rem Check if environment for PHP already exists
:CheckPhpEnvExists
set php_env_filepath=%project_dirpath%\config\php-env.bat
if not exist "%php_env_filepath%" goto End

rem Destination directory
:DstDir
set cabundle_destination_dirpath=%project_dirpath%\var\certs
if not exist "%cabundle_destination_dirpath%" mkdir %cabundle_destination_dirpath%

rem Destination file
:DstFile
set cabundle_destination_filename=curl-ca-bundle.pem
set cabundle_destination_filepath=%cabundle_destination_dirpath%\%cabundle_destination_filename%

rem Download root certificates bundle
set cabundle_download_url=https://curl.se/ca/cacert.pem
powershell -ExecutionPolicy Bypass -File bin\download-file.ps1 -url '%cabundle_download_url%' -filepath '%cabundle_destination_filepath%' -caption "Curl root certificates bundle"

rem Setup PHP environment with downloaded bundle
powershell write-host -fore DarkBlue 'Setup root certificates bundle in \"config\php-env.bat\"... ' -NoNewline
if "%~1" == "-vv" powershell write-host ''
powershell -ExecutionPolicy Bypass -File bin\bat-set.ps1 -filepath '%php_env_filepath%' -name 'php_extension_curl_cainfo' -value '%cabundle_destination_filepath%'
if "%~1" == "-vv" powershell write-host -fore DarkGray "php_extension_curl_cainfo = %cabundle_destination_filepath%"
powershell -ExecutionPolicy Bypass -File bin\bat-set.ps1 -filepath '%php_env_filepath%' -name 'php_extension_openssl_cafile' -value '%cabundle_destination_filepath%'
if "%~1" == "-vv" powershell write-host -fore DarkGray "php_extension_openssl_cafile = %cabundle_destination_filepath%"
powershell write-host -fore DarkGreen 'Done.'
goto End

rem End
:End
endlocal
cd %current_dirpath%