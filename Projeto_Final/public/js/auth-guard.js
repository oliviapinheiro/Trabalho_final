// ============================================================
// GUARDA DE ACESSO — roda antes do site carregar.
// Se não houver sessão ativa, redireciona para login.html.
// Arquivo novo, não altera a lógica do site original.
// ============================================================
(function(){
  const sessao = sessionStorage.getItem('pavuna_sessao');
  if (!sessao){
    window.location.replace('login.html');
  }
})();
