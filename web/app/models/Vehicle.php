<?php
class Vehicle extends Model {
    protected string $table = 'vehicles';
    protected string $primaryKey = 'vehicle_id';

    #[Override]
    public function __construct()
    {
        return parent::__construct();
    }
}