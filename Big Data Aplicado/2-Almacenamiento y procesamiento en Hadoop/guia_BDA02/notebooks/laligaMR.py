#!/usr/bin/python3

from mrjob.job import MRJob
from mrjob.step import MRStep
from datetime import datetime
    
class LaLigaMR(MRJob):
    
    SORT_VALUES = True
        
    # Mapper: En esta etapa aún no hay clave (_), el valor lo recibimos en la variable line
    def mapper_points(self, _, line):
        #Por cada línea, esta se divide en los campos que forman las columnas
        _, date, _, home_team, away_team, _, _, result, *rest = line.split(',')
        
        # Si es la cabecera no emitimos nada
        if home_team == "HomeTeam":
            return
        
        date = datetime.strptime(date, "%d/%m/%Y").strftime("%Y/%m/%d")

        if result == 'D':            
            yield home_team, (date, 1)
            yield away_team, (date, 1)
        elif result == 'H':
            yield home_team, (date, 3)
            yield away_team, (date, 0)
        else:
            yield home_team, (date, 0)
            yield away_team, (date, 3)
            
    def reducer_points(self, team, points):
        points = list(points)
        points = [p for date, p in points]
        five_latest_points = points[-5:]
        five_latest_points.reverse()
        yield None, (team, sum(points), five_latest_points)
    
    
    def reducer_classification(self, _, points):
            yield None, sorted(points, key=lambda t: t[1], reverse=True)
            
    def steps(self):
        return [
            MRStep(mapper=self.mapper_points, reducer=self.reducer_points),
            MRStep(reducer=self.reducer_classification)
        ]
         
if __name__=='__main__':
    LaLigaMR.run()
