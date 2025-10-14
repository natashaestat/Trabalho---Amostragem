/*Trabalho - Técnicas de Amostragem */

ods word file='/home/u64059723/Natasha/Amostragem/Trabalho.docx';

title;
footnote;
data _null_;
   file print;
   put 'Técnicas de Amostragem';
   put 'Grupo 1 (ICC Sul)';
run;


/*Introdução*/
ods text= '1. Introdução';

ods text = 'Há aproximadamente quinze anos, as primeiras montadoras chinesas desembarcaram no Brasil com o objetivo de 
expandir a presença do setor automobilístico chinês no país. Entretanto, foi apenas recentemente que se iniciou um novo 
e mais vigoroso movimento de fabricantes chinesas interessadas não apenas em vender, mas também em produzir veículos 
em território nacional, agora com ênfase na eletrificação automotiva.

De acordo com dados da Federação Nacional da Distribuição de Veículos Automotores (Fenabrave), em apenas três anos as 
montadoras chinesas conquistaram 7,2% do mercado brasileiro. Atualmente, a GWM, com 1,8% de participação, já supera marcas 
tradicionais como Peugeot e BMW, ambas com fábricas instaladas no país há anos. Já a BYD, com 5,4% de participação, ocupa 
a oitava posição no ranking nacional de vendas.

Diante desse cenário, o presente relatório propõe um estudo sobre a participação e a proporção das montadoras 
chinesas no Brasil. Para tanto, foi considerado um plano amostral do tipo Amostra Aleatória Simples (AAS), com dados 
coletados no estacionamento do ICC Sul da Universidade de Brasília (UnB). O relatório apresenta, primeiramente, 
a metodologia utilizada para a obetnção da amostra, em seguida, a análise dos resultados obtidos, e, por fim, 
as conclusões decorrentes das informações coletadas.

O estudo tem como objetivo observar em que medida as montadoras chinesas estão consolidando espaço no mercado
automobilístico brasileiro, oferecendo recursos para futuras investigações sobre o tema. A BYD, por exemplo, 
anunciou a meta de alcançar mais de 50% de nacionalização de partes e peças até 2027, o que sinaliza uma tendência 
de fortalecimento da presença industrial chinesa no país.';

ods text = "Referências: 
https://www.gazetadopovo.com.br/economia/avanco-montadoras-chinesas-brasil-byd-gwm/
https://www.uol.com.br/carros/noticias/redacao/2025/05/24/quais-marcas-chinesas-ja-estao-no-brasil-quais-virao-e-quais-ja-se-foram.htm?cmpid=copiaecola";



/*Metodologia*/
/*Plano Amostral*/

ods text= '2. Metodologia';
ods text = '2.1. Plano Amostral';


/*Resultados*/
ods text = "3. Análise dos Resultados";

ods text = "Com base nas amostras coletadas, esta seção apresenta a análise dos resultados obtidos.
As análises incluem: a proporção de veículos segundo a nacionalidade, a proporção de veículos
de origem chinesa por dia de coleta e, por fim, a estimação pontual e intervalar dessa proporção.";

/*Importação e tratamento dos dados*/
proc import datafile = '/home/u64059723/Natasha/Amostragem/analisar_quarta.xlsx'
  out = quarta
  dbms = xlsx
  replace;
run;

proc import datafile = '/home/u64059723/Natasha/Amostragem/analisar_quinta.xlsx'
  out = quinta
  dbms = xlsx
  replace;
run;

data quarta;
  set quarta;
  dia = 'Quarta-feira';
  if Marca = 'Chinês' then chines = 1;
  else chines = 0;
run;

data quinta;
  set quinta;
  dia = 'Quinta-feira';
  if Marca = 'Chinês' then chines = 1;
  else chines = 0;
run;


data veiculos;
  set quarta quinta; /* Base conjunta */
  if Marca = 'Sem carro' then valido = 'Não';
  else valido = 'Sim';
run;


ods text = "3.1. Caracterização da Amostra";

ods text = "Nesta seção, descreve-se a composição das amostras coletadas em dois dias distintos (quarta e quinta-feira).
Apresentam-se o tamanho de cada amostra, o total de informações válidas e a distribuição dos veículos por nacionalidade
em valores absolutos, além de um gráfico para melhor visualização dos resultados.";



proc freq data=veiculos noprint;
  tables dia / out=tam_dia(drop=percent);
run;

data tam_dia; 
  set tam_dia;
  length Dia $15;
  Dia = dia; 
  label count = "Tamanho da Amostra (n)";
run;

title "Tamanho da Amostra por Dia de Coleta";
proc print data=tam_dia noobs label;
  var Dia count;
run;
title;

proc sort data=veiculos; by dia; run;

proc freq data=veiculos noprint;
  by dia;
  tables valido / out=validade_out;
run;

data validade_fmt;
  set validade_out;
  length Dia $15 Válido $3;
  Dia = dia;
  Válido = valido;
  Percentual = round(percent, 0.01);
  label count = "Frequência" Percentual = "Percentual (%)";
  keep Dia Válido count Percentual;
run;

title "Distribuição da Validade dos Registros por Dia da Semana";
proc print data=validade_fmt noobs label;
  format Percentual 6.2;
run;
title;

ods text = "Observa-se, a partir das tabelas acima, que ambas as amostras apresentaram tamanho idêntico (n = 168).
Verifica-se também uma proporção elevada de vagas sem automóvel nas duas coletas (por volta de 60% em cada dia).
Esse volume de observações sem veículo pode impactar as estimativas; ainda assim, como não foi utilizada calibração,
os dados são analisados considerando tais observações.";


proc freq data=veiculos noprint;
  by dia;
  tables Marca / out=marcas_out;
run;

data marcas_quarta marcas_quinta;
  set marcas_out;
  length Marca $20;
  Percentual = round(percent, 0.01);
  label count = "Frequência" Percentual = "Percentual (%)" Marca = "Nacionalidade / Marca";
  if dia = "Quarta-feira" then output marcas_quarta;
  else if dia = "Quinta-feira" then output marcas_quinta;
  keep Marca count Percentual dia;
run;

title "Distribuição das Marcas de Veículos - Quarta-feira";
proc print data=marcas_quarta noobs label;
  format Percentual 6.2;
run;
title;

title "Gráfico - Distribuição das Marcas (Quarta-feira)";
proc gchart data=marcas_quarta;
  vbar Marca / sumvar=count type=sum discrete inside=freq outside=percent;
run;
quit;
title;

title "Distribuição das Marcas de Veículos - Quinta-feira";
proc print data=marcas_quinta noobs label;
  format Percentual 6.2;
run;
title;

title "Gráfico 3D - Distribuição das Marcas (Quinta-feira)";
proc gchart data=marcas_quinta;
  vbar3d Marca / sumvar=count type=sum discrete inside=freq outside=percent width=6 coutline=black;
run;
quit;
title;

ods text= '3.2. Proporção de Veículos Chineses';

ods text= 'Nesta subseção, apresenta-se a proporção de veículos de origem chinesa em cada dia e no total. 
A seguir, são mostrados o cálculo da proporção de veículos chineses (p̂), a proporção total, 
os intervalos de confiança de 95% e, por fim, um gráfico de barras com intervalo de confiança (erro padrão visual).';

proc means data=veiculos mean var;
  class dia;
  var chines;
run;

proc surveymeans data=veiculos mean var clm;
  var chines;
  domain dia;
run;

proc means data=quarta mean var; var chines; run;
proc surveymeans data=quarta total=1125 mean var clm; var chines; run;

proc means data=quinta mean var; var chines; run;
proc surveymeans data=quinta mean var clm; var chines; run;

proc means data=veiculos noprint;
  class dia;
  var chines;
  output out=prop_china (where=(_type_=1)) mean=p_hat;
run;

title "Proporção de Veículos Chineses por Dia (p̂)";
proc gchart data=prop_china;
  vbar dia / sumvar=p_hat type=sum discrete outside=percent;
run;
quit;
title;



ods text= '3.3. Comparação entre os Dias de Coleta';

ods text= 'Com o objetivo de verificar se o comportamento amostral difere entre os dias de coleta, 
compara-se a proporção de veículos chineses observada em cada um deles. Em seguida, apresenta-se o teste de 
diferença de proporções (Teste Qui-Quadrado 2x2) e a interpretação dos resultados obtidos.';


proc freq data=veiculos;
  tables dia*chines / chisq expected riskdiff relrisk;
run;


ods text= '3.4. Distribuição Geral por Nacionalidade';

ods text= 'A seguir, amplia-se a análise para todas as categorias de nacionalidade, de modo a observar se o 
perfil de veículos varia entre os dias de coleta. Essa verificação baseia-se na tabela com as frequências e 
proporções de cada origem por dia e na aplicação do Teste de Homogeneidade (Qui-Quadrado).
Por fim, apresenta-se uma visualização gráfica dos resultados.';

proc freq data=veiculos;
  tables dia*Marca / chisq nocol norow expected;
run;

title "Distribuição por Nacionalidade, por Dia";
proc gchart data=veiculos;
  vbar Marca / discrete group=dia;
run;
quit;
title;

ods text= '3.5. Estimativa Final e Precisão';

ods text= 'Como última análise, apresenta-se a estimativa pontual, o intervalo de confiança de 95% e a 
margem de erro observada, comparando-a com a margem de erro planejada (7%).';

/*Conclusão*/
ods text = 'Conclusão';


ods word close;

