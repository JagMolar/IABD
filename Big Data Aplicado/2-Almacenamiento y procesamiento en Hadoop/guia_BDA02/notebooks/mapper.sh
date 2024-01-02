#!/bin/bash

# Leemos línea a línea de la entrada estándar
while read line; do
    
    # Extraemos el nombre de la línea
    name=${line%% *}
    
    # Procesamos nota a nota
    for mark in ${line#* }; do
                  
        # para cada nota emitimos nombre,nota
        echo -e "$name,$mark"
    done    
done
