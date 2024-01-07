
-- registramos la librería PiggyBank para poder usar la función de carga CSVExcelStorage.
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

-- Probamos que podemos recuperar datos.
      
-- Nos quedamos con 10 aeropuertos
AIRPORTS_10 = LIMIT AIRPORTS 10;

-- Mostramos 10 aeropuertos
DUMP AIRPORTS_10;

-- Hacemos lo mismo con los vuelos
FLIGHTS_10 = LIMIT FLIGHTS 10;
DUMP FLIGHTS_10;
