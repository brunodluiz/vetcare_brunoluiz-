-- Entrega da atividade de Manutenção de Sistemas - VetCare
-- Banco compatível com config/database.php (dbname=vetcare).
-- Execute após importar o banco principal do projeto.
CREATE DATABASE IF NOT EXISTS vetcare CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE vetcare;

CREATE TABLE IF NOT EXISTS chamados (
  id INT AUTO_INCREMENT PRIMARY KEY,
  titulo VARCHAR(160) NOT NULL,
  modulo VARCHAR(60) NOT NULL,
  solicitante VARCHAR(120) NOT NULL,
  equipe VARCHAR(100),
  descricao TEXT NOT NULL,
  passos TEXT NOT NULL,
  resultado_esperado TEXT NOT NULL,
  resultado_obtido TEXT NOT NULL,
  severidade ENUM('Baixa','Média','Alta','Crítica') NOT NULL DEFAULT 'Média',
  prioridade ENUM('Baixa','Média','Alta','Urgente') NOT NULL DEFAULT 'Média',
  status ENUM('Aberto','Em análise','Aguardando informações','Resolvido','Fechado') NOT NULL DEFAULT 'Aberto',
  responsavel VARCHAR(120),
  criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  atualizado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS historico_chamados (
  id INT AUTO_INCREMENT PRIMARY KEY,
  chamado_id INT NOT NULL,
  autor VARCHAR(120) NOT NULL,
  comentario TEXT NOT NULL,
  status_anterior VARCHAR(40),
  status_novo VARCHAR(40),
  criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_historico_chamado FOREIGN KEY (chamado_id)
    REFERENCES chamados(id) ON DELETE CASCADE
);

-- Evita duplicar os registros desta entrega ao importar novamente.
DELETE FROM historico_chamados WHERE chamado_id BETWEEN 1 AND 12;
DELETE FROM chamados WHERE id BETWEEN 1 AND 12;

INSERT INTO chamados
(id,titulo,modulo,solicitante,equipe,descricao,passos,resultado_esperado,resultado_obtido,severidade,prioridade,status,responsavel)
VALUES
(1,'Banco criado com nome diferente do utilizado na conexão','Outro','Equipe de manutenção','Equipe VetCare','O script SQL cria vetcare_djeniffer, mas seleciona vetcare e a conexão PHP também utiliza vetcare. A importação pode criar um banco e tentar usar outro.','Executar database/vetcare.sql e conferir o banco selecionado no phpMyAdmin.','O banco criado deve ser o mesmo utilizado pela aplicação.','A definição do banco no script e na conexão precisa permanecer igual.','Alta','Alta','Fechado','Equipe de manutenção'),
(2,'Exclusão de animal sem condição WHERE','Animais','Equipe de manutenção','Equipe VetCare','A consulta DELETE não filtra pelo identificador recebido e ainda recebe um parâmetro que não possui marcador.','Abrir Animais e clicar em Excluir em um registro de teste.','Somente o animal selecionado deve ser removido.','A instrução SQL não contém WHERE e pode falhar por quantidade incorreta de parâmetros; se executada sem parâmetro, poderia apagar todos os animais.','Crítica','Urgente','Fechado','Equipe de manutenção'),
(3,'Botão Novo tutor não abre o formulário','Tutores','Equipe de manutenção','Equipe VetCare','A função JavaScript cancela a navegação e exibe apenas uma mensagem de erro.','Abrir Tutores e clicar em + Novo tutor.','O formulário de cadastro deve ser aberto.','A navegação é interrompida por event.preventDefault().','Alta','Alta','Fechado','Equipe de manutenção'),
(4,'Busca de tutores considera somente a primeira palavra','Tutores','Equipe de manutenção','Equipe VetCare','O termo de busca é dividido e somente a primeira palavra é enviada ao LIKE.','Pesquisar um tutor usando nome e sobrenome.','A pesquisa deve considerar o texto completo informado.','Somente a primeira palavra do campo é utilizada.','Média','Média','Fechado','Equipe de manutenção'),
(5,'Filtro por status não é aplicado nas consultas','Consultas','Equipe de manutenção','Equipe VetCare','A tela recebe o parâmetro status, mas executa a consulta sem adicionar condição WHERE.','Acessar Consultas, selecionar Realizada e clicar em Filtrar.','A lista deve exibir somente consultas com o status selecionado.','Todos os status continuam aparecendo.','Média','Alta','Fechado','Equipe de manutenção'),
(6,'Idade do animal calculada sem considerar o aniversário','Animais','Equipe de manutenção','Equipe VetCare','A idade é calculada apenas pela diferença entre os anos, podendo acrescentar um ano antes do aniversário.','Consultar um animal cuja data de nascimento ainda não ocorreu no ano atual.','A idade deve considerar dia e mês do nascimento.','A idade exibida pode ficar um ano acima da idade real.','Baixa','Média','Fechado','Equipe de manutenção'),
(7,'Links do menu quebram em páginas internas','Outro','Equipe de manutenção','Equipe VetCare','Os links do cabeçalho usam caminhos relativos. Em páginas dentro de subpastas, o navegador procura destinos dentro da pasta atual.','Abrir uma página em chamados, animais ou consultas e utilizar os links do menu.','Todos os links devem levar às páginas corretas independentemente da pasta atual.','Os caminhos relativos podem gerar URLs incorretas, como /animais/chamados/index.php.','Alta','Alta','Fechado','Equipe de manutenção'),
(8,'Painel lista consultas antigas como próximas','Dashboard','Equipe de manutenção','Equipe VetCare','A consulta do painel ordena por data, mas não limita os resultados a datas futuras.','Acessar o painel quando existirem consultas passadas e futuras.','A seção Próximas consultas deve listar apenas consultas futuras não canceladas.','Consultas antigas podem aparecer antes das futuras.','Média','Média','Fechado','Equipe de manutenção'),
(9,'Identificador de sessão não é regenerado após login','Login','Equipe de manutenção','Equipe VetCare','Após autenticação bem-sucedida, o sistema mantém o identificador de sessão anterior.','Acessar o login e autenticar com uma conta válida.','O identificador da sessão deve ser regenerado após autenticação.','A sessão é mantida sem chamar session_regenerate_id(true).','Alta','Alta','Fechado','Equipe de manutenção'),
(10,'Falha de exclusão de tutor é ocultada','Tutores','Equipe de manutenção','Equipe VetCare','A exceção PDOException é ignorada sem mensagem ao usuário, dificultando identificar quando a exclusão não ocorre por vínculo com animais.','Tentar excluir um tutor que possui animal cadastrado.','O sistema deve informar que o tutor possui vínculo e não pode ser excluído, ou oferecer desativação.','A operação falha silenciosamente e o usuário não recebe retorno.','Média','Média','Fechado','Equipe de manutenção'),
(11,'Login compara senha sem mecanismo de hash','Login','Equipe de manutenção','Equipe VetCare','A senha informada é comparada diretamente com o valor armazenado no banco. O banco mantém a senha em texto puro.','Verificar o cadastro do usuário e realizar login com a senha de demonstração.','A senha deve ser armazenada com hash e validada com password_verify.','A senha fica legível no banco e a validação depende de comparação direta.','Alta','Alta','Fechado','Equipe de manutenção'),
(12,'Formulário de consulta não preserva os dados após erro','Consultas','Equipe de manutenção','Equipe VetCare','Quando ocorre erro de validação, os valores enviados não são copiados de volta para o formulário; os campos continuam usando os valores antigos do banco ou vazios.','Enviar o formulário de consulta com veterinário vazio e preencher outros campos.','Após a mensagem de validação, os demais dados digitados devem permanecer preenchidos.','Os dados digitados podem ser perdidos após a validação falhar.','Baixa','Média','Fechado','Equipe de manutenção');

-- Histórico: abertura dos 12 chamados e registro do encerramento.
INSERT INTO historico_chamados
(chamado_id,autor,comentario,status_anterior,status_novo)
VALUES
(1,'Equipe de manutenção','1ª etapa: divergência identificada em database/vetcare.sql, linha 1. 2ª etapa: nome de criação padronizado para vetcare, igual ao USE vetcare e ao config/database.php, linha 3.','', 'Aberto'),
(1,'Equipe de manutenção','Correção validada: criação, seleção e conexão utilizam vetcare. Chamado encerrado.','Aberto','Fechado'),
(2,'Equipe de manutenção','1ª etapa: falha reproduzida em animais/excluir.php, linha 4. 2ª etapa: corrigido para DELETE FROM animais WHERE id=?; o parâmetro $id é vinculado à condição.','', 'Aberto'),
(2,'Equipe de manutenção','Teste de exclusão confirmou que somente o animal selecionado é removido. Chamado encerrado.','Aberto','Fechado'),
(3,'Equipe de manutenção','1ª etapa: falha reproduzida em tutores/index.php, linhas 12 e 19-22. 2ª etapa: removido o onclick que chamava testeErro e removida a função que bloqueava a navegação.','', 'Aberto'),
(3,'Equipe de manutenção','Botão + Novo tutor abre form.php normalmente. Chamado encerrado.','Aberto','Fechado'),
(4,'Equipe de manutenção','1ª etapa: falha reproduzida em tutores/index.php, linha 6. 2ª etapa: alterado o parâmetro para usar o termo completo: $param=[\"%\".$busca.\"%\"].','', 'Aberto'),
(4,'Equipe de manutenção','Pesquisa validada com nome e sobrenome completos. Chamado encerrado.','Aberto','Fechado'),
(5,'Equipe de manutenção','1ª etapa: falha reproduzida em consultas/index.php, linhas 3-5. 2ª etapa: adicionada condição WHERE c.status=? quando o filtro estiver preenchido, com execução por prepared statement.','', 'Aberto'),
(5,'Equipe de manutenção','Filtro de status validado para Agendada, Realizada e Cancelada. Chamado encerrado.','Aberto','Fechado'),
(6,'Equipe de manutenção','1ª etapa: falha identificada em animais/index.php, linha 8. 2ª etapa: idade recalculada por diferença de datas, descontando um ano quando o aniversário ainda não ocorreu.','', 'Aberto'),
(6,'Equipe de manutenção','Idade validada antes e depois da data de aniversário. Chamado encerrado.','Aberto','Fechado'),
(7,'Equipe de manutenção','1ª etapa: falha reproduzida em includes/header.php, linhas 18-23. 2ª etapa: caminhos relativos substituídos por caminhos absolutos iniciados em /vetcare_manutencao_djeniffer/.','', 'Aberto'),
(7,'Equipe de manutenção','Menu validado a partir das páginas de todas as subpastas. Chamado encerrado.','Aberto','Fechado'),
(8,'Equipe de manutenção','1ª etapa: falha identificada em index.php, linha 9. 2ª etapa: consulta ajustada para filtrar c.data_consulta >= NOW() e status diferente de Cancelada antes da ordenação.','', 'Aberto'),
(8,'Equipe de manutenção','Painel validado: somente consultas futuras são exibidas. Chamado encerrado.','Aberto','Fechado'),
(9,'Equipe de manutenção','1ª etapa: falha identificada em login.php, antes da atribuição das variáveis de sessão (linhas 15-17). 2ª etapa: incluído session_regenerate_id(true) imediatamente após a autenticação válida.','', 'Aberto'),
(9,'Equipe de manutenção','Login validado com regeneração do identificador da sessão após autenticação. Chamado encerrado.','Aberto','Fechado'),
(10,'Equipe de manutenção','1ª etapa: falha identificada em tutores/excluir.php, linha 4. 2ª etapa: adicionada mensagem de retorno para falha de integridade referencial e orientação para inativar o tutor.','', 'Aberto'),
(10,'Equipe de manutenção','Erro de exclusão agora é comunicado ao usuário sem ocultar a falha. Chamado encerrado.','Aberto','Fechado'),
(11,'Equipe de manutenção','1ª etapa: falha identificada em login.php, linha 13, e database/vetcare.sql, linha 18. 2ª etapa: autenticação alterada para password_verify e senha inicial armazenada com password_hash.','', 'Aberto'),
(11,'Equipe de manutenção','Login validado com senha armazenada em hash. Chamado encerrado.','Aberto','Fechado'),
(12,'Equipe de manutenção','1ª etapa: falha identificada em consultas/form.php, linhas 6-14. 2ª etapa: em caso de erro, os dados recebidos são copiados para $r e reapresentados no formulário.','', 'Aberto'),
(12,'Equipe de manutenção','Validação testada: campos permanecem preenchidos após mensagem de erro. Chamado encerrado.','Aberto','Fechado');
