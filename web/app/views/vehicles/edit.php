<form action="/vehicles/update/<?= (int) $vehicle['vehicle_id'] ?>" method="post" class="card max-w-xl space-y-4">
  <div>
    <label class="label">Plate number</label>
    <input class="input" name="plate_number" value="<?= e($vehicle['plate_number']) ?>" required>
  </div>
  <div>
    <label class="label">Owner name</label>
    <input class="input" name="owner_name" value="<?= e($vehicle['owner_name']) ?>" required>
  </div>
  <div class="grid grid-cols-2 gap-4">
    <div>
      <label class="label">Type</label>
      <select class="input" name="vehicle_type">
        <?php foreach (['car', 'motorcycle', 'suv', 'van', 'truck'] as $t): ?>
          <option <?= $vehicle['vehicle_type'] === $t ? 'selected' : '' ?>><?= e($t) ?></option>
        <?php endforeach; ?>
      </select>
    </div>
    <div>
      <label class="label">Status</label>
      <select class="input" name="status">
        <?php foreach (['active', 'suspended', 'blocked'] as $s): ?>
          <option <?= $vehicle['status'] === $s ? 'selected' : '' ?>><?= e($s) ?></option>
        <?php endforeach; ?>
      </select>
    </div>
  </div>
  <div class="flex gap-2">
    <button class="btn btn-primary">Update</button>
    <a href="/vehicles" class="btn btn-secondary">Cancel</a>
  </div>
</form>