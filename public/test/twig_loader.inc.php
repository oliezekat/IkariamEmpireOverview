<?php
$twig_loader = new \Twig\Loader\FilesystemLoader(PROJECT_TEMPLATES_DIRPATH);
$twig_env = new \Twig\Environment($twig_loader, [
    'cache'          => false,
    'autoescape'     => false,
]);
// sources files used to render local test userscript
$userscript_sources      = array();
$userscript_sources[]    = implode(DIRECTORY_SEPARATOR, array(PROJECT_TEMPLATES_DIRPATH, 'userscript', 'test', 'script.meta.js.twig'));
$userscript_sources[]    = implode(DIRECTORY_SEPARATOR, array(PROJECT_TEMPLATES_DIRPATH, 'userscript', 'test', 'script.user.js.twig'));
$userscript_sources[]    = implode(DIRECTORY_SEPARATOR, array(PROJECT_ASSETS_DIRPATH, 'userscript', 'main.js'));
$userscript_sources[]    = implode(DIRECTORY_SEPARATOR, array(PROJECT_ASSETS_DIRPATH, 'favicon.ico'));
// calc timed version from files modified time
$userscript_sources_time = 0;
clearstatcache();
foreach ($userscript_sources as $source_filepath){
    $userscript_sources_time = max($userscript_sources_time, filemtime($source_filepath));
}
// vars to render with Twig
$userscript_meta_version = gmdate('Y.z.His', $userscript_sources_time); // timed version number for local test
$userscript_meta_vars = array(
    'version' => $userscript_meta_version,
);
$userscript_vars = array(
    'meta' => $userscript_meta_vars,
);
