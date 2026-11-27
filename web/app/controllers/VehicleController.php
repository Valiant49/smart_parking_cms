<?php
require_once __DIR__ . '/../models/Vehicle.php';

class VehicleController extends Controller {

    public function index() {
        Auth::requireLogin();

        $vehicles = (new Vehicle)->all();

        $this->view('vehicles/index', [
            'title'    => 'Vehicles',
            'vehicles' => $vehicles,
        ]);
    }
}