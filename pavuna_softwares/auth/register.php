<?php
require_once __DIR__ . '/../config.php';
header('Content-Type: application/json; charset=utf-8');

$dados = json_decode(file_get_contents('php://input'), true) ?? $_POST;

$nome  = trim($dados['nome'] ?? '');
$email = strtolower(trim($dados['email'] ?? ''));
$senha = $dados['senha'] ?? '';
$tipo  = $dados['tipo'] ?? '';

$tiposValidos = ['coordenador', 'instrutor', 'aluno'];

if (strlen($nome) < 2){
    http_response_code(422);
    echo json_encode(['erro' => 'Informe o nome completo.']);
    exit;
}
if (!filter_var($email, FILTER_VALIDATE_EMAIL)){
    http_response_code(422);
    echo json_encode(['erro' => 'Informe um e-mail válido.']);
    exit;
}
if (strlen($senha) < 6){
    http_response_code(422);
    echo json_encode(['erro' => 'A senha precisa ter ao menos 6 caracteres.']);
    exit;
}
if (!in_array($tipo, $tiposValidos, true)){
    http_response_code(422);
    echo json_encode(['erro' => 'Selecione um tipo de conta válido.']);
    exit;
}

$pdo = getConexao();

$stmt = $pdo->prepare('SELECT id FROM usuarios WHERE email = ?');
$stmt->execute([$email]);
if ($stmt->fetch()){
    http_response_code(409);
    echo json_encode(['erro' => 'Já existe uma conta com esse e-mail.']);
    exit;
}

$hash = password_hash($senha, PASSWORD_DEFAULT);
$stmt = $pdo->prepare('INSERT INTO usuarios (nome, email, senha, tipo) VALUES (?, ?, ?, ?)');
$stmt->execute([$nome, $email, $hash, $tipo]);

echo json_encode(['sucesso' => true, 'mensagem' => 'Conta criada com sucesso!']);
