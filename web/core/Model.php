<?php
class Model {
    // Base class for all Models 
    protected PDO $db;
    protected string $table;          // each child sets this, e.g. 'vehicles'
    protected string $primaryKey = 'id';

    public function __construct() {
        $c = require __DIR__ . '/../config/database.php';
        $this->db = new PDO(
            "mysql:host={$c['host']};dbname={$c['name']};charset=utf8mb4",
            $c['user'], $c['pass'],
            [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
             PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC]
        );
    }

    protected function query(string $sql, array $params = []): PDOStatement {
        $stmt = $this->db->prepare($sql);         // prepared statements = no SQL injection
        $stmt->execute($params);
        return $stmt;
    }

    public function all()        { return $this->query("SELECT * FROM {$this->table}")->fetchAll(); }
    public function find($id)    { return $this->query("SELECT * FROM {$this->table} WHERE {$this->primaryKey} = ?", [$id])->fetch(); }
    public function delete($id)  { return $this->query("DELETE FROM {$this->table} WHERE {$this->primaryKey} = ?", [$id]); }
}