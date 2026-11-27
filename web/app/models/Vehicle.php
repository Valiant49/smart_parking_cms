<?php
class Vehicle extends Model {
    protected string $table = 'vehicles';
    protected string $primaryKey = 'vehicle_id';

    // SAMPLE FUNCTION
    public function findByPlate(string $plate) {
        return $this->query("SELECT * FROM vehicles WHERE plate_number = ?", [$plate])->fetch();
    }
}