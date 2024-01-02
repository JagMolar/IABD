#!/bin/bash
prev_name=
acc=0
n_marks=0

# Leemos línea a línea
while read line; do
    # Extraemos el nombre y la nota
    name=${line%,*}
    mark=${line#*,}
    
    # Si el nombre es igual al de la anterior línea o es la primera iteración, acumulamos suma de notas y el nº de notas
    if [ -z "$prev_name" -o "$prev_name" == "$name" ]; then                
        let n_marks++
        acc=$(($acc + $mark))
    
    # Cuando el nombre sea diferente, emitimos el nombre anterior,la nota media anterior
    else
        echo $prev_name,$(($acc/n_marks))
        acc=$mark
        n_marks=1
    fi
    prev_name=$name
done
           
# Emitimos el nombre y la nota media del último nombre
echo $prev_name,$(($acc/n_marks))
