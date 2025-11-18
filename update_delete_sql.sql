-- ============================================
-- SISTEMA DE GESTÃO DE CLÍNICA MÉDICA
-- Script de UPDATE e DELETE
-- ============================================

USE clinica_medica;

-- ============================================
-- COMANDOS UPDATE
-- ============================================

-- UPDATE 1: Atualizar status de consulta para "REALIZADA"
-- Objetivo: Marcar consultas que já foram realizadas
-- ============================================
UPDATE CONSULTA
SET status = 'REALIZADA'
WHERE idConsulta IN (5, 6)
  AND status = 'AGENDADA'
  AND dataHora < NOW();

-- Verificação do UPDATE 1
SELECT 
    idConsulta, 
    DATE_FORMAT(dataHora, '%d/%m/%Y %H:%i') AS DataHora, 
    status 
FROM CONSULTA 
WHERE idConsulta IN (5, 6);

-- ============================================
-- UPDATE 2: Atualizar dados de contato do paciente
-- Objetivo: Corrigir informações cadastrais
-- ============================================
UPDATE PACIENTE
SET nome = 'Carlos Alberto Mendes'
WHERE cpf = '123.456.789-00'
  AND idPaciente = 1;

-- Verificação do UPDATE 2
SELECT idPaciente, nome, cpf 
FROM PACIENTE 
WHERE idPaciente = 1;

-- ============================================
-- UPDATE 3: Alterar especialidade de um médico
-- Objetivo: Adicionar nova especialidade para médico
-- ============================================
-- Primeiro, inserir a relação se não existir
INSERT IGNORE INTO MEDICO_ESPECIALIDADE (idMedico, idEspecialidade)
SELECT 2, idEspecialidade 
FROM ESPECIALIDADE 
WHERE nomeEspecialidade = 'Clínica Geral';

-- Verificação do UPDATE 3
SELECT 
    m.nome AS Medico,
    GROUP_CONCAT(e.nomeEspecialidade SEPARATOR ', ') AS Especialidades
FROM MEDICO m
INNER JOIN MEDICO_ESPECIALIDADE me ON m.idMedico = me.idMedico
INNER JOIN ESPECIALIDADE e ON me.idEspecialidade = e.idEspecialidade
WHERE m.idMedico = 2
GROUP BY m.idMedico, m.nome;

-- ============================================
-- UPDATE 4: Atualizar validade de receita médica
-- Objetivo: Estender prazo de validade de receita
-- ============================================
UPDATE RECEITA_MEDICA
SET validade = '60 dias'
WHERE idReceita = 1
  AND idProntuario IN (
      SELECT idProntuario 
      FROM PRONTUARIO 
      WHERE diagnostico LIKE '%cardio%'
  );

-- Verificação do UPDATE 4
SELECT 
    rm.idReceita, 
    rm.validade, 
    pr.diagnostico 
FROM RECEITA_MEDICA rm
INNER JOIN PRONTUARIO pr ON rm.idProntuario = pr.idProntuario
WHERE rm.idReceita = 1;

-- ============================================
-- COMANDOS DELETE
-- ============================================

-- DELETE 1: Remover consultas canceladas antigas
-- Objetivo: Limpar histórico de consultas canceladas há mais de 30 dias
-- ============================================
-- Primeiro, visualizar o que será deletado
SELECT 
    idConsulta, 
    DATE_FORMAT(dataHora, '%d/%m/%Y') AS Data, 
    status 
FROM CONSULTA
WHERE status = 'CANCELADA'
  AND dataHora < DATE_SUB(NOW(), INTERVAL 30 DAY);

-- Executar o DELETE
DELETE FROM CONSULTA
WHERE status = 'CANCELADA'
  AND dataHora < DATE_SUB(NOW(), INTERVAL 30 DAY);

-- Verificação do DELETE 1
SELECT COUNT(*) AS ConsultasCanceladas 
FROM CONSULTA 
WHERE status = 'CANCELADA';

-- ============================================
-- DELETE 2: Remover medicamento não utilizado
-- Objetivo: Limpar medicamentos sem prescrições associadas
-- ============================================
-- Visualizar medicamentos sem uso
SELECT 
    med.idMedicamento,
    med.nomeMedicamento,
    COUNT(ir.idMedicamento) AS TotalPrescricoes
FROM MEDICAMENTO med
LEFT JOIN ITENS_RECEITA ir ON med.idMedicamento = ir.idMedicamento
GROUP BY med.idMedicamento, med.nomeMedicamento
HAVING TotalPrescricoes = 0;

-- Executar o DELETE (exemplo: deletar Dipirona se não estiver em uso)
DELETE FROM MEDICAMENTO
WHERE idMedicamento NOT IN (
    SELECT DISTINCT idMedicamento 
    FROM ITENS_RECEITA
)
AND nomeMedicamento = 'Dipirona 500mg';

-- Verificação do DELETE 2
SELECT * FROM MEDICAMENTO 
WHERE nomeMedicamento = 'Dipirona 500mg';

-- ============================================
-- DELETE 3: Remover especialidade sem médicos associados
-- Objetivo: Manter apenas especialidades ativas na clínica
-- ============================================
-- Visualizar especialidades sem médicos
SELECT 
    e.idEspecialidade,
    e.nomeEspecialidade,
    COUNT(me.idMedico) AS TotalMedicos
FROM ESPECIALIDADE e
LEFT JOIN MEDICO_ESPECIALIDADE me ON e.idEspecialidade = me.idEspecialidade
GROUP BY e.idEspecialidade, e.nomeEspecialidade
HAVING TotalMedicos = 0;

-- Executar o DELETE
DELETE FROM ESPECIALIDADE
WHERE idEspecialidade NOT IN (
    SELECT DISTINCT idEspecialidade 
    FROM MEDICO_ESPECIALIDADE
)
AND nomeEspecialidade IN ('Ginecologia', 'Neurologia', 'Endocrinologia');

-- Verificação do DELETE 3
SELECT * FROM ESPECIALIDADE
WHERE nomeEspecialidade IN ('Ginecologia', 'Neurologia', 'Endocrinologia');

-- ============================================
-- DELETE 4: Remover relacionamento médico-especialidade
-- Objetivo: Remover especialidade secundária de um médico
-- ============================================
DELETE FROM MEDICO_ESPECIALIDADE
WHERE idMedico = 1
  AND idEspecialidade = (
      SELECT idEspecialidade 
      FROM ESPECIALIDADE 
      WHERE nomeEspecialidade = 'Clínica Geral'
  )
  AND EXISTS (
      SELECT 1 
      FROM MEDICO_ESPECIALIDADE me2 
      WHERE me2.idMedico = 1 
      GROUP BY me2.idMedico 
      HAVING COUNT(*) > 1
  );

-- Verificação do DELETE 4
SELECT 
    m.nome AS Medico,
    GROUP_CONCAT(e.nomeEspecialidade SEPARATOR ', ') AS EspecialidadesAtuais
FROM MEDICO m
LEFT JOIN MEDICO_ESPECIALIDADE me ON m.idMedico = me.idMedico
LEFT JOIN ESPECIALIDADE e ON me.idEspecialidade = e.idEspecialidade
WHERE m.idMedico = 1
GROUP BY m.idMedico, m.nome;

-- ============================================
-- RESUMO FINAL DAS OPERAÇÕES
-- ============================================
SELECT 'Total de Consultas' AS Informacao, COUNT(*) AS Quantidade FROM CONSULTA
UNION ALL
SELECT 'Consultas Realizadas', COUNT(*) FROM CONSULTA WHERE status = 'REALIZADA'
UNION ALL
SELECT 'Consultas Agendadas', COUNT(*) FROM CONSULTA WHERE status = 'AGENDADA'
UNION ALL
SELECT 'Consultas Canceladas', COUNT(*) FROM CONSULTA WHERE status = 'CANCELADA'
UNION ALL
SELECT 'Total de Medicamentos', COUNT(*) FROM MEDICAMENTO
UNION ALL
SELECT 'Total de Especialidades', COUNT(*) FROM ESPECIALIDADE;