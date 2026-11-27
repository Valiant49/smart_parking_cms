<!-- Base class for all Controllers -->

<?php
class Controller {
    protected function view(string $view, array $data = []) {
        extract($data);                                 // makes $vehicles etc. available
        require __DIR__ . '/../app/views/layouts/header.php';
        require __DIR__ . "/../app/views/$view.php";
        require __DIR__ . '/../app/views/layouts/footer.php';
    }

    protected function redirect(string $url) {
        header("Location: $url");
        exit;
    }

    protected function json(array $data, int $status = 200) {   // used by the ESP endpoints
        http_response_code($status);
        header('Content-Type: application/json');
        echo json_encode($data);
        exit;
    }
}