<?php
require_once __DIR__ . '/../models/Vehicle.php';

class VehicleController extends Controller {
    public const TYPES    = ['car', 'motorcycle', 'suv', 'van', 'truck', 'other'];
    public const STATUSES = ['active', 'suspended', 'blocked'];

    public function index() {
        $q = trim($_GET['q'] ?? '');
        $m = new Vehicle;

        $this->view('vehicles/index', [
            'title'    => 'Vehicles',
            'vehicles' => $q !== '' ? $m->search($q) : $m->all(),
            'q'        => $q,
        ]);
    }

    public function create() {
        $this->view('vehicles/create', [
            'title'   => 'Add Vehicle',
            'vehicle' => ['vehicle_type' => 'car', 'status' => 'active'],
            'errors'  => [],
        ]);
    }

    public function store() {
        $m      = new Vehicle;
        $data   = $this->input();
        $errors = $this->validate($data, $m);

        if ($errors) {
            http_response_code(422);
            return $this->view('vehicles/create', [
                'title' => 'Add Vehicle', 'vehicle' => $data, 'errors' => $errors,
            ]);
        }

        $m->create($data);
        $this->redirect('/vehicles');
    }

    public function edit($id) {
        $vehicle = (new Vehicle)->find($id);
        if (!$vehicle) $this->notFound();

        $this->view('vehicles/edit', [
            'title' => 'Edit Vehicle', 'vehicle' => $vehicle, 'errors' => [],
        ]);
    }

    public function update($id) {
        $m = new Vehicle;
        if (!$m->find($id)) $this->notFound();

        $data   = $this->input();
        $errors = $this->validate($data, $m, $id);

        if ($errors) {
            http_response_code(422);
            $data['vehicle_id'] = $id;
            return $this->view('vehicles/edit', [
                'title' => 'Edit Vehicle', 'vehicle' => $data, 'errors' => $errors,
            ]);
        }

        $m->update($id, $data);
        $this->redirect('/vehicles');
    }

    // Archives (never hard-deletes). Called by the modal's POST form.
    public function delete($id) {
        $m = new Vehicle;
        if (!$m->find($id)) $this->notFound();

        $m->archive($id);
        $this->redirect('/vehicles');
    }

    // ---------- helpers ----------

    private function input(): array {
        $fields = ['plate_number', 'vehicle_type', 'brand', 'model',
                   'color', 'owner_name', 'owner_contact', 'status'];
        $d = [];
        foreach ($fields as $f) {
            $v = trim((string) ($_POST[$f] ?? ''));
            $d[$f] = $v === '' ? null : $v;           // empty -> NULL
        }
        if ($d['plate_number'] !== null) $d['plate_number'] = strtoupper($d['plate_number']);
        $d['vehicle_type'] ??= 'car';
        $d['status']       ??= 'active';
        return $d;
    }

    private function validate(array $d, Vehicle $m, $exceptId = null): array {
        $e = [];

        if (empty($d['plate_number'])) {
            $e['plate_number'] = 'Plate number is required.';
        } elseif (strlen($d['plate_number']) > 20) {
            $e['plate_number'] = 'Plate number is too long (max 20).';
        } elseif (!$m->isUnique('plate_number', $d['plate_number'], $exceptId)) {
            $e['plate_number'] = 'This plate number is already registered (it may be archived).';
        }

        if (empty($d['owner_name'])) {
            $e['owner_name'] = 'Owner name is required.';
        }
        if (!in_array($d['vehicle_type'], self::TYPES, true)) {
            $e['vehicle_type'] = 'Invalid vehicle type.';
        }
        if (!in_array($d['status'], self::STATUSES, true)) {
            $e['status'] = 'Invalid status.';
        }
        return $e;
    }

    private function notFound() {
        http_response_code(404);
        exit('Vehicle not found');
    }
}