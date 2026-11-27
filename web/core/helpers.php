<?php
// HTML-escape output. Use on EVERY value printed in a view.
function e($value): string {
    return htmlspecialchars((string) $value, ENT_QUOTES, 'UTF-8');
}

// TEMPORARY: remove the fallback once login works.
function current_user(): array {
    $user = class_exists('Auth') ? Auth::user() : null;
    return $user ?? ['name' => 'Dev User', 'role' => 'admin'];
}