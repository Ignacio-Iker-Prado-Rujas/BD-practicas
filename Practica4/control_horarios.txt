LOAD DATA 

INFILE 'horarios.txt'
INTO TABLE HORARIOS
APPEND
FIELDS TERMINATED BY ';'
TRAILING NULLCOLS (restaurante, "dia semana", hora_apertura DATE 'HH24:MI', hora_cierre DATE 'HH24:MI')
