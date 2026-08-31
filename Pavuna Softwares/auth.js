// ============================================================
// AUTENTICAÇÃO (front-end, armazenado em localStorage)
// Arquivo novo, independente do restante do sistema.
// Como index.php está vazio, não há backend real ainda —
// quando houver, basta trocar as funções salvarUsuario/validarLogin
// por chamadas fetch() para a API.
// ============================================================

const AUTH_DB_KEY = 'pavuna_usuarios';
const AUTH_SESSION_KEY = 'pavuna_sessao';

function lerUsuarios(){
  try{
    return JSON.parse(localStorage.getItem(AUTH_DB_KEY)) || [];
  }catch(e){
    return [];
  }
}
function salvarUsuarios(lista){
  localStorage.setItem(AUTH_DB_KEY, JSON.stringify(lista));
}
function emailValido(email){
  return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
}

// ---------- CADASTRO ----------
function inicializarCadastro(){
  const form = document.getElementById('formCadastro');
  if (!form) return;
  const alerta = document.getElementById('cadastroAlerta');

  form.addEventListener('submit', (e) => {
    e.preventDefault();
    limparErros(form);
    esconderAlerta(alerta);

    const nome = document.getElementById('nome').value.trim();
    const email = document.getElementById('email').value.trim().toLowerCase();
    const senha = document.getElementById('senha').value;
    const confirmarSenha = document.getElementById('confirmarSenha').value;

    let valido = true;

    if (nome.length < 2){
      marcarErro('nome', 'Informe seu nome completo.');
      valido = false;
    }
    if (!emailValido(email)){
      marcarErro('email', 'Informe um e-mail válido.');
      valido = false;
    }
    if (senha.length < 6){
      marcarErro('senha', 'A senha precisa ter ao menos 6 caracteres.');
      valido = false;
    }
    if (confirmarSenha !== senha){
      marcarErro('confirmarSenha', 'As senhas não coincidem.');
      valido = false;
    }

    if (!valido) return;

    const usuarios = lerUsuarios();
    if (usuarios.some(u => u.email === email)){
      mostrarAlerta(alerta, 'Já existe uma conta com esse e-mail.', 'error');
      return;
    }

    usuarios.push({ nome, email, senha });
    salvarUsuarios(usuarios);

    mostrarAlerta(alerta, 'Conta criada com sucesso! Redirecionando para o login...', 'success');
    form.reset();
    setTimeout(() => { window.location.href = 'login.html'; }, 1200);
  });
}

// ---------- LOGIN ----------
function inicializarLogin(){
  const form = document.getElementById('formLogin');
  if (!form) return;
  const alerta = document.getElementById('loginAlerta');

  form.addEventListener('submit', (e) => {
    e.preventDefault();
    limparErros(form);
    esconderAlerta(alerta);

    const email = document.getElementById('email').value.trim().toLowerCase();
    const senha = document.getElementById('senha').value;

    let valido = true;
    if (!emailValido(email)){
      marcarErro('email', 'Informe um e-mail válido.');
      valido = false;
    }
    if (senha.length === 0){
      marcarErro('senha', 'Informe sua senha.');
      valido = false;
    }
    if (!valido) return;

    const usuarios = lerUsuarios();
    const usuario = usuarios.find(u => u.email === email && u.senha === senha);

    if (!usuario){
      mostrarAlerta(alerta, 'E-mail ou senha incorretos.', 'error');
      return;
    }

    sessionStorage.setItem(AUTH_SESSION_KEY, JSON.stringify({ nome: usuario.nome, email: usuario.email }));
    mostrarAlerta(alerta, 'Login realizado! Redirecionando...', 'success');
    setTimeout(() => { window.location.href = 'index.html'; }, 800);
  });
}

// ---------- HELPERS DE UI ----------
function marcarErro(campoId, mensagem){
  const input = document.getElementById(campoId);
  if (!input) return;
  const campo = input.closest('.auth-field');
  campo.classList.add('field-error');
  const erroEl = campo.querySelector('.auth-error');
  if (erroEl) erroEl.textContent = mensagem;
}
function limparErros(form){
  form.querySelectorAll('.auth-field').forEach(campo => campo.classList.remove('field-error'));
}
function mostrarAlerta(el, texto, tipo){
  if (!el) return;
  el.textContent = texto;
  el.className = `auth-alert show ${tipo}`;
}
function esconderAlerta(el){
  if (!el) return;
  el.className = 'auth-alert';
}

// ---------- INIT ----------
inicializarCadastro();
inicializarLogin();
