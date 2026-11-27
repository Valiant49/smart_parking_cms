<?php
$nav = [
    ['label' => 'Dashboard',      'href' => '/dashboard'],
    ['label' => 'Monitoring',     'href' => '/monitoring'],
    ['label' => 'Vehicles',       'href' => '/vehicles'],
    ['label' => 'RFID Cards',     'href' => '/rfid-cards'],
    ['label' => 'Slots',          'href' => '/slots'],
    ['label' => 'Entry/Exit Logs','href' => '/logs'],
    ['label' => 'Records',        'href' => '/records'],
    ['label' => 'Reports',        'href' => '/reports'],
    ['label' => 'Devices',        'href' => '/devices'],
    ['label' => 'Notifications',  'href' => '/notifications'],
    ['label' => 'Users',          'href' => '/users'],
];

$path    = trim(parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH), '/');
$current = '/' . explode('/', $path)[0];     // "/vehicles/edit/5" -> "/vehicles"
?>
<aside class="w-64 shrink-0 bg-sidebar text-slate-300 flex flex-col">
  <div class="h-14 flex items-center px-5 text-white font-semibold border-b border-white/10">
    Smart Parking
  </div>
  <nav class="flex-1 p-3 space-y-1">
    <?php foreach ($nav as $item): ?>
      <a href="<?= e($item['href']) ?>"
         class="block rounded-lg px-3 py-2 text-sm <?= $current === $item['href']
              ? 'bg-white/10 text-white'
              : 'hover:bg-white/5 hover:text-white' ?>">
        <?= e($item['label']) ?>
      </a>
    <?php endforeach; ?>
  </nav>
</aside>