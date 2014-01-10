--BD- PRACTICA 5, ENRIQUE BALLESTEROS HORCAJO, IGNACIO IKER PRADO RUJAS
--APARTADO 1:

create or replace 
PROCEDURE PEDIDOS_CLIENTE (DNI_CLIENTE CLIENTES.DNI%TYPE) 
IS 
  cDNI         CLIENTES.DNI%TYPE;
  cNombre      CLIENTES.NOMBRE%TYPE;
  cApellidos   CLIENTES.APELLIDOS%TYPE;
  cCalle       CLIENTES.CALLE%TYPE;
  cNumero      CLIENTES.NUMERO%TYPE;
  cPiso        CLIENTES.PISO%TYPE;
  cLocalidad   CLIENTES.LOCALIDAD%TYPE;
  cPostal      CLIENTES."codigo postal"%TYPE;
  cTelefono    CLIENTES.TELEFONO%TYPE;
  suma_importes NUMBER(12, 2) := 0;
  num_pedidos NUMBER := 0;
  CURSOR cursorPedidos IS 
   SELECT p.CODIGO, p.FECHA_HORA_PEDIDO, p.FECHA_HORA_ENTREGA, p.ESTADO, p."importe total"
   FROM PEDIDOS p
   WHERE DNI_CLIENTE = p.CLIENTE
   ORDER BY FECHA_HORA_PEDIDO ASC;
  pedidoCliente cursorPedidos%ROWTYPE;
  NO_PEDIDOS EXCEPTION;
  
  BEGIN 
  SELECT CLIENTES.DNI, CLIENTES.NOMBRE, CLIENTES.APELLIDOS, CLIENTES.CALLE, CLIENTES.NUMERO, CLIENTES.PISO, CLIENTES.LOCALIDAD, CLIENTES."codigo postal", CLIENTES.TELEFONO
  INTO cDNI, cNombre, cApellidos, cCalle, cNumero, cPiso, cLocalidad, cPostal, cTelefono
  FROM CLIENTES
  WHERE DNI_CLIENTE = CLIENTES.DNI;
  DBMS_OUTPUT.PUT_LINE('DNI: ' || cDNI || '. Nombre y apellidos: ' || cNombre || ' ' || cApellidos);
  DBMS_OUTPUT.PUT_LINE('Calle: ' || cCalle || ', Nº ' || cNumero || ', piso: ' || cPiso || ', localidad: ' ||  cLocalidad || ', CP: ' || cPostal || ', TLF: ' || cTelefono || chr(10));
  FOR pedidoCliente IN cursorPedidos LOOP
   suma_importes := suma_importes + pedidoCliente."importe total"; 
   num_pedidos := num_pedidos + 1;
   DBMS_OUTPUT.PUT_LINE('Pedido ' || NUM_PEDIDOS || ': ' || pedidoCliente.CODIGO || ', ' || pedidoCliente.FECHA_HORA_PEDIDO || ', ' || pedidoCliente.FECHA_HORA_ENTREGA || ', ' || pedidoCliente.ESTADO || ', ' || pedidoCliente."importe total"  || chr(10)); 
  END LOOP; 
  IF num_pedidos > 0 THEN 
    DBMS_OUTPUT.PUT_LINE('Suma de los importes de todos los pedidos de ' || DNI_CLIENTE || ': ' || suma_importes);
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


-----------------------------------------------------------------------------------------------------------------


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
  num_cambios NUMBER := 0;
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
    IF cContiene."precio con comision" <> precioPlato + (precioPlato * comisionPlato / 100) THEN 
      UPDATE CONTIENE SET "precio con comision" = precioPlato + (precioPlato * comisionPlato / 100) 
      WHERE CURRENT OF cursorContiene;
      num_cambios := num_cambios + 1;
      DBMS_OUTPUT.PUT_LINE('Precio con comision de ' || cContiene.PLATO || 'modificado: ' || (precioPlato + (precioPlato * comisionPlato / 100)));
    END IF;
  END LOOP; 
  IF num_cambios > 0 THEN
    DBMS_OUTPUT.PUT_LINE(chr(10) || 'Numero de filas modificadas en la tabla CONTIENE: '|| NUM_CAMBIOS);
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
      num_cambios := num_cambios + 1;
      DBMS_OUTPUT.PUT_LINE('Importe total del pedido con codigo ' || cPedidos.CODIGO || ' modificado: ' || importeTotal);
    END IF;
  END LOOP; 
  IF num_cambios > 0 THEN
    DBMS_OUTPUT.PUT_LINE(chr(10) || 'Numero de filas modificadas en la tabla PEDIDOS: '|| NUM_CAMBIOS);
  ELSE
    DBMS_OUTPUT.PUT_LINE('Ningún cambio en los datos (de la tabla PEDIDOS)');
  END IF; 
   
END; 


--Para utilizar DBMS_OUTPUT.PUT_LINE
SET SERVEROUTPUT ON SIZE 1000000
--Para probar el procedimiento
EXECUTE REVISA_PEDIDOS;