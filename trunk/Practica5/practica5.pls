--BD- PRACTICA 6, ENRIQUE BALLESTEROS HORCAJO, IGNACIO IKER PRADO RUJAS
--Dudas: 1) Comision suma o porcentaje?
		 2) If vs excepciones
		 3) Minusculas en el apartado 1
		 4) Bloque anonimo? Todo en un fichero?
--APARTADO 1:

create or replace 
PROCEDURE PEDIDOS_CLIENTE (DNI_CLIENTE CLIENTES.DNI%TYPE) 
IS 
  c_DNI         CLIENTES.DNI%TYPE;
  c_NOMBRE      CLIENTES.NOMBRE%TYPE;
  c_APELLIDOS   CLIENTES.APELLIDOS%TYPE;
  c_CALLE       CLIENTES.CALLE%TYPE;
  c_NUMERO      CLIENTES.NUMERO%TYPE;
  c_PISO        CLIENTES.PISO%TYPE;
  c_LOCALIDAD   CLIENTES.LOCALIDAD%TYPE;
  c_POSTAL      CLIENTES."codigo postal"%TYPE;
  c_TELEFONO    CLIENTES.TELEFONO%TYPE;
  SUMA_IMPORTES NUMBER(12, 2) := 0;
  NUM_PEDIDOS NUMBER := 0;
  CURSOR cursorPedidos IS 
   SELECT p.CODIGO, p.FECHA_HORA_PEDIDO, p.FECHA_HORA_ENTREGA, p.ESTADO, p."importe total"
   FROM PEDIDOS p
   WHERE DNI_CLIENTE = p.CLIENTE
   ORDER BY FECHA_HORA_PEDIDO ASC;
  pedidoCliente cursorPedidos%ROWTYPE;
  NO_DNI EXCEPTION;
  NO_PEDIDOS EXCEPTION;
  
  BEGIN 
  SELECT CLIENTES.DNI, CLIENTES.NOMBRE, CLIENTES.APELLIDOS, CLIENTES.CALLE, CLIENTES.NUMERO, CLIENTES.PISO, CLIENTES.LOCALIDAD, CLIENTES."codigo postal", CLIENTES.TELEFONO
  INTO c_DNI, c_NOMBRE, c_APELLIDOS, c_CALLE, c_NUMERO, c_PISO, c_LOCALIDAD, c_POSTAL, c_TELEFONO
  FROM CLIENTES
  WHERE DNI_CLIENTE = CLIENTES.DNI;
  DBMS_OUTPUT.PUT_LINE(c_DNI || ', ' || c_NOMBRE || ', ' || c_APELLIDOS || ', ' || c_CALLE || ', ' || c_NUMERO || ', ' || c_PISO || ', ' ||  c_LOCALIDAD || ', ' || c_POSTAL || ', ' || c_TELEFONO);
  FOR pedidoCliente IN cursorPedidos LOOP
   SUMA_IMPORTES := SUMA_IMPORTES + pedidoCliente."importe total"; 
   NUM_PEDIDOS := NUM_PEDIDOS + 1;
   DBMS_OUTPUT.PUT_LINE('Pedido ' || NUM_PEDIDOS || ': ' || pedidoCliente.CODIGO || ', ' || pedidoCliente.FECHA_HORA_PEDIDO || ', ' || pedidoCliente.FECHA_HORA_ENTREGA || ', ' || pedidoCliente.ESTADO || ', ' || pedidoCliente."importe total"  || chr(10)); 
  END LOOP; 
  IF NUM_PEDIDOS > 0 THEN 
    DBMS_OUTPUT.PUT_LINE('Suma de los importes de todos los pedidos de ' || DNI_CLIENTE || ': ' || SUMA_IMPORTES);
  ELSE 
    RAISE NO_PEDIDOS; 
  END IF;
  
  EXCEPTION 
    WHEN NO_DATA_FOUND THEN 
      DBMS_OUTPUT.PUT_LINE('Error: ' || DNI_CLIENTE || ' no aparece en la tabla de CLIENTES.');
    WHEN NO_PEDIDOS THEN 
      DBMS_OUTPUT.PUT_LINE('Error: el cliente con DNI ' || DNI_CLIENTE || ' no ha realizado pedidos.');
END; 


--Para utilizar DBMS_OUTPUT.PUT_LINE
SET SERVEROUTPUT ON SIZE 1000000
--Para probar el procedimiento
EXECUTE PEDIDOS_CLIENTE('12345678N');


--_______________________________________________________________________________________________
--APARTADO 2:

  create or replace 
PROCEDURE REVISA_PEDIDOS
IS 
  CURSOR cursorContiene IS 
   SELECT *
   FROM CONTIENE
   FOR UPDATE OF "precio con comision" NOWAIT;
  cContiene cursorContiene%ROWTYPE;
  precioPlato PLATOS.PRECIO%TYPE;
  comisionPlato RESTAURANTES.COMISION%TYPE;
  NUM_CAMBIOS NUMBER := 0;
  CURSOR cursorPedidos IS 
   SELECT *
   FROM PEDIDOS
   FOR UPDATE OF "importe total" NOWAIT;
  cPedidos cursorContiene%ROWTYPE;
  importeTotal PEDIDOS."importe total"%TYPE;
  
  BEGIN 
  --Primera parte: comprobacion del precio con comision de la tabla CONTIENE
  DBMS_OUTPUT.PUT_LINE(chr(10) || 'APARTADO 1: ' || chr(10));
  FOR cContiene IN cursorContiene LOOP
    SELECT p.PRECIO 
      INTO precioPlato 
      FROM PLATOS p 
      WHERE cContiene.PLATO = p.NOMBRE;
    SELECT r.COMISION 
      INTO comisionPlato 
      FROM RESTAURANTES r
      WHERE cContiene.RESTAURANTE = r.CODIGO;
    IF cContiene."precio con comision" <> precioPlato + comisionPlato THEN 
      UPDATE CONTIENE SET "precio con comision" = precioPlato + comisionPlato 
      WHERE CURRENT OF cursorContiene;
      NUM_CAMBIOS := NUM_CAMBIOS + 1;
      DBMS_OUTPUT.PUT_LINE('Precio con comision de ' || cContiene.PLATO || 'modificado: ' || (precioPlato + comisionPlato));
    END IF;
  END LOOP; 
  IF NUM_CAMBIOS > 0 THEN
    DBMS_OUTPUT.PUT_LINE('Numero de filas modificadas en la tabla CONTIENE: '|| NUM_CAMBIOS);
  ELSE
    DBMS_OUTPUT.PUT_LINE('Ningún cambio en los datos (de la tabla CONTIENE)');
  END IF;
  
  --Segunda parte: comprobacion del importe total de la tabla PEDIDOS
  DBMS_OUTPUT.PUT_LINE(chr(10) || 'APARTADO 2: ' || chr(10));
  NUM_CAMBIOS := 0;
  FOR cPedidos IN cursorPedidos LOOP
    SELECT SUM(c."precio con comision" * c.unidades)
      INTO importeTotal 
      FROM CONTIENE c
      WHERE cPedidos.CODIGO = c.PEDIDO
      GROUP BY c.PEDIDO;
    IF cPedidos."importe total" <> importeTotal THEN 
      UPDATE PEDIDOS SET "importe total" = importeTotal 
      WHERE CURRENT OF cursorPedidos;
      NUM_CAMBIOS := NUM_CAMBIOS + 1;
      DBMS_OUTPUT.PUT_LINE('Importe total del pedido con codigo ' || cPedidos.CODIGO || ' modificado: ' || importeTotal);
    END IF;
  END LOOP; 
  IF NUM_CAMBIOS > 0 THEN
    DBMS_OUTPUT.PUT_LINE('Numero de filas modificadas en la tabla PEDIDOS: '|| NUM_CAMBIOS);
  ELSE
    DBMS_OUTPUT.PUT_LINE('Ningún cambio en los datos (de la tabla PEDIDOS)');
  END IF;
  
  --EXCEPTION 
   
END; 


--Para utilizar DBMS_OUTPUT.PUT_LINE
SET SERVEROUTPUT ON SIZE 1000000
--Para probar el procedimiento
EXECUTE REVISA_PEDIDOS;