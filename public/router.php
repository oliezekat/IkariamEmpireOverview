<?php
require_once(implode(DIRECTORY_SEPARATOR, array(__DIR__, 'autoload.inc.php')));

if (php_sapi_name() === "cli") {
    error_log(sprintf('Script "%s" not for CLI purpose.', $_SERVER['PHP_SELF']), 0);
    exit(1);
}
if (php_sapi_name() !== 'cli-server') {
    // todo: support Apache
}
$request_path = urldecode(parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH));
$script_path = $_SERVER['DOCUMENT_ROOT'];
$script_path .= str_replace('/', DIRECTORY_SEPARATOR, $request_path);
if (is_file($script_path) and file_exists($script_path)) {
    return false;
}
if (is_dir($script_path) and file_exists($script_path)) {
    $index_html_path = $script_path . DIRECTORY_SEPARATOR . 'index.html';
    if (is_file($index_html_path) and file_exists($index_html_path)) {
        return false;
    }
    $index_php_path = $script_path . DIRECTORY_SEPARATOR . 'index.php';
    if (is_file($index_php_path) and file_exists($index_php_path)) {
        $script_path = $index_php_path;
    } else {
        error_log(sprintf('Route "%s" not found.', $request_path), 0);
        $script_path = $_SERVER['DOCUMENT_ROOT'] . DIRECTORY_SEPARATOR . 'index.php';
    }
} else {
    error_log(sprintf('Route "%s" not found.', $request_path), 0);
    $script_path = $_SERVER['DOCUMENT_ROOT'] . DIRECTORY_SEPARATOR . 'index.php';
}
include_once($script_path);