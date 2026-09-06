const STATUS_LABEL = { confirmada:'Confirmada', reposicao:'Reposição', cancelada:'Cancelada' };
const TURNO_LABEL = { manha:'Manhã', tarde:'Tarde', noite:'Noite' };
const DIA_LABEL = ['Segunda','Terça','Quarta','Quinta','Sexta','Sábado'];

let TURMAS = [];
let AULAS = [];
let INSTRUTORES = [];

// ============ NAVEGAÇÃO ENTRE VIEWS ============
function irPara(view){
  document.querySelectorAll('.view').forEach(v => v.classList.remove('active'));
  const alvo = document.getElementById('view-' + view);
  if (alvo) alvo.classList.add('active');
  document.querySelectorAll('.tab').forEach(t => t.classList.toggle('active', t.dataset.view === view));
  document.getElementById('mobilePanel').classList.remove('open');
}
document.querySelectorAll('.tab, .mobile-link').forEach(btn => {
  btn.addEventListener('click', () => irPara(btn.dataset.view));
});
document.getElementById('menuToggle').addEventListener('click', () => {
  document.getElementById('mobilePanel').classList.toggle('open');
});

// ============ CARREGAMENTO DE DADOS (API / banco) ============
async function carregarDados(){
  try{
    const respAulas = await fetch('api/aulas.php');
    const dadosAulas = await respAulas.json();
    TURMAS = dadosAulas.turmas || [];
    AULAS = dadosAulas.aulas || [];

    const respInstrutores = await fetch('api/instrutores.php');
    INSTRUTORES = await respInstrutores.json();
  } catch (e){
    console.error('Falha ao carregar dados do servidor', e);
  }

  popularSelectInstrutores();
  renderGrade();
  renderInstrutor();
  renderAlunos();
  popularSelectsTurma();
  if (document.getElementById('relatorioInstrutor')) popularSelectRelatorioInstrutor();
}

// ============ GRADE DA SEMANA ============
function renderGrade(){
  const turnoAlvo = document.getElementById('filtroTurno').value;
  const busca = document.getElementById('filtroBusca').value.trim().toLowerCase();
  const corpo = document.getElementById('corpoGrade');
  corpo.innerHTML = '';

  for (let idx = 0; idx < 6; idx++){
    const tr = document.createElement('tr');
    const tdDia = document.createElement('td');
    tdDia.className = 'col-dia';
    tdDia.textContent = DIA_LABEL[idx];
    tr.appendChild(tdDia);

    ['manha','tarde','noite'].forEach(turno => {
      const td = document.createElement('td');
      if (turnoAlvo !== 'todos' && turnoAlvo !== turno){
        tr.appendChild(td);
        return;
      }
      const aulas = AULAS.filter(a => a.dia_semana == idx && a.turno === turno && matchBusca(a, busca));
      if (aulas.length === 0){
        td.innerHTML = '<span class="chip-empty">—</span>';
      } else {
        aulas.forEach(a => {
          const chip = document.createElement('button');
          chip.className = `chip shift-${a.turno}`;
          const instrutorNome = a.instrutor_nome || 'Sem instrutor definido';
          chip.innerHTML = `<span class="chip-turma">${a.turma_codigo} · ${a.turma_nome}</span><span class="chip-meta">${instrutorNome} · Sala ${a.sala || '-'}</span>`;
          chip.addEventListener('click', () => abrirDetalhe(a, idx));
          td.appendChild(chip);
        });
      }
      tr.appendChild(td);
    });
    corpo.appendChild(tr);
  }
}
function matchBusca(a, termo){
  if (!termo) return true;
  const instrutor = (a.instrutor_nome || '').toLowerCase();
  return a.turma_nome.toLowerCase().includes(termo) || a.turma_codigo.toLowerCase().includes(termo) || instrutor.includes(termo);
}
document.getElementById('filtroTurno').addEventListener('change', renderGrade);
document.getElementById('filtroBusca').addEventListener('input', renderGrade);

// ============ DETALHE (overlay) ============
function abrirDetalhe(aula, diaIdx){
  const card = document.getElementById('detailCard');
  card.innerHTML = `
    <h3>${aula.turma_codigo} · ${aula.turma_nome}</h3>
    <div class="detail-row"><span>Dia</span><span>${DIA_LABEL[diaIdx]}</span></div>
    <div class="detail-row"><span>Turno</span><span>${TURNO_LABEL[aula.turno]}</span></div>
    <div class="detail-row"><span>Instrutor</span><span>${aula.instrutor_nome || 'Não definido'}</span></div>
    <div class="detail-row"><span>Sala</span><span>${aula.sala || '-'}</span></div>
    <div class="detail-row"><span>Status</span><span><span class="badge badge-${aula.status}">${STATUS_LABEL[aula.status]}</span></span></div>
    <button class="detail-close" id="fecharDetalhe">Fechar</button>
  `;
  document.getElementById('detailOverlay').classList.add('open');
  document.getElementById('fecharDetalhe').addEventListener('click', fecharDetalhe);
}
function fecharDetalhe(){ document.getElementById('detailOverlay').classList.remove('open'); }
document.getElementById('detailOverlay').addEventListener('click', e => {
  if (e.target.id === 'detailOverlay') fecharDetalhe();
});

// ============ CONSULTA INSTRUTOR ============
function popularSelectInstrutores(){
  const sel = document.getElementById('filtroInstrutor');
  sel.innerHTML = INSTRUTORES.map(i => `<option value="${i.id}">${i.nome}</option>`).join('');
}
function renderInstrutor(){
  const id = document.getElementById('filtroInstrutor').value;
  const tbody = document.querySelector('#tabelaInstrutor tbody');
  tbody.innerHTML = '';

  const aulas = AULAS.filter(a => String(a.instrutor_id) === String(id));
  document.getElementById('vazioInstrutor').hidden = aulas.length > 0;

  aulas.forEach(a => {
    const tr = document.createElement('tr');
    tr.innerHTML = `
      <td>${DIA_LABEL[a.dia_semana]}</td>
      <td>${TURNO_LABEL[a.turno]}</td>
      <td>${a.turma_codigo} · ${a.turma_nome}</td>
      <td class="mono">${a.sala || '-'}</td>
      <td><span class="badge badge-${a.status}">${STATUS_LABEL[a.status]}</span></td>
    `;
    tbody.appendChild(tr);
  });
}
document.getElementById('filtroInstrutor').addEventListener('change', renderInstrutor);

// ============ CONSULTA ALUNOS ============
async function renderAlunos(){
  const busca = document.getElementById('buscaAluno').value.trim().toLowerCase();
  const wrap = document.getElementById('listaAlunos');
  wrap.innerHTML = '';

  let alunos = [];
  try{
    const resp = await fetch('api/alunos.php');
    alunos = await resp.json();
  } catch(e){ console.error(e); }

  alunos = alunos.filter(a => a.nome.toLowerCase().includes(busca));
  document.getElementById('vazioAluno').hidden = alunos.length > 0;

  alunos.forEach(a => {
    const freq = a.frequencia !== null ? Number(a.frequencia) : null;
    const card = document.createElement('div');
    card.className = 'aluno-card';
    card.innerHTML = `
      <div class="aluno-top">
        <div>
          <div class="aluno-nome">${a.nome}</div>
          <div class="aluno-turma">${a.turma_codigo ? a.turma_codigo + ' · ' + a.turma_nome : 'Sem turma'}</div>
        </div>
      </div>
      ${freq !== null ? `
      <div class="freq-bar"><div class="freq-fill ${freq < 75 ? 'low' : ''}" style="width:${freq}%"></div></div>
      <div class="freq-label">Frequência: ${freq}%</div>` : ''}
    `;
    wrap.appendChild(card);
  });
}
document.getElementById('buscaAluno').addEventListener('input', renderAlunos);

function popularSelectsTurma(){
  const sel = document.getElementById('caTurma');
  if (sel) sel.innerHTML = TURMAS.map(t => `<option value="${t.id}">${t.codigo} · ${t.nome}</option>`).join('');
}

// ============ CADASTRO DE INSTRUTOR (perfil coordenador) ============
const formCI = document.getElementById('formCadastroInstrutor');
if (formCI){
  formCI.addEventListener('submit', async (e) => {
    e.preventDefault();
    const alerta = document.getElementById('alertaCadastroInstrutor');
    const nome = document.getElementById('ciNome').value.trim();
    const email = document.getElementById('ciEmail').value.trim();
    const senha = document.getElementById('ciSenha').value;

    const resp = await fetch('api/instrutores.php', {
      method: 'POST', headers: {'Content-Type': 'application/json'},
      body: JSON.stringify({ nome, email, senha })
    });
    const data = await resp.json();
    if (!resp.ok){
      mostrarAlertaGenerico(alerta, data.erro || 'Erro ao cadastrar.', 'error');
      return;
    }
    mostrarAlertaGenerico(alerta, 'Instrutor cadastrado com sucesso!', 'success');
    formCI.reset();
    const respInstrutores = await fetch('api/instrutores.php');
    INSTRUTORES = await respInstrutores.json();
    popularSelectInstrutores();
    if (document.getElementById('relatorioInstrutor')) popularSelectRelatorioInstrutor();
  });
}

// ============ CADASTRO DE ALUNO (perfil coordenador/instrutor) ============
const formCA = document.getElementById('formCadastroAluno');
if (formCA){
  formCA.addEventListener('submit', async (e) => {
    e.preventDefault();
    const alerta = document.getElementById('alertaCadastroAluno');
    const nome = document.getElementById('caNome').value.trim();
    const email = document.getElementById('caEmail').value.trim();
    const senha = document.getElementById('caSenha').value;
    const turma_id = document.getElementById('caTurma').value;

    const resp = await fetch('api/alunos.php', {
      method: 'POST', headers: {'Content-Type': 'application/json'},
      body: JSON.stringify({ nome, email, senha, turma_id })
    });
    const data = await resp.json();
    if (!resp.ok){
      mostrarAlertaGenerico(alerta, data.erro || 'Erro ao cadastrar.', 'error');
      return;
    }
    mostrarAlertaGenerico(alerta, 'Aluno cadastrado com sucesso!', 'success');
    formCA.reset();
    renderAlunos();
  });
}

function mostrarAlertaGenerico(el, texto, tipo){
  if (!el) return;
  el.textContent = texto;
  el.className = `auth-alert show ${tipo}`;
}

// ============ RELATÓRIOS (instrutor / coordenador) ============
function popularSelectRelatorioInstrutor(){
  const sel = document.getElementById('relatorioInstrutor');
  if (sel) sel.innerHTML = INSTRUTORES.map(i => `<option value="${i.id}">${i.nome}</option>`).join('');
}
const btnGerarRelatorio = document.getElementById('gerarRelatorio');
if (btnGerarRelatorio){
  btnGerarRelatorio.addEventListener('click', async () => {
    const selInstrutor = document.getElementById('relatorioInstrutor');
    const url = selInstrutor ? `api/relatorio_instrutor.php?instrutor_id=${selInstrutor.value}` : 'api/relatorio_instrutor.php';
    const resp = await fetch(url);
    const data = await resp.json();
    const resumoEl = document.getElementById('relatorioResumo');
    const tbody = document.querySelector('#tabelaRelatorio tbody');

    if (!resp.ok){
      resumoEl.innerHTML = `<p class="empty-state">${data.erro || 'Erro ao gerar relatório.'}</p>`;
      tbody.innerHTML = '';
      return;
    }

    resumoEl.innerHTML = `
      <div class="resumo-card"><strong>${data.resumo.confirmada || 0}</strong><span>Confirmadas</span></div>
      <div class="resumo-card"><strong>${data.resumo.reposicao || 0}</strong><span>Reposições</span></div>
      <div class="resumo-card"><strong>${data.resumo.cancelada || 0}</strong><span>Canceladas</span></div>
      <div class="resumo-card"><strong>${data.total}</strong><span>Total de aulas</span></div>
    `;
    tbody.innerHTML = data.aulas.map(a => `
      <tr>
        <td>${DIA_LABEL[a.dia_semana]}</td>
        <td>${TURNO_LABEL[a.turno]}</td>
        <td>${a.turma_codigo} · ${a.turma_nome}</td>
        <td class="mono">${a.sala || '-'}</td>
        <td><span class="badge badge-${a.status}">${STATUS_LABEL[a.status]}</span></td>
      </tr>
    `).join('');
  });
}
const btnExportarRelatorio = document.getElementById('exportarRelatorio');
if (btnExportarRelatorio){
  btnExportarRelatorio.addEventListener('click', () => {
    const selInstrutor = document.getElementById('relatorioInstrutor');
    const idParam = selInstrutor ? `instrutor_id=${selInstrutor.value}&` : '';
    window.location.href = `api/relatorio_instrutor.php?${idParam}formato=csv`;
  });
}

// ============ ÍCONE DE PERFIL / LOGOUT ============
const perfilBtn = document.getElementById('perfilBtn');
const perfilDropdown = document.getElementById('perfilDropdown');
if (perfilBtn){
  perfilBtn.addEventListener('click', () => perfilDropdown.classList.toggle('open'));
  document.addEventListener('click', (e) => {
    if (!e.target.closest('.perfil-area')) perfilDropdown.classList.remove('open');
  });
}
const abrirEditarPerfil = document.getElementById('abrirEditarPerfil');
if (abrirEditarPerfil){
  abrirEditarPerfil.addEventListener('click', () => {
    perfilDropdown.classList.remove('open');
    document.getElementById('perfilOverlay').classList.add('open');
  });
}
document.getElementById('fecharPerfil')?.addEventListener('click', () => {
  document.getElementById('perfilOverlay').classList.remove('open');
});
const formPerfil = document.getElementById('formPerfil');
if (formPerfil){
  formPerfil.addEventListener('submit', async (e) => {
    e.preventDefault();
    const alerta = document.getElementById('alertaPerfil');
    const nome = document.getElementById('perfilNomeInput').value.trim();
    const arquivoFoto = document.getElementById('perfilFotoInput').files[0];

    const formData = new FormData();
    formData.append('nome', nome);
    if (arquivoFoto) formData.append('foto', arquivoFoto);

    const resp = await fetch('api/perfil.php', { method: 'POST', body: formData });
    const data = await resp.json();
    if (!resp.ok){
      mostrarAlertaGenerico(alerta, data.erro || 'Erro ao salvar.', 'error');
      return;
    }
    mostrarAlertaGenerico(alerta, 'Perfil atualizado!', 'success');
    if (data.foto) document.getElementById('perfilFoto').src = data.foto;
    setTimeout(() => document.getElementById('perfilOverlay').classList.remove('open'), 900);
  });
}

// ============ INIT ============
carregarDados();
