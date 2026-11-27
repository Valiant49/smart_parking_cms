<?php
// Full class names so Tailwind can see them
$statusClass = [
    'active'    => 'badge badge-success',
    'suspended' => 'badge badge-warning',
    'blocked'   => 'badge badge-danger',
];
?>
<div class="flex items-center justify-between mb-4">
  <input class="input max-w-xs" placeholder="Search plate or owner">
  <a href="/vehicles/create" class="btn btn-primary">+ Add Vehicle</a>
</div>

<div class="card p-0 overflow-x-auto">
  <table class="data-table">
    <thead>
      <tr><th>Plate</th><th>Owner</th><th>Type</th><th>Status</th><th class="text-right">Actions</th></tr>
    </thead>
    <tbody>
      <?php if (empty($vehicles)): ?>
        <tr><td colspan="5" class="text-center text-ink-muted py-8">No vehicles registered yet.</td></tr>
      <?php endif; ?>

      <?php foreach ($vehicles as $v): ?>
        <tr>
          <td class="font-medium"><?= e($v['plate_number']) ?></td>
          <td><?= e($v['owner_name']) ?></td>
          <td><?= e($v['vehicle_type']) ?></td>
          <td><span class="<?= $statusClass[$v['status']] ?? 'badge badge-neutral' ?>"><?= e($v['status']) ?></span></td>
          <td class="text-right">
            <a href="/vehicles/edit/<?= (int) $v['vehicle_id'] ?>" class="btn btn-secondary">Edit</a>
            <form action="/vehicles/delete/<?= (int) $v['vehicle_id'] ?>" method="post" class="inline"
                  onsubmit="return confirm('Block this vehicle?')">
              <button class="btn btn-danger">Block</button>
            </form>
          </td>
        </tr>
      <?php endforeach; ?>
    </tbody>
  </table>
</div>