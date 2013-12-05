LOAD DATA 

INFILE 'areas.txt'
INTO TABLE "Areas Cobertura"
APPEND 
FIELDS TERMINATED BY ';' 
TRAILING NULLCOLS (restaurante, "codigo postal")
