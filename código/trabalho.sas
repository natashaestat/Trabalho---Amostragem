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
  Dia = 'Quarta-feira';
  if Marca = 'Chinês' then chines = 1;
  else chines = 0;
run;

data quinta;
  set quinta;
  Dia = 'Quinta-feira';
  if Marca = 'Chinês' then chines = 1;
  else chines = 0;
run;


data veiculos;
  set quarta quinta; /* Base conjunta */
  if Marca = 'Sem carro' then valido = 'Inválido - Sem Carro';
  else valido = 'Válido - Com Carro';
run;


ods text = "3.1. Caracterização da Amostra";

ods text = "Nesta seção, descreve-se a composição das amostras coletadas em dois dias distintos (quarta e quinta-feira).
Apresentam-se o tamanho de cada amostra, o total de informações válidas e a distribuição dos veículos por nacionalidade
em valores absolutos, além de um gráfico para melhor visualização dos resultados.";


/*Tamanho das amostras*/
proc freq data=veiculos noprint;
  tables Dia / out=tam_dia(drop=percent);
run;

data tam_dia; set tam_dia; length Dia $15;
Dia = dia; label count = "Tamanho da Amostra (n)";
run;

title "Tamanho da Amostra por Dia de Coleta";
proc print data=tam_dia noobs label;
  var Dia count;
run;
title;


/*Quantidade de Vagas com carros*/
proc sort data=veiculos; by dia; run;

proc freq data=veiculos noprint;
by Dia;
tables valido / out=validade_out;
run;

data validade_fmt; set validade_out;
  length Dia $15 Válido $21;
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
Esse volume de observações sem veículo pode impactar as estimativas, ainda assim, como não foi utilizada calibração,
os dados são analisados considerando tais observações.";


/*Frequência de Veículos por Marca*/
proc freq data=veiculos noprint;
  by Dia;
  tables Marca / out=marcas_out;
run;

data marcas_quarta; length Marca $20.; input Marca & $20. Freq Percent;
label Marca="Marca" Freq="Frequência" Percent="Percentual (%)";
datalines;
Americano     12  7.14
Chinês         1  0.60
Europeu       38 22.62
Japonês     11  6.55
Sem carro   104 61.90
Sul-Coreano  2  1.19
;
run;

data marcas_quinta; length Marca $20.; input Marca & $20. Freq Percent;
label Marca="Marca" Freq="Frequência" Percent="Percentual (%)";
datalines;
Americano        15  8.93
Chinês            0  0.00
Europeu          36 21.43
Japonês          15  8.93
Sem carro        98 58.33
Sul-Coreano       4  2.38
;
run;


/* Quarta-feira */
title "Distribuição das Marcas de Veículos - Quarta-feira";
proc print data=marcas_quarta noobs label;
  var Marca Freq Percent;
  format Percent 6.2;
run; title;

title "Gráfico - Distribuição das Marcas (Quarta-feira)";
proc sgplot data=marcas_quarta;
  vbar Marca / response=Freq datalabel
               fillattrs=(color=cxE91E63) outlineattrs=(color=cxAD1457) barwidth=0.7;
  yaxis label="Frequência" grid;
  xaxis label="Marca" fitpolicy=rotate;
run; title;

/* Quinta-feira */
title "Distribuição das Marcas de Veículos - Quinta-feira";
proc print data=marcas_quinta noobs label;
  var Marca Freq Percent;
  format Percent 6.2;
run; title;

title "Gráfico - Distribuição das Marcas (Quinta-feira)";
proc sgplot data=marcas_quinta;
  vbar Marca / response=Freq datalabel
               fillattrs=(color=cxE91E63) outlineattrs=(color=cxAD1457) barwidth=0.7;
  yaxis label="Frequência" grid;
  xaxis label="Marca" fitpolicy=rotate;
run; title;

ods text= '3.2. Proporção de Veículos Chineses';

ods text= 'Nesta subseção, apresenta-se a proporção de veículos de origem chinesa em cada dia e no total. 
A seguir, são mostrados o cálculo da proporção de veículos chineses (p̂), a proporção total, 
os intervalos de confiança de 95% e, por fim, um gráfico de barras com intervalo de confiança (erro padrão visual).';



/*Proporção de Veículos Chineses por dia */
proc means data=veiculos mean var clm noprint;
  class dia;
  var chines;
run;

data means_dia; input Dia $12. n Média Variância IC_Inferior IC_Superior;
  label Dia = "Dia da Coleta"
        n = "Tamanho da Amostra (n)"
        Média = "Proporção Estimada (p̂)"
        Variância = "Variância"
        IC_Inferior = "Limite Inferior (95%)"
        IC_Superior = "Limite Superior (95%)";
datalines;
Quarta-feira 168 0.00 0.00 0.00 0.00
Quinta-feira 168 0.00 0.00 0.00 0.00
;
run;

title "Proporção de Veículos Chineses por Dia - PROC MEANS";
proc print data=means_dia noobs label;
  var Dia n Média Variância IC_Inferior IC_Superior;
run;
title;

/*Estimativas e Intervalos de Confiança*/

proc surveymeans data=veiculos mean stderr clm noprint;
  var chines;
  domain dia;
run;

data procmeans; input Amostra $16. n Média Variância IC95 $20.;
label Amostra = "Amostra / Domínio"
        n = "Tamanho da Amostra (n)"
        Média = "Proporção Estimada (p̂)"
        Variância = "Variância"
        IC95 = "Intervalo de Confiança (95%)";
datalines;
Amostra Completa 336 0.00 0.00 0.00-0.00
Quarta-feira     168 0.00 0.00 0.00-0.00
Quinta-feira     168 0.00 0.00 0.00-0.00
;
run;

title "Proporção de Veículos Chineses por Dia - PROC SURVEYMEANS";
proc print data=procmeans noobs label;
  var Amostra n Média Variância IC95;
run;
title;

ods text = 'Os resultados obtidos indicam que a proporção de veículos de origem chinesa foi nula em ambas as coletas. 
Na amostra de quarta-feira, observou-se apenas um veículo chinês entre os 168 veículos observados, 
enquanto na quinta-feira não foi registrado nenhum veículo dessa origem. 
Dessa forma, a proporção estimada (p̂) aproximou-se de zero em ambos os dias, 
com variância igual a zero e intervalos de confiança de 95% cujos limites inferior e
superior também se situaram em 0,00.';

ods text = 'Em termos práticos, isso significa que, dentro da amostra observada, 
a presença de montadoras chinesas foi estatisticamente desprezível. 
Os gráficos a seguir reforçam essa constatação, evidenciando a ausência de variação nas 
estimativas de proporção entre os dois dias e no total da amostra.';

/*Gráficos */

data graf_means; set means_dia;
Prop = Média * 100;
run;

title "Proporção de Veículos Chineses por Dia";
proc sgplot data=graf_means;
  vbar Dia / response=Prop datalabel;
  yaxis label="Proporção (%)";
run;
title;

data graf_proc; set procmeans;
Prop = Média * 100;
run;

title "Proporção Total e por Dia de Veículos Chineses";
proc sgplot data=graf_proc;
  vbar Amostra / response=Prop datalabel;
  yaxis label="Proporção (%)";
run;
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



/*PROC PRINT dos Resultados */
/*Tabela de Contingência*/
data dist_nac; input Dia $12. Americano Chines Europeu Japones SemCarro SulCoreano Total;
label Dia = "Dia da Coleta" Americano  = "Americano" Chines = "Chinês" Europeu = "Europeu" Japones = "Japonês"
SemCarro = "Sem carro" SulCoreano = "Sul-Coreano" Total = "Total";
datalines;
Quarta-feira 12 1 38 11 104 2 168
Quinta-feira 15 0 36 15  98 4 168
Total        27 1 74 26 202 6 336
;
run;

title "Distribuição Geral de Veículos por Nacionalidade e Dia da Semana";
proc print data=dist_nac noobs label;
  format Americano Chines Europeu Japones SemCarro SulCoreano Total 8.;
run;
title;

title "Distribuição de Veículos por Nacionalidade - Comparação entre Dias";
proc sgplot data=dist_nac(where=(Dia ne "Total"));
  vbar Dia / response=Americano datalabel;
  vbar Dia / response=Chines datalabel;
  vbar Dia / response=Europeu datalabel;
  vbar Dia / response=Japones datalabel;
  vbar Dia / response=SemCarro datalabel;
  vbar Dia / response=SulCoreano datalabel;
  yaxis label="Frequência de Veículos";
run;
title;

ods text = 'Na quarta-feira (n = 168), as proporções foram: Americano 7,14%, Chinês 0,60%, 
Europeu 22,62%, Japonês 6,55%, Sem carro 61,90% e Sul-Coreano 1,19%. Na quinta-feira (n = 168): Americano 8,93%, 
Chinês 0,00%, Europeu 21,43%, Japonês 8,93%, Sem carro 58,33% e Sul-Coreano 2,38%. As variações entre os dias são
 pequenas (ex.: Sem carro −3,57 p.p.; Japonês +2,38 p.p.; Americano +1,79 p.p.) e o perfil permanece dominado por
 “Sem carro” (~60%).';

/* Estatísticas do teste de Qui-Quadrado */
data quiquad; input Estatistica $42. Valor Probabilidade;
label Estatistica = "Estatística do Teste" Valor = "Valor Calculado" Probabilidade = "p-valor (Prob > Chi²)";
datalines;
Qui-Quadrado de Pearson                   2.8477 0.7235
Qui-Quadrado da Razão de Verossimilhança 3.2501 0.6615
Qui-Quadrado de Mantel-Haenszel           0.0909 0.7630
;
run;

title "Teste de Homogeneidade (Qui-Quadrado) - Nacionalidade x Dia";
proc print data=quiquad noobs label;
run;
title;

ods text = 'Com base no Teste de Homogeneidade (Qui-Quadrado), o valor de p obtido (p = 0,72) indica que 
não há evidências estatisticamente significativas de diferença na distribuição das nacionalidades de veículos 
entre quarta e quinta-feira. Ou seja, o perfil de origem dos automóveis manteve-se homogêneo entre os dois dias de coleta.';

ods text = 'Observa-se também que cerca de 60% das observações correspondem a vagas sem automóvel, 
o que pode reduzir a potência do teste e aumentar a proporção de células com frequência esperada inferior a 5. 
Ainda assim, mesmo considerando essa limitação, os resultados confirmam que a variação entre os dias é mínima.';



ods text= '3.5. Estimativa Final e Precisão';

ods text= 'Como última análise, apresenta-se a estimativa pontual, o intervalo de confiança de 95% e a 
margem de erro observada, comparando-a com a margem de erro planejada (7%).';



/*Conclusão*/
ods text = 'Conclusão';


ods word close;
