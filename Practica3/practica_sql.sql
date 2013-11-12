%Practica 3 de la asignatura de Bases de Datos, Enrique Ballesteros e Iker Prado

/abolish 		-- Limpiamos la base de datos


-- Tabla de los programadores de la empresa
create table programadores(dni string primary key, nombre string, dirección string, teléfono string);
insert into programadores values('1','Jacinto','Jazmín 4','91-8888888');
insert into programadores values('2','Herminia','Rosa 4','91-7777777');
insert into programadores values('3','Calixto','Clavel 3','91-1231231');
insert into programadores values('4','Teodora','Petunia 3','91-6666666');

-- Tablas de los analistas de la empresa
create table analistas(dni string primary key, nombre string, dirección string, teléfono string);
insert into analistas values('4','Teodora','Petunia 3','91-6666666');
insert into analistas values('5','Evaristo','Luna 1','91-1111111');
insert into analistas values('6','Luciana','Júpiter 2','91-8888888');
insert into analistas values('7','Nicodemo','Plutón 3',NULL);

-- Tabla de la organizacion de los proyectos
create table distribución(códigoPr string, dniEmp string, horas int, primary key (códigoPr, dniEmp));
insert into distribución values('P1','1',10);
insert into distribución values('P1','2',40);
insert into distribución values('P1','4',5);
insert into distribución values('P2','4',10);
insert into distribución values('P3','1',10);
insert into distribución values('P3','3',40);
insert into distribución values('P3','4',5);
insert into distribución values('P3','5',30);
insert into distribución values('P4','4',20);
insert into distribución values('P4','5',10);

-- Tabla de proyectos y directores
create table proyectos(código string primary key, descripción string, dniDir string);
insert into proyectos values('P1','Nómina','4');
insert into proyectos values('P2','Contabilidad','4');
insert into proyectos values('P3','Producción','5');
insert into proyectos values('P4','Clientes','5');
insert into proyectos values('P5','Ventas','6');

-- Ejercicio 1
create view empleados as select * from programadores union select * from analistas;
create view vista1 as select dni from empleados;

-- Ejercicio 2
create view vista2 as select dni from (select * from programadores intersect select * from analistas);

-- Ejercicio 3
create view empleados_trabajando as select dniEmp as dni from distribución union select dniDir as dni from proyectos; -- En realidad no es necesario renombrar a dni, pero es mas claro
create view vista3 as select dni from empleados except select * from empleados_trabajando;

-- Ejercicio 4
create view proyectos_con_analistas as select códigoPr from distribución , analistas where dniEmp = dni;
create view vista4 as select código from proyectos except select códigoPr from proyectos_con_analistas;

-- Ejercicio 5
create view vista5 as select dniDir as dni from (select dniDir from proyectos intersect select dni from analistas) except select dni from programadores;

-- Ejercicio 6
create view vista6 as select descripción, nombre, horas from proyectos, distribución, programadores where dniEmp = dni and código = códigoPr;

-- Ejercicio 7
create view vista7 as select distinct teléfono from  empleados as e1, empleados as e2 where e1.teléfono = e2.teléfono and e1.dni <> e2.dni;

-- Ejercicio 8
create view vista8 as select dni from analistas natural inner join programadores;

-- Ejercicio 9
-- ARREGLAR!!!!! 
create view vista9 as select dniEmp, sum(horas) as horas from distribución group by dniEmp;

-- Ejercicio 10


-- Ejercicio 11


-- Ejercicio 12


-- Ejercicio 13


-- Ejercicio 14


-- Ejercicio 15


-- Ejercicio 16



select * from vista1; 
select * from vista2; 
select * from vista3; 
select * from vista4; 
select * from vista5; 
select * from vista6; 
select * from vista7; 
select * from vista8; 
select * from vista9; 
select * from vista10;
select * from vista11; 
select * from vista12; 
select * from vista13; 
select * from vista14; 
select * from vista15; 
select * from vista16; 
 
