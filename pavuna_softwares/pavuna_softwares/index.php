<?php
require_once __DIR__ . '/includes/guard.php';
exigirLogin();

$tipo = $_SESSION['usuario_tipo'];
$nome = $_SESSION['usuario_nome'];
$foto = $_SESSION['usuario_foto'] ? 'uploads/fotos/' . basename($_SESSION['usuario_foto']) : null;
// (a linha acima já guarda o caminho completo em $_SESSION['usuario_foto']; ajuste abaixo)
$foto = $_SESSION['usuario_foto'] ?: null;

$podeCadastrarInstrutor = ($tipo === 'coordenador');
$podeCadastrarAluno = in_array($tipo, ['coordenador', 'instrutor'], true);
$podeVerRelatorios = in_array($tipo, ['coordenador', 'instrutor'], true);
?>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>PAVUNA SOFTWARES · Controle de Turmas</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@500;600;700&family=Inter:wght@400;500;600;700&family=IBM+Plex+Mono:wght@500&display=swap" rel="stylesheet">
<link rel="stylesheet" href="style.css">
</head>
<body>

  <div vw class="enabled">
    <div vw-access-button class="active"></div>
    <div vw-plugin-wrapper><div class="vw-plugin-top-wrapper"></div></div>
  </div>
  <script src="https://vlibras.gov.br/app/vlibras-plugin.js"></script>
  <script>new window.VLibras.Widget('https://vlibras.gov.br/app');</script>

<header class="topbar">
  <div class="brand">
    <div class="brand-icon">
      <img src="Pavuna Softwares/SENAI_Port_com_assinatura_cor.png" alt="Logo">
      <img src="Pavuna Softwares/SESI_Port_com_assinatura_cor.png" alt="Logo">
    </div>
    <div class="brand-text">
      <strong>NÚCLEO ESCOLAR DA PAVUNA SOFTWARES</strong>
      <span>Controle de Turmas &amp; Instrutores</span>
    </div>
  </div>

  <nav class="tabs" id="tabs">
    <button class="tab active" data-view="grade">Grade da Semana</button>
    <button class="tab" data-view="instrutores">Instrutores</button>
    <button class="tab" data-view="alunos">Alunos</button>
    <?php if ($podeVerRelatorios): ?>
    <button class="tab" data-view="relatorios">Relatórios</button>
    <?php endif; ?>
    <?php if ($podeCadastrarInstrutor): ?>
    <button class="tab" data-view="cadastro-instrutor">Cadastrar Instrutor</button>
    <?php endif; ?>
    <?php if ($podeCadastrarAluno): ?>
    <button class="tab" data-view="cadastro-aluno">Cadastrar Aluno</button>
    <?php endif; ?>
  </nav>

  <div class="perfil-area">
    <button class="perfil-icon" id="perfilBtn" title="Meu perfil">
      <img id="perfilFoto" src="<?= $foto ? htmlspecialchars($foto) : 'https://api.dicebear.com/7.x/initials/svg?seed=' . urlencode($nome) ?>" alt="Perfil">
    </button>
    <div class="perfil-dropdown" id="perfilDropdown">
      <div class="perfil-nome"><?= htmlspecialchars($nome) ?></div>
      <div class="perfil-tipo"><?= htmlspecialchars(ucfirst($tipo)) ?></div>
      <button class="perfil-link" id="abrirEditarPerfil">Alterar foto / nome</button>
      <a class="perfil-link perfil-sair" href="auth/logout.php">Sair do sistema</a>
    </div>
  </div>

  <button class="menu-toggle" id="menuToggle" aria-label="Abrir menu">
    <span></span><span></span><span></span>
  </button>
</header>

<div class="mobile-panel" id="mobilePanel">
  <button class="mobile-link" data-view="grade">Grade da Semana</button>
  <button class="mobile-link" data-view="instrutores">Consulta Instrutores</button>
  <button class="mobile-link" data-view="alunos">Consulta Alunos</button>
  <?php if ($podeVerRelatorios): ?><button class="mobile-link" data-view="relatorios">Relatórios</button><?php endif; ?>
  <?php if ($podeCadastrarInstrutor): ?><button class="mobile-link" data-view="cadastro-instrutor">Cadastrar Instrutor</button><?php endif; ?>
  <?php if ($podeCadastrarAluno): ?><button class="mobile-link" data-view="cadastro-aluno">Cadastrar Aluno</button><?php endif; ?>
</div>

<main>

  <!-- ===================== VIEW: GRADE DA SEMANA ===================== -->
  <section class="view active" id="view-grade">
    <div class="view-head">
      <h1>Grade da semana</h1>
      <p>Turmas em andamento por dia e turno. Toque numa turma para ver detalhes.</p>
    </div>
    <div class="filters">
      <label>Turno
        <select id="filtroTurno">
          <option value="todos">Todos</option>
          <option value="manha">Manhã</option>
          <option value="tarde">Tarde</option>
          <option value="noite">Noite</option>
        </select>
      </label>
      <label>Buscar turma ou instrutor
        <input type="text" id="filtroBusca" placeholder="ex.: Redes, Camila...">
      </label>
      <div class="legend">
        <span class="dot dot-manha"></span> Manhã
        <span class="dot dot-tarde"></span> Tarde
        <span class="dot dot-noite"></span> Noite
      </div>
    </div>
    <div class="grade-scroll">
      <table class="grade" id="tabelaGrade">
        <thead><tr><th class="col-dia">Dia</th><th>Manhã</th><th>Tarde</th><th>Noite</th></tr></thead>
        <tbody id="corpoGrade"></tbody>
      </table>
    </div>
  </section>

  <!-- ===================== VIEW: INSTRUTORES ===================== -->
  <section class="view" id="view-instrutores">
    <div class="view-head">
      <h1>Consulta de instrutores</h1>
      <p>Filtre por instrutor para ver a carga de aulas no período.</p>
    </div>
    <div class="filters">
      <label>Instrutor <select id="filtroInstrutor"></select></label>
    </div>
    <div class="table-wrap">
      <table class="lista" id="tabelaInstrutor">
        <thead><tr><th>Dia</th><th>Turno</th><th>Turma</th><th>Sala</th><th>Status</th></tr></thead>
        <tbody></tbody>
      </table>
    </div>
    <p class="empty-state" id="vazioInstrutor" hidden>Nenhuma aula encontrada para esse instrutor.</p>
  </section>

  <!-- ===================== VIEW: ALUNOS ===================== -->
  <section class="view" id="view-alunos">
    <div class="view-head">
      <h1>Consulta de alunos</h1>
      <p>Situação de matrícula e frequência por turma.</p>
    </div>
    <div class="filters">
      <label>Buscar aluno <input type="text" id="buscaAluno" placeholder="nome do aluno..."></label>
    </div>
    <div class="cards-alunos" id="listaAlunos"></div>
    <p class="empty-state" id="vazioAluno" hidden>Nenhum aluno encontrado com esses filtros.</p>
  </section>

  <?php if ($podeVerRelatorios): ?>
  <!-- ===================== VIEW: RELATÓRIOS ===================== -->
  <section class="view" id="view-relatorios">
    <div class="view-head">
      <h1>Relatório de instrutor</h1>
      <p>Resumo de aulas confirmadas, canceladas e de reposição por instrutor.</p>
    </div>
    <div class="filters">
      <?php if ($tipo === 'coordenador'): ?>
      <label>Instrutor <select id="relatorioInstrutor"></select></label>
      <?php endif; ?>
      <button class="auth-submit" id="gerarRelatorio" style="width:auto;padding:9px 18px;">Gerar relatório</button>
      <button class="auth-submit" id="exportarRelatorio" style="width:auto;padding:9px 18px;background:var(--tarde);">Exportar CSV</button>
    </div>
    <div id="relatorioResumo" class="relatorio-resumo"></div>
    <div class="table-wrap">
      <table class="lista" id="tabelaRelatorio">
        <thead><tr><th>Dia</th><th>Turno</th><th>Turma</th><th>Sala</th><th>Status</th></tr></thead>
        <tbody></tbody>
      </table>
    </div>
  </section>
  <?php endif; ?>

  <?php if ($podeCadastrarInstrutor): ?>
  <!-- ===================== VIEW: CADASTRAR INSTRUTOR ===================== -->
  <section class="view" id="view-cadastro-instrutor">
    <div class="view-head">
      <h1>Cadastrar instrutor</h1>
      <p>Apenas coordenadores podem criar contas de instrutor.</p>
    </div>
    <div class="auth-card" style="max-width:420px;">
      <div class="auth-alert" id="alertaCadastroInstrutor"></div>
      <form id="formCadastroInstrutor" novalidate>
        <div class="auth-field"><label>Nome completo</label><input type="text" id="ciNome"></div>
        <div class="auth-field"><label>E-mail</label><input type="email" id="ciEmail"></div>
        <div class="auth-field"><label>Senha provisória</label><input type="password" id="ciSenha"></div>
        <button type="submit" class="auth-submit">Cadastrar instrutor</button>
      </form>
    </div>
  </section>
  <?php endif; ?>

  <?php if ($podeCadastrarAluno): ?>
  <!-- ===================== VIEW: CADASTRAR ALUNO ===================== -->
  <section class="view" id="view-cadastro-aluno">
    <div class="view-head">
      <h1>Cadastrar aluno</h1>
      <p>Coordenadores e instrutores podem matricular novos alunos.</p>
    </div>
    <div class="auth-card" style="max-width:420px;">
      <div class="auth-alert" id="alertaCadastroAluno"></div>
      <form id="formCadastroAluno" novalidate>
        <div class="auth-field"><label>Nome completo</label><input type="text" id="caNome"></div>
        <div class="auth-field"><label>E-mail</label><input type="email" id="caEmail"></div>
        <div class="auth-field"><label>Senha provisória</label><input type="password" id="caSenha"></div>
        <div class="auth-field"><label>Turma</label><select id="caTurma"></select></div>
        <button type="submit" class="auth-submit">Cadastrar aluno</button>
      </form>
    </div>
  </section>
  <?php endif; ?>

</main>

<div class="detail-overlay" id="detailOverlay"><div class="detail-card" id="detailCard"></div></div>

<!-- Modal de edição de perfil -->
<div class="detail-overlay" id="perfilOverlay">
  <div class="detail-card">
    <h3>Meu perfil</h3>
    <div class="auth-alert" id="alertaPerfil"></div>
    <form id="formPerfil" novalidate>
      <div class="auth-field"><label>Nome</label><input type="text" id="perfilNomeInput" value="<?= htmlspecialchars($nome) ?>"></div>
      <div class="auth-field"><label>Foto de perfil</label><input type="file" id="perfilFotoInput" accept="image/png,image/jpeg,image/webp"></div>
      <button type="submit" class="auth-submit">Salvar alterações</button>
    </form>
    <button class="detail-close" id="fecharPerfil">Fechar</button>
  </div>
</div>

<script>window.PAVUNA_SESSAO = <?= json_encode(['nome' => $nome, 'tipo' => $tipo]) ?>;</script>
<script src="script.js"></script>
</body>
</html>
