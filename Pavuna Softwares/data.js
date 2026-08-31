// Dados de exemplo (mock). Numa versão real isso viria de uma API/planilha.

const DIAS = [
  { dia: "Segunda", data: "03/08" },
  { dia: "Terça",   data: "04/08" },
  { dia: "Quarta",  data: "05/08" },
  { dia: "Quinta",  data: "06/08" },
  { dia: "Sexta",   data: "07/08" },
  { dia: "Sábado",  data: "08/08" },
];

// Cada aula: dia (índice de DIAS), turno, turma, instrutor, sala
const AULAS = [
  { dia:0, turno:"manha", turma:"DS-24 · Dev. de Sistemas",        instrutor:"Marcos Vinícius", sala:"102 D", status:"confirmada" },
  { dia:0, turno:"tarde", turma:"GEI-12 · Gestão Industrial",      instrutor:"Renata Alves",     sala:"214 C", status:"confirmada" },
  { dia:0, turno:"noite", turma:"MOS-04 · Modelagem de Sistemas",  instrutor:"Marcos Vinícius", sala:"TF4",   status:"reposicao" },

  { dia:1, turno:"manha", turma:"MMA-03 · Manut. Automóveis",      instrutor:"Cláudio Ely",      sala:"119 A", status:"confirmada" },
  { dia:1, turno:"manha", turma:"PCI-02 · Assistente de Estilo",   instrutor:"Josiane Melo",     sala:"225 C", status:"confirmada" },
  { dia:1, turno:"tarde", turma:"GEI-12 · Gestão Industrial",      instrutor:"Renata Alves",     sala:"214 C", status:"cancelada" },

  { dia:2, turno:"manha", turma:"DS-24 · Dev. de Sistemas",        instrutor:"Marcos Vinícius", sala:"102 D", status:"confirmada" },
  { dia:2, turno:"manha", turma:"FPF-01 · Fundamentos de Física",  instrutor:"Aélia Vasconcelos",sala:"216 C", status:"confirmada" },
  { dia:2, turno:"tarde", turma:"MOS-04 · Modelagem de Sistemas",  instrutor:"Marcos Vinícius", sala:"TF4",   status:"confirmada" },
  { dia:2, turno:"noite", turma:"VES-05 · Técnico em Vestuário",   instrutor:"Lucimar Moraes",  sala:"224 C", status:"confirmada" },

  { dia:3, turno:"manha", turma:"MD-01 · Manut. Máq. Pesadas",     instrutor:"Guilherme Sá",    sala:"107 B", status:"confirmada" },
  { dia:3, turno:"tarde", turma:"FQ-01 · Fundamentos de Química",  instrutor:"Juliana Costa",   sala:"210 C", status:"confirmada" },
  { dia:3, turno:"noite", turma:"MOS-04 · Modelagem de Sistemas",  instrutor:"Marcos Vinícius", sala:"TF4",   status:"reposicao" },

  { dia:4, turno:"tarde", turma:"SST-01 · Segurança do Trabalho",  instrutor:"Paulo Enrique",   sala:"Sala 15", status:"confirmada" },
  { dia:4, turno:"noite", turma:"MOS-04 · Modelagem de Sistemas",  instrutor:"Marcos Vinícius", sala:"TF4",   status:"confirmada" },

  { dia:5, turno:"manha", turma:"DS-24 · Dev. de Sistemas",        instrutor:"Marcos Vinícius", sala:"102 D", status:"confirmada" },
  { dia:5, turno:"tarde", turma:"MOS-04 · Modelagem de Sistemas",  instrutor:"Marcos Vinícius", sala:"TF4",   status:"confirmada" },
];

const INSTRUTORES = [...new Set(AULAS.map(a => a.instrutor))].sort();

const TURMAS = [...new Set(AULAS.map(a => a.turma))].sort();

const ALUNOS = [
  { nome:"Olivia Pinheiro Matos", turma:"DS-24 · Dev. de Sistemas",       frequencia:96 },
  { nome:"Samuel Mayrink Batista",  turma:"DS-24 · Dev. de Sistemas",       frequencia:88 },
  { nome:"Gabriel Lopes Anibal Costa",     turma:"DS-24 · Dev. de Sistemas",       frequencia:61 },
  { nome:"Yuri Vieri Santana de Paula",    turma:"GEI-12 · Gestão Industrial",     frequencia:92 },
  { nome:"Daniel Luigi Simões Campos",    turma:"GEI-12 · Gestão Industrial",     frequencia:79 },
  { nome:"Manuella Gonçalves Soares",    turma:"MMA-03 · Manut. Automóveis",     frequencia:85 },
  { nome:"Lucas Gonçalves Maximiano da Costa",   turma:"MMA-03 · Manut. Automóveis",     frequencia:70 },
  { nome:"Ana Luiza Dutra Moreira",    turma:"PCI-02 · Assistente de Estilo",  frequencia:98 },
  { nome:"Leandro Francisco Moreira Santos",  turma:"VES-05 · Técnico em Vestuário",  frequencia:55 },
  { nome:"Miguel Campos Mendes", turma:"MOS-04 · Modelagem de Sistemas", frequencia:90 },
  { nome:"Leonardo Fernandes de Carvalho",    turma:"MOS-04 · Modelagem de Sistemas", frequencia:83 },
  { nome:"Guilherme Ferreira Marques",    turma:"SST-01 · Segurança do Trabalho", frequencia:100 },
];
