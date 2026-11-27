<!-- The routes are registered in public/index.php:-->

<?php
class Router {
    private array $routes = [];

    public function get(string $path, string $handler)  { $this->routes['GET'][$path]  = $handler; }
    public function post(string $path, string $handler) { $this->routes['POST'][$path] = $handler; }

    public function dispatch(string $method, string $uri) {
        $path = rtrim(parse_url($uri, PHP_URL_PATH), '/') ?: '/';

        foreach ($this->routes[$method] ?? [] as $route => $handler) {
            // "/vehicles/edit/{id}" -> regex
            $pattern = '#^' . preg_replace('#\{(\w+)\}#', '([^/]+)', $route) . '$#';

            if (preg_match($pattern, $path, $m)) {
                array_shift($m);                                  // URL params
                [$class, $action] = explode('@', $handler);

                $file = __DIR__ . "/../app/controllers/$class.php";
                if (!file_exists($file)) { http_response_code(500); exit("Controller file missing: $class"); }
                require_once $file;

                $class = basename($class);                        // "Api/X" -> "X"
                return (new $class)->$action(...$m);
            }
        }

        http_response_code(404);
        echo '404 Not Found';
    }
}