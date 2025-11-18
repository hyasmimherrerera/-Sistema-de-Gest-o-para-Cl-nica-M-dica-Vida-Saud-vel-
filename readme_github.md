# 🏥 Sistema de Gestão de Clínica Médica

[![SQL](https://img.shields.io/badge/SQL-MySQL-blue.svg)](https://www.mysql.com/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

## 📋 Sobre o Projeto

Sistema completo de banco de dados para gestão de uma clínica médica, desenvolvido como projeto acadêmico para aplicação prática de conceitos de modelagem de dados, normalização e manipulação com SQL.

O projeto implementa um mini-mundo real contemplando:
- Gestão de médicos e especialidades
- Cadastro de pacientes
- Agendamento e controle de consultas
- Prontuários médicos eletrônicos
- Prescrição de receitas médicas
- Controle de medicamentos

## 🎯 Objetivos de Aprendizagem

### Taxonomia de Bloom
- **Aplicar**: Executar comandos SQL para manipulação de dados reais
- **Criar**: Desenvolver scripts SQL completos e estruturados

### Taxonomia de Fink
- **Aplicação**: Utilizar ferramentas reais (MySQL Workbench/PGAdmin)
- **Integração**: Combinar modelagem lógica, normalização e integridade
- **Aprendendo a aprender**: Lidar com erros, compreender mensagens do sistema

## 🗂️ Estrutura do Banco de Dados

### Entidades Principais

| Tabela | Descrição | Registros |
|--------|-----------|-----------|
| **USUARIO** | Credenciais e controle de acesso | 7 usuários |
| **MEDICO** | Cadastro de médicos | 4 médicos |
| **ESPECIALIDADE** | Áreas médicas disponíveis | 8 especialidades |
| **PACIENTE** | Cadastro de pacientes | 10 pacientes |
| **CONSULTA** | Agendamentos e atendimentos | 10 consultas |
| **PRONTUARIO** | Histórico médico | 4 prontuários |
| **MEDICAMENTO** | Catálogo de medicamentos | 8 medicamentos |
| **RECEITA_MEDICA** | Prescrições médicas | 4 receitas |

### Relacionamentos
- **MEDICO_ESPECIALIDADE**: N:M entre médicos e especialidades
- **ITENS_RECEITA**: N:M entre receitas e medicamentos

## 🚀 Como Executar

### Pré-requisitos
- MySQL Server 8.0 ou superior
- MySQL Workbench OU
- PostgreSQL + PGAdmin (com adaptações)

### Passo 1: Criar o Banco de Dados
```bash
# Executar no MySQL Workbench ou linha de comando
mysql -u root -p < 01_criacao_tabelas.sql
```

### Passo 2: Popular com Dados
```bash
mysql -u root -p < 02_insercao_dados.sql
```

### Passo 3: Testar Consultas
```bash
mysql -u root -p < 03_consultas_select.sql
```

### Passo 4: Executar Atualizações
```bash
mysql -u root -p < 04_update_delete.sql
```

## 📁 Arquivos do Repositório

```
clinica-medica-sql/
│
├── 01_criacao_tabelas.sql      # DDL - Criação de tabelas
├── 02_insercao_dados.sql       # DML - INSERT de dados
├── 03_consultas_select.sql     # DML - Consultas SELECT
├── 04_update_delete.sql        # DML - UPDATE e DELETE
├── README.md                   # Documentação
└── diagrama_er.png            # Diagrama ER do banco
```

## 🔍 Exemplos de Consultas

### 1. Listar Médicos e Especialidades
```sql
SELECT m.nome, GROUP_CONCAT(e.nomeEspecialidade) AS Especialidades
FROM MEDICO m
INNER JOIN MEDICO_ESPECIALIDADE me ON m.idMedico = me.idMedico
INNER JOIN ESPECIALIDADE e ON me.idEspecialidade = e.idEspecialidade
GROUP BY m.idMedico;
```

### 2. Consultas Agendadas
```sql
SELECT c.dataHora, p.nome AS Paciente, m.nome AS Medico
FROM CONSULTA c
INNER JOIN PACIENTE p ON c.idPaciente = p.idPaciente
INNER JOIN MEDICO m ON c.idMedico = m.idMedico
WHERE c.status = 'AGENDADA' AND c.dataHora >= NOW()
ORDER BY c.dataHora;
```

### 3. Histórico de Paciente
```sql
SELECT p.nome, c.dataHora, m.nome AS Medico, pr.diagnostico
FROM PACIENTE p
INNER JOIN CONSULTA c ON p.idPaciente = c.idPaciente
INNER JOIN MEDICO m ON c.idMedico = m.idMedico
LEFT JOIN PRONTUARIO pr ON c.idConsulta = pr.idConsulta
WHERE p.cpf = '123.456.789-00';
```

## 🔄 Operações de Atualização

### UPDATE - Exemplos
1. Atualizar status de consulta
2. Corrigir dados cadastrais
3. Modificar especialidades de médicos
4. Atualizar validade de receitas

### DELETE - Exemplos
1. Remover consultas canceladas antigas
2. Limpar medicamentos não utilizados
3. Excluir especialidades inativas
4. Remover relacionamentos obsoletos

## 🛡️ Integridade dos Dados

### Constraints Implementadas
- **PRIMARY KEY**: Identificação única em todas as tabelas
- **FOREIGN KEY**: Relacionamentos com integridade referencial
- **UNIQUE**: CPF de pacientes, CRM de médicos, login de usuários
- **CHECK**: Validação de status e tipos de acesso
- **NOT NULL**: Campos obrigatórios

### Estratégias de Exclusão
- `ON DELETE CASCADE`: Para dados dependentes
- `ON DELETE SET NULL`: Para referências opcionais

## 📊 Normalização

O banco de dados está normalizado até a **3ª Forma Normal (3FN)**:
- ✅ 1FN: Valores atômicos em todas as colunas
- ✅ 2FN: Dependência total da chave primária
- ✅ 3FN: Sem dependências transitivas

## 🎓 Conceitos Aplicados

- **DDL**: CREATE, DROP, ALTER
- **DML**: INSERT, SELECT, UPDATE, DELETE
- **Joins**: INNER JOIN, LEFT JOIN
- **Funções de Agregação**: COUNT, GROUP_CONCAT, SUM
- **Subconsultas**: Queries aninhadas
- **Índices**: Otimização de consultas
- **Transações**: Integridade (ACID)

## 📈 Melhorias Futuras

- [ ] Implementar stored procedures
- [ ] Criar triggers para auditoria
- [ ] Adicionar views para relatórios
- [ ] Implementar backup automatizado
- [ ] Criar dashboard com métricas
- [ ] Adicionar controle de permissões granular


## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.



---

