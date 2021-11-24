#Retorna a data atual do servidor
select curdate() as dataAtual;
select current_date() as dataAtual;

select curTime() as horaAtual;
select current_time() as horaAtual;

#Retorna a data e a hora atual do servidor
select current_timestamp() as dataHoraAtual;

#FUNÇÕES DE FORMATAÇÃO DE HORA
select time_format(curtime(), '%H') as hora;
select time_format(curtime(), '%i') as minuto;
select time_format(curtime(), '%s') as segundo;
select time_format(curtime(), '%H horas, e %i minutos') as formatoPersonalizável;
select time_format(curtime(), '%r') as formatoAMPM;
select time_format(curtime(), '%T') as formato24h;

#hour(), minute(), second()
select hour(curtime()) as horas;
select minute(curtime()) as minutos;
select second(curtime()) as segundos;

#calcula a diferença entre horas
select timediff(curtime(), '06:00:00') as diferencaHora;

#Diferença entre datas
select datediff(curdate(), '2021-11-06') as diferencaDias; 

#FUNÇÕES DE FORMATAÇÃO DE DATA
select date_format(curdate(), '%W') as diaSemana;
#Começa com domingo sendo 0
select date_format(curdate(), '%w') as numeroDiaSemana;
select date_format(curdate(), '%a') as diaSemanaAbreviado;

select date_format(curdate(), '%m') as mesNumero;
select date_format(curdate(), '%b') as mesAbreviado;
select date_format(curdate(), '%M') as mes;

select date_format(curdate(), '%d') as diaMes;
select date_format(curdate(), '%D') as diaMesPosicao;
select date_format(curdate(), '%y') as anoAbreviado;
select date_format(curdate(), '%Y') as anoInteiro;

select date_format(curdate(), '%d/%m/%Y') as dataFormatada;

#day, month(), year()
select day(curdate()) as dia;
select month(curdate()) as mes;
select year(curdate()) as ano;
select weekofyear('2021-11-24') as semanaNoAno;

select week(curdate()) as numeroDaSemana;
#segunda = 0 ... domingo = 6
select weekday('2021-11-24') as diaSemana;

#Retorna o ano e o numero da semana daquele dia
select yearweek(curdate()) as AnoESemana;

select dayofyear(curdate()) as numeroDiaAno;