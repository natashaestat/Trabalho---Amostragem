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
ods text= '3. Análise dos resultados';

ods text= 'Com base nas amostras coletadas, esta seção apresenta a análise dos resultados obtidos.
As análises a seguir incluem: a proporção de veículos segundo a nacionalidade, a proporção de veículos
de origem chinesa por dia de coleta e, por fim, a estimação pontual e intervalar dessa proporção.';


/*Importação e tratamento dos dados*/]

proc import datafile='/home/u64059723/Natasha/Amostragem/analisar_quarta.xlsx'
  out=quarta replace dbms=xlsx;
run;

proc import datafile='/home/u64059723/Natasha/Amostragem/analisar_quinta.xlsx'
  out=quinta replace dbms=xlsx;
run;

data quarta; set quarta;
if Marca = 'Chinês' then chines = 1;
else chines=0;
run;

data quinta; set quinta;
if Marca = 'Chinês' then chines = 1;
else chines=0;
run;

data veiculos;
set quarta quinta; /*Base conjunta*/
run;


ods text= '3.1. Caracterização da Amostra';


proc freq data=veiculos;
  tables dia / nocum;
run;

proc sort data=veiculos; by dia; run;

proc freq data=veiculos;
  by dia;
  tables Marca / nocum;
run;

proc means data=veiculos mean var;
  class dia;
  var chines;
run;


proc means data=quarta mean var;
var chines;
run;

proc surveymeans data=quarta total=1125 mean var clm;
var chines;
run;


ods text= '3.2. Proporção de Veículos Chineses';

proc surveyfreq data=quarta total= 1125;
tables Marca/deff var;
run;

proc surveyfreq data=quinta total = 1125;
tables Marca /deff var;
run;


ods text= '3.3. Comparação entre os dias de coleta';

ods text= '3.4. Distribuição geral por nacionalidade';

ods text= '3.5. Estimativa final e precisão';



/*Conclusão*/
ods text = 'Conclusão';


ods word close;
