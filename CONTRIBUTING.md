# Contributing

## Setup

1. Clone the repo.
2. Install PHP 8.1+ and MySQL/MariaDB (XAMPP works), plus Node.js.
3. Create the database and import `database/smart_parking_schema.sql`.
4. Copy `web/config/database.example.php` to `web/config/database.php` and set your credentials.
5. In `web/`, run `npm install`.
6. Run both of these from `web/`, in two terminals:

```bash
tailwind watch:css
php -S localhost:8000 -t public public/index.php
```

7. Open http://localhost:8000

If the page is unstyled, hard-refresh (Ctrl+Shift+R) and check that the Tailwind terminal is still running.

## Workflow

- Pick an issue from the GitHub Project board and move it to **In Progress**.
- One branch per issue: `feature/<issue#>-short-name` (e.g. `feature/13-vehicle-crud`).
- Never commit directly to `main` or `dev`. Pull `dev` before you start and before you open a PR.
- Commit messages: short and imperative ("Add vehicle search filter").
- Open a PR that says `Closes #<issue>`. Another teammate must review it before merging.
- Keep PRs small. Merge often.
- Stuck for more than an hour? Post in the group chat.

## Adding a module

Copy the pattern from the Vehicles module:

1. Model in `app/models/` (extends `Model`)
2. Controller in `app/controllers/` (extends `Controller`)
3. Views in `app/views/<module>/` (`index`, `create`, `edit`)
4. Routes in `public/index.php` (add yours in your own block to avoid merge conflicts)
5. Sidebar link (already listed in `app/views/layouts/sidebar.php`)

## Rules

- Controllers: no SQL. Models: no HTML. Views: no queries.
- Use PDO prepared statements. Escape all output with `e()`.
- `database/smart_parking_schema.sql` is the source of truth. If you change the schema, update that file in the same PR and tell the team to re-import.
- Don't hard-delete vehicles, records or logs. Use the `status` column.
- Filename case must match the class name exactly (Linux is case-sensitive).
- Use the existing Tailwind classes (`card`, `btn`, `badge`, `input`, `data-table`). Add new colors in `@theme` in `resources/css/app.css`.
- Never commit `web/config/database.php`, `arduino/config.h`, or any password/API key.

## Before you open a PR

- [ ] Works on a fresh database import
- [ ] Tried valid, invalid and empty input
- [ ] No PHP warnings or errors
- [ ] Screenshot attached (for UI changes)

## Using AI assistants

Read `CLAUDE.md` first. Give your AI the schema file and one existing module as a pattern, and read every line it generates before committing. You are responsible for what you push.