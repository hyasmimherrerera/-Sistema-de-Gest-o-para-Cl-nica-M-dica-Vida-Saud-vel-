-- ============================================
-- SISTEMA DE GESTÃO DE CLÍNICA MÉDICA
-- Script de Inserção de Dados
-- ============================================

USE clinica_medica;

-- ============================================
-- INSERÇÃO: USUARIOS
-- ============================================
INSERT INTO USUARIO (login, senha, tipoAcesso) VALUES
('admin', MD5('admin123'), 'ADMIN'),
('dr.silva', MD5('medico123'), 'MEDICO'),
('dra.santos', MD5('medico456'), 'MEDICO'),
('dr.oliveira', MD5('medico789'), 'MEDICO'),
('dra.costa', MD5('medico321'), 'MEDICO'),
('recep01', MD5('recep123'), 'RECEPCIONISTA'),
('recep02', MD5('recep456'), 'RECEPCIONISTA');

-- ============================================
-- INSERÇÃO: ESPECIALIDADES
-- ============================================
INSERT INTO ESPECIALIDADE (nomeEspecialidade) VALUES
('Cardiologia'),
('Dermatologia'),
('Ortopedia'),
('Pediatria'),
('Ginecologia'),
('Neurologia'),
('Clínica Geral'),
('Endocrinologia');

-- ============================================
-- INSERÇÃO: MEDICOS
-- ============================================
INSERT INTO MEDICO (nome, crm, idUsuario) VALUES
('Dr. João Silva', 'CRM/SP 123456', 2),
('Dra. Maria Santos', 'CRM/RJ 234567', 3),
('Dr. Pedro Oliveira', 'CRM/MG 345678', 4),
('Dra. Ana Costa', 'CRM/SP 456789', 5);

-- ============================================
-- INSERÇÃO: MEDICO_ESPECIALIDADE
-- ============================================
INSERT INTO MEDICO_ESPECIALIDADE (idMedico, idEspecialidade) VALUES
(1, 1), -- Dr. Silva - Cardiologia
(1, 7), -- Dr. Silva - Clínica Geral
(2, 2), -- Dra. Santos - Dermatologia
(3, 3), -- Dr. Oliveira - Ortopedia
(4, 4), -- Dra. Costa - Pediatria
(4, 7); -- Dra. Costa - Clínica Geral

-- ============================================
-- INSERÇÃO: PACIENTES
-- ============================================
INSERT INTO PACIENTE (nome, cpf, dataNascimento) VALUES
('Carlos Mendes', '123.456.789-00', '1985-03-15'),
('Juliana Ferreira', '234.567.890-11', '1990-07-22'),
('Roberto Lima', '345.678.901-22', '1978-11-30'),
('Fernanda Alves', '456.789.012-33', '1995-05-18'),
('Paulo Souza', '567.890.123-44', '1982-09-08'),
('Amanda Silva', '678.901.234-55', '2010-01-25'),
('Ricardo Santos', '789.012.345-66', '1988-12-12'),
('Beatriz Costa', '890.123.456-77', '1992-04-03'),
('Gabriel Rocha', '901.234.567-88', '2015-08-19'),
('Mariana Dias', '012.345.678-99', '1975-06-27');

-- ============================================
-- INSERÇÃO: CONSULTAS
-- ============================================
INSERT INTO CONSULTA (dataHora, status, idPaciente, idMedico) VALUES
('2025-01-10 09:00:00', 'REALIZADA', 1, 1),
('2025-01-10 10:30:00', 'REALIZADA', 2, 2),
('2025-01-11 14:00:00', 'REALIZADA', 3, 3),
('2025-01-12 08:30:00', 'REALIZADA', 4, 4),
('2025-01-15 11:00:00', 'AGENDADA', 5, 1),
('2025-01-16 15:30:00', 'AGENDADA', 6, 4),
('2025-01-17 09:00:00', 'AGENDADA', 7, 2),
('2025-01-18 10:00:00', 'CANCELADA', 8, 3),
('2025-01-19 13:30:00', 'AGENDADA', 9, 4),
('2025-01-20 16:00:00', 'AGENDADA', 10, 1);

-- ============================================
-- INSERÇÃO: PRONTUARIOS
-- ============================================
INSERT INTO PRONTUARIO (historico, diagnostico, idConsulta) VALUES
('Paciente relata dores no peito há 3 dias. Histórico familiar de problemas cardíacos.', 
 'Angina estável. Recomendado acompanhamento cardiológico regular.', 1),
 
('Paciente apresenta manchas na pele. Sem histórico de alergias.', 
 'Dermatite de contato. Prescrição de pomada e orientação para evitar alérgenos.', 2),
 
('Paciente sofreu queda e relata dor no joelho direito. Mobilidade reduzida.', 
 'Entorse de grau 2 no joelho. Repouso e fisioterapia recomendados.', 3),
 
('Criança com febre há 2 dias e tosse persistente. Vacinação em dia.', 
 'Infecção respiratória viral. Tratamento sintomático e hidratação.', 4);

-- ============================================
-- INSERÇÃO: MEDICAMENTOS
-- ============================================
INSERT INTO MEDICAMENTO (nomeMedicamento, principioAtivo) VALUES
('Aspirina 100mg', 'Ácido Acetilsalicílico'),
('Losartana 50mg', 'Losartana Potássica'),
('Hidrocortisona Pomada 1%', 'Hidrocortisona'),
('Cetoprofeno 100mg', 'Cetoprofeno'),
('Amoxicilina 500mg', 'Amoxicilina'),
('Paracetamol 750mg', 'Paracetamol'),
('Dipirona 500mg', 'Dipirona Sódica'),
('Ibuprofeno 600mg', 'Ibuprofeno');

-- ============================================
-- INSERÇÃO: RECEITAS MEDICAS
-- ============================================
INSERT INTO RECEITA_MEDICA (dataEmissao, validade, idProntuario) VALUES
('2025-01-10', '30 dias', 1),
('2025-01-10', '15 dias', 2),
('2025-01-11', '20 dias', 3),
('2025-01-12', '7 dias', 4);

-- ============================================
-- INSERÇÃO: ITENS_RECEITA
-- ============================================
INSERT INTO ITENS_RECEITA (idReceita, idMedicamento, dosagem, posologia) VALUES
(1, 1, '100mg', 'Tomar 1 comprimido pela manhã, em jejum, por 30 dias.'),
(1, 2, '50mg', 'Tomar 1 comprimido ao dia, preferencialmente pela manhã.'),

(2, 3, '1%', 'Aplicar fina camada na região afetada 2x ao dia por 15 dias.'),

(3, 4, '100mg', 'Tomar 1 comprimido a cada 8 horas, após as refeições, por 5 dias.'),
(3, 8, '600mg', 'Tomar 1 comprimido a cada 8 horas se houver dor intensa.'),

(4, 5, '500mg', 'Tomar 1 comprimido a cada 8 horas por 7 dias.'),
(4, 6, '750mg', 'Tomar 1 comprimido a cada 6 horas se houver febre.');

-- ============================================
-- VERIFICAÇÃO DOS DADOS INSERIDOS
-- ============================================
SELECT 'USUARIOS' AS Tabela, COUNT(*) AS Total FROM USUARIO
UNION ALL
SELECT 'ESPECIALIDADES', COUNT(*) FROM ESPECIALIDADE
UNION ALL
SELECT 'MEDICOS', COUNT(*) FROM MEDICO
UNION ALL
SELECT 'PACIENTES', COUNT(*) FROM PACIENTE
UNION ALL
SELECT 'CONSULTAS', COUNT(*) FROM CONSULTA
UNION ALL
SELECT 'PRONTUARIOS', COUNT(*) FROM PRONTUARIO
UNION ALL
SELECT 'MEDICAMENTOS', COUNT(*) FROM MEDICAMENTO
UNION ALL
SELECT 'RECEITAS', COUNT(*) FROM RECEITA_MEDICA
UNION ALL
SELECT 'ITENS_RECEITA', COUNT(*) FROM ITENS_RECEITA;