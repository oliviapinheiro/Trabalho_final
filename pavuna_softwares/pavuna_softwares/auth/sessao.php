<?php
require_once __DIR__ . '/../config.php';
header('Content-Type: application/json; charset=utf-8');

if (!isset($_SESSION['usuario_id'])){
    http_response_code(401);
    echo json_encode(['logado' => false]);
    exit;
}

echo json_encode([
    'logado' => true,
    'nome'   => $_SESSION['usuario_nome'],
    'email'  => $_SESSION['usuario_email'],
    'tipo'   => $_SESSION['usuario_tipo'],
    'foto'   => $_SESSION['usuario_foto'],
]);
