/*Trabalho - Técnicas de Amostragem */

/*--------------------------------------------------------------------------------------------------------------------------*/
/*Resultados*/
/*Importação e tratamento dos dados*/

proc import datafile = '/home/u64059723/Natasha/Amostragem/analisar_quarta.xlsx' out = quarta dbms = xlsx replace;
run;

proc import datafile = '/home/u64059723/Natasha/Amostragem/analisar_quinta.xlsx' out = quinta dbms = xlsx replace;
run;

data quarta; set quarta;
Dia = 'Quarta-feira';
if Marca = 'Chines' then chines = 1; else chines = 0;
run;

data quinta; set quinta;
Dia = 'Quinta-feira';
if Marca = 'Chines' then chines = 1; else chines = 0;
run;


data veiculos; set quarta quinta; /* Base conjunta */
run;

/*--------------------------------------------------------------------------------------------------------------------------*/
/*3.1. Caracterização da Amostra*/

/*Tamanho das amostras*/
proc freq data=veiculos noprint; 
tables Dia / out=tam_dia(drop=percent);
run;

title "Tamanho da Amostra por Dia de Coleta";
proc print data=tam_dia noobs label;
label count = "Tamanho da Amostra (n)";
run;


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

/*--------------------------------------------------------------------------------------------------------------------------*/
/*3.2. Proporção de Veículos Chineses*/

/*Proporção de Veículos Chineses por dia */
proc means data=veiculos mean var clm noprint;
class dia;
var chines;
run;

data means_dia; input Dia $12. n Média Variância IC_Inferior IC_Superior;
label Dia = "Dia da Coleta" n = "Tamanho da Amostra (n)"Média = "Proporção Estimada (p̂)"
Variância = "Variância" IC_Inferior = "Limite Inferior (95%)" IC_Superior = "Limite Superior (95%)";
datalines;
Quarta-feira 168 0.0059524 0.0059524 -0.0057992 0.0177040
Quinta-feira 168 0.0000000 0.0000000 . .
;
run;


title "Proporção de Veículos Chineses por Dia - PROC MEANS";
proc print data=means_dia noobs label;
run;
title;


/*Estimativas e Intervalos de Confiança*/

ods listing gpath='/home/u64059723/Natasha/Amostragem/';
ods graphics / imagename="ic" imagefmt=png;
ods select DomainPlot;
title "Estimativas e Intervalos de Confiança da Proporção de Veículos Chineses";
proc surveymeans data=veiculos mean stderr clm plots=domain;
var chines;
domain dia;
label chines = "Proporção de Veículos Chineses";
run;
ods graphics off;

ods graphics / imagename="distribuicao" imagefmt=png;
title "Distribuição da Variável 'Chines'";
proc sgplot data=veiculos;
histogram chines / transparency=0.3;
density chines / type=kernel;
density chines / type=normal;
xaxis label="Proporção de Veículos Chineses";
yaxis label="Percentual";
run;

ods graphics off;
title;

ods listing close;


data procmeans; input Amostra $16. n Média Variância IC95 $25.;
label Amostra = "Amostra / Domínio" n = "Tamanho da Amostra (n)" Média = "Proporção Estimada (p̂)"
Variância = "Variância" IC95 = "Intervalo de Confiança (95%)";
datalines;
Amostra Conjunta 336 0.0029760 0.0029760 (-0.0028782 , 0.00883057)
Quarta-feira     168 0.0059524 0.0059524 (-0.0057992 , 0.01770400)
Quinta-feira     168 0.0000000 0.0000000 .
;
run;

title "Proporção de Veículos Chineses por Dia - PROC SURVEYMEANS";
proc print data=procmeans noobs label;
run;
title;

/*--------------------------------------------------------------------------------------------------------------------------*/
/*3.3. Comparação entre os Dias de Coleta*/

proc freq data=veiculos noprint;
tables dia*chines / chisq expected fisher riskdiff relrisk;
run;

/*PROC PRINT dos Resultados */
/*Tabela de Contingência*/
data comp_dias; input Dia $12. Chines Nao_Chines Total;
label Dia = "Dia da Coleta" Chines = "Origem Chinesa" Nao_Chines ="Sem Origem Chinesa" Total = "Total";
datalines;
Quarta-feira 1 167 168
Quinta-feira 0 168 168
Total        1 335 336
;
run;

title "Distribuição de Veículos de Origem Chinesa por Dia de Coleta";
proc print data=comp_dias noobs label;
run;
title;

/* Estatísticas do teste de Qui-Quadrado */

data quiquad33; input Estatistica $40. Valor Probabilidade; 
label Estatistica = "Estatística do Teste" Valor = "Valor Calculado" Probabilidade = "p-valor (Prob > Chi²)";
datalines;
Qui-Quadrado de Pearson                  1.0000 0.3173
Teste Exato de Fisher                    .      0.3170
;
run;


title "Teste de Diferença de Proporções (Qui-Quadrado e Fisher) - Origem Chinesa x Dia";
proc print data=quiquad33 noobs label;
run;
title;

/*--------------------------------------------------------------------------------------------------------------------------*/
/*3.4. Distribuição Geral por Nacionalidade*/


proc freq data=veiculos noprint;
tables dia*Marca / chisq expected riskdiff relrisk;
run;


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
run;
title;


/* Estatísticas do teste de Qui-Quadrado */
data quiquad34; input Estatistica $42. Valor Probabilidade;
label Estatistica = "Estatística do Teste" Valor = "Valor Calculado" Probabilidade = "p-valor (Prob > Chi²)";
datalines;
Qui-Quadrado de Pearson                   2.8477 0.7235
Qui-Quadrado da Razão de Verossimilhança 3.2501 0.6615
Qui-Quadrado de Mantel-Haenszel           0.0909 0.7630
;
run;

title "Teste de Homogeneidade (Qui-Quadrado) - Nacionalidade x Dia";
proc print data=quiquad34 noobs label;
run;
title;
