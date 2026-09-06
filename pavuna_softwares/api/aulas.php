<?php
require_once __DIR__ . '/../includes/guard.php';
exigirLoginApi();
header('Content-Type: application/json; charset=utf-8');

$pdo = getConexao();

$turmas = $pdo->query('SELECT id, codigo, nome FROM turmas ORDER BY codigo')->fetchAll(PDO::FETCH_ASSOC);

$sql = "SELECT a.id, a.dia_semana, a.turno, a.sala, a.status,
               t.codigo AS turma_codigo, t.nome AS turma_nome,
               u.id AS instrutor_id, u.nome AS instrutor_nome
        FROM aulas a
        JOIN turmas t ON t.id = a.turma_id
        LEFT JOIN usuarios u ON u.id = a.instrutor_id
        ORDER BY a.dia_semana, a.turno";
$aulas = $pdo->query($sql)->fetchAll(PDO::FETCH_ASSOC);

echo json_encode(['turmas' => $turmas, 'aulas' => $aulas]);
