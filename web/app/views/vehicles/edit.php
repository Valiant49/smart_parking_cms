<?php
/** @var array $vehicle - FOR INTELEPHENSE*/ 
$action = '/vehicles/update/' . (int) $vehicle['vehicle_id'];
$submit = 'Update';
require __DIR__ . '/_form.php';