<?php
require_once __DIR__ . '/../includes/guard.php';
header('Content-Type: application/json; charset=utf-8');
$pdo = getConexao();

$metodo = $_SERVER['REQUEST_METHOD'];

if ($metodo === 'GET'){
    exigirLoginApi();
    $sql = "SELECT u.id, u.nome, u.email,
                   t.codigo AS turma_codigo, t.nome AS turma_nome,
                   m.frequencia
            FROM usuarios u
            LEFT JOIN matriculas m ON m.aluno_id = u.id
            LEFT JOIN turmas t ON t.id = m.turma_id
            WHERE u.tipo = 'aluno'
            ORDER BY u.nome";
    echo json_encode($pdo->query($sql)->fetchAll(PDO::FETCH_ASSOC));
    exit;
}

if ($metodo === 'POST'){
    // Coordenador e instrutor podem cadastrar alunos
    exigirPerfilApi(['coordenador', 'instrutor']);

    $dados = json_decode(file_get_contents('php://input'), true) ?? [];
    $nome     = trim($dados['nome'] ?? '');
    $email    = strtolower(trim($dados['email'] ?? ''));
    $senha    = $dados['senha'] ?? '';
    $turmaId  = $dados['turma_id'] ?? null;

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

    $pdo->beginTransaction();
    try{
        $hash = password_hash($senha, PASSWORD_DEFAULT);
        $stmt = $pdo->prepare("INSERT INTO usuarios (nome, email, senha, tipo) VALUES (?, ?, ?, 'aluno')");
        $stmt->execute([$nome, $email, $hash]);
        $alunoId = $pdo->lastInsertId();

        if (!empty($turmaId)){
            $stmt = $pdo->prepare('INSERT INTO matriculas (aluno_id, turma_id, frequencia) VALUES (?, ?, 100)');
            $stmt->execute([$alunoId, $turmaId]);
        }
        $pdo->commit();
    } catch (Exception $e){
        $pdo->rollBack();
        http_response_code(500);
        echo json_encode(['erro' => 'Não foi possível cadastrar o aluno.']);
        exit;
    }

    echo json_encode(['sucesso' => true, 'id' => $alunoId]);
    exit;
}

http_response_code(405);
echo json_encode(['erro' => 'Método não permitido.']);
