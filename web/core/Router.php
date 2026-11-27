<!-- The routes are registered in public/index.php:-->


<?php
class Router {
    private array $routes = [];

    public function get(string $path, string $handler)  { $this->routes['GET'][$path]  = $handler; }
    public function post(string $path, string $handler) { $this->routes['POST'][$path] = $handler; }

    public function dispatch(string $method, string $uri) {
        $path = parse_url($uri, PHP_URL_PATH);

        foreach ($this->routes[$method] ?? [] as $route => $handler) {
            // turn "/vehicles/edit/{id}" into a regex
            $pattern = '#^' . preg_replace('#\{(\w+)\}#', '([^/]+)', $route) . '$#';
            if (preg_match($pattern, $path, $m)) {
                array_shift($m);                       // remaining items = URL params
                [$class, $action] = explode('@', $handler);
                require_once __DIR__ . "/../app/controllers/$class.php";
                return (new $class)->$action(...$m);
            }
        }
        http_response_code(404);
        echo '404 Not Found';
    }
}