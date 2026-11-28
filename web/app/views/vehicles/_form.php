<?php
// Expects: $action, $submit, $vehicle (array), $errors (array)
/** FOR INTELEPHENSE
 * @var string $action
 * @var string $submit
 * @var array  $vehicle
 * @var array  $errors
 */
$v   = $vehicle ?? [];
$errors = $errors ?? [];
$val = fn($k) => e($v[$k] ?? '');
$err = fn($k) => isset($errors[$k])
    ? '<p class="mt-1 text-xs text-danger">' . e($errors[$k]) . '</p>' : '';
?>
<form action="<?= e($action) ?>" method="post" class="card max-w-2xl space-y-4">
  <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
    <div>
      <label class="label">Plate number *</label>
      <input class="input" name="plate_number" value="<?= $val('plate_number') ?>">
      <?= $err('plate_number') ?>
    </div>
    <div>
      <label class="label">Owner name *</label>
      <input class="input" name="owner_name" value="<?= $val('owner_name') ?>">
      <?= $err('owner_name') ?>
    </div>
    <div>
      <label class="label">Type</label>
      <select class="input" name="vehicle_type">
        <?php foreach (VehicleController::TYPES as $t): ?>
          <option <?= ($v['vehicle_type'] ?? '') === $t ? 'selected' : '' ?>><?= e($t) ?></option>
        <?php endforeach; ?>
      </select>
      <?= $err('vehicle_type') ?>
    </div>
    <div>
      <label class="label">Status</label>
      <select class="input" name="status">
        <?php foreach (VehicleController::STATUSES as $s): ?>
          <option <?= ($v['status'] ?? '') === $s ? 'selected' : '' ?>><?= e($s) ?></option>
        <?php endforeach; ?>
      </select>
      <?= $err('status') ?>
    </div>
    <div>
      <label class="label">Brand</label>
      <input class="input" name="brand" value="<?= $val('brand') ?>">
    </div>
    <div>
      <label class="label">Model</label>
      <input class="input" name="model" value="<?= $val('model') ?>">
    </div>
    <div>
      <label class="label">Color</label>
      <input class="input" name="color" value="<?= $val('color') ?>">
    </div>
    <div>
      <label class="label">Contact</label>
      <input class="input" name="owner_contact" value="<?= $val('owner_contact') ?>">
    </div>
  </div>

  <div class="flex gap-2">
    <button class="btn btn-primary"><?= e($submit) ?></button>
    <a href="/vehicles" class="btn btn-secondary">Cancel</a>
  </div>
</form>