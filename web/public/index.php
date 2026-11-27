<?php
// Dev server only: let PHP serve real files (css, js, images) directly
if (PHP_SAPI === 'cli-server') {
    $file = __DIR__ . parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
    if (is_file($file)) {
        return false;
    }
}

ini_set('display_errors', '1');
error_reporting(E_ALL);

require __DIR__ . '/../core/helpers.php';
require __DIR__ . '/../core/Router.php';
require __DIR__ . '/../core/Controller.php';
require __DIR__ . '/../core/Model.php';

$router = new Router();

$router->get('/',          'DashboardController@index');
$router->get('/dashboard', 'DashboardController@index');


// ---- Vehicles ----
$router->get('/vehicles',               'VehicleController@index');
$router->get('/vehicles/create',        'VehicleController@create');
$router->post('/vehicles/store',        'VehicleController@store');
$router->get('/vehicles/edit/{id}',     'VehicleController@edit');
$router->post('/vehicles/update/{id}',  'VehicleController@update');
$router->post('/vehicles/delete/{id}',  'VehicleController@delete');


$router->dispatch($_SERVER['REQUEST_METHOD'], $_SERVER['REQUEST_URI']);