LOAD DATA 

INFILE 'restaurantes.txt'
INTO TABLE RESTAURANTES
APPEND 
FIELDS TERMINATED BY ';' 
TRAILING NULLCOLS (codigo, nombre, calle, "codigo postal", comision)
