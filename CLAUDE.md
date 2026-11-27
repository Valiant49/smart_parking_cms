# CLAUDE.md

Context for AI assistants working on this repo. Read this first, then look at an existing module before writing a new one.

## Project

Smart Parking Management System with RFID. An Arduino/ESP prototype reads RFID cards and sensors, and a web-based admin CMS (PHP + MySQL) manages vehicles, cards, slots, logs and reports. The CMS is **admin-side only** (admin and parking staff). Vehicle owners have no accounts.

Key rule: CMS data must come from real Arduino activity. Hardware-written tables are read-only in the UI.

## Stack

- PHP 8.1+ (plain PHP, no framework), custom lightweight MVC
- MySQL / MariaDB, accessed through PDO
- Tailwind CSS v4 (CLI build, no CDN, no `tailwind.config.js`)
- Arduino + ESP8266/ESP32 firmware in `arduino/`

## Structure

```
arduino/                 firmware (not part of the web app)
database/
  smart_parking_schema.sql   SOURCE OF TRUTH for the database
web/
  public/                web root (index.php = single entry point, assets/)
  core/                  Router, Controller, Model, helpers (rarely edited)
  config/                database.php (gitignored), database.example.php
  resources/css/app.css  Tailwind input + @theme (colors/tokens)
  app/
    controllers/         one per module; controllers/Api/ for ESP endpoints
    models/              one per table, extends Model
    services/            business logic (e.g. AccessService)
    views/               layouts/ + one folder per module
```

All commands run from `web/`.

```bash
tailwind watch:css
php -S localhost:8000 -t public public/index.php
```

## Architecture rules

- **Controllers** handle the request and choose a view. No SQL, no HTML.
- **Models** hold SQL for one table. No HTML, no `$_POST`.
- **Views** hold HTML and simple loops only. No queries.
- **Services** hold rules that span tables (e.g. the RFID grant/deny decision).
- Routes are registered **only** in `public/index.php`.
- Pages render through `$this->view('module/page', ['title' => '...', ...])`, which wraps them in `layouts/header.php` and `footer.php`.
- ESP endpoints live under `/api/...` in `controllers/Api/`, return JSON, and authenticate with the device `api_key`, not a session.

## Database rules

- Always read `database/smart_parking_schema.sql` before writing queries. **Never invent table or column names.**
- Always use PDO prepared statements. Never concatenate user input into SQL.
- Never hard-delete vehicles, parking records or logs. Use the `status` column.
- Schema changes must update the schema file in the same PR.

Tables: `users`, `vehicles`, `rfid_cards` (1 card : 1 vehicle), `parking_slots`, `parking_records` (one row per parking session), `entry_exit_logs` (every RFID scan, granted or denied), `device_management`, `notifications`.

CRUD in the UI: users, vehicles, rfid_cards, parking_slots, device_management. Read-only: parking_records, entry_exit_logs, notifications.

## Coding conventions

- Classes/files: PascalCase (`VehicleController.php`). View folders: snake_case. Filename case must match exactly (Linux is case-sensitive).
- Escape every printed value with `e()` (defined in `core/helpers.php`).
- Use the Tailwind theme tokens and component classes (`card`, `btn btn-primary`, `badge badge-success`, `input`, `data-table`) instead of one-off styles.
- Status colors: green = active/available/granted, red = denied/occupied/blocked, amber = warning/maintenance/lost, grey = inactive/offline.
- Write full Tailwind class names. Never build them dynamically (`"bg-" . $color`).
- Keep `@source "../../app";` in `app.css` so Tailwind scans the PHP views.

## Don't

- Don't commit `web/config/database.php`, `arduino/config.h`, or secrets.
- Don't edit `core/` for a module-specific need without discussing it.
- Don't add frameworks or Composer packages without team agreement.
- Don't load assets from a CDN (the demo network may be offline).

## Reference

Use the Vehicles module as the pattern for any new CRUD module (model, controller, `index`/`create`/`edit` views, routes).