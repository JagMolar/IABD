#!/usr/bin/python3

import sys

prev_name=''
acc=0
n_marks=0

# Leemos línea a línea de la entrada estándar
for line in sys.stdin: 
    
    name, mark = line.split()
    
    # Si el nombre es igual al de la anterior línea o es la primera iteración, acumulamos la suma de notas y el nḿero de notas
    if not prev_name or prev_name == name:                
        n_marks = n_marks + 1
        acc = acc + float(mark)
    
    # Cuando el nombre sea diferente, emitimos el nombre anterior,la nota media anterior
    else:
        print(f'{prev_name}\t{acc/n_marks}')
        acc=float(mark)
        n_marks=1
    prev_name=name
           
# Emitimos el nombre y la nota media del último nombre
print(f'{prev_name}\t{acc/n_marks}')
