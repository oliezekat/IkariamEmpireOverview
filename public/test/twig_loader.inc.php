<?php
$twig_loader = new \Twig\Loader\FilesystemLoader(PROJECT_TEMPLATES_DIRPATH);
$twig_env = new \Twig\Environment($twig_loader, [
    'cache'          => false,
    'autoescape'     => false,
]);
$userscript_main_js_filepath = implode(DIRECTORY_SEPARATOR, array(PROJECT_ASSETS_DIRPATH, 'userscript', 'main.js'));
clearstatcache();
$userscript_meta_version = gmdate('Y.z.His', filemtime($userscript_main_js_filepath));
$userscript_meta_vars = array(
    'version' => $userscript_meta_version,
);
$userscript_vars = array(
    'meta' => $userscript_meta_vars,
);
