# SMART PARKING MANAGEMENT SYSTEM WITH RFID

## Project Requirements:
- php v8.4+
- Tailwind v4.3.5
- XAMPP

## Setup
1. Clone the repo
2. Install PHP 8.4+ and MySQL/MariaDB (or XAMPP)
3. Import database/smart_parking_schema.sql
4. Copy web/config/database.example.php to web/config/database.php and edit credentials
5. In web/, run: npm install
6. Terminal 1 (web/): tailwind watch:css
7. Terminal 2 (web/): php -S localhost:8000 -t public public/index.php
8. Open http://localhost:8000 in a browser