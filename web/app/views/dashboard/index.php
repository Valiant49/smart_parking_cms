<div class="grid grid-cols-4 gap-4 mb-6">
  <?php foreach (['Total Slots' => 6, 'Available' => 4, 'Occupied' => 2, 'Vehicles' => 12] as $label => $n): ?>
    <div class="card">
      <p class="text-sm text-ink-muted"><?= e($label) ?></p>
      <p class="text-3xl font-semibold"><?= (int) $n ?></p>
    </div>
  <?php endforeach; ?>
</div>

<div class="card">
  <p class="mb-3 font-medium">Status badges</p>
  <span class="badge badge-success">available</span>
  <span class="badge badge-danger">occupied</span>
  <span class="badge badge-warning">maintenance</span>
</div>