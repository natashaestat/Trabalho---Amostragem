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

proc sort data=veiculos; by Dia;
run;

/*--------------------------------------------------------------------------------------------------------------------------*/
/*3.1. Caracterização da Amostra*/


title "Tamanho da Amostra por Dia de Coleta";
proc freq data=veiculos; 
tables Dia;
run;
title;

/*Frequência de Carros Chinês por Dia*/

proc means data=veiculos noprint;
class dia;
var chines;
output out=chines_dia sum=total_chines n=n_obs;
run;

data chines_dia; set chines_dia (where=(_TYPE_ = 1));
nao_chines = n_obs - total_chines;
porcentagem_chines = (total_chines / n_obs) * 100;
porcentagem_nao_chines = (nao_chines / n_obs) * 100;
run;

proc print data=chines_dia;
run;


ods listing gpath='/home/u64059723/Natasha/Amostragem/';

/*Gráfico Quarta-feira*/

data chines_long; set chines_dia; length tipo $20;
tipo='Chinês'; count=total_chines; pct=porcentagem_chines; output;
tipo='Não-chinês'; count=nao_chines; pct=porcentagem_nao_chines; output;
keep dia tipo count pct;
run;

ods graphics on;
ods graphics / imagename="setor_quarta" imagefmt=png;
proc gchart data=chines_long(where=(dia="Quarta-feira"));
pattern1 color=cx0B1F33;
pattern2 color=cxD0E1F9;
pie tipo / sumvar=pct percent=arrow noheading;
title "Frequência relativa de veículos chineses na Quarta-feira";
run;
quit;

ods graphics / imagename="chines_quarta" imagefmt=png;
proc sgplot data=chines_long(where=(dia='Quarta-feira'));
vbar tipo / response=count datalabel fillattrs=(color=cxD0E1F9);
yaxis label="Frequência";
xaxis label="Categoria";
title "Frequência absoluta de veículos na Quarta-feira";
run;



/*Gráfico Quinta-feira*/

ods graphics / imagename="setor_quinta" imagefmt=png;
proc gchart data=chines_long(where=(dia="Quinta-feira"));
pattern1 color=cx0B1F33;
pattern2 color=cxD0E1F9;
pie tipo / sumvar=pct percent=arrow noheading;
title "Frequência relativa de veículos chineses na Quinta-feira";
run;
quit;



ods graphics / imagename="chines_quinta" imagefmt=png;
proc sgplot data=chines_long(where=(dia='Quinta-feira'));
vbar tipo / response=count datalabel fillattrs=(color=cxD0E1F9);
yaxis label="Frequência";
xaxis label="Categoria";
title "Frequência absoluta de veículos na Quinta-feira";
run;


/*Frequência de Veículos por Marca*/
proc freq data=veiculos;
by Dia;
tables Marca / out=marcas_dia;
run;


/*Gráfico Quarta-feira*/

ods graphics / imagename="setor_marca_quarta" imagefmt=png;
proc gchart data=marcas_dia(where=(dia="Quarta-feira"));
pattern1 color=cxD0E1F9; 
pattern2 color=cx0B1F33; 
pattern3 color=cx1B365D; 
pattern4 color=cx0B1F33; 
pattern5 color=cx2B578A; 
pie marca / sumvar=percent percent=arrow noheading otherlabel="Outros";
title "Frequência relativa de veículos por nacionalidade na Quarta-feira";
run;
quit;


ods graphics / imagename="marca_quarta" imagefmt=png;
proc sgplot data=marcas_dia(where=(dia='Quarta-feira'));
vbar marca / response=count datalabel fillattrs=(color=cxD0E1F9);
title "Frequência absoluta de veículos por nacionalidade na Quarta-feira";
run;


/*Gráfico Quinta-feira*/

ods graphics / imagename="setor_marca_quinta" imagefmt=png;
proc gchart data=marcas_dia(where=(dia="Quinta-feira"));
pattern1 color=cxD0E1F9; 
pattern2 color=cx1B365D; 
pattern3 color=cx0B1F33; 
pattern4 color=cx2B578A; 
pattern5 color= cx74A9CF; 
pie marca / sumvar=percent percent=arrow noheading;
title "Frequência relativa de veículos por nacionalidade na Quinta-feira";
run;
quit;

data marcas_dia; set marcas_dia; output;
if dia='Quinta-feira' and not (Marca='Chines') then do;
Marca='Chines'; count=0; output; 
end;
run;

ods graphics / imagename="marca_quinta" imagefmt=png;
proc sgplot data=marcas_dia(where=(dia='Quinta-feira'));
vbar Marca / response=count datalabel fillattrs=(color=cxD0E1F9);
title "Frequência absoluta de veículos por nacionalidade na Quinta-feira";
run;

ods graphics off;


/*--------------------------------------------------------------------------------------------------------------------------*/
/*3.2. Proporção de Veículos Chineses*/

/*Proporção de Veículos Chineses por dia - PROC MEANS */

title "Proporção de Veículos Chineses por Dia - PROC MEANS";
proc means data=veiculos mean var clm;
class dia;
var chines;
run;
title;


/*Estimativas e Intervalos de Confiança - PROC SURVEY MEANS*/

ods graphics on;
ods graphics / imagename="ic" imagefmt=png;
ods select DomainPlot;
title "Estimativas e Intervalos de Confiança da Proporção de Veículos Chineses";
proc surveymeans data=veiculos mean var clm plots=domain;
var chines;
domain dia;
label chines = "Proporção de Veículos Chineses";
run;


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


title "Proporção de Veículos Chineses por Dia - PROC SURVEYMEANS";
proc surveymeans data=veiculos mean var clm;
var chines; 
domain dia;
run;
title;


/*--------------------------------------------------------------------------------------------------------------------------*/
/*3.3. Comparação entre os Dias de Coleta*/


/*Tabela de Contingência*/
/* Estatísticas do teste de Qui-Quadrado */

title "Distribuição de Veículos de Origem Chinesa por Dia de Coleta";
proc freq data=veiculos;
tables dia*chines / chisq expected fisher riskdiff relrisk;
run;
title;


/*--------------------------------------------------------------------------------------------------------------------------*/
/*3.4. Distribuição Geral por Nacionalidade*/


/*Tabela de Contingência*/
/* Estatísticas do teste de Qui-Quadrado */

title "Distribuição Geral de Veículos por Nacionalidade e Dia da Semana";
proc freq data=veiculos;
tables dia*Marca / chisq expected riskdiff relrisk;
run;
title;
