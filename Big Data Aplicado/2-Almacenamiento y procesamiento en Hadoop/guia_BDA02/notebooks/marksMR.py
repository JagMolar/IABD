#!/usr/bin/python3

from mrjob.job import MRJob
from statistics import mean
    
#Definimos una clase MrJob
class MarksMR(MRJob):
        
    # Mapper: En esta etapa aún no hay clave (_), el valor lo recibimos en la variable line
    def mapper(self, _, line):
        #Por cada línea, esta se divide en los campos que forman las columnas
        name, *marks = line.split()
        for mark in marks:            
            yield name, float(mark)
         
    #Reducer: La clave será el nombre y los valores las notas
    def reducer(self, name, marks):
        yield name, mean(marks)
        
if __name__=='__main__':
    MarksMR.run()
