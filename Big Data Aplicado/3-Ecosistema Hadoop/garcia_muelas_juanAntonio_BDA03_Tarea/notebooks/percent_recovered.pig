-- registramos la librería PiggyBank para poder usar la función de carga CSVExcelStorage.
REGISTER piggybank.jar

-- Leemos el fichero fligths.csv
flights = LOAD '$flights_file' USING       org.apache.pig.piggybank.storage.CSVExcelStorage(',', 'NO_MULTILINE', 'UNIX', 'SKIP_INPUT_HEADER')
       AS (dayofmonth:int, dayofweek:int, carrier:chararray, 
              depairportid:chararray, arrairportid:chararray, depdelay:int, arrdelay:int);

-- Filtramos las variables por salida con retraso y vuelos recuperados.
dep_delayed_flights = FILTER flights BY depdelay > 15;
recovered_flights = FILTER flights BY depdelay > 15 AND arrdelay <= 15;

-- Agrupo por carrier y calculamos las salidas con retraso
dep_delayed_flights_grouped = GROUP dep_delayed_flights BY carrier;
dep_delayed_count = FOREACH dep_delayed_flights_grouped GENERATE
    group AS carrier,
    COUNT(dep_delayed_flights) AS dep_delayed_count;
    
-- Agrupo por carrier y calculamos los vuelos recuperados
recovered_flights_grouped = GROUP recovered_flights BY carrier;
recovered_count = FOREACH recovered_flights_grouped GENERATE
    group AS carrier,
    COUNT(recovered_flights) AS recovered_count;

-- Mostramos el esquema de la relación para que se entienda cómo funciona GROUP
DESCRIBE dep_delayed_flights_grouped;
DESCRIBE recovered_flights_grouped;

-- Unimos con JOIN depdelayed y recovered counts 
joined_counts = JOIN dep_delayed_count BY carrier, recovered_count BY carrier;

-- Renombramos campos y contamos vuelos con recuperación
-- percent_recovered = FOREACH joined_counts GENERATE
--    $0 AS carrier, (float)$2.recovered_count / (float)$1.dep_delayed_count AS percent_recovered;
-- Lo dejo comentado como recordatorio de no usar tras un JOIN. En este caso usar el operador de desambigüación.
percent_recovered = FOREACH joined_counts GENERATE
    recovered_count::carrier AS carrier,
    recovered_count/ (float)dep_delayed_count::dep_delayed_count AS percent_recovered;
                                                                                                                                                                
-- Ordenamos de forma descendente por vuelos
ordered_flights = ORDER percent_recovered BY percent_recovered DESC;

-- Limitamos a 5
limited_flights = LIMIT ordered_flights 5;

DUMP limited_flights;
