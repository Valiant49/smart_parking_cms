<?php
class DashboardController extends Controller {
    public function index() {
        // No Auth::requireLogin() yet, on purpose.
        $this->view('dashboard/index', ['title' => 'Dashboard']);
    }
}