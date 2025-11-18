-- ============================================
-- SISTEMA DE GESTÃO DE CLÍNICA MÉDICA
-- Script de Consultas SELECT
-- ============================================

USE clinica_medica;

-- ============================================
-- CONSULTA 1: Lista completa de médicos com suas especialidades
-- Objetivo: Visualizar todos os médicos e suas áreas de atuação
-- ============================================
SELECT 
    m.idMedico,
    m.nome AS NomeMedico,
    m.crm,
    GROUP_CONCAT(e.nomeEspecialidade ORDER BY e.nomeEspecialidade SEPARATOR ', ') AS Especialidades
FROM 
    MEDICO m
    INNER JOIN MEDICO_ESPECIALIDADE me ON m.idMedico = me.idMedico
    INNER JOIN ESPECIALIDADE e ON me.idEspecialidade = e.idEspecialidade
GROUP BY 
    m.idMedico, m.nome, m.crm
ORDER BY 
    m.nome;

-- ============================================
-- CONSULTA 2: Consultas agendadas para os próximos dias
-- Objetivo: Listar agenda futura com informações de paciente e médico
-- ============================================
SELECT 
    c.idConsulta,
    DATE_FORMAT(c.dataHora, '%d/%m/%Y %H:%i') AS DataHora,
    c.status,
    p.nome AS Paciente,
    p.cpf AS CPF_Paciente,
    m.nome AS Medico,
    GROUP_CONCAT(DISTINCT e.nomeEspecialidade SEPARATOR ', ') AS Especialidades
FROM 
    CONSULTA c
    INNER JOIN PACIENTE p ON c.idPaciente = p.idPaciente
    INNER JOIN MEDICO m ON c.idMedico = m.idMedico
    LEFT JOIN MEDICO_ESPECIALIDADE me ON m.idMedico = me.idMedico
    LEFT JOIN ESPECIALIDADE e ON me.idEspecialidade = e.idEspecialidade
WHERE 
    c.status = 'AGENDADA'
    AND c.dataHora >= NOW()
GROUP BY 
    c.idConsulta, c.dataHora, c.status, p.nome, p.cpf, m.nome
ORDER BY 
    c.dataHora
LIMIT 10;

-- ============================================
-- CONSULTA 3: Histórico médico completo de um paciente
-- Objetivo: Buscar todas as consultas e diagnósticos de um paciente específico
-- ============================================
SELECT 
    p.nome AS Paciente,
    p.cpf,
    TIMESTAMPDIFF(YEAR, p.dataNascimento, CURDATE()) AS Idade,
    DATE_FORMAT(c.dataHora, '%d/%m/%Y') AS DataConsulta,
    m.nome AS Medico,
    e.nomeEspecialidade AS Especialidade,
    pr.diagnostico,
    c.status AS StatusConsulta
FROM 
    PACIENTE p
    INNER JOIN CONSULTA c ON p.idPaciente = c.idPaciente
    INNER JOIN MEDICO m ON c.idMedico = m.idMedico
    LEFT JOIN MEDICO_ESPECIALIDADE me ON m.idMedico = me.idMedico
    LEFT JOIN ESPECIALIDADE e ON me.idEspecialidade = e.idEspecialidade
    LEFT JOIN PRONTUARIO pr ON c.idConsulta = pr.idConsulta
WHERE 
    p.cpf = '123.456.789-00'  -- Buscar por CPF específico
ORDER BY 
    c.dataHora DESC;

-- ============================================
-- CONSULTA 4: Receitas médicas com medicamentos prescritos
-- Objetivo: Visualizar receitas completas com todos os medicamentos
-- ============================================
SELECT 
    p.nome AS Paciente,
    m.nome AS Medico,
    DATE_FORMAT(c.dataHora, '%d/%m/%Y') AS DataConsulta,
    DATE_FORMAT(rm.dataEmissao, '%d/%m/%Y') AS DataReceita,
    rm.validade,
    med.nomeMedicamento,
    med.principioAtivo,
    ir.dosagem,
    ir.posologia
FROM 
    RECEITA_MEDICA rm
    INNER JOIN PRONTUARIO pr ON rm.idProntuario = pr.idProntuario
    INNER JOIN CONSULTA c ON pr.idConsulta = c.idConsulta
    INNER JOIN PACIENTE p ON c.idPaciente = p.idPaciente
    INNER JOIN MEDICO m ON c.idMedico = m.idMedico
    INNER JOIN ITENS_RECEITA ir ON rm.idReceita = ir.idReceita
    INNER JOIN MEDICAMENTO med ON ir.idMedicamento = med.idMedicamento
WHERE 
    c.status = 'REALIZADA'
ORDER BY 
    rm.dataEmissao DESC, p.nome, med.nomeMedicamento;

-- ============================================
-- CONSULTA 5: Estatísticas de consultas por médico e status
-- Objetivo: Relatório gerencial de produtividade e status das consultas
-- ============================================
SELECT 
    m.nome AS Medico,
    m.crm,
    COUNT(c.idConsulta) AS TotalConsultas,
    SUM(CASE WHEN c.status = 'REALIZADA' THEN 1 ELSE 0 END) AS Realizadas,
    SUM(CASE WHEN c.status = 'AGENDADA' THEN 1 ELSE 0 END) AS Agendadas,
    SUM(CASE WHEN c.status = 'CANCELADA' THEN 1 ELSE 0 END) AS Canceladas,
    ROUND(
        (SUM(CASE WHEN c.status = 'REALIZADA' THEN 1 ELSE 0 END) * 100.0) / 
        NULLIF(COUNT(c.idConsulta), 0), 
        2
    ) AS PercentualRealizadas
FROM 
    MEDICO m
    LEFT JOIN CONSULTA c ON m.idMedico = c.idMedico
GROUP BY 
    m.idMedico, m.nome, m.crm
HAVING 
    TotalConsultas > 0
ORDER BY 
    TotalConsultas DESC, PercentualRealizadas DESC;