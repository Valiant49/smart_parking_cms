<?php
class Vehicle extends Model {
    protected string $table = 'vehicles';
    protected string $primaryKey = 'vehicle_id';
    protected bool   $archivable = true;
    protected array  $fillable = [
        'plate_number', 'vehicle_type', 'brand', 'model',
        'color', 'owner_name', 'owner_contact', 'status',
    ];

    public function search(string $q): array {
        $like = "%$q%";
        return $this->query(
            "SELECT * FROM vehicles
             WHERE archived_at IS NULL AND (plate_number LIKE ? OR owner_name LIKE ?)
             ORDER BY vehicle_id DESC",
            [$like, $like]
        )->fetchAll();
    }
}