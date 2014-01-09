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
   DBMS_OUTPUT.PUT_LINE(pedidoCliente.CODIGO || ', ' || pedidoCliente.FECHA_HORA_PEDIDO || ', ' || pedidoCliente.FECHA_HORA_ENTREGA || ', ' || pedidoCliente.ESTADO || ', ' || pedidoCliente."importe total"  || chr(10)); 
  END LOOP; 
  DBMS_OUTPUT.PUT_LINE('Suma de los importes de todos los pedidos de ' || DNI_CLIENTE || ': ' || SUMA_IMPORTES);
  
  EXCEPTION 
    WHEN NO_DNI THEN 
      DBMS_OUTPUT.PUT_LINE('Error: ' || DNI_CLIENTE || ' no aparece en la tabla de CLIENTES.');
    WHEN NO_PEDIDOS THEN 
      DBMS_OUTPUT.PUT_LINE('Error: el cliente con DNI ' || DNI_CLIENTE || ' no ha realizado pedidos.');
END; 

--Para utilizar DBMS_OUTPUT.PUT_LINE
SET SERVEROUTPUT ON SIZE 1000000
--Para probar el procedimiento
EXECUTE PEDIDOS_CLIENTE('12345678N');