<?php
require_once __DIR__ . '/../includes/guard.php';
exigirLoginApi();
header('Content-Type: application/json; charset=utf-8');

$pdo = getConexao();
$usuarioId = $_SESSION['usuario_id'];

// Atualizar nome (via JSON) e/ou foto (via multipart/form-data com campo "foto")
$nome = trim($_POST['nome'] ?? '');
if ($nome === '' && empty($_FILES['foto'])){
    $dados = json_decode(file_get_contents('php://input'), true) ?? [];
    $nome = trim($dados['nome'] ?? '');
}

if ($nome !== '' && strlen($nome) >= 2){
    $stmt = $pdo->prepare('UPDATE usuarios SET nome = ? WHERE id = ?');
    $stmt->execute([$nome, $usuarioId]);
    $_SESSION['usuario_nome'] = $nome;
}

if (!empty($_FILES['foto']) && $_FILES['foto']['error'] === UPLOAD_ERR_OK){
    $permitidos = ['image/jpeg' => 'jpg', 'image/png' => 'png', 'image/webp' => 'webp'];
    $tipoArquivo = mime_content_type($_FILES['foto']['tmp_name']);

    if (!isset($permitidos[$tipoArquivo])){
        http_response_code(422);
        echo json_encode(['erro' => 'Envie uma imagem JPG, PNG ou WEBP.']);
        exit;
    }
    if ($_FILES['foto']['size'] > 3 * 1024 * 1024){
        http_response_code(422);
        echo json_encode(['erro' => 'A imagem deve ter no máximo 3MB.']);
        exit;
    }

    $nomeArquivo = 'usuario_' . $usuarioId . '_' . time() . '.' . $permitidos[$tipoArquivo];
    $destino = __DIR__ . '/../uploads/fotos/' . $nomeArquivo;
    move_uploaded_file($_FILES['foto']['tmp_name'], $destino);

    $caminhoPublico = 'uploads/fotos/' . $nomeArquivo;
    $stmt = $pdo->prepare('UPDATE usuarios SET foto = ? WHERE id = ?');
    $stmt->execute([$caminhoPublico, $usuarioId]);
    $_SESSION['usuario_foto'] = $caminhoPublico;
}

echo json_encode([
    'sucesso' => true,
    'nome' => $_SESSION['usuario_nome'],
    'foto' => $_SESSION['usuario_foto'],
]);
