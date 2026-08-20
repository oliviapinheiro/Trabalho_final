CREATE TABLE Alunos (
  idAlunos INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
  Turma_idTurma INTEGER UNSIGNED NOT NULL,
  PRIMARY KEY(idAlunos),
  INDEX Alunos_FKIndex1(Turma_idTurma)
);

CREATE TABLE Atividades (
  idAtividades INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
  Cadastros_idCadastros INTEGER UNSIGNED NOT NULL,
  Alunos_idAlunos INTEGER UNSIGNED NOT NULL,
  PRIMARY KEY(idAtividades),
  INDEX Atividades_FKIndex1(Alunos_idAlunos),
  INDEX Atividades_FKIndex2(Cadastros_idCadastros)
);

CREATE TABLE Aula (
  idAula INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
  Curso_idCurso INTEGER UNSIGNED NOT NULL,
  Turma_idTurma INTEGER UNSIGNED NOT NULL,
  Instrutor_idInstrutor INTEGER UNSIGNED NOT NULL,
  Matéria INTEGER UNSIGNED NULL,
  Data_2 INTEGER UNSIGNED NULL,
  Horário INTEGER UNSIGNED NULL,
  PRIMARY KEY(idAula, Curso_idCurso, Turma_idTurma),
  INDEX Aula_FKIndex1(Instrutor_idInstrutor),
  INDEX Aula_FKIndex2(Curso_idCurso),
  INDEX Aula_FKIndex3(Turma_idTurma)
);

CREATE TABLE Cadastros (
  idCadastros INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
  PRIMARY KEY(idCadastros)
);

CREATE TABLE Consulta Instrutor (
  Login_Usuario INTEGER UNSIGNED NOT NULL,
  Aula_Turma_idTurma INTEGER UNSIGNED NOT NULL,
  Aula_Curso_idCurso INTEGER UNSIGNED NOT NULL,
  Aula_idAula INTEGER UNSIGNED NOT NULL,
  INDEX Consulta Instrutor_FKIndex1(Aula_idAula, Aula_Curso_idCurso, Aula_Turma_idTurma),
  INDEX Consulta Instrutor_FKIndex2(Login_Usuario)
);

CREATE TABLE Consulta_aula (
  Login_Usuario INTEGER UNSIGNED NOT NULL,
  Aula_Turma_idTurma INTEGER UNSIGNED NOT NULL,
  Aula_Curso_idCurso INTEGER UNSIGNED NOT NULL,
  Aula_idAula INTEGER UNSIGNED NOT NULL,
  Data_2 INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
  Horario INTEGER UNSIGNED NOT NULL,
  INDEX Consulta_aula_FKIndex1(Aula_idAula, Aula_Curso_idCurso, Aula_Turma_idTurma),
  INDEX Consulta_aula_FKIndex2(Login_Usuario)
);

CREATE TABLE Consulta_aula_has_Aula (
  Aula_Turma_idTurma INTEGER UNSIGNED NOT NULL,
  Aula_Curso_idCurso INTEGER UNSIGNED NOT NULL,
  Aula_idAula INTEGER UNSIGNED NOT NULL,
  PRIMARY KEY(Aula_Turma_idTurma, Aula_Curso_idCurso, Aula_idAula),
  INDEX Consulta_aula_has_Aula_FKIndex2(Aula_idAula, Aula_Curso_idCurso, Aula_Turma_idTurma)
);

CREATE TABLE Consulta_Sala (
  Login_Usuario INTEGER UNSIGNED NOT NULL,
  Sala_2_idSala_2 INTEGER UNSIGNED NOT NULL,
  INDEX Consulta_Sala_FKIndex1(Sala_2_idSala_2),
  INDEX Consulta_Sala_FKIndex2(Login_Usuario)
);

CREATE TABLE Curso (
  idCurso INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
  PRIMARY KEY(idCurso)
);

CREATE TABLE Instrutor (
  idInstrutor INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
  Nome VARCHAR(20) NULL,
  PRIMARY KEY(idInstrutor)
);

CREATE TABLE Instrutor_has_Login (
  Instrutor_idInstrutor INTEGER UNSIGNED NOT NULL,
  Login_Usuario INTEGER UNSIGNED NOT NULL,
  PRIMARY KEY(Instrutor_idInstrutor, Login_Usuario),
  INDEX Instrutor_has_Login_FKIndex1(Instrutor_idInstrutor),
  INDEX Instrutor_has_Login_FKIndex2(Login_Usuario)
);

CREATE TABLE LANÇA_ATIV (
  idLANÇA_ATIV INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
  Movimentação_idMovimentação INTEGER UNSIGNED NOT NULL,
  PRIMARY KEY(idLANÇA_ATIV),
  INDEX LANÇA_ATIV_FKIndex1(Movimentação_idMovimentação)
);

CREATE TABLE lANÇA_AULA (
  idlANÇA_AULA INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
  Movimentação_idMovimentação INTEGER UNSIGNED NOT NULL,
  PRIMARY KEY(idlANÇA_AULA),
  INDEX lANÇA_AULA_FKIndex1(Movimentação_idMovimentação)
);

CREATE TABLE Lista telefonica (
  id_telefone INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
  Utilitários_idUtilitários INTEGER UNSIGNED NOT NULL,
  Nome_donodotele INTEGER UNSIGNED NULL,
  PRIMARY KEY(id_telefone),
  INDEX Lista telefonica_FKIndex1(Utilitários_idUtilitários)
);

CREATE TABLE Login (
  Usuario INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
  senha INTEGER UNSIGNED NOT NULL,
  unidade VARCHAR(20) NOT NULL,
  PRIMARY KEY(Usuario)
);

CREATE TABLE Login_has_Cadastros (
  Login_Usuario INTEGER UNSIGNED NOT NULL,
  Cadastros_idCadastros INTEGER UNSIGNED NOT NULL,
  PRIMARY KEY(Login_Usuario, Cadastros_idCadastros),
  INDEX Login_has_Cadastros_FKIndex1(Login_Usuario),
  INDEX Login_has_Cadastros_FKIndex2(Cadastros_idCadastros)
);

CREATE TABLE Matéria (
  idMatéria INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
  Aula_Turma_idTurma INTEGER UNSIGNED NOT NULL,
  Aula_Curso_idCurso INTEGER UNSIGNED NOT NULL,
  Aula_idAula INTEGER UNSIGNED NOT NULL,
  PRIMARY KEY(idMatéria),
  INDEX Matéria_FKIndex1(Aula_idAula, Aula_Curso_idCurso, Aula_Turma_idTurma)
);

CREATE TABLE Movimentação (
  idMovimentação INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
  Login_has_Cadastros_Cadastros_idCadastros INTEGER UNSIGNED NOT NULL,
  Login_has_Cadastros_Login_Usuario INTEGER UNSIGNED NOT NULL,
  PRIMARY KEY(idMovimentação),
  INDEX Movimentação_FKIndex1(Login_has_Cadastros_Login_Usuario, Login_has_Cadastros_Cadastros_idCadastros)
);

CREATE TABLE OcorrÊncias (
  idOcorrÊncias INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
  Relatórios_idRelatórios INTEGER UNSIGNED NOT NULL,
  Alunos_idAlunos INTEGER UNSIGNED NOT NULL,
  PRIMARY KEY(idOcorrÊncias),
  INDEX OcorrÊncias_FKIndex1(Alunos_idAlunos),
  INDEX OcorrÊncias_FKIndex2(Relatórios_idRelatórios)
);

CREATE TABLE PROGRAMAÇÃOAULAS (
  idPROGRAMAÇÃOAULAS INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
  Movimentação_idMovimentação INTEGER UNSIGNED NOT NULL,
  PRIMARY KEY(idPROGRAMAÇÃOAULAS),
  INDEX PROGRAMAÇÃOAULAS_FKIndex1(Movimentação_idMovimentação)
);

CREATE TABLE Relatórios (
  idRelatórios INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
  Login_Usuario INTEGER UNSIGNED NOT NULL,
  PRIMARY KEY(idRelatórios),
  INDEX Relatórios_FKIndex1(Login_Usuario)
);

CREATE TABLE Sala (
  idSala INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
  Aula_Turma_idTurma INTEGER UNSIGNED NOT NULL,
  Aula_Curso_idCurso INTEGER UNSIGNED NOT NULL,
  Aula_idAula INTEGER UNSIGNED NOT NULL,
  PRIMARY KEY(idSala),
  INDEX Sala_FKIndex1(Aula_idAula, Aula_Curso_idCurso, Aula_Turma_idTurma)
);

CREATE TABLE Sala_2 (
  idSala_2 INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
  Curso_idCurso INTEGER UNSIGNED NOT NULL,
  PRIMARY KEY(idSala_2),
  INDEX Sala_2_FKIndex1(Curso_idCurso)
);

CREATE TABLE tROCA_de_SENHA (
  idtROCA_de_SENHA INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
  Utilitários_idUtilitários INTEGER UNSIGNED NOT NULL,
  Login_Usuario INTEGER UNSIGNED NOT NULL,
  PRIMARY KEY(idtROCA_de_SENHA),
  INDEX tROCA_de_SENHA_FKIndex1(Login_Usuario),
  INDEX tROCA_de_SENHA_FKIndex2(Utilitários_idUtilitários)
);

CREATE TABLE Turma (
  idTurma INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
  Sala_2_idSala_2 INTEGER UNSIGNED NOT NULL,
  PRIMARY KEY(idTurma),
  INDEX Turma_FKIndex1(Sala_2_idSala_2)
);

CREATE TABLE Utilitários (
  idUtilitários INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
  tROCA_de_SENHA_idtROCA_de_SENHA INTEGER UNSIGNED NOT NULL,
  Login_Usuario INTEGER UNSIGNED NOT NULL,
  PRIMARY KEY(idUtilitários),
  INDEX Utilitários_FKIndex1(Login_Usuario),
  INDEX Utilitários_FKIndex2(tROCA_de_SENHA_idtROCA_de_SENHA)
);

CREATE TABLE Áreas (
  idÁreas INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
  Cadastros_idCadastros INTEGER UNSIGNED NOT NULL,
  Atividades_idAtividades INTEGER UNSIGNED NOT NULL,
  Matéria_idMatéria INTEGER UNSIGNED NOT NULL,
  PRIMARY KEY(idÁreas),
  INDEX Áreas_FKIndex1(Matéria_idMatéria),
  INDEX Áreas_FKIndex2(Atividades_idAtividades),
  INDEX Áreas_FKIndex3(Cadastros_idCadastros)
);


