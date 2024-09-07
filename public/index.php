<?php
require_once(implode(DIRECTORY_SEPARATOR, array(__DIR__, 'autoload.inc.php')));

use Psr\Http\Message\ResponseInterface              as PsrHttpResponse;
use Psr\Http\Message\ServerRequestInterface         as PsrHttpServerRequest;
use Slim\Factory\AppFactory                         as SlimAppFactory;
use Slim\Error\Renderers\PlainTextErrorRenderer     as SlimPlainTextErrorRenderer;
use Slim\Handlers\ErrorHandler                      as SlimErrorHandler;

class SlimLogErrorRendererFromRequest extends SlimPlainTextErrorRenderer
{
    public function __invoke(Throwable $exception, bool $displayErrorDetails): string
    {
        return sprintf(
            "Request \"%s\" returned \"%s\".",
            $exception->getRequest()->getUri()->getPath(),
            $this->getErrorTitle($exception)
            );
    }
}
class SlimErrorHandlerCli extends SlimErrorHandler
{
    protected function logError(string $error): void
    {
        parent::logError($error);
        if ('cli-server' === php_sapi_name()) {
            // CLI output
            error_log($error . PHP_EOL, 3, 'php://stderr'); 
        }
    }
}
$slim_app = SlimAppFactory::create();
$slim_app->addRoutingMiddleware();
$slim_errorHandler = new SlimErrorHandlerCli($slim_app->getCallableResolver(), $slim_app->getResponseFactory());
$slim_errorHandler->setLogErrorRenderer(SlimLogErrorRendererFromRequest::class);
$slim_errorMiddleware = $slim_app->addErrorMiddleware(false, true, false);
$slim_errorMiddleware->setDefaultErrorHandler($slim_errorHandler);
// Define app routes
$slim_app->get('/favicon.ico', function (PsrHttpServerRequest $request, PsrHttpResponse $response) {
    $filepath = implode(DIRECTORY_SEPARATOR, array(PROJECT_ASSETS_DIRPATH, 'favicon.ico'));
    $content = file_get_contents($filepath);
    $response = $response->withHeader('Content-type', 'image/x-icon');
    $response->getBody()->write($content);
    return $response;
});
$slim_app->get('/assets/userscript/local/favicon.ico', function (PsrHttpServerRequest $request, PsrHttpResponse $response) {
    $filepath = implode(DIRECTORY_SEPARATOR, array(PROJECT_ASSETS_DIRPATH, 'favicon.ico'));
    $content = file_get_contents($filepath);
    $response = $response->withHeader('Content-type', 'image/x-icon');
    $response->getBody()->write($content);
    return $response;
});
$slim_app->get('/assets/userscript/local/main.js', function (PsrHttpServerRequest $request, PsrHttpResponse $response) {
    $filepath = implode(DIRECTORY_SEPARATOR, array(PROJECT_ASSETS_DIRPATH, 'userscript', 'main.js'));
    $content = file_get_contents($filepath);
    $response = $response->withHeader('Content-type', 'application/javascript');
    $response->getBody()->write($content);
    return $response;
});
// Run app
$slim_app->run();