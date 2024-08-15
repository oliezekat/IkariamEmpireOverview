<?php
header('Content-Type: application/javascript');
$project_dirpath = dirname(__FILE__) . DIRECTORY_SEPARATOR . '..' . DIRECTORY_SEPARATOR . '..' . DIRECTORY_SEPARATOR . '..' . DIRECTORY_SEPARATOR;
$assets_dirpath = $project_dirpath . DIRECTORY_SEPARATOR . 'assets';
$userscript_main_js_filepath = $assets_dirpath . DIRECTORY_SEPARATOR . 'userscript' . DIRECTORY_SEPARATOR . 'main.js';
$content = file_get_contents($userscript_main_js_filepath);
echo($content);