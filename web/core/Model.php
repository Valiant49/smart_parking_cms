<?php
class Model {
    protected string $table = '';
    protected string $primaryKey = 'id';
    protected array  $fillable = [];       // columns allowed to be written
    protected bool   $archivable = false;  // true = table has archived_at
    private static ?PDO $pdo = null;

    protected function db(): PDO {
        if (self::$pdo === null) {
            $c = require __DIR__ . '/../config/database.php';
            self::$pdo = new PDO(
                "mysql:host={$c['host']};dbname={$c['name']};charset=utf8mb4",
                $c['user'], $c['pass'],
                [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
                 PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC]
            );
        }
        return self::$pdo;
    }

    protected function query(string $sql, array $params = []): PDOStatement {
        $stmt = $this->db()->prepare($sql);
        $stmt->execute($params);
        return $stmt;
    }

    // All active (non-archived) records, newest first
    public function all(): array {
        $sql = "SELECT * FROM `{$this->table}`";
        if ($this->archivable) $sql .= " WHERE archived_at IS NULL";
        $sql .= " ORDER BY `{$this->primaryKey}` DESC";
        return $this->query($sql)->fetchAll();
    }

    // One active record, or null
    public function find($id) {
        $sql = "SELECT * FROM `{$this->table}` WHERE `{$this->primaryKey}` = ?";
        if ($this->archivable) $sql .= " AND archived_at IS NULL";
        return $this->query($sql, [$id])->fetch() ?: null;
    }

    // Insert. Only $fillable columns are written. Returns the new id.
    public function create(array $data): int {
        $data = $this->onlyFillable($data);
        if (!$data) throw new InvalidArgumentException('No fillable data given.');

        $cols  = implode(', ', array_map(fn($c) => "`$c`", array_keys($data)));
        $marks = implode(', ', array_fill(0, count($data), '?'));
        $this->query("INSERT INTO `{$this->table}` ($cols) VALUES ($marks)", array_values($data));
        return (int) $this->db()->lastInsertId();
    }

    // Update. Only $fillable columns are written.
    public function update($id, array $data): bool {
        $data = $this->onlyFillable($data);
        if (!$data) return false;

        $set = implode(', ', array_map(fn($c) => "`$c` = ?", array_keys($data)));
        $this->query(
            "UPDATE `{$this->table}` SET $set WHERE `{$this->primaryKey}` = ?",
            [...array_values($data), $id]
        );
        return true;
    }

    // "Delete" = archive. There is intentionally no hard-delete method.
    public function archive($id): bool {
        if (!$this->archivable) {
            throw new LogicException("{$this->table} cannot be archived.");
        }
        $this->query(
            "UPDATE `{$this->table}` SET archived_at = NOW()
             WHERE `{$this->primaryKey}` = ? AND archived_at IS NULL",
            [$id]
        );
        return true;
    }

    // Is this value unused? Pass $exceptId when editing so a record doesn't clash with itself.
    // Archived rows count as used (the DB UNIQUE keys still apply to them).
    public function isUnique(string $column, $value, $exceptId = null): bool {
        if (!in_array($column, $this->fillable, true)) {
            throw new InvalidArgumentException("Column not allowed: $column");
        }
        $sql    = "SELECT COUNT(*) FROM `{$this->table}` WHERE `$column` = ?";
        $params = [$value];
        if ($exceptId !== null) {
            $sql .= " AND `{$this->primaryKey}` <> ?";
            $params[] = $exceptId;
        }
        return (int) $this->query($sql, $params)->fetchColumn() === 0;
    }

    private function onlyFillable(array $data): array {
        return array_intersect_key($data, array_flip($this->fillable));
    }
}