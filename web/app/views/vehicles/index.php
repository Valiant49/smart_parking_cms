<?php
/** FOR INTELEPHENSE
 * @var array  $vehicles
 * @var string $q
 */
$statusClass = [
    'active'    => 'badge badge-success',
    'suspended' => 'badge badge-warning',
    'blocked'   => 'badge badge-danger',
];
?>
<div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-3 mb-4">
  <form method="get" action="/vehicles" class="flex gap-2">
    <input class="input sm:w-64" name="q" value="<?= e($q ?? '') ?>" placeholder="Search plate or owner">
    <button class="btn btn-secondary">Search</button>
  </form>
  <a href="/vehicles/create" class="btn btn-primary">+ Add Vehicle</a>
</div>

<div class="card p-0 overflow-x-auto">
  <table class="data-table">
    <thead>
      <tr><th>Plate</th><th>Owner</th><th>Type</th><th>Status</th><th class="text-right">Actions</th></tr>
    </thead>
    <tbody>
      <?php if (empty($vehicles)): ?>
        <tr><td colspan="5" class="text-center text-ink-muted py-8">No vehicles found.</td></tr>
      <?php endif; ?>

      <?php foreach ($vehicles as $v): ?>
        <tr>
          <td class="font-medium"><?= e($v['plate_number']) ?></td>
          <td><?= e($v['owner_name']) ?></td>
          <td><?= e($v['vehicle_type']) ?></td>
          <td><span class="<?= $statusClass[$v['status']] ?? 'badge badge-neutral' ?>"><?= e($v['status']) ?></span></td>
          <td class="text-right whitespace-nowrap">
            <a href="/vehicles/edit/<?= (int) $v['vehicle_id'] ?>" class="btn btn-secondary">Edit</a>
            <button type="button" class="btn btn-danger"
                    data-archive
                    data-action="/vehicles/delete/<?= (int) $v['vehicle_id'] ?>"
                    data-name="<?= e($v['plate_number']) ?>">Archive</button>
          </td>
        </tr>
      <?php endforeach; ?>
    </tbody>
  </table>
</div>

<!-- Archive modal (one instance, reused by every row) -->
<dialog id="archive-modal" class="m-auto w-full max-w-sm rounded-card bg-surface p-6 backdrop:bg-black/40">
  <h2 class="text-lg font-semibold mb-2">Archive vehicle?</h2>
  <p class="text-sm text-ink-muted mb-4">
    <span id="archive-name" class="font-medium text-ink"></span> will be hidden from the list.
    The record is kept for history.
  </p>
  <form id="archive-form" method="post" class="flex justify-end gap-2">
    <button type="button" class="btn btn-secondary" data-close>Cancel</button>
    <button class="btn btn-danger">Archive</button>
  </form>
</dialog>

<script>
  const modal = document.getElementById('archive-modal');
  document.querySelectorAll('[data-archive]').forEach(btn => {
    btn.addEventListener('click', () => {
      document.getElementById('archive-form').action = btn.dataset.action;
      document.getElementById('archive-name').textContent = btn.dataset.name;
      modal.showModal();
    });
  });
  modal.querySelector('[data-close]').addEventListener('click', () => modal.close());
</script>