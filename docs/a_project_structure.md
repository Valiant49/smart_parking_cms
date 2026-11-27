# Smart Parking Project Structure 



```
smart-parking/
│
├── arduino/                      # Hardware code (separate from the web app)
│   ├── main_controller/
│   │   └── main_controller.ino   # RFID, servo, IR, LCD, buzzer, LEDs
│   ├── wifi_gateway/
│   │   └── wifi_gateway.ino      # ESP8266/ESP32: sends data to the API
│   └── config.h                  # WiFi SSID, server URL, API key
│
├── database/
│   └── smart_parking_schema.sql  # The schema file I gave you
│
├── docs/                         # Required: documentation and user manual
│
└── web/                          # Put this folder in htdocs (XAMPP)
    ├── index.php                 # Redirects to login or dashboard
    │
    ├── config/
    │   └── database.php          # PDO connection
    │
    ├── includes/                 # Shared pieces
    │   ├── auth.php              # Session check + role check
    │   ├── functions.php         # Helpers (formatting, flash messages)
    │   ├── header.php
    │   ├── sidebar.php
    │   └── footer.php
    │
    ├── api/                      # Endpoints the ESP calls (JSON in/out)
    │   ├── rfid_scan.php         # Card scan -> grant/deny + log + record
    │   ├── slot_update.php       # Ultrasonic sensor -> update slot status
    │   ├── heartbeat.php         # Device "I'm alive" -> last_seen_at
    │   └── status.php            # CMS polls this for real-time updates
    │
    ├── auth/
    │   ├── login.php
    │   └── logout.php
    │
    ├── admin/                    # Pages = CMS modules
    │   ├── dashboard.php         # Modules 2 and 7: stats + live slot status
    │   ├── users/                # Modules 1 and 8
    │   ├── vehicles/             # Module 3
    │   ├── rfid_cards/           # Module 4
    │   ├── slots/                # Module 5
    │   ├── logs/                 # Module 6: entry/exit logs
    │   ├── records/              # Module 9: transaction history
    │   ├── reports/              # Module 10
    │   ├── devices/              # Module 11
    │   └── notifications/        # Module 12
    │
    └── assets/
        ├── css/
        ├── js/
        │   └── live-status.js    # Polls api/status.php every few seconds
        └── img/
```


Each folder under `admin/` follows the same CRUD pattern:
```
vehicles/
├── index.php      # List + search
├── create.php     # Add form
├── edit.php       # Edit form
└── delete.php     # Handler (or soft-delete via status)
```
