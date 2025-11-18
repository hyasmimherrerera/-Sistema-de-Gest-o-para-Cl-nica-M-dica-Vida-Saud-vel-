-- ============================================
-- SISTEMA DE GESTÃO DE CLÍNICA MÉDICA
-- Script de Criação das Tabelas
-- ============================================

-- Excluir banco se existir e criar novo
DROP DATABASE IF EXISTS clinica_medica;
CREATE DATABASE clinica_medica;
USE clinica_medica;

-- ============================================
-- TABELA: USUARIO
-- ============================================
CREATE TABLE USUARIO (
    idUsuario INT AUTO_INCREMENT PRIMARY KEY,
    login VARCHAR(50) NOT NULL UNIQUE,
    senha VARCHAR(255) NOT NULL,
    tipoAcesso VARCHAR(20) NOT NULL CHECK (tipoAcesso IN ('ADMIN', 'MEDICO', 'RECEPCIONISTA'))
) ENGINE=InnoDB;

-- ============================================
-- TABELA: ESPECIALIDADE
-- ============================================
CREATE TABLE ESPECIALIDADE (
    idEspecialidade INT AUTO_INCREMENT PRIMARY KEY,
    nomeEspecialidade VARCHAR(100) NOT NULL UNIQUE
) ENGINE=InnoDB;

-- ============================================
-- TABELA: MEDICO
-- ============================================
CREATE TABLE MEDICO (
    idMedico INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    crm VARCHAR(20) NOT NULL UNIQUE,
    idUsuario INT,
    FOREIGN KEY (idUsuario) REFERENCES USUARIO(idUsuario) ON DELETE SET NULL
) ENGINE=InnoDB;

-- ============================================
-- TABELA: MEDICO_ESPECIALIDADE (Relacionamento N:M)
-- ============================================
CREATE TABLE MEDICO_ESPECIALIDADE (
    idMedico INT NOT NULL,
    idEspecialidade INT NOT NULL,
    PRIMARY KEY (idMedico, idEspecialidade),
    FOREIGN KEY (idMedico) REFERENCES MEDICO(idMedico) ON DELETE CASCADE,
    FOREIGN KEY (idEspecialidade) REFERENCES ESPECIALIDADE(idEspecialidade) ON DELETE CASCADE
) ENGINE=InnoDB;

-- ============================================
-- TABELA: PACIENTE
-- ============================================
CREATE TABLE PACIENTE (
    idPaciente INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(14) NOT NULL UNIQUE,
    dataNascimento DATE NOT NULL
) ENGINE=InnoDB;

-- ============================================
-- TABELA: CONSULTA
-- ============================================
CREATE TABLE CONSULTA (
    idConsulta INT AUTO_INCREMENT PRIMARY KEY,
    dataHora DATETIME NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'AGENDADA' CHECK (status IN ('AGENDADA', 'REALIZADA', 'CANCELADA')),
    idPaciente INT NOT NULL,
    idMedico INT NOT NULL,
    FOREIGN KEY (idPaciente) REFERENCES PACIENTE(idPaciente) ON DELETE CASCADE,
    FOREIGN KEY (idMedico) REFERENCES MEDICO(idMedico) ON DELETE CASCADE
) ENGINE=InnoDB;

-- ============================================
-- TABELA: PRONTUARIO
-- ============================================
CREATE TABLE PRONTUARIO (
    idProntuario INT AUTO_INCREMENT PRIMARY KEY,
    historico TEXT,
    diagnostico TEXT,
    idConsulta INT NOT NULL UNIQUE,
    FOREIGN KEY (idConsulta) REFERENCES CONSULTA(idConsulta) ON DELETE CASCADE
) ENGINE=InnoDB;

-- ============================================
-- TABELA: MEDICAMENTO
-- ============================================
CREATE TABLE MEDICAMENTO (
    idMedicamento INT AUTO_INCREMENT PRIMARY KEY,
    nomeMedicamento VARCHAR(100) NOT NULL,
    principioAtivo VARCHAR(100) NOT NULL
) ENGINE=InnoDB;

-- ============================================
-- TABELA: RECEITA_MEDICA
-- ============================================
CREATE TABLE RECEITA_MEDICA (
    idReceita INT AUTO_INCREMENT PRIMARY KEY,
    dataEmissao DATE NOT NULL,
    validade VARCHAR(50),
    idProntuario INT NOT NULL,
    FOREIGN KEY (idProntuario) REFERENCES PRONTUARIO(idProntuario) ON DELETE CASCADE
) ENGINE=InnoDB;

-- ============================================
-- TABELA: ITENS_RECEITA (Relacionamento N:M)
-- ============================================
CREATE TABLE ITENS_RECEITA (
    idReceita INT NOT NULL,
    idMedicamento INT NOT NULL,
    dosagem VARCHAR(50) NOT NULL,
    posologia TEXT NOT NULL,
    PRIMARY KEY (idReceita, idMedicamento),
    FOREIGN KEY (idReceita) REFERENCES RECEITA_MEDICA(idReceita) ON DELETE CASCADE,
    FOREIGN KEY (idMedicamento) REFERENCES MEDICAMENTO(idMedicamento) ON DELETE CASCADE
) ENGINE=InnoDB;

-- ============================================
-- ÍNDICES PARA OTIMIZAÇÃO
-- ============================================
CREATE INDEX idx_consulta_data ON CONSULTA(dataHora);
CREATE INDEX idx_consulta_status ON CONSULTA(status);
CREATE INDEX idx_paciente_cpf ON PACIENTE(cpf);
CREATE INDEX idx_medico_crm ON MEDICO(crm);

SHOW TABLES;