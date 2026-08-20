drop database if exists sistema_escolar;

create database sistema_escolar
    character set utf8mb4
    collate utf8mb4_unicode_ci;

use sistema_escolar;

-- =========================================================
-- tabela de cursos
-- =========================================================

create table cursos (
    id_curso int unsigned not null auto_increment,
    nome varchar(100) not null,
    descricao varchar(255) null,
    carga_horaria int unsigned null,
    ativo boolean not null default true,

    primary key (id_curso),
    unique key uk_cursos_nome (nome)
) engine = innodb;


-- =========================================================
-- tabela de salas
-- =========================================================

create table salas (
    id_sala int unsigned not null auto_increment,
    nome varchar(50) not null,
    capacidade int unsigned not null default 30,
    localizacao varchar(100) null,
    ativo boolean not null default true,

    primary key (id_sala),
    unique key uk_salas_nome (nome)
) engine = innodb;


-- =========================================================
-- tabela de turmas
-- =========================================================

create table turmas (
    id_turma int unsigned not null auto_increment,
    id_curso int unsigned not null,
    id_sala int unsigned null,
    nome varchar(100) not null,
    turno enum('manha', 'tarde', 'noite', 'integral') not null,
    data_inicio date null,
    data_fim date null,
    ano smallint unsigned null,
    semestre tinyint unsigned null,
    ativo boolean not null default true,

    primary key (id_turma),

    constraint fk_turmas_cursos
        foreign key (id_curso)
        references cursos (id_curso)
        on update cascade
        on delete restrict,

    constraint fk_turmas_salas
        foreign key (id_sala)
        references salas (id_sala)
        on update cascade
        on delete set null,

    constraint ck_turmas_semestre
        check (semestre is null or semestre in (1, 2))
) engine = innodb;


-- =========================================================
-- tabela de instrutores
-- =========================================================

create table instrutores (
    id_instrutor int unsigned not null auto_increment,
    nome varchar(120) not null,
    cpf varchar(14) null,
    email varchar(150) null,
    telefone varchar(20) null,
    especialidade varchar(100) null,
    data_admissao date null,
    ativo boolean not null default true,

    primary key (id_instrutor),
    unique key uk_instrutores_cpf (cpf),
    unique key uk_instrutores_email (email)
) engine = innodb;


-- =========================================================
-- tabela de usuarios/login
-- =========================================================

create table usuarios (
    id_usuario int unsigned not null auto_increment,
    nome varchar(120) not null,
    login varchar(50) not null,
    senha_hash varchar(255) not null,
    email varchar(150) null,
    unidade varchar(100) null,

    perfil enum(
        'administrador',
        'instrutor',
        'secretaria',
        'coordenador',
        'usuario'
    ) not null default 'usuario',

    ativo boolean not null default true,
    ultimo_acesso datetime null,
    criado_em timestamp not null default current_timestamp,

    primary key (id_usuario),
    unique key uk_usuarios_login (login),
    unique key uk_usuarios_email (email)
) engine = innodb;


-- =========================================================
-- relacionamento instrutor x usuario
-- =========================================================

create table instrutor_usuarios (
    id_instrutor int unsigned not null,
    id_usuario int unsigned not null,

    primary key (id_instrutor, id_usuario),

    constraint fk_instrutor_usuarios_instrutor
        foreign key (id_instrutor)
        references instrutores (id_instrutor)
        on update cascade
        on delete cascade,

    constraint fk_instrutor_usuarios_usuario
        foreign key (id_usuario)
        references usuarios (id_usuario)
        on update cascade
        on delete cascade
) engine = innodb;


-- =========================================================
-- tabela de alunos
-- =========================================================

create table alunos (
    id_aluno int unsigned not null auto_increment,
    id_turma int unsigned not null,
    nome varchar(120) not null,
    cpf varchar(14) null,
    matricula varchar(30) not null,
    email varchar(150) null,
    telefone varchar(20) null,
    data_nascimento date null,
    data_matricula date not null default (current_date),
    status enum('ativo', 'inativo', 'concluido', 'trancado')
        not null default 'ativo',

    primary key (id_aluno),

    unique key uk_alunos_matricula (matricula),
    unique key uk_alunos_cpf (cpf),

    constraint fk_alunos_turmas
        foreign key (id_turma)
        references turmas (id_turma)
        on update cascade
        on delete restrict
) engine = innodb;


-- =========================================================
-- tabela de materias
-- =========================================================

create table materias (
    id_materia int unsigned not null auto_increment,
    id_curso int unsigned not null,
    nome varchar(120) not null,
    descricao varchar(255) null,
    carga_horaria int unsigned null,
    ativo boolean not null default true,

    primary key (id_materia),

    constraint fk_materias_cursos
        foreign key (id_curso)
        references cursos (id_curso)
        on update cascade
        on delete cascade,

    unique key uk_materias_curso_nome (id_curso, nome)
) engine = innodb;


-- =========================================================
-- tabela de aulas
-- =========================================================

create table aulas (
    id_aula int unsigned not null auto_increment,
    id_curso int unsigned not null,
    id_turma int unsigned not null,
    id_instrutor int unsigned not null,
    id_materia int unsigned null,
    id_sala int unsigned null,

    data_aula date not null,
    horario_inicio time not null,
    horario_fim time not null,

    conteudo varchar(255) null,
    observacoes text null,

    status enum(
        'agendada',
        'realizada',
        'cancelada'
    ) not null default 'agendada',

    criado_em timestamp not null default current_timestamp,

    primary key (id_aula),

    constraint fk_aulas_cursos
        foreign key (id_curso)
        references cursos (id_curso)
        on update cascade
        on delete restrict,

    constraint fk_aulas_turmas
        foreign key (id_turma)
        references turmas (id_turma)
        on update cascade
        on delete restrict,

    constraint fk_aulas_instrutores
        foreign key (id_instrutor)
        references instrutores (id_instrutor)
        on update cascade
        on delete restrict,

    constraint fk_aulas_materias
        foreign key (id_materia)
        references materias (id_materia)
        on update cascade
        on delete set null,

    constraint fk_aulas_salas
        foreign key (id_sala)
        references salas (id_sala)
        on update cascade
        on delete set null,

    constraint ck_aulas_horario
        check (horario_fim > horario_inicio)
) engine = innodb;


-- =========================================================
-- tabela de atividades
-- =========================================================

create table atividades (
    id_atividade int unsigned not null auto_increment,
    id_aluno int unsigned not null,
    id_usuario int unsigned null,

    titulo varchar(150) not null,
    descricao text null,
    data_criacao datetime not null default current_timestamp,
    data_entrega datetime null,
    nota decimal(5,2) null,

    status enum(
        'pendente',
        'entregue',
        'corrigida',
        'atrasada'
    ) not null default 'pendente',

    primary key (id_atividade),

    constraint fk_atividades_alunos
        foreign key (id_aluno)
        references alunos (id_aluno)
        on update cascade
        on delete cascade,

    constraint fk_atividades_usuarios
        foreign key (id_usuario)
        references usuarios (id_usuario)
        on update cascade
        on delete set null,

    constraint ck_atividades_nota
        check (nota is null or (nota >= 0 and nota <= 100))
) engine = innodb;


-- =========================================================
-- tabela de ocorrencias
-- =========================================================

create table ocorrencias (
    id_ocorrencia int unsigned not null auto_increment,
    id_aluno int unsigned not null,
    id_usuario int unsigned null,

    titulo varchar(150) not null,
    descricao text not null,
    tipo enum(
        'disciplinar',
        'pedagogica',
        'administrativa',
        'elogio',
        'outros'
    ) not null default 'outros',

    data_ocorrencia datetime not null default current_timestamp,
    resolvida boolean not null default false,

    primary key (id_ocorrencia),

    constraint fk_ocorrencias_alunos
        foreign key (id_aluno)
        references alunos (id_aluno)
        on update cascade
        on delete cascade,

    constraint fk_ocorrencias_usuarios
        foreign key (id_usuario)
        references usuarios (id_usuario)
        on update cascade
        on delete set null
) engine = innodb;


-- =========================================================
-- tabela de cadastros
-- =========================================================

create table cadastros (
    id_cadastro int unsigned not null auto_increment,
    id_usuario int unsigned null,

    tipo varchar(50) not null,
    descricao varchar(255) null,
    criado_em timestamp not null default current_timestamp,

    primary key (id_cadastro),

    constraint fk_cadastros_usuarios
        foreign key (id_usuario)
        references usuarios (id_usuario)
        on update cascade
        on delete set null
) engine = innodb;


-- =========================================================
-- tabela de areas
-- =========================================================

create table areas (
    id_area int unsigned not null auto_increment,
    id_cadastro int unsigned null,
    id_atividade int unsigned null,
    id_materia int unsigned null,

    nome varchar(100) not null,
    descricao varchar(255) null,

    primary key (id_area),

    constraint fk_areas_cadastros
        foreign key (id_cadastro)
        references cadastros (id_cadastro)
        on update cascade
        on delete set null,

    constraint fk_areas_atividades
        foreign key (id_atividade)
        references atividades (id_atividade)
        on update cascade
        on delete set null,

    constraint fk_areas_materias
        foreign key (id_materia)
        references materias (id_materia)
        on update cascade
        on delete set null
) engine = innodb;


-- =========================================================
-- tabela de movimentacoes
-- =========================================================

create table movimentacoes (
    id_movimentacao int unsigned not null auto_increment,
    id_usuario int unsigned not null,

    tipo varchar(50) not null,
    descricao varchar(255) null,
    data_movimentacao datetime not null default current_timestamp,

    primary key (id_movimentacao),

    constraint fk_movimentacoes_usuarios
        foreign key (id_usuario)
        references usuarios (id_usuario)
        on update cascade
        on delete restrict
) engine = innodb;


-- =========================================================
-- programacao de aulas
-- =========================================================

create table programacao_aulas (
    id_programacao int unsigned not null auto_increment,
    id_movimentacao int unsigned null,
    id_aula int unsigned not null,

    observacoes varchar(255) null,
    criado_em timestamp not null default current_timestamp,

    primary key (id_programacao),

    constraint fk_programacao_aulas_movimentacoes
        foreign key (id_movimentacao)
        references movimentacoes (id_movimentacao)
        on update cascade
        on delete set null,

    constraint fk_programacao_aulas_aulas
        foreign key (id_aula)
        references aulas (id_aula)
        on update cascade
        on delete cascade
) engine = innodb;


-- =========================================================
-- relatorios
-- =========================================================

create table relatorios (
    id_relatorio int unsigned not null auto_increment,
    id_usuario int unsigned not null,

    titulo varchar(150) not null,
    tipo varchar(50) not null,
    descricao text null,
    data_geracao datetime not null default current_timestamp,

    primary key (id_relatorio),

    constraint fk_relatorios_usuarios
        foreign key (id_usuario)
        references usuarios (id_usuario)
        on update cascade
        on delete restrict
) engine = innodb;


-- =========================================================
-- telefones
-- =========================================================

create table telefones (
    id_telefone int unsigned not null auto_increment,
    id_usuario int unsigned null,

    nome_contato varchar(120) not null,
    telefone varchar(20) not null,
    tipo enum('pessoal', 'comercial', 'emergencia', 'outro')
        not null default 'pessoal',

    observacao varchar(255) null,

    primary key (id_telefone),

    constraint fk_telefones_usuarios
        foreign key (id_usuario)
        references usuarios (id_usuario)
        on update cascade
        on delete set null
) engine = innodb;


-- =========================================================
-- troca de senha
-- =========================================================

create table trocas_senha (
    id_troca_senha int unsigned not null auto_increment,
    id_usuario int unsigned not null,

    token varchar(255) not null,
    solicitado_em datetime not null default current_timestamp,
    expiracao datetime not null,
    utilizado boolean not null default false,

    primary key (id_troca_senha),
    unique key uk_trocas_senha_token (token),

    constraint fk_trocas_senha_usuarios
        foreign key (id_usuario)
        references usuarios (id_usuario)
        on update cascade
        on delete cascade
) engine = innodb;

-- =========================================================
-- cursos
-- =========================================================

insert into cursos
    (nome, descricao, carga_horaria)
values
    ('informatica', 'curso de informatica basica e avancada', 200),
    ('administracao', 'curso tecnico de administracao', 240),
    ('contabilidade', 'curso de contabilidade', 220),
    ('programacao', 'curso de desenvolvimento de sistemas', 300);


-- =========================================================
-- salas
-- =========================================================

insert into salas
    (nome, capacidade, localizacao)
values
    ('sala 01', 30, 'bloco a'),
    ('sala 02', 35, 'bloco a'),
    ('laboratorio 01', 25, 'bloco b'),
    ('laboratorio 02', 25, 'bloco b');


-- =========================================================
-- instrutores
-- =========================================================

insert into instrutores
    (nome, cpf, email, telefone, especialidade, data_admissao)
values
    ('carlos silva', '111.222.333-44',
     'carlos@escola.com', '(31) 99999-1001',
     'programacao', '2024-02-01'),

    ('ana souza', '222.333.444-55',
     'ana@escola.com', '(31) 99999-1002',
     'administracao', '2023-08-10'),

    ('marcos oliveira', '333.444.555-66',
     'marcos@escola.com', '(31) 99999-1003',
     'contabilidade', '2022-03-15');


-- =========================================================
-- usuarios
-- =========================================================
--
-- senha_hash abaixo e apenas um valor de exemplo.
-- em um sistema real, gere o hash utilizando bcrypt/argon2
-- na aplicacao.
-- =========================================================

insert into usuarios
    (nome, login, senha_hash, email, unidade, perfil)
values
    ('administrador do sistema',
     'admin',
     '$2y$10$exemplo_hash_da_senha',
     'admin@escola.com',
     'unidade central',
     'administrador'),

    ('carlos silva',
     'carlos',
     '$2y$10$exemplo_hash_da_senha',
     'carlos@escola.com',
     'unidade central',
     'instrutor'),

    ('ana souza',
     'ana',
     '$2y$10$exemplo_hash_da_senha',
     'ana@escola.com',
     'unidade central',
     'instrutor'),

    ('secretaria escolar',
     'secretaria',
     '$2y$10$exemplo_hash_da_senha',
     'secretaria@escola.com',
     'unidade central',
     'secretaria');


-- =========================================================
-- instrutor x usuario
-- =========================================================

insert into instrutor_usuarios
    (id_instrutor, id_usuario)
values
    (1, 2),
    (2, 3);


-- =========================================================
-- turmas
-- =========================================================

insert into turmas
    (id_curso, id_sala, nome, turno, data_inicio, data_fim, ano, semestre)
values
    (1, 3, 'informatica turma a', 'manha',
     '2026-02-02', '2026-12-15', 2026, 1),

    (1, 4, 'informatica turma b', 'noite',
     '2026-02-02', '2026-12-15', 2026, 1),

    (2, 1, 'administracao turma a', 'tarde',
     '2026-02-02', '2026-12-15', 2026, 1),

    (3, 2, 'contabilidade turma a', 'noite',
     '2026-02-02', '2026-12-15', 2026, 1);


-- =========================================================
-- alunos
-- =========================================================

insert into alunos
    (id_turma, nome, cpf, matricula, email, telefone, data_nascimento)
values
    (1, 'joao da silva', '444.555.666-77',
     '20260001', 'joao@email.com',
     '(31) 98888-1001', '2005-05-10'),

    (1, 'maria oliveira', '555.666.777-88',
     '20260002', 'maria@email.com',
     '(31) 98888-1002', '2004-08-21'),

    (2, 'pedro santos', '666.777.888-99',
     '20260003', 'pedro@email.com',
     '(31) 98888-1003', '2003-12-03'),

    (3, 'lucas costa', '777.888.999-00',
     '20260004', 'lucas@email.com',
     '(31) 98888-1004', '2005-01-17'),

    (4, 'juliana souza', '888.999.000-11',
     '20260005', 'juliana@email.com',
     '(31) 98888-1005', '2004-06-28');


-- =========================================================
-- materias
-- =========================================================

insert into materias
    (id_curso, nome, descricao, carga_horaria)
values
    (1, 'logica de programacao',
     'fundamentos de logica e algoritmos', 60),

    (1, 'banco de dados',
     'introducao a bancos de dados e sql', 80),

    (1, 'programacao web',
     'desenvolvimento de aplicacoes web', 80),

    (2, 'gestao empresarial',
     'principios de gestao empresarial', 60),

    (2, 'recursos humanos',
     'fundamentos de recursos humanos', 60),

    (3, 'contabilidade geral',
     'principios de contabilidade', 80);


-- =========================================================
-- aulas
-- =========================================================

insert into aulas
    (
        id_curso,
        id_turma,
        id_instrutor,
        id_materia,
        id_sala,
        data_aula,
        horario_inicio,
        horario_fim,
        conteudo,
        status
    )
values
    (
        1, 1, 1, 1, 3,
        '2026-08-18',
        '08:00:00',
        '10:00:00',
        'introducao a algoritmos',
        'agendada'
    ),

    (
        1, 1, 1, 2, 3,
        '2026-08-19',
        '08:00:00',
        '10:00:00',
        'conceitos de banco de dados',
        'agendada'
    ),

    (
        1, 2, 1, 3, 4,
        '2026-08-19',
        '19:00:00',
        '21:00:00',
        'introducao ao desenvolvimento web',
        'agendada'
    ),

    (
        2, 3, 2, 4, 1,
        '2026-08-20',
        '14:00:00',
        '16:00:00',
        'conceitos de gestao',
        'agendada'
    );


-- =========================================================
-- atividades
-- =========================================================

insert into atividades
    (
        id_aluno,
        id_usuario,
        titulo,
        descricao,
        data_entrega,
        nota,
        status
    )
values
    (
        1, 2,
        'atividade de algoritmos',
        'desenvolver cinco algoritmos utilizando pseudocodigo',
        '2026-08-25 23:59:00',
        null,
        'pendente'
    ),

    (
        2, 2,
        'atividade de algoritmos',
        'desenvolver cinco algoritmos utilizando pseudocodigo',
        '2026-08-25 23:59:00',
        85.00,
        'corrigida'
    ),

    (
        3, 3,
        'atividade de gestao',
        'elaborar um planejamento empresarial',
        '2026-08-27 23:59:00',
        null,
        'pendente'
    );


-- =========================================================
-- ocorrencias
-- =========================================================

insert into ocorrencias
    (
        id_aluno,
        id_usuario,
        titulo,
        descricao,
        tipo
    )
values
    (
        1,
        2,
        'atraso',
        'aluno chegou apos o inicio da aula.',
        'disciplinar'
    ),

    (
        2,
        2,
        'bom desempenho',
        'aluna apresentou excelente desempenho na atividade.',
        'elogio'
    );


-- =========================================================
-- cadastros
-- =========================================================

insert into cadastros
    (id_usuario, tipo, descricao)
values
    (1, 'aluno', 'cadastro de alunos'),
    (1, 'instrutor', 'cadastro de instrutores'),
    (4, 'turma', 'cadastro de turmas');


-- =========================================================
-- areas
-- =========================================================

insert into areas
    (id_cadastro, id_atividade, id_materia, nome, descricao)
values
    (1, 1, 1,
     'algoritmos',
     'atividades relacionadas a logica de programacao'),

    (1, 2, 2,
     'banco de dados',
     'atividades relacionadas a banco de dados');


-- =========================================================
-- movimentacoes
-- =========================================================

insert into movimentacoes
    (id_usuario, tipo, descricao)
values
    (1, 'login', 'usuario administrador acessou o sistema'),
    (2, 'cadastro', 'instrutor cadastrou uma atividade'),
    (4, 'cadastro', 'secretaria cadastrou uma turma');


-- =========================================================
-- programacao de aulas
-- =========================================================

insert into programacao_aulas
    (id_movimentacao, id_aula, observacoes)
values
    (1, 1, 'aula programada normalmente'),
    (1, 2, 'aula programada normalmente'),
    (2, 3, 'aula de laboratorio');


-- =========================================================
-- relatorios
-- =========================================================

insert into relatorios
    (id_usuario, titulo, tipo, descricao)
values
    (
        1,
        'relatorio de alunos',
        'alunos',
        'relatorio geral de alunos cadastrados'
    ),

    (
        1,
        'relatorio de aulas',
        'aulas',
        'relatorio de aulas programadas'
    );


-- =========================================================
-- telefones
-- =========================================================

insert into telefones
    (id_usuario, nome_contato, telefone, tipo, observacao)
values
    (
        1,
        'recepcao',
        '(31) 3333-1000',
        'comercial',
        'telefone principal da unidade'
    ),

    (
        4,
        'coordenacao',
        '(31) 3333-1001',
        'comercial',
        'telefone da coordenacao'
    );

-- =========================================================
-- listar alunos com suas respectivas turmas e cursos
-- =========================================================

select
    a.id_aluno,
    a.matricula,
    a.nome as aluno,
    t.nome as turma,
    c.nome as curso,
    t.turno,
    a.status
from alunos a
inner join turmas t
    on t.id_turma = a.id_turma
inner join cursos c
    on c.id_curso = t.id_curso
order by a.nome;


-- =========================================================
-- listar aulas completas
-- =========================================================

select
    au.id_aula,
    au.data_aula,
    au.horario_inicio,
    au.horario_fim,
    c.nome as curso,
    t.nome as turma,
    m.nome as materia,
    i.nome as instrutor,
    s.nome as sala,
    au.status
from aulas au
inner join cursos c
    on c.id_curso = au.id_curso
inner join turmas t
    on t.id_turma = au.id_turma
inner join instrutores i
    on i.id_instrutor = au.id_instrutor
left join materias m
    on m.id_materia = au.id_materia
left join salas s
    on s.id_sala = au.id_sala
order by au.data_aula, au.horario_inicio;


-- =========================================================
-- atividades dos alunos
-- =========================================================

select
    a.nome as aluno,
    t.nome as turma,
    at.titulo,
    at.descricao,
    at.nota,
    at.status,
    at.data_entrega
from atividades at
inner join alunos a
    on a.id_aluno = at.id_aluno
inner join turmas t
    on t.id_turma = a.id_turma
order by a.nome, at.data_entrega;


-- =========================================================
-- ocorrencias dos alunos
-- =========================================================

select
    o.id_ocorrencia,
    a.nome as aluno,
    o.titulo,
    o.tipo,
    o.descricao,
    o.data_ocorrencia,
    o.resolvida
from ocorrencias o
inner join alunos a
    on a.id_aluno = o.id_aluno
order by o.data_ocorrencia desc;


-- =========================================================
-- quantidade de alunos por turma
-- =========================================================

select
    t.nome as turma,
    c.nome as curso,
    count(a.id_aluno) as quantidade_alunos
from turmas t
inner join cursos c
    on c.id_curso = t.id_curso
left join alunos a
    on a.id_turma = t.id_turma
group by
    t.id_turma,
    t.nome,
    c.nome
order by t.nome;

create or replace view vw_aulas as
select
    au.id_aula,
    au.data_aula,
    au.horario_inicio,
    au.horario_fim,
    c.id_curso,
    c.nome as curso,
    t.id_turma,
    t.nome as turma,
    i.id_instrutor,
    i.nome as instrutor,
    m.id_materia,
    m.nome as materia,
    s.id_sala,
    s.nome as sala,
    au.conteudo,
    au.observacoes,
    au.status
from aulas au
inner join cursos c
    on c.id_curso = au.id_curso
inner join turmas t
    on t.id_turma = au.id_turma
inner join instrutores i
    on i.id_instrutor = au.id_instrutor
left join materias m
    on m.id_materia = au.id_materia
left join salas s
    on s.id_sala = au.id_sala;
select *
from vw_aulas
order by data_aula, horario_inicio;
