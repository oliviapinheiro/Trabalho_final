<?php
require_once __DIR__ . '/../includes/guard.php';
exigirLoginApi();

$pdo = getConexao();

// Instrutor só pode ver o relatório dele mesmo; coordenador pode ver de qualquer um
$instrutorId = $_GET['instrutor_id'] ?? null;
if ($_SESSION['usuario_tipo'] === 'instrutor'){
    $instrutorId = $_SESSION['usuario_id'];
} elseif ($_SESSION['usuario_tipo'] !== 'coordenador'){
    http_response_code(403);
    header('Content-Type: application/json; charset=utf-8');
    echo json_encode(['erro' => 'Seu perfil não tem acesso a relatórios.']);
    exit;
}
if (empty($instrutorId)){
    http_response_code(422);
    header('Content-Type: application/json; charset=utf-8');
    echo json_encode(['erro' => 'Selecione um instrutor.']);
    exit;
}

$stmt = $pdo->prepare("SELECT nome FROM usuarios WHERE id = ? AND tipo = 'instrutor'");
$stmt->execute([$instrutorId]);
$instrutor = $stmt->fetch(PDO::FETCH_ASSOC);
if (!$instrutor){
    http_response_code(404);
    header('Content-Type: application/json; charset=utf-8');
    echo json_encode(['erro' => 'Instrutor não encontrado.']);
    exit;
}

$sql = "SELECT a.dia_semana, a.turno, a.sala, a.status, t.codigo AS turma_codigo, t.nome AS turma_nome
        FROM aulas a JOIN turmas t ON t.id = a.turma_id
        WHERE a.instrutor_id = ?
        ORDER BY a.dia_semana, a.turno";
$stmt = $pdo->prepare($sql);
$stmt->execute([$instrutorId]);
$aulas = $stmt->fetchAll(PDO::FETCH_ASSOC);

$resumo = ['confirmada' => 0, 'reposicao' => 0, 'cancelada' => 0];
foreach ($aulas as $a){
    $resumo[$a['status']] = ($resumo[$a['status']] ?? 0) + 1;
}

// Exportação em CSV: /api/relatorio_instrutor.php?instrutor_id=1&formato=csv
if (($_GET['formato'] ?? '') === 'csv'){
    header('Content-Type: text/csv; charset=utf-8');
    header('Content-Disposition: attachment; filename="relatorio_' . preg_replace('/\s+/', '_', $instrutor['nome']) . '.csv"');
    $saida = fopen('php://output', 'w');
    fputcsv($saida, ['Dia', 'Turno', 'Turma', 'Sala', 'Status']);
    $dias = ['Segunda','Terça','Quarta','Quinta','Sexta','Sábado'];
    foreach ($aulas as $a){
        fputcsv($saida, [$dias[$a['dia_semana']], $a['turno'], $a['turma_codigo'] . ' - ' . $a['turma_nome'], $a['sala'], $a['status']]);
    }
    fclose($saida);
    exit;
}

header('Content-Type: application/json; charset=utf-8');
echo json_encode(['instrutor' => $instrutor['nome'], 'resumo' => $resumo, 'aulas' => $aulas, 'total' => count($aulas)]);
