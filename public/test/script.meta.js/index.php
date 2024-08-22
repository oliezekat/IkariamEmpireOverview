<?php
require_once(implode(DIRECTORY_SEPARATOR, array(__DIR__, '..', '..', 'autoload.inc.php')));

include_once(implode(DIRECTORY_SEPARATOR, array(__DIR__, '..', 'twig_loader.inc.php')));
$twig_template = $twig_env->load('userscript/test/script.meta.js.twig');
$twig_render_vars = array(
    'userscript' => $userscript_vars,
);
$content = $twig_template->render($twig_render_vars);

header('Content-Type: application/javascript');
echo($content);