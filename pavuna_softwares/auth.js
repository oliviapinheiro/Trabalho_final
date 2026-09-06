// ============================================================
// AUTENTICAÇÃO (agora via backend PHP + banco de dados)
// ============================================================

function emailValido(email){
  return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
}

// ---------- CADASTRO ----------
function inicializarCadastro(){
  const form = document.getElementById('formCadastro');
  if (!form) return;
  const alerta = document.getElementById('cadastroAlerta');

  form.addEventListener('submit', async (e) => {
    e.preventDefault();
    limparErros(form);
    esconderAlerta(alerta);

    const nome = document.getElementById('nome').value.trim();
    const email = document.getElementById('email').value.trim().toLowerCase();
    const tipo = document.getElementById('tipo').value;
    const senha = document.getElementById('senha').value;
    const confirmarSenha = document.getElementById('confirmarSenha').value;

    let valido = true;
    if (nome.length < 2){ marcarErro('nome', 'Informe seu nome completo.'); valido = false; }
    if (!emailValido(email)){ marcarErro('email', 'Informe um e-mail válido.'); valido = false; }
    if (senha.length < 6){ marcarErro('senha', 'A senha precisa ter ao menos 6 caracteres.'); valido = false; }
    if (confirmarSenha !== senha){ marcarErro('confirmarSenha', 'As senhas não coincidem.'); valido = false; }
    if (!valido) return;

    try{
      const resp = await fetch('auth/register.php', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({ nome, email, senha, tipo })
      });
      const data = await resp.json();

      if (!resp.ok){
        mostrarAlerta(alerta, data.erro || 'Não foi possível criar a conta.', 'error');
        return;
      }

      mostrarAlerta(alerta, 'Conta criada com sucesso! Redirecionando para o login...', 'success');
      form.reset();
      setTimeout(() => { window.location.href = 'login.html'; }, 1200);
    } catch (err){
      mostrarAlerta(alerta, 'Erro de conexão com o servidor. Verifique se o Apache/MySQL estão rodando.', 'error');
    }
  });
}

// ---------- LOGIN ----------
function inicializarLogin(){
  const form = document.getElementById('formLogin');
  if (!form) return;
  const alerta = document.getElementById('loginAlerta');

  form.addEventListener('submit', async (e) => {
    e.preventDefault();
    limparErros(form);
    esconderAlerta(alerta);

    const email = document.getElementById('email').value.trim().toLowerCase();
    const senha = document.getElementById('senha').value;

    let valido = true;
    if (!emailValido(email)){ marcarErro('email', 'Informe um e-mail válido.'); valido = false; }
    if (senha.length === 0){ marcarErro('senha', 'Informe sua senha.'); valido = false; }
    if (!valido) return;

    try{
      const resp = await fetch('auth/login.php', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({ email, senha })
      });
      const data = await resp.json();

      if (!resp.ok){
        mostrarAlerta(alerta, data.erro || 'E-mail ou senha incorretos.', 'error');
        return;
      }

      mostrarAlerta(alerta, 'Login realizado! Redirecionando...', 'success');
      setTimeout(() => { window.location.href = 'index.php'; }, 800);
    } catch (err){
      mostrarAlerta(alerta, 'Erro de conexão com o servidor. Verifique se o Apache/MySQL estão rodando.', 'error');
    }
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
