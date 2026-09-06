-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Tempo de geração: 05/09/2026 às 13:24
-- Versão do servidor: 10.4.32-MariaDB
-- Versão do PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Banco de dados: `pavuna_softwares`
--

-- --------------------------------------------------------

--
-- Estrutura para tabela `aulas`
--

CREATE TABLE `aulas` (
  `id` int(11) NOT NULL,
  `turma_id` int(11) NOT NULL,
  `dia_semana` tinyint(4) NOT NULL,
  `turno` enum('manha','tarde','noite') NOT NULL,
  `instrutor_id` int(11) DEFAULT NULL,
  `sala` varchar(30) DEFAULT NULL,
  `status` enum('confirmada','reposicao','cancelada') DEFAULT 'confirmada'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Despejando dados para a tabela `aulas`
--

INSERT INTO `aulas` (`id`, `turma_id`, `dia_semana`, `turno`, `instrutor_id`, `sala`, `status`) VALUES
(1, 1, 0, 'manha', 3, '102 D', 'confirmada'),
(2, 2, 0, 'tarde', 4, '214 C', 'confirmada'),
(3, 3, 0, 'noite', 3, 'TF4', 'reposicao'),
(4, 4, 1, 'manha', 5, '119 A', 'confirmada'),
(5, 5, 1, 'manha', 6, '225 C', 'confirmada'),
(6, 2, 1, 'tarde', 4, '214 C', 'cancelada'),
(7, 1, 2, 'manha', 3, '102 D', 'confirmada'),
(8, 6, 2, 'manha', 7, '216 C', 'confirmada'),
(9, 3, 2, 'tarde', 3, 'TF4', 'confirmada'),
(10, 7, 2, 'noite', 11, '224 C', 'confirmada'),
(11, 8, 3, 'manha', 8, '107 B', 'confirmada'),
(12, 9, 3, 'tarde', 9, '210 C', 'confirmada'),
(13, 3, 3, 'noite', 3, 'TF4', 'reposicao'),
(14, 10, 4, 'tarde', 10, 'Sala 15', 'confirmada'),
(15, 3, 4, 'noite', 3, 'TF4', 'confirmada'),
(16, 1, 5, 'manha', 3, '102 D', 'confirmada'),
(17, 3, 5, 'tarde', 3, 'TF4', 'confirmada');

-- --------------------------------------------------------

--
-- Estrutura para tabela `matriculas`
--

CREATE TABLE `matriculas` (
  `id` int(11) NOT NULL,
  `aluno_id` int(11) NOT NULL,
  `turma_id` int(11) NOT NULL,
  `frequencia` decimal(5,2) DEFAULT 100.00
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Despejando dados para a tabela `matriculas`
--

INSERT INTO `matriculas` (`id`, `aluno_id`, `turma_id`, `frequencia`) VALUES
(1, 14, 1, 61.00),
(2, 13, 1, 88.00),
(3, 12, 1, 96.00),
(4, 16, 2, 79.00),
(5, 15, 2, 92.00),
(6, 22, 3, 83.00),
(7, 21, 3, 90.00),
(8, 18, 4, 70.00),
(9, 17, 4, 85.00),
(10, 19, 5, 98.00),
(11, 20, 7, 55.00),
(12, 23, 10, 100.00),
(16, 25, 1, 100.00);

-- --------------------------------------------------------

--
-- Estrutura para tabela `turmas`
--

CREATE TABLE `turmas` (
  `id` int(11) NOT NULL,
  `codigo` varchar(30) NOT NULL,
  `nome` varchar(150) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Despejando dados para a tabela `turmas`
--

INSERT INTO `turmas` (`id`, `codigo`, `nome`) VALUES
(1, 'DS-24', 'Dev. de Sistemas'),
(2, 'GEI-12', 'Gestão Industrial'),
(3, 'MOS-04', 'Modelagem de Sistemas'),
(4, 'MMA-03', 'Manut. Automóveis'),
(5, 'PCI-02', 'Assistente de Estilo'),
(6, 'FPF-01', 'Fundamentos de Física'),
(7, 'VES-05', 'Técnico em Vestuário'),
(8, 'MD-01', 'Manut. Máq. Pesadas'),
(9, 'FQ-01', 'Fundamentos de Química'),
(10, 'SST-01', 'Segurança do Trabalho');

-- --------------------------------------------------------

--
-- Estrutura para tabela `usuarios`
--

CREATE TABLE `usuarios` (
  `id` int(11) NOT NULL,
  `nome` varchar(150) NOT NULL,
  `email` varchar(150) NOT NULL,
  `senha` varchar(255) NOT NULL,
  `tipo` enum('coordenador','instrutor','aluno') NOT NULL,
  `foto` varchar(255) DEFAULT NULL,
  `criado_em` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Despejando dados para a tabela `usuarios`
--

INSERT INTO `usuarios` (`id`, `nome`, `email`, `senha`, `tipo`, `foto`, `criado_em`) VALUES
(1, 'Samuel Mayrink Batista', 'samuelmayrink3@gmail.com', '$2y$10$D5NMC9Q8gLIOfMbbrqU8te2Ty6Osdvz49Fslyp3Ff/b8AKByLl4vG', 'aluno', NULL, '2026-09-05 07:53:45'),
(2, 'Samuel Mayrink Batista', '0000792341@senaimgaluno.com.br', '$2y$10$wBPO5.OOCtxVFvTKGuImde9B863JmZlNtCV4/P3euek1K44lsFkCW', 'coordenador', 'uploads/fotos/usuario_2_1788607365.jpg', '2026-09-05 07:54:43'),
(3, 'Marcos Vinícius', 'marcos.vinicius@pavuna.com', '$2b$10$IcLEiHo0PsBUCd9Mw7otcuxmHO8Oac0Wpr6.KvPLkvbb9dFR7kuUy', 'instrutor', NULL, '2026-09-05 08:01:44'),
(4, 'Renata Alves', 'renata.alves@pavuna.com', '$2b$10$IcLEiHo0PsBUCd9Mw7otcuxmHO8Oac0Wpr6.KvPLkvbb9dFR7kuUy', 'instrutor', NULL, '2026-09-05 08:01:44'),
(5, 'Cláudio Ely', 'claudio.ely@pavuna.com', '$2b$10$IcLEiHo0PsBUCd9Mw7otcuxmHO8Oac0Wpr6.KvPLkvbb9dFR7kuUy', 'instrutor', NULL, '2026-09-05 08:01:44'),
(6, 'Josiane Melo', 'josiane.melo@pavuna.com', '$2b$10$IcLEiHo0PsBUCd9Mw7otcuxmHO8Oac0Wpr6.KvPLkvbb9dFR7kuUy', 'instrutor', NULL, '2026-09-05 08:01:44'),
(7, 'Aélia Vasconcelos', 'aelia.vasconcelos@pavuna.com', '$2b$10$IcLEiHo0PsBUCd9Mw7otcuxmHO8Oac0Wpr6.KvPLkvbb9dFR7kuUy', 'instrutor', NULL, '2026-09-05 08:01:44'),
(8, 'Guilherme Sá', 'guilherme.sa@pavuna.com', '$2b$10$IcLEiHo0PsBUCd9Mw7otcuxmHO8Oac0Wpr6.KvPLkvbb9dFR7kuUy', 'instrutor', NULL, '2026-09-05 08:01:44'),
(9, 'Juliana Costa', 'juliana.costa@pavuna.com', '$2b$10$IcLEiHo0PsBUCd9Mw7otcuxmHO8Oac0Wpr6.KvPLkvbb9dFR7kuUy', 'instrutor', NULL, '2026-09-05 08:01:44'),
(10, 'Paulo Enrique', 'paulo.enrique@pavuna.com', '$2b$10$IcLEiHo0PsBUCd9Mw7otcuxmHO8Oac0Wpr6.KvPLkvbb9dFR7kuUy', 'instrutor', NULL, '2026-09-05 08:01:44'),
(11, 'Lucimar Moraes', 'lucimar.moraes@pavuna.com', '$2b$10$IcLEiHo0PsBUCd9Mw7otcuxmHO8Oac0Wpr6.KvPLkvbb9dFR7kuUy', 'instrutor', NULL, '2026-09-05 08:01:44'),
(12, 'Olivia Pinheiro Matos', 'olivia.matos@aluno.pavuna.com', '$2b$10$IcLEiHo0PsBUCd9Mw7otcuxmHO8Oac0Wpr6.KvPLkvbb9dFR7kuUy', 'aluno', NULL, '2026-09-05 08:01:44'),
(13, 'Samuel Mayrink Batista', 'samuel.batista@aluno.pavuna.com', '$2b$10$IcLEiHo0PsBUCd9Mw7otcuxmHO8Oac0Wpr6.KvPLkvbb9dFR7kuUy', 'aluno', NULL, '2026-09-05 08:01:44'),
(14, 'Gabriel Lopes Anibal Costa', 'gabriel.costa@aluno.pavuna.com', '$2b$10$IcLEiHo0PsBUCd9Mw7otcuxmHO8Oac0Wpr6.KvPLkvbb9dFR7kuUy', 'aluno', NULL, '2026-09-05 08:01:44'),
(15, 'Yuri Vieri Santana de Paula', 'yuri.paula@aluno.pavuna.com', '$2b$10$IcLEiHo0PsBUCd9Mw7otcuxmHO8Oac0Wpr6.KvPLkvbb9dFR7kuUy', 'aluno', NULL, '2026-09-05 08:01:44'),
(16, 'Daniel Luigi Simões Campos', 'daniel.campos@aluno.pavuna.com', '$2b$10$IcLEiHo0PsBUCd9Mw7otcuxmHO8Oac0Wpr6.KvPLkvbb9dFR7kuUy', 'aluno', NULL, '2026-09-05 08:01:44'),
(17, 'Manuella Gonçalves Soares', 'manuella.soares@aluno.pavuna.com', '$2b$10$IcLEiHo0PsBUCd9Mw7otcuxmHO8Oac0Wpr6.KvPLkvbb9dFR7kuUy', 'aluno', NULL, '2026-09-05 08:01:44'),
(18, 'Lucas Gonçalves Maximiano da Costa', 'lucas.costa@aluno.pavuna.com', '$2b$10$IcLEiHo0PsBUCd9Mw7otcuxmHO8Oac0Wpr6.KvPLkvbb9dFR7kuUy', 'aluno', NULL, '2026-09-05 08:01:44'),
(19, 'Ana Luiza Dutra Moreira', 'ana.moreira@aluno.pavuna.com', '$2b$10$IcLEiHo0PsBUCd9Mw7otcuxmHO8Oac0Wpr6.KvPLkvbb9dFR7kuUy', 'aluno', NULL, '2026-09-05 08:01:44'),
(20, 'Leandro Francisco Moreira Santos', 'leandro.santos@aluno.pavuna.com', '$2b$10$IcLEiHo0PsBUCd9Mw7otcuxmHO8Oac0Wpr6.KvPLkvbb9dFR7kuUy', 'aluno', NULL, '2026-09-05 08:01:44'),
(21, 'Miguel Campos Mendes', 'miguel.mendes@aluno.pavuna.com', '$2b$10$IcLEiHo0PsBUCd9Mw7otcuxmHO8Oac0Wpr6.KvPLkvbb9dFR7kuUy', 'aluno', NULL, '2026-09-05 08:01:44'),
(22, 'Leonardo Fernandes de Carvalho', 'leonardo.carvalho@aluno.pavuna.com', '$2b$10$IcLEiHo0PsBUCd9Mw7otcuxmHO8Oac0Wpr6.KvPLkvbb9dFR7kuUy', 'aluno', NULL, '2026-09-05 08:01:44'),
(23, 'Guilherme Ferreira Marques', 'guilherme.marques@aluno.pavuna.com', '$2b$10$IcLEiHo0PsBUCd9Mw7otcuxmHO8Oac0Wpr6.KvPLkvbb9dFR7kuUy', 'aluno', NULL, '2026-09-05 08:01:44'),
(24, 'Gabriel', 'aaa@gmail.com', '$2y$10$srHnfplLIoLPjTzudF2ZqeTNCa2ul4q05MALn62ikU4VS9YVlDDNS', 'instrutor', NULL, '2026-09-05 08:18:51'),
(25, 'Migles', 'aaaaa@gmail.com', '$2y$10$BrgScGCqfJ8I.vXh0zK5quMdpcK4QlagsK1AnMVmjwk2Fayn7UJ62', 'aluno', NULL, '2026-09-05 08:19:41');

--
-- Índices para tabelas despejadas
--

--
-- Índices de tabela `aulas`
--
ALTER TABLE `aulas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `turma_id` (`turma_id`),
  ADD KEY `instrutor_id` (`instrutor_id`);

--
-- Índices de tabela `matriculas`
--
ALTER TABLE `matriculas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `aluno_id` (`aluno_id`),
  ADD KEY `turma_id` (`turma_id`);

--
-- Índices de tabela `turmas`
--
ALTER TABLE `turmas`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT para tabelas despejadas
--

--
-- AUTO_INCREMENT de tabela `aulas`
--
ALTER TABLE `aulas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT de tabela `matriculas`
--
ALTER TABLE `matriculas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT de tabela `turmas`
--
ALTER TABLE `turmas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de tabela `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- Restrições para tabelas despejadas
--

--
-- Restrições para tabelas `aulas`
--
ALTER TABLE `aulas`
  ADD CONSTRAINT `aulas_ibfk_1` FOREIGN KEY (`turma_id`) REFERENCES `turmas` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `aulas_ibfk_2` FOREIGN KEY (`instrutor_id`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL;

--
-- Restrições para tabelas `matriculas`
--
ALTER TABLE `matriculas`
  ADD CONSTRAINT `matriculas_ibfk_1` FOREIGN KEY (`aluno_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `matriculas_ibfk_2` FOREIGN KEY (`turma_id`) REFERENCES `turmas` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
