LOAD DATA 

INFILE 'clientes.txt'
INTO TABLE CLIENTES
APPEND 
FIELDS TERMINATED BY ';' 
TRAILING NULLCOLS (DNI, nombre, apellidos, calle, numero, piso, localidad,
 "codigo postal", telefono, usuario, contraseña)
