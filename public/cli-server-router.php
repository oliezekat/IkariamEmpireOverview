<?php
// disallow self script call from CLI
if ('cli' === php_sapi_name()) {
    error_log(sprintf("Script \"%s\" not for CLI usage.", $_SERVER['PHP_SELF']), 0);
    // CLI output
    error_log(sprintf("Script \"%s\" not for CLI usage.", $_SERVER['PHP_SELF']) . PHP_EOL, 3, 'php://stderr'); 
    exit(1);
}
// allow PHP built-in server only for any request
if ('cli-server' !== php_sapi_name()) {
    error_log(sprintf("Script \"%s\" for PHP's built-in server only.", $_SERVER['PHP_SELF']), 0);
    http_response_code(403);
    exit(1);
}
$request_uri_path = urldecode(parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH));
$script_path = $_SERVER['DOCUMENT_ROOT'];
if ('/' !== $request_uri_path) {
    $script_path .= str_replace('/', DIRECTORY_SEPARATOR, $request_uri_path);
}
if (file_exists($script_path)) {
    if (is_file($script_path)) {
        $script_filename = basename($script_path);
        // let serve static file
        if ('php' !== strtolower(pathinfo($script_filename, PATHINFO_EXTENSION))) {
            return false;
        }
        // disallow request to PHP's script not named "index.php"
        if ('index.php' !== $script_filename) {
            error_log(sprintf("Request \"%s\" not allowed.", $request_uri_path), 0);
            if ('cli-server' === php_sapi_name()) {
                // CLI output
                error_log(sprintf("Request \"%s\" not allowed.", $request_uri_path) . PHP_EOL, 3, 'php://stderr'); 
            }
            http_response_code(403);
            exit(1);
        }
        // let any "index.php" script to manage routing and/or response
    } else if (is_dir($script_path)) {
        // let serve directory's "index.html" as static file
        $index_html_path = $script_path . DIRECTORY_SEPARATOR . 'index.html';
        if (is_file($index_html_path) and file_exists($index_html_path)) {
            return false;
        }
        $index_php_path = $script_path . DIRECTORY_SEPARATOR . 'index.php';
        if (is_file($index_php_path) and file_exists($index_php_path)) {
            // let directory's index.php to manage response
            $script_path = $index_php_path;
        } else {
            // let root's "index.php" to manage routing and response
            $script_path = $_SERVER['DOCUMENT_ROOT'] . DIRECTORY_SEPARATOR . 'index.php';
        }
    } else {
        // Probably a symbolic link but could not resolve if is file or directory
        error_log(sprintf("Request \"%s\" not supported.", $request_uri_path), 0);
        if ('cli-server' === php_sapi_name()) {
            // CLI output
            error_log(sprintf("Request \"%s\" not supported.", $request_uri_path) . PHP_EOL, 3, 'php://stderr'); 
        }
        http_response_code(501);
        exit(1);
    }
} else {
    // let root's "index.php" to manage routing and response
    $script_path = $_SERVER['DOCUMENT_ROOT'] . DIRECTORY_SEPARATOR . 'index.php';
}
if (false === file_exists($script_path)) {
    error_log(sprintf("Script \"%s\" not found.", str_replace($_SERVER['DOCUMENT_ROOT'], '', $script_path)), 0);
    if ('cli-server' === php_sapi_name()) {
        // CLI output
        error_log(sprintf("Script \"%s\" not found.", str_replace($_SERVER['DOCUMENT_ROOT'], '', $script_path)) . PHP_EOL, 3, 'php://stderr'); 
    }
    http_response_code(404);
    exit(1);
}
if ('cli-server' === php_sapi_name()) {
        // CLI output
        fwrite(
            fopen('php://stdout', 'w'),
            sprintf(
                "Request \"%s\" managed by \"%s\".",
                $request_uri_path,
                str_replace($_SERVER['DOCUMENT_ROOT'], '', $script_path)
                ) . PHP_EOL
            );
    }
include_once($script_path);