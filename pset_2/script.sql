/*PSet 2*\


/* Questão 1*\
SELECT nome_departamento, AVG(salario)
FROM funcionario, departamento
GROUP BY nome_departamento HAVING AVG(salario);

/* Questão 2 *\
SELECT sexo, AVG(salario) as media_salarial
FROM funcionario
WHERE sexo = "F" UNION SELECT sexo, AVG(salario) FROM funcionario
WHERE sexo = "M";

/* Questão 3 *\
SELECT  nome_departamento,  primeiro_nome, nome_meio, ultimo_nome, data_nascimento, 2022 - year(data_nascimento) as idade, salario
FROM  funcionario as f, departamento as d
WHERE f.numero_departamento = d.numero_departamento;

/* Questão 4 *\
SELECT f.primeiro_nome, f.nome_meio, f.ultimo_nome, f.data_nascimento, 2022 -year(f.data_nascimento) as idade, funcionario.salario,
CASE 
WHEN f.salario < 35000.00 THEN (f.salario) * 1.2
WHEN f.salario >= 35000.00 THEN (f.salario)* 1.15
ELSE (f.salario) * 1
END as ajuste_salarial
FROM funcionario JOIN funcionario as f on (f.cpf = funcionario.cpf);

/* Questão 5 *\
SELECT departamento.nome_departamento, funcionario.primeiro_nome as nome_gerente, f.primeiro_nome as nome_funcionario
FROM departamento as d join funcionario as f on (d.numero_departamento = f.numero_departamento)
JOIN departamento join funcionario on (departamento.cpf_gerente = funcionario.cpf)
WHERE departamento.nome_departamento = d.nome_departamento
ORDER BY d.nome_departamento ASC, f.salario DESC;

/* Questão 6*\
SELECT  primeiro_nome, nome_meio, ultimo_nome, nome_departamento, nome_dependente, 2022 - year(de.data_nascimento) as idade, de.sexo,
CASE 
WHEN de.sexo = 'M' THEN 'masculino'
WHEN de.sexo = 'F' THEN 'feminino'
END as sexo
FROM  funcionario as f, departamento as da, dependente as de
WHERE de.cpf_funcionario = f.cpf AND f.numero_departamento = da.numero_departamento;

/* Questão 7 *\
SELECT f.primeiro_nome, f.nome_meio ,f.ultimo_nome, f.numero_departamento as departamento, de.nome_departamento, f.salario
FROM funcionario f join departamento as de on (f.numero_departamento = de.numero_departamento)
WHERE NOT EXISTS(
SELECT * 
FROM dependente as d 
WHERE f.cpf = d.cpf_funcionario);

/* Questão 8 *\
SELECT nome_departamento, nome_projeto, horas, primeiro_nome, nome_meio, ultimo_nome
FROM funcionario, departamento, projeto, trabalha_em
WHERE funcionario.cpf = trabalha_em.cpf_funcionario AND trabalha_em.numero_projeto = projeto.numero_projeto AND funcionario.numero_departamento = departamento.numero_departamento;


/* Questão 9 *\
SELECT projeto.nome_projeto, departamento.nome_departamento, SUM(horas)
FROM projeto, departamento, trabalha_em
WHERE projeto.numero_departamento = departamento.numero_departamento AND trabalha_em.numero_projeto = projeto.numero_projeto
GROUP BY projeto.nome_projeto;

/* Questão 10 *\
SELECT nome_departamento, AVG(salario)
FROM funcionario, departamento
GROUP BY nome_departamento HAVING AVG(salario);


/* Questão 11 *\
SELECT primeiro_nome, nome_meio, ultimo_nome, p.nome_projeto, horas * 50 as valor_das_horas
FROM funcionario join projeto as p 
join trabalha_em as t on (p.numero_projeto = t.numero_projeto)
WHERE funcionario.cpf = t.cpf_funcionario;

/* Questão 12 *\
SELECT f.primeiro_nome, f.nome_meio, f.ultimo_nome, p.nome_projeto, d.nome_departamento
FROM funcionario as f JOIN projeto as p on  ( f.numero_departamento = p.numero_departamento)
JOIN departamento as d on  ( f.numero_departamento = d.numero_departamento)
JOIN trabalha_em as t on  ( t.cpf_funcionario = f.cpf)
WHERE horas IS NULL;

/* Questão 13 *\
SELECT primeiro_nome, nome_meio, ultimo_nome, 2022 -year(funcionario.data_nascimento) as idade ,funcionario.sexo, nome_dependente, dependente.sexo, 2022 -year(dependente.data_nascimento) as idade
FROM funcionario 
LEFT JOIN dependente on (dependente.cpf_funcionario = funcionario.cpf)
ORDER BY idade DESC;
/* Questão 14 *\
SELECT funcionario.numero_departamento, departamento.nome_departamento, COUNT(cpf) as qtde_por_departamento 
FROM departamento join funcionario ON (funcionario.numero_departamento = departamento.numero_departamento) GROUP BY numero_departamento;

/* Questão 15 *\
SELECT primeiro_nome, nome_meio, ultimo_nome, d.nome_departamento, p.nome_projeto
FROM trabalha_em as t LEFT JOIN projeto as p on (p.numero_projeto = t.numero_projeto)
JOIN funcionario as f JOIN departamento as d on (d.numero_departamento = f.numero_departamento)
WHERE cpf_funcionario = f.cpf;



