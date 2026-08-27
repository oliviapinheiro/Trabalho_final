<?php
// register.php
include 'header.php';
?>

<div class="auth-wrap">
    <div class="auth-brand">
        <div class="auth-brand-icon"><img src="images.jpg" alt="Logo"></div>
        <div class="auth-brand-text">
            <strong>NÚCLEO ESCOLAR DA PAVUNA SOFTWARES</strong>
            <span>Controle de Turmas &amp; Instrutores</span>
        </div>
    </div>
    <div class="auth-card">
        <h1>Criar conta</h1>
        <p class="auth-sub">Preencha os dados abaixo para se cadastrar.</p>
        <div class="auth-alert" id="cadastroAlerta"></div>
        
        <form id="formCadastro" action="processar_cadastro.php" method="POST" novalidate>
            <div class="auth-field">
                <label for="nome">Nome completo</label>
                <input type="text" id="nome" name="nome" placeholder="Seu nome" autocomplete="name">
                <span class="auth-error"></span>
            </div>
            <div class="auth-field">
                <label for="email">E-mail</label>
                <input type="email" id="email" name="email" placeholder="voce@exemplo.com" autocomplete="email">
                <span class="auth-error"></span>
            </div>
            <div class="auth-field">
                <label for="senha">Senha</label>
                <input type="password" id="senha" name="senha" placeholder="Mínimo 6 caracteres" autocomplete="new-password">
                <span class="auth-error"></span>
            </div>
            <div class="auth-field">
                <label for="confirmarSenha">Confirmar senha</label>
                <input type="password" id="confirmarSenha" name="confirmar_senha" placeholder="Repita a senha" autocomplete="new-password">
                <span class="auth-error"></span>
            </div>
            <button type="submit" class="auth-submit">Criar conta</button>
        </form>
        
        <p class="auth-footer">Já tem uma conta? <a href="login.php">Entrar</a></p>
    </div>
</div>

<?php
include 'footer.php';
?>
