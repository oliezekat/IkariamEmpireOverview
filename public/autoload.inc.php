<?php
if (defined('PROJECT_DIRPATH') === false) {
    define('PROJECT_DIRPATH', implode(DIRECTORY_SEPARATOR, array(__DIR__, '..')));
}
if (defined('PROJECT_ASSETS_DIRPATH') === false) {
    define('PROJECT_ASSETS_DIRPATH', implode(DIRECTORY_SEPARATOR, array(PROJECT_DIRPATH, 'assets')));
}
if (defined('PROJECT_TEMPLATES_DIRPATH') === false) {
    define('PROJECT_TEMPLATES_DIRPATH', implode(DIRECTORY_SEPARATOR, array(PROJECT_DIRPATH, 'templates')));
}
require_once(implode(DIRECTORY_SEPARATOR, array(PROJECT_DIRPATH, 'vendor', 'autoload.php')));