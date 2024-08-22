<?php
require_once(implode(DIRECTORY_SEPARATOR, array(__DIR__, '..', '..', 'autoload.inc.php')));

$userscript_main_js_filepath = implode(DIRECTORY_SEPARATOR, array(PROJECT_ASSETS_DIRPATH, 'userscript', 'main.js'));
$content = file_get_contents($userscript_main_js_filepath);

header('Content-Type: application/javascript');
echo($content);