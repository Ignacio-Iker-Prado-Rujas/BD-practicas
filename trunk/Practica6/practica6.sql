--BD- PRACTICA 6, ENRIQUE BALLESTEROS HORCAJO, IGNACIO IKER PRADO RUJAS
--APARTADO 1:
CREATE TABLE REGISTRO_VENTAS ( 
  COD_REST NUMBER(8) PRIMARY KEY REFERENCES Restaurantes, 
  TOTAL_PEDIDOS NUMBER, 
  FECHA_ULT_PEDIDO DATE 
); 


--------------------------------------------------------------------------------------------

--APARTADO 2: 

CREATE OR REPLACE TRIGGER CONTROL_DETALLE_PEDIDOS
AFTER INSERT OR DELETE OR UPDATE ON PEDIDOS 
FOR EACH ROW 
begin 
IF INSERTING THEN
  UPDATE REGISTRO_VENTAS
  SET (SELECT TOTAL_PEDIDOS
      FROM REGISTRO_VENTAS R
      WHERE R.COD_REST = NEW_REST) = ;
  WHERE COD_REST = NEW_REST;
            NEW_REST = SELECT RESTAURANTE
                    FROM CONTIENE C, PEDIDOS P
                    WHERE C.PEDIDO = NEW.CODIGO;

  --actualizar importe total
  --mirar si es el m�s antiguo  
  --si es, actualizar fecha ult pedido pedido
  --instrucciones que se ejecutan si el trigger salt� por borrar filas 
--ELSIF INSERTING THEN 
--instrucciones que se ejecutan si el trigger salt� por insertar filas 
-- ELSE
--  TOTAL_PEDIDOS := TOTAL_PEDIDOS + 1;
--instrucciones que se ejecutan si el trigger salt� por modificar filas 
END IF 
END;

