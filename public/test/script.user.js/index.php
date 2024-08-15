<?php
header('Content-Type: application/javascript');
$project_dirpath = dirname(__FILE__) . DIRECTORY_SEPARATOR . '..' . DIRECTORY_SEPARATOR . '..' . DIRECTORY_SEPARATOR . '..' . DIRECTORY_SEPARATOR;
$templates_dirpath = $project_dirpath . DIRECTORY_SEPARATOR . 'templates';
$userscript_user_js_twig_filepath = $templates_dirpath . DIRECTORY_SEPARATOR . 'userscript' . DIRECTORY_SEPARATOR . 'test' . DIRECTORY_SEPARATOR . 'script.user.js.twig';
$content = file_get_contents($userscript_user_js_twig_filepath);
$assets_dirpath = $project_dirpath . DIRECTORY_SEPARATOR . 'assets';
$userscript_main_js_filepath = $assets_dirpath . DIRECTORY_SEPARATOR . 'userscript' . DIRECTORY_SEPARATOR . 'main.js';
clearstatcache();
$userscript_meta_version = gmdate('Y.md.His', filemtime($userscript_main_js_filepath));
$content = str_replace('{{ userscript.meta.version }}', $userscript_meta_version, $content);
echo($content);