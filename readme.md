O sistema “Vida Saudável” tem como objetivo informatizar o gerenciamento de uma clínica médica. Seu público-alvo são recepcionistas, médicos e administradores da clínica. O propósito é facilitar o controle de pacientes, consultas, médicos e prontuários, otimizando os processos internos. O sistema permite agendar consultas, registrar atendimentos e armazenar informações médicas de pacientes de forma rápida, segura e acessível a partir de qualquer dispositivo autorizado.
# Projeto de Banco de Dados: Sistema de Clínica Médica

Este repositório contém os scripts SQL para a criação, manipulação e consulta de dados de um banco de dados relacional para um sistema de gestão de clínica médica. O projeto foi desenvolvido como parte de um estudo prático, aplicando conceitos de modelagem de dados, normalização (1FN, 2FN, 3FN) e a linguagem SQL (DML).

## 📄 Modelo de Dados

O banco de dados foi projetado a partir de um Diagrama Entidade-Relacionamento (DER) normalizado. As principais entidades são:
- `Paciente`
- `Medico`
- `Especialidade`
- `Consulta`
- `Prontuario`
- `Receita_Medica`
- `Medicamento`
- `Usuario`
- E tabelas associativas para resolver relacionamentos N:M.

## 🛠️ Tecnologias Utilizadas

- **Linguagem:** SQL (Padrão ANSI)
- **SGBD:** MySQL (mas os scripts são facilmente adaptáveis para PostgreSQL)
- **Ferramenta:** MySQL Workbench (ou DBeaver / pgAdmin)
- **Versionamento:** Git & GitHub

## 📁 Estrutura do Repositório

O repositório está organizado com os scripts SQL em uma ordem lógica de execução:

- `0_Schema.sql`: Contém os comandos DDL (`CREATE TABLE`) para construir toda a estrutura do banco de dados, incluindo tabelas, chaves primárias, chaves estrangeiras e restrições.
- `1_Inserts.sql`: Contém os comandos DML (`INSERT INTO`) para popular o banco de dados com dados de exemplo (médicos, pacientes, consultas, etc.).
- `2_Consultas.sql`: Contém uma seleção de comandos `SELECT` para extrair informações relevantes do banco de dados, demonstrando o uso de `JOIN`, `WHERE`, `ORDER BY` e funções de agregação.
- `3_Updates_Deletes.sql`: Contém exemplos de comandos DML (`UPDATE` e `DELETE`) para modificar e remover registros, com cláusulas `WHERE` para garantir a precisão das operações.

## 🚀 Como Executar

1. **Clone o repositório:**
   ```bash
   git clone [URL_DO_SEU_REPOSITORIO]
   -- Script para povoar as tabelas principais com dados de exemplo
Exemplos de insert
-- Script para povoar as tabelas principais com dados de exemplo

-- Inserindo Usuários
INSERT INTO Usuario (login, senha, tipoAcesso) VALUES
('carlos.santos', 'senha123', 'Medico'),
('ana.oliveira', 'senha456', 'Medico'),
('recepcao', 'admin123', 'Recepcionista');

-- Inserindo Médicos e associando aos usuários
INSERT INTO Medico (nome, crm, idUsuario) VALUES
('Dr. Carlos Santos', 'CRM-MG 12345', 1),
('Dra. Ana Oliveira', 'CRM-SP 67890', 2);

-- Inserindo Especialidades
INSERT INTO Especialidade (nomeEspecialidade) VALUES
('Cardiologia'), ('Dermatologia'), ('Clínica Geral');

-- Associando Médicos às Especialidades
INSERT INTO Medico_Especialidade (idMedico, idEspecialidade) VALUES
(1, 1), -- Dr. Carlos é Cardiologista
(1, 3), -- Dr. Carlos também é Clínico Geral
(2, 2); -- Dra. Ana é Dermatologista

-- Inserindo Pacientes
INSERT INTO Paciente (nome, cpf, dataNascimento, telefone) VALUES
('João da Silva', '111.222.333-44', '1985-05-20', '34 99999-1111'),
('Maria Pereira', '555.666.777-88', '1992-11-15', '11 98888-2222'),
('Pedro Almeida', '999.888.777-66', '1978-01-30', '21 97777-3333');

-- Inserindo Consultas
INSERT INTO Consulta (dataHora, status, idPaciente, idMedico) VALUES
('2025-11-20 10:00:00', 'Realizada', 1, 1), -- João com Dr. Carlos
('2025-11-21 14:30:00', 'Realizada', 2, 2), -- Maria com Dra. Ana
('2025-12-05 09:00:00', 'Agendada', 1, 1);   -- João com Dr. Carlos novamente

-- Inserindo Prontuários (associados às consultas realizadas)
INSERT INTO Prontuario (historico, diagnostico, idConsulta) VALUES
('Paciente relata dor no peito após esforço.', 'Hipertensão Arterial', 1),
('Paciente apresenta manchas vermelhas na pele.', 'Dermatite de Contato', 2);

-- Inserindo Receitas Médicas
INSERT INTO Receita_Medica (dataEmissao, validade, idProntuario) VALUES
('2025-11-20', '2026-05-20', 1),
('2025-11-21', '2025-12-21', 2);

-- Inserindo Medicamentos
INSERT INTO Medicamento (nomeMedicamento, principioAtivo) VALUES
('Losartana', 'Losartana Potássica'),
('Hidrocortisona', 'Acetato de hidrocortisona'),
('Paracetamol', 'Paracetamol');

-- Inserindo Itens nas Receitas
INSERT INTO Itens_Receita (idReceita, idMedicamento, dosagem, posologia) VALUES
(1, 1, '50mg', '1 comprimido ao dia'),
(2, 2, '10mg/g', 'Aplicar na área afetada 2 vezes ao dia');
Exemplos de select

SELECT
  -- Script com consultas (SELECT) para extrair informações do banco

-- Consulta 1: Listar todas as consultas com o nome do paciente e do médico.
SELECT
    c.idConsulta,
    c.dataHora,
    p.nome AS Nome_Paciente,
    m.nome AS Nome_Medico,
    c.status
FROM Consulta c
JOIN Paciente p ON c.idPaciente = p.idPaciente
JOIN Medico m ON c.idMedico = m.idMedico
ORDER BY c.dataHora DESC;


-- Consulta 2: Listar todos os médicos e suas especialidades.
SELECT
    m.nome AS Nome_Medico,
    m.crm,
    e.nomeEspecialidade AS Especialidade
FROM Medico m
JOIN Medico_Especialidade me ON m.idMedico = me.idMedico
JOIN Especialidade e ON me.idEspecialidade = e.idEspecialidade
ORDER BY m.nome, e.nomeEspecialidade;


-- Consulta 3: Exibir o prontuário e a receita de um paciente específico (João da Silva).
SELECT
    p.nome AS Paciente,
    c.dataHora AS Data_Consulta,
    pr.diagnostico,
    med.nomeMedicamento,
    ir.dosagem,
    ir.posologia
FROM Paciente p
JOIN Consulta c ON p.idPaciente = c.idPaciente
JOIN Prontuario pr ON c.idConsulta = pr.idConsulta
LEFT JOIN Receita_Medica rm ON pr.idProntuario = rm.idProntuario
LEFT JOIN Itens_Receita ir ON rm.idReceita = ir.idReceita
LEFT JOIN Medicamento med ON ir.idMedicamento = med.idMedicamento
WHERE p.nome = 'João da Silva';


-- Consulta 4: Contar quantas consultas cada médico possui.
SELECT
    m.nome AS Nome_Medico,
    COUNT(c.idConsulta) AS Total_Consultas
FROM Medico m
LEFT JOIN Consulta c ON m.idMedico = c.idMedico
GROUP BY m.nome
ORDER BY Total_Consultas DESC;

-- Script com comandos de UPDATE e DELETE

-- =================================================================
-- COMANDOS DE UPDATE
-- =================================================================

-- UPDATE 1: Atualizar o telefone de um paciente específico.
UPDATE Paciente
SET telefone = '34 99988-7766'
WHERE idPaciente = 1; -- ATUALIZA O TELEFONE DE 'João da Silva'


-- UPDATE 2: Alterar o status de uma consulta agendada para 'Confirmada'.
UPDATE Consulta
SET status = 'Confirmada'
WHERE idConsulta = 3 AND status = 'Agendada';


-- UPDATE 3: Atualizar o diagnóstico de um prontuário após uma reavaliação.
UPDATE Prontuario
SET diagnostico = 'Dermatite Alérgica'
WHERE idProntuario = 2;


-- =================================================================
-- COMANDOS DE DELETE
-- CUIDADO: SEMPRE USE A CLÁUSULA WHERE EM COMANDOS DELETE E UPDATE!
-- =================================================================

-- DELETE 1: Deletar um medicamento que não será mais utilizado na clínica.
-- (Este comando falhará se o medicamento estiver em uso em alguma receita, devido à restrição de chave estrangeira ON DELETE RESTRICT)
-- DELETE FROM Medicamento WHERE nomeMedicamento = 'Paracetamol';


-- DELETE 2: Cancelar uma consulta (removendo-a do banco).
-- O ON DELETE CASCADE na tabela Prontuario garantirá que o prontuário associado também seja removido.
DELETE FROM Consulta
WHERE idConsulta = 3;


-- DELETE 3: Remover uma especialidade de um médico.
DELETE FROM Medico_Especialidade
WHERE idMedico = 1 AND idEspecialidade = 3; -- Remove 'Clínica Geral' do Dr. Carlos
