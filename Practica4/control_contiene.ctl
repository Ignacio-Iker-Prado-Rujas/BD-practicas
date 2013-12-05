LOAD DATA 

INFILE 'contiene.txt'
INTO TABLE CONTIENE
APPEND 
FIELDS TERMINATED BY ';' 
TRAILING NULLCOLS (restaurante, plato, pedido, "precio con comision", unidades)
