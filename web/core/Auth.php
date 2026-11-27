<!-- Auth manager for the CMS -->

<?php
class Auth {
    public static function attempt(string $username, string $password): bool {
        $user = (new User)->findByUsername($username);
        if ($user && $user['status'] === 'active' && password_verify($password, $user['password_hash'])) {
            session_regenerate_id(true);
            $_SESSION['user'] = ['id' => $user['user_id'], 'name' => $user['full_name'], 'role' => $user['role']];
            return true;
        }
        return false;
    }

    public static function check(): bool { return isset($_SESSION['user']); }
    public static function user()        { return $_SESSION['user'] ?? null; }

    public static function requireLogin() {
        if (!self::check()) { header('Location: /login'); exit; }
    }

    public static function requireRole(string $role) {      // e.g. only admins manage users
        self::requireLogin();
        if ($_SESSION['user']['role'] !== $role) { http_response_code(403); exit('Forbidden'); }
    }

    public static function logout() { session_destroy(); }
}