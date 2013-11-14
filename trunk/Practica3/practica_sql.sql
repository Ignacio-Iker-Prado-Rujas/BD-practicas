--Practica 3 de la asignatura de Bases de Datos, Enrique Ballesteros e Iker Prado

		-- Limpiamos la base de datos
/abolish
/multiline on

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
create view empleados as
 select * from programadores
  union 
 select * from analistas;
 
create view vista1(dni) as
 select dni
 from empleados;

-- Ejercicio 2
create view vista2(dni) as
 select dni
 from (select * from programadores 
 	intersect
	select * from analistas);

-- Ejercicio 3
create view empleados_trabajando as
 select dniEmp as dni 
 from distribución
  union 
 select dniDir as dni 
 from proyectos;
 
create view vista3(dni) as 
 select dni
 from empleados 
  except 
 select * 
 from empleados_trabajando;

-- Ejercicio 4
create view proyectos_con_analistas as
 select códigoPr
 from distribución , analistas
 where dniEmp = dni;
 
create view vista4(código) as
 select código
 from proyectos
  except 
 select códigoPr 
 from proyectos_con_analistas;

-- Ejercicio 5
create view vista5(dni) as 
 select dniDir 
 from (select dniDir 
 	from proyectos 
 	 intersect 
 	select dni from analistas) 
  except 
 select dni 
 from programadores;

-- Ejercicio 6
create view vista6(descripción, nombre, horas) as
 select descripción, nombre, horas
 from proyectos, distribución, programadores 
 where dniEmp = dni and código = códigoPr;

-- Ejercicio 7
create view vista7(teléfono) as 
 select teléfono 
 from  empleados as e1, empleados as e2 
 where e1.teléfono = e2.teléfono and e1.dni <> e2.dni;

-- Ejercicio 8
create view vista8(dni) as 
 select dni 
 from analistas natural inner join programadores;

-- Ejercicio 9
create view vista9(dni, horas) as
 select dniEmp, sum(horas)
 from distribución
 group by dniEmp;

-- Ejercicio 10
create view vista10(dni, nombre, proyecto) as
 select dni, nombre, códigoPr
 from empleados left join distribución on empleados.dni=distribución.dniEmp;

-- Ejercicio 11
create view vista11(dni, nombre) as
 select dni, nombre
 from empleados
 where teléfono is null;

-- Ejercicio 12
create view media_horas_por_empleado(dniEmp, media_horas) as
 select dniEmp, avg(horas)
 from distribución
 group by dniEmp;
 
create view media_horas_por_proyecto(códigoPr, horas_por_proyecto) as
 select códigoPr, avg(horas)
 from distribución
 group by códigoPr;
 
create view media(media_total) as
  select avg(horas_por_proyecto)
  from media_horas_por_proyecto;

create view vista12(dni, número) as
 select dniEmp, media_horas
 from (select *
 	from media_horas_por_empleado, media
 	where media_horas < media_total);
 
-- Ejercicio 13

create view dni_evaristo(dniEv) as
 select dni
 from empleados
 where nombre='Evaristo';

create view pr_con_evaristo(codigosEv) as
 select códigoPr 
 from distribución, dni_evaristo
 where dniEmp = dniEv;
 
create view conEvaristo(dni_conEvaristo) as
 select dniEmp
 from distribución, pr_con_evaristo
 where códigoPr=codigosEv;
 
create view sin_evaristo(dni_sinEv) as
 select dni
 from empleados
  except
 select dni_conEvaristo
 from conEvaristo;

create view vista13(códigoPr, dni, horas) as
 select códigoPr, dniEmp, horas*1.2
 from distribución, sin_evaristo
 where dniEmp=dni_sinEv;
 
-- Ejercicio 14

create view vista14(dni) as
 select dniEmp
 from ( 	select códigoPr, dniEmp
 	from distribución
  	 division
 	select codigosEv as códigoPr
	from pr_con_evaristo);

-- Ejercicio 15

create view proy_y_emp_con_evaristo(dniEmp, códigoPr) as
 select dniEmp, códigoPr
 from (	distribución
 	 inner join 
 	pr_con_evaristo
	on distribución.códigoPr = pr_con_evaristo.codigosEv );

create view num_prs_evaristo(num_prs) as
 select count(codigosEv)
 from pr_con_evaristo;
 
create view dni_numPrsEmpleados(dni, numPrs) as
 select dniEmp, count(códigoPr)
 from proy_y_emp_con_evaristo
 group by dniEmp;
 
create view vista15(dni) as
 select dni
 from dni_numPrsEmpleados, num_prs_evaristo
 where numPrs = num_prs;
 
-- Ejercicio 16

create view vista16(dni) as
 select dniEv as dni
 from dni_evaristo
  union
 select dni
 from vista9
  union
 select dniEmp as dni
 from distribución, proyectos, vista9
 where dniDir = dni and códigoPr=código;


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
 
