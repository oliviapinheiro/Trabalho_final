<?php
require_once __DIR__ . '/../config.php';

function usuarioLogado(){
    return isset($_SESSION['usuario_id']);
}

function exigirLogin(){
    if (!usuarioLogado()){
        header('Location: login.html');
        exit;
    }
}

// Usado dentro de arquivos em /api — responde com JSON 401 em vez de redirecionar
function exigirLoginApi(){
    if (!usuarioLogado()){
        http_response_code(401);
        echo json_encode(['erro' => 'Sessão expirada. Faça login novamente.']);
        exit;
    }
}

// $tiposPermitidos = ['coordenador'] ou ['coordenador','instrutor'] etc.
function exigirPerfilApi(array $tiposPermitidos){
    exigirLoginApi();
    if (!in_array($_SESSION['usuario_tipo'], $tiposPermitidos, true)){
        http_response_code(403);
        echo json_encode(['erro' => 'Seu perfil não tem permissão para essa ação.']);
        exit;
    }
}
