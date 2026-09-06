<?php
require_once __DIR__ . '/../includes/guard.php';
header('Content-Type: application/json; charset=utf-8');
$pdo = getConexao();

$metodo = $_SERVER['REQUEST_METHOD'];

if ($metodo === 'GET'){
    exigirLoginApi();
    $sql = "SELECT id, nome, email FROM usuarios WHERE tipo = 'instrutor' ORDER BY nome";
    echo json_encode($pdo->query($sql)->fetchAll(PDO::FETCH_ASSOC));
    exit;
}

if ($metodo === 'POST'){
    // Só coordenador pode cadastrar novos instrutores
    exigirPerfilApi(['coordenador']);

    $dados = json_decode(file_get_contents('php://input'), true) ?? [];
    $nome  = trim($dados['nome'] ?? '');
    $email = strtolower(trim($dados['email'] ?? ''));
    $senha = $dados['senha'] ?? '';

    if (strlen($nome) < 2 || !filter_var($email, FILTER_VALIDATE_EMAIL) || strlen($senha) < 6){
        http_response_code(422);
        echo json_encode(['erro' => 'Preencha nome, e-mail válido e senha (mín. 6 caracteres).']);
        exit;
    }

    $stmt = $pdo->prepare('SELECT id FROM usuarios WHERE email = ?');
    $stmt->execute([$email]);
    if ($stmt->fetch()){
        http_response_code(409);
        echo json_encode(['erro' => 'Já existe uma conta com esse e-mail.']);
        exit;
    }

    $hash = password_hash($senha, PASSWORD_DEFAULT);
    $stmt = $pdo->prepare("INSERT INTO usuarios (nome, email, senha, tipo) VALUES (?, ?, ?, 'instrutor')");
    $stmt->execute([$nome, $email, $hash]);

    echo json_encode(['sucesso' => true, 'id' => $pdo->lastInsertId()]);
    exit;
}

http_response_code(405);
echo json_encode(['erro' => 'Método não permitido.']);
