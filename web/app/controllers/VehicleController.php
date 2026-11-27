<?php
require_once __DIR__ . '/../models/Vehicle.php';

class VehicleController extends Controller {

    public function index() {
        $this->view('vehicles/index', [
            'title'    => 'Vehicles',
            'vehicles' => (new Vehicle)->all(),
        ]);
    }

    public function create() {
        $this->view('vehicles/create', ['title' => 'Add Vehicle']);
    }

    public function store() {
        // TODO: validate $_POST and insert via the Vehicle model
        $this->redirect('/vehicles');
    }

    public function edit($id) {
        $vehicle = null;
        foreach ($this->vehicles() as $v) {
            if ((int) $v['vehicle_id'] === (int) $id) { $vehicle = $v; break; }
        }
        if (!$vehicle) { http_response_code(404); exit('Vehicle not found'); }

        $this->view('vehicles/edit', ['title' => 'Edit Vehicle', 'vehicle' => $vehicle]);
    }

    public function update($id) {
        // TODO: validate $_POST and update via the Vehicle model
        $this->redirect('/vehicles');
    }

    public function delete($id) {
        // TODO: set status = 'blocked' (or archive). Never hard-delete.
        $this->redirect('/vehicles');
    }

    // TEMPORARY sample data. Replace with: return (new Vehicle)->all();
    private function vehicles(): array {
        return [
            ['vehicle_id' => 1, 'plate_number' => 'ABC 1234', 'owner_name' => 'Juan Dela Cruz', 'vehicle_type' => 'car',        'status' => 'active'],
            ['vehicle_id' => 2, 'plate_number' => 'XYZ 5678', 'owner_name' => 'Maria Santos',   'vehicle_type' => 'suv',        'status' => 'active'],
            ['vehicle_id' => 3, 'plate_number' => 'MNO 9012', 'owner_name' => 'Pedro Reyes',    'vehicle_type' => 'motorcycle', 'status' => 'suspended'],
            ['vehicle_id' => 4, 'plate_number' => 'DEF 3456', 'owner_name' => 'Ana Lim',        'vehicle_type' => 'van',        'status' => 'blocked'],
        ];
    }
}