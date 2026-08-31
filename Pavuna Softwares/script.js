// ============ NAVEGAÇÃO ENTRE VIEWS ============
function irPara(view){
  document.querySelectorAll('.view').forEach(v => v.classList.remove('active'));
  document.getElementById('view-' + view).classList.add('active');
  document.querySelectorAll('.tab').forEach(t => t.classList.toggle('active', t.dataset.view === view));
  document.getElementById('mobilePanel').classList.remove('open');
}
document.querySelectorAll('.tab, .mobile-link').forEach(btn => {
  btn.addEventListener('click', () => irPara(btn.dataset.view));
});
document.getElementById('menuToggle').addEventListener('click', () => {
  document.getElementById('mobilePanel').classList.toggle('open');
});

const STATUS_LABEL = { confirmada:'Confirmada', reposicao:'Reposição', cancelada:'Cancelada' };
const TURNO_LABEL = { manha:'Manhã', tarde:'Tarde', noite:'Noite' };

// ============ GRADE DA SEMANA ============
function renderGrade(){
  const turnoAlvo = document.getElementById('filtroTurno').value;
  const busca = document.getElementById('filtroBusca').value.trim().toLowerCase();
  const corpo = document.getElementById('corpoGrade');
  corpo.innerHTML = '';

  DIAS.forEach((diaInfo, idx) => {
    const tr = document.createElement('tr');

    const tdDia = document.createElement('td');
    tdDia.className = 'col-dia';
    tdDia.innerHTML = `${diaInfo.dia}<small>${diaInfo.data}</small>`;
    tr.appendChild(tdDia);

    ['manha','tarde','noite'].forEach(turno => {
      const td = document.createElement('td');
      if (turnoAlvo !== 'todos' && turnoAlvo !== turno){
        td.innerHTML = '';
        tr.appendChild(td);
        return;
      }
      const aulas = AULAS.filter(a => a.dia === idx && a.turno === turno && matchBusca(a, busca));
      if (aulas.length === 0){
        td.innerHTML = '<span class="chip-empty">—</span>';
      } else {
        aulas.forEach(a => {
          const chip = document.createElement('button');
          chip.className = `chip shift-${a.turno}`;
          chip.innerHTML = `<span class="chip-turma">${a.turma}</span><span class="chip-meta">${a.instrutor} · Sala ${a.sala}</span>`;
          chip.addEventListener('click', () => abrirDetalhe(a, diaInfo));
          td.appendChild(chip);
        });
      }
      tr.appendChild(td);
    });

    corpo.appendChild(tr);
  });
}
function matchBusca(a, termo){
  if (!termo) return true;
  return a.turma.toLowerCase().includes(termo) || a.instrutor.toLowerCase().includes(termo);
}
document.getElementById('filtroTurno').addEventListener('change', renderGrade);
document.getElementById('filtroBusca').addEventListener('input', renderGrade);

// ============ DETALHE (overlay) ============
function abrirDetalhe(aula, diaInfo){
  const card = document.getElementById('detailCard');
  card.innerHTML = `
    <h3>${aula.turma}</h3>
    <div class="detail-row"><span>Dia</span><span>${diaInfo.dia} · ${diaInfo.data}</span></div>
    <div class="detail-row"><span>Turno</span><span>${TURNO_LABEL[aula.turno]}</span></div>
    <div class="detail-row"><span>Instrutor</span><span>${aula.instrutor}</span></div>
    <div class="detail-row"><span>Sala</span><span>${aula.sala}</span></div>
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
  sel.innerHTML = INSTRUTORES.map(i => `<option value="${i}">${i}</option>`).join('');
}
function renderInstrutor(){
  const nome = document.getElementById('filtroInstrutor').value;
  const tbody = document.querySelector('#tabelaInstrutor tbody');
  tbody.innerHTML = '';

  const aulas = AULAS.filter(a => a.instrutor === nome);
  document.getElementById('vazioInstrutor').hidden = aulas.length > 0;

  aulas.forEach(a => {
    const diaInfo = DIAS[a.dia];
    const tr = document.createElement('tr');
    tr.innerHTML = `
      <td class="mono">${diaInfo.data}</td>
      <td>${diaInfo.dia}</td>
      <td>${TURNO_LABEL[a.turno]}</td>
      <td>${a.turma}</td>
      <td class="mono">${a.sala}</td>
      <td><span class="badge badge-${a.status}">${STATUS_LABEL[a.status]}</span></td>
    `;
    tbody.appendChild(tr);
  });
}
document.getElementById('filtroInstrutor').addEventListener('change', renderInstrutor);
document.getElementById('dataInicial').addEventListener('change', renderInstrutor);
document.getElementById('dataFinal').addEventListener('change', renderInstrutor);

// ============ CONSULTA ALUNOS ============
function popularSelectTurmas(){
  const sel = document.getElementById('filtroTurma');
  sel.innerHTML = `<option value="todas">Todas as turmas</option>` +
    TURMAS.map(t => `<option value="${t}">${t}</option>`).join('');
}
function renderAlunos(){
  const turmaAlvo = document.getElementById('filtroTurma').value;
  const busca = document.getElementById('buscaAluno').value.trim().toLowerCase();
  const wrap = document.getElementById('listaAlunos');
  wrap.innerHTML = '';

  const alunos = ALUNOS.filter(a =>
    (turmaAlvo === 'todas' || a.turma === turmaAlvo) &&
    a.nome.toLowerCase().includes(busca)
  );
  document.getElementById('vazioAluno').hidden = alunos.length > 0;

  alunos.forEach(a => {
    const card = document.createElement('div');
    card.className = 'aluno-card';
    card.innerHTML = `
      <div class="aluno-top">
        <div>
          <div class="aluno-nome">${a.nome}</div>
          <div class="aluno-turma">${a.turma}</div>
        </div>
      </div>
      <div class="freq-bar"><div class="freq-fill ${a.frequencia < 75 ? 'low' : ''}" style="width:${a.frequencia}%"></div></div>
      <div class="freq-label">Frequência: ${a.frequencia}%</div>
    `;
    wrap.appendChild(card);
  });
}
document.getElementById('filtroTurma').addEventListener('change', renderAlunos);
document.getElementById('buscaAluno').addEventListener('input', renderAlunos);

// ============ INIT ============
popularSelectInstrutores();
popularSelectTurmas();
renderGrade();
renderInstrutor();
renderAlunos();
