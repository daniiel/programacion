-- ---------------------------------------------------------------
--    PL / SQL  Procedural Language/ Structured Query Language
-- ---------------------------------------------------------------

SQL
 Categorizacion de las sentencias:
 . DDL (Data Definition Language)         : crear, alterar o borrar objetos (ALTER, CREATE, DROP).
 . DML (Data Manipulation Language)       : manipulacion de datos existentes (SELECT, INSERT, UPDATE, DELETE).
 . TLC (Transaction Modification Language): confirmar o restaurar transacciones (COMMIT, ROLLBACK).
 . DCL (Data control Language)            : control de acceso a la base de datos (GRANT, REVOKE).
 
PL/SQL
 DML + Manejo de variables
     + Estructuras modulares
     + sentencias de control, ciclos
     + manejo de excepciones
     
Objecto : Table, view, sequence, trigger, procedure, package, function

Conversiones de datos:
 . Explicita : to_char(), to_number(), to_date(), ....
 . Implicita : id_mno = '1' <==> id_mno = 1
    Oracle por debajo maneja todo como characters, por lo q puedo igualar 
    una columna definida como NUMERICA con un caracter ('').
     
Transaccion : Conjunto de ordenes que se ejecutan formando una unidad de trabajo,
              es decir, en forma indivisible o atomica.
              
Tabla dual : Tabla especial de una sola columna, presente en todas las bases de datos
             Oracle.
             
             select 1 + 1 from dual;
             select 1 from dual;
             select user from dual;
             select sysdate from dual;

Bloque PL/SQL : Unidad de estructura basica en los programas PL/SQL.
      Supone una mejora de rendimiento enviar todo en un bloque, que 
      sentencia por sentencia.
    

-- ---------------------------------
--  BLOQUE BEGIN-END
-- ---------------------------------

-- propiedad para activar la impresion por consola del DBMS_OUTPUT.PUT_LINE()
SET SERVEROUTPUT ON       

-- Un bloque BEGIN - END no puede realizar una consulta sin asignar el resultado a 
-- una variable
BEGIN
  SELECT * FROM EMPLOYEES;
END;
/


DECLARE
  I_ER734_INIT_DATE   number;
  I_ER734_END_DATE    number;
BEGIN
  -- SELECT .. INTO con varias variables
  select TO_CHAR(SYSDATE - 5,'YYYYMMDD'), TO_CHAR(SYSDATE - 10,'YYYYMMDD')
    into I_ER734_INIT_DATE, I_ER734_END_DATE 
  from dual;
  
  IF SQL%FOUND THEN 
    DBMS_OUTPUT.PUT_LINE('I_ER734_INIT_DATE: ' || I_ER734_INIT_DATE || ', I_ER734_END_DATE: ' || I_ER734_END_DATE);
  END IF;
  
END;
/
