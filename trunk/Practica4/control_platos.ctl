LOAD DATA 

INFILE 'platos.txt'
INTO TABLE PLATOS
APPEND 
FIELDS TERMINATED BY ';' 
TRAILING NULLCOLS (restaurante, nombre, precio, descripcion, categoria)
