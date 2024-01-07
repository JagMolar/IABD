
-- resgistramos la librería PiggyBank para poder usar la función de carga CSVExcelStorage.
REGISTER piggybank.jar

/*
Leemos el fichero de airports.csv.

Usamos el loader CSVExcelStorage indicando el delimitador (,) y que se debe excluir la cabecera.
*/

AIRPORTS = LOAD '$airports_file' USING
       org.apache.pig.piggybank.storage.CSVExcelStorage(',', 'NO_MULTILINE', 'UNIX', 'SKIP_INPUT_HEADER')
       AS (airportid:chararray, city:chararray, state:chararray, airportname:chararray);

-- Leemos el fichero fligths.csv

FLIGHTS = LOAD '$flights_file' USING
       org.apache.pig.piggybank.storage.CSVExcelStorage(',', 'NO_MULTILINE', 'UNIX', 'SKIP_INPUT_HEADER')
       AS (dayofmonth:int, dayofweek:int, carrier:chararray, 
               depairportid:chararray, arrairportid:chararray, depdelay:int, arrdelay:int);


/*
    FOREACH ... GENERATE es similar al SELECT de SQL
*/
DEPARTURES = FOREACH FLIGHTS GENERATE depairportid AS airportid;
ARRIVES    = FOREACH FLIGHTS GENERATE arrairportid AS airportid;

OPERATIONS = UNION DEPARTURES, ARRIVES;

TOTAL_OPERATIONS = GROUP OPERATIONS BY airportid;

-- Mostramos el esquema de la relación para que se entienda cómo funciona GROUP
DESCRIBE TOTAL_OPERATIONS;

-- Renombramos campos y contamos vuelos
TOTAL_OPERATIONS = FOREACH TOTAL_OPERATIONS GENERATE group AS airportid, COUNT(OPERATIONS) AS flights;

-- Ordenamos de forma descendente por vuelos
TOTAL_OPERATIONS = ORDER TOTAL_OPERATIONS BY flights DESC;

-- Limitamos a 5 aeropuertos
TOP_TOTAL_OPERATIONS = LIMIT TOTAL_OPERATIONS 5;

-- Hacemos un join con la relación de aeropuertos para obtener el nombre
TOP_TOTAL_OPERATIONS = JOIN TOP_TOTAL_OPERATIONS BY airportid, AIRPORTS BY airportid;

DESCRIBE TOP_TOTAL_OPERATIONS;

-- Seleccionamos los campos que nos interesan
TOP_TOTAL_OPERATIONS = FOREACH TOP_TOTAL_OPERATIONS GENERATE airportname, flights;

-- Volvemos a ordenar por el número de vuelos
TOP_TOTAL_OPERATIONS = ORDER TOP_TOTAL_OPERATIONS BY flights DESC;

DUMP TOP_TOTAL_OPERATIONS;
