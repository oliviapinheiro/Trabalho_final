<?php
require_once __DIR__ . '/../config.php';
header('Content-Type: application/json; charset=utf-8');

$dados = json_decode(file_get_contents('php://input'), true) ?? $_POST;
$email = strtolower(trim($dados['email'] ?? ''));
$senha = $dados['senha'] ?? '';

if (!filter_var($email, FILTER_VALIDATE_EMAIL) || $senha === ''){
    http_response_code(422);
    echo json_encode(['erro' => 'Informe e-mail e senha.']);
    exit;
}

$pdo = getConexao();
$stmt = $pdo->prepare('SELECT id, nome, email, senha, tipo, foto FROM usuarios WHERE email = ?');
$stmt->execute([$email]);
$usuario = $stmt->fetch(PDO::FETCH_ASSOC);

if (!$usuario || !password_verify($senha, $usuario['senha'])){
    http_response_code(401);
    echo json_encode(['erro' => 'E-mail ou senha incorretos.']);
    exit;
}

$_SESSION['usuario_id']    = $usuario['id'];
$_SESSION['usuario_nome']  = $usuario['nome'];
$_SESSION['usuario_email'] = $usuario['email'];
$_SESSION['usuario_tipo']  = $usuario['tipo'];
$_SESSION['usuario_foto']  = $usuario['foto'];

echo json_encode([
    'sucesso' => true,
    'usuario' => [
        'nome'  => $usuario['nome'],
        'tipo'  => $usuario['tipo'],
        'foto'  => $usuario['foto'],
    ],
]);
