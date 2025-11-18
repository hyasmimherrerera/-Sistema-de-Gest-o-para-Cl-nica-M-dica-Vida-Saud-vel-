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
-- Inserindo Usuários
INSERT INTO Usuario (login, senha, tipoAcesso) VALUES
('carlos.santos', 'senha123', 'Medico'),
('ana.oliveira', 'senha456', 'Medico'),
('recepcao', 'admin123', 'Recepcionista');

Exemplos de select

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

Exemplos de update

UPDATE Paciente
SET telefone = '34 99988-7766'
WHERE idPaciente = 1; -- ATUALIZA O TELEFONE DE 'João da Silva'

Exemplos de delete

 DELETE 2: Cancelar uma consulta (removendo-a do banco).
-- O ON DELETE CASCADE na tabela Prontuario garantirá que o prontuário associado também seja removido.
DELETE FROM Consulta
WHERE idConsulta = 3;
