##1.Conexao ao BD
#install.packages("RPostgres")
#carregar libraries usadas
library(RPostgres)
library(DBI)
library(writexl)

#setwd("C:/Users/karla.ferreira/Documents/Karla 2021/Demandas julho/Trimestral 2")

db <- "dbpro_11323_sisdpu"  #provide the name of your db
host_db <- "10.0.2.239"
db_port <- "5432"  # or any other port specified by the DBA
db_user <- "postgres"
db_password <- " "
con <- dbConnect(RPostgres::Postgres(), dbname = db, host=host_db, port=db_port, user=db_user, password=db_password)
dbListTables(con) #saber se funcionou a conexao

#1.PAJs com pretensão e ofício atual
q_pretensao <- "SELECT 	distinct EXTRACT (MONTH FROM rlpm.dh_movimentacao) as mes,
  EXTRACT (YEAR FROM rlpm.dh_movimentacao) as ano, u.no_unidade||''||oat.no_oficio as concat,
  o.co_seq_oficio as cod_orig, o.no_oficio AS oficio_original, o.st_ativo as ativo,
  p3.no_pretensao as pret3, p2.no_pretensao as pret2, p1.no_pretensao as pret1,
  p.nu_ano_abertura_processo||'/'||right('000'||(P.co_seq_unidade::CHAR(3)),3)||'-'||right('00000'||(P.nu_processo::CHAR(6)),5)  AS PAJ,
  oat.co_seq_oficio as cod_at,oat.no_oficio as oficio_atual, 
  P.co_seq_unidade as cod_unidade,
  case 
  when upper(oat.no_oficio) similar to '%OSASCO%' then 'Osasco/SP'
  else u.no_unidade
  end as unidade,
  
  case 
  when p1.co_seq_pretensao in (2,3,4,7,11,12,13,14,15,16,18,19,21,22,23,24,25,26,28,29,30,33,34,36,37,38,39,40,41,42,43,44,45,47,48,49,50,51,55,57,60,65,66,89,90,91,92,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,
110,111,112,113,114,115,125,163,164,165,166,167,169,170,171,172,173,174,175,176,177,178,179,180,181,182,183,184,185,187,188,189,190,191,192,194,195,197,199,200,202,203,204,214,215,217,226,227,
228,229,230,231,232,233,234,235,236,237,238,239,240,241,242,243,244,245,246,247,248,249,250,251,252,253,254,255,256,257,258,259,260,261,262,263,264,265,266,267,268,269,270,271,272,273,274,275,
276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,329,331) then 'Cível' 
  when p1.co_seq_pretensao in (20,52,53,54,58,59,61,63,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,94,126,129,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,
154,155,156,157,158,159,160,161,162,186,216,299,300,301,302,303,304,305,306,307,308,309,310,314,315,316,326,328) then 'Criminal'
  when p1.co_seq_pretensao = 68 then 'Eleitoral'
  when p1.co_seq_pretensao = 70 then 'Matéria Estadual'
  when p1.co_seq_pretensao in (5,6,8,9,10,17,27,31,32,67,116,117,118,119,120,121,122,123,124,193,196,198,201,205,206,207,208,209,210,211,212,213,218,311,312,313,317,318,319,320,321,322,323,324,325) then  'Previdenciário'
  when p1.co_seq_pretensao in (35,69,93,127,128,130,131,132,133,134) then 'Trabalhista'
  when p1.co_seq_pretensao in (64,88,168) then 'Tutela Coletiva'
  when p1.co_seq_pretensao in (1,46) then 'Não Cadastrada'
  when p1.co_seq_pretensao in (56,62,327,330) then 'Outra Pretensao'
  end as Materia,
  
  case 
  when upper(oat.no_oficio) similar to '%GERAL%' then 'Geral'
  
  when upper(oat.no_oficio) similar to '%CÍVEL%' and
  upper(oat.no_oficio) similar to '%RESIDUAL%' and
  upper(oat.no_oficio) similar to '%PREVIDENCIÁRIO%' then 'Cível'
  
  
  when upper(oat.no_oficio) similar to '%CRIMINAL MILITAR%' and
  upper(oat.no_oficio) similar to '%ELEITORAL%' and
  upper(oat.no_oficio) similar to '%TRABALHISTA%' then 'Misto'
  
  when upper(oat.no_oficio) similar to '%ESPECIALIZADO%' and
  upper(oat.no_oficio) similar to '%CÍVEL%' and
  upper(oat.no_oficio) similar to '%PREVIDENCIÁRIO%' then 'ESPECIALIZADO CÍVEL E PREVIDENCIÁRIO'
  
  when upper(oat.no_oficio) similar to '%ESPECIALIZADO%' and
  upper(oat.no_oficio) similar to '%CRIMINAL%' and
  upper(oat.no_oficio) similar to '%PREVIDENCIÁRIO%' then 'ESPECIALIZADO CRIMINAL E PREVIDENCIÁRIO'
  
  when upper(oat.no_oficio) similar to '%CÍVEL%' then 'Cível'
  when upper(oat.no_oficio) similar to '%MILITAR%' then 'Militar'
  when upper(oat.no_oficio) similar to '%PREVIDENCIÁRIO%' then 'Previdenciário'
  when upper(oat.no_oficio) similar to '%PREVIDENCIARIO%' then 'Previdenciário'
  when upper(oat.no_oficio) similar to '%CRIMINAL%' then 'Criminal'
  when upper(oat.no_oficio) similar to '%PENAL%' then 'Execução Penal'
  when upper(oat.no_oficio) similar to '%EXECUÇÃO FISCAL%' then 'EXECUÇÃO FISCAL'
  when upper(oat.no_oficio) similar to '%MIGRAÇÕES%' then 'Cível'
  when upper(oat.no_oficio) similar to '%TRABALHISTA%' then 'Trabalhista'
  
  when upper(oat.no_oficio) similar to '%DIREITOS HUMANOS%' and
  upper(oat.no_oficio) similar to '%REGIONAL%'then 'DRDH'
  
  when upper(oat.no_oficio) similar to '%DIREITOS HUMANOS%' and
  upper(oat.no_oficio) similar to '%NACIONAL%'then 'DNDH'
  
  when upper(oat.no_oficio) similar to '%GTRUA%' then 'GTRUA'
  when upper(oat.no_oficio) similar to '%GT%' then 'GT'
  when upper(oat.no_oficio) similar to '%AASTF%' then 'AASTF'
  when upper(oat.no_oficio) similar to '%TURMA RECURSAL%' then 'Especial'
  when upper(oat.no_oficio) similar to '%REGIONAL ESPECIAL%' then 'Especial'
  
  else 'Geral'
  end as Area,
  
  case 
  when p.co_seq_unidade =102 then 'DNDH'
  when upper(oat.no_oficio) similar to '%HUMANOS%' and
  p.co_seq_unidade =48 then ' DRDH 1a Categoria'
  when upper(oat.no_oficio) similar to '%HUMANOS%'then 'DRDH 2a Categoria'
  when upper(oat.no_oficio) similar to '%REGIONAL%' then '1a Categoria'
  when upper(u.no_unidade) similar to '%CATEGORIA ESPECIAL%' then 'Categoria Especial'
  when upper(u.no_unidade) similar to '%CÂMARAS%' then 'Câmaras'
  when upper(u.no_unidade) similar to '%TESTE%' then 'Unidade Teste'	
  when upper(u.no_unidade) similar to '%AASTF%' then 'AASTF'
  when upper(u.no_unidade) similar to '%DPU EMERGENCIAL%' then 'DPU Emergencial'
  when upper(u.no_unidade) similar to '%ITINERANTE%' then 'Itinerante'
  when upper(oat.no_oficio) similar to '%ITINERANTE%' then 'Itinerante'
  
  else '2a Categoria'
  end as Categoria,
  -- Pretensao completa
  
  case when  p1.co_seq_pretensao_relacionada is null then p1.no_pretensao
  when  p3.no_pretensao is null then concat(p2.no_pretensao,' >> ',p1.no_pretensao)
  else concat(p3.no_pretensao,' >> ', p2.no_pretensao, ' >> ',p1.no_pretensao) end as Pretensao
  
  FROM (select x.dh_movimentacao, x.co_seq_processo, x.co_seq_proc_movto, x.co_seq_oficio_responsavel, y.co_seq_unidade as co_seq_unidade_usr_logado
        from epaj.rl_proc_movimentacao x
        left join epaj.tb_processo y
        on x.co_seq_processo  = y.co_seq_processo      )  rlpm --corrigir cod da unidade de acordo com tabela de processo
  
  INNER JOIN epaj.tb_processo p ON rlpm.co_seq_processo  = p.co_seq_processo	
  LEFT JOIN epaj.rl_proc_movto_fase rlpmf ON rlpm.co_seq_proc_movto = rlpmf.co_seq_proc_movto	
  LEFT JOIN epaj.rh_unidade u ON rlpm.co_seq_unidade_usr_logado = u.co_seq_unidade	
  LEFT JOIN epaj.tb_oficio o ON rlpm.co_seq_oficio_responsavel = o.co_seq_oficio	
  LEFT JOIN epaj.tb_oficio oat ON p.co_seq_oficio = oat.co_seq_oficio	
  JOIN epaj.rl_processo_pretensao rlpp on p.co_seq_processo = rlpp.co_seq_processo and rlpp.st_principal = true	
  join epaj.tb_pretensao p1 on p1.co_seq_pretensao = rlpp.co_seq_pretensao	
  left join epaj.tb_pretensao p2 on p1.co_seq_pretensao_relacionada = p2.co_seq_pretensao	
  left join epaj.tb_pretensao p3 on p2.co_seq_pretensao_relacionada = p3.co_seq_pretensao	
  WHERE 
  rlpmf.co_seq_fase IN (1)	
  AND rlpm.dh_movimentacao::date >= '2022-01-01'::date	
  AND rlpm.dh_movimentacao::date <= '2022-03-31'::date	
  AND p.co_seq_unidade not in (40,73,43,54,84,107,52,102) --	unidades nao usadas
  --AND p.co_seq_unidade = 16	
  ORDER BY 1,2,3,5,6,7,8;"

pretensao<-dbGetQuery(con, q_pretensao)
#pretensao
#Salvar dados pretensao
write_xlsx(pretensao, "Trimestral 2.xlsx")


#Desconectar do BD
dbDisconnect(con)