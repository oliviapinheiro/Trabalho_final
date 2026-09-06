<?php
require_once __DIR__ . '/../includes/guard.php';
exigirLoginApi();
header('Content-Type: application/json; charset=utf-8');

$pdo = getConexao();
echo json_encode($pdo->query('SELECT id, codigo, nome FROM turmas ORDER BY codigo')->fetchAll(PDO::FETCH_ASSOC));
