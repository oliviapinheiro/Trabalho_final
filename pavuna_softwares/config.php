<?php
// ============================================================
// CONFIGURAÇÃO DO BANCO DE DADOS
// Ajuste aqui caso seu XAMPP/WAMP use outro usuário/senha.
// Padrão do XAMPP: usuário "root", senha vazia.
// ============================================================
define('DB_HOST', 'localhost');
define('DB_NAME', 'pavuna_softwares');
define('DB_USER', 'root');
define('DB_PASS', '');

function getConexao(){
    static $pdo = null;
    if ($pdo === null){
        try{
            $pdo = new PDO(
                'mysql:host=' . DB_HOST . ';dbname=' . DB_NAME . ';charset=utf8mb4',
                DB_USER,
                DB_PASS,
                [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION]
            );
        } catch (PDOException $e){
            http_response_code(500);
            die(json_encode(['erro' => 'Falha na conexão com o banco de dados. Verifique config.php e se o MySQL está rodando.']));
        }
    }
    return $pdo;
}

// Sessão única para todo o site
if (session_status() === PHP_SESSION_NONE){
    session_start();
}
