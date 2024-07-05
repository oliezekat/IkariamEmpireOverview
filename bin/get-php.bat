@echo off
rem Download and setup PHP for built-in server usages

rem Load setup for CLI & batch usages
call "%~dp0\env.bat" -q

rem Default download source and destination
if not defined php_download_url set php_download_url=https://windows.php.net/downloads/releases/latest/php-8.3-nts-Win32-vs16-x64-latest.zip
if not defined php_destination_dirname set php_destination_dirname=php-8.3-nts-Win32-vs16-x64-latest

setlocal

rem Check current environment for PHP
if not exist "%project_dirpath%\config\php-env.bat" goto DstFile
powershell write-host -fore DarkRed 'Overwrite current environment for PHP in \"config\php-env.bat\" ?'
choice /c yn /n /m "[Y]es or [N]o : "
if errorlevel 2 goto End
if errorlevel 1 goto DstFile
goto End

rem Destination file
:DstFile
set php_destination_filename=%php_destination_dirname%.zip
set php_destination_filepath=%project_dirpath%\var\%php_destination_filename%

rem Destination directory
set php_destination_dirpath=%project_dirpath%\var\%php_destination_dirname%
if not exist "%php_destination_dirpath%" goto MakeDestDir
powershell write-host -fore DarkRed 'Replace current PHP release in \"var\%php_destination_dirname%\" ?'
choice /c yn /n /m "[Y]es or [N]o : "
if errorlevel 2 goto End
if errorlevel 1 goto ClearDestDir
goto End
:ClearDestDir
del /s /q %php_destination_dirpath%\* >NUL
goto DownloadZipFile
:MakeDestDir
mkdir %php_destination_dirpath%

rem Download with PowerShell WebClient
:DownloadZipFile
powershell -ExecutionPolicy Bypass -File bin\download-file.ps1 -url '%php_download_url%' -filepath '%php_destination_filepath%'

rem Unzip
powershell Expand-Archive '%php_destination_filepath%' -DestinationPath %php_destination_dirpath% -Force
del /q %php_destination_filepath% >NUL

rem Setup config\php-env.bat
powershell write-host -fore DarkBlue 'Setup PHP environment in \"config\php-env.bat\"...'
set php_env_filepath=%project_dirpath%\config\php-env.bat
copy /y %project_dirpath%\config\php-env.bat.dist %php_env_filepath% >NUL
powershell -ExecutionPolicy Bypass -File bin\bat-set.ps1 -filepath '%php_env_filepath%' -name 'php_dirpath' -value '%php_destination_dirpath%'
powershell write-host -fore DarkGray "php_dirpath = %php_destination_dirpath%"
set php_ini_dev_filepath=%php_destination_dirpath%\php.ini-development
powershell -ExecutionPolicy Bypass -File bin\bat-set.ps1 -filepath '%php_env_filepath%' -name 'php_ini_filepath' -value '%php_ini_dev_filepath%'
powershell write-host -fore DarkGray "php_ini_filepath = %php_ini_dev_filepath%"

rem Reload environment
endlocal
set php_download_url=
set php_dirname=
cd %current_dirpath%
call "%project_dirpath%\bin\env.bat"
powershell write-host -fore DarkGreen "Call 'bin\php-server' to start it."
goto :EOF

:End
endlocal
set php_download_url=
set php_dirname=
cd %current_dirpath%