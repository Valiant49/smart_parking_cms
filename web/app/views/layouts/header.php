<?php
$title = $title ?? 'Smart Parking';
$bare  = $bare  ?? false;      // true = no sidebar (for the login page, later)
?>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title><?= e($title) ?> | Smart Parking</title>
  <link rel="stylesheet" href="/assets/css/style.css">
</head>
<body class="bg-page text-ink font-sans antialiased">

<?php if ($bare): ?>
<main class="min-h-screen grid place-items-center p-4">
<?php else: ?>
<div class="flex min-h-screen">
  <?php require __DIR__ . '/sidebar.php'; ?>

  <div class="flex-1 flex flex-col min-w-0">
    <header class="flex items-center justify-between bg-surface border-b border-line px-6 h-14">
      <h1 class="text-lg font-semibold"><?= e($title) ?></h1>
      <div class="text-sm text-ink-muted">Parking Admin</div>
    </header>

    <main class="flex-1 p-6">
<?php endif; ?>