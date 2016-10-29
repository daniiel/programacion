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
  var_num       NUMBER := 5.299999999;
BEGIN
  DBMS_OUTPUT.PUT_LINE('valor variable: ' || var_num);
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

-- ---------------------------------
--  OPERADORES
-- ---------------------------------

  '--'    doble comilla se usa para comentarios inline
  /* */   comentar multiples lineas
  ||      operador de concatenacion
  q'[]'   operador q'', permite usar apostrofes dentro de un literal
  :=      operador de asignacion ( var := 1;)
  %       (attibute indicator)
  <>      operador relacional 'diferente'
  !=      operador relacional 'diferente'
  
-- ---------------------------------
--   Notas varias
-- ---------------------------------

1. Los nombres de los elementos de PL/SQL como CONSTANTS, VARIABLES, EXCEPTIONS,
   CURSORS VARIABLE, SUBPROGRAMS and PACKAGES, tienen una longitud maxima de 30 caracteres
   y debe iniciar con una letra
   
2. Para representar un apostrofe dentro de un string, ud puede escribir 2 comillas simples

    select 'I''m a teacher of PL/SQL and you''re a student' from dual;
    
    usando la notación --q'<>'
    
    select q'<I'm a teacher of PL/SQL and you're a student>' from dual;
    select q'[I'm a teacher of PL/SQL and you're a student]' from dual;
    select q'(I'm a teacher of PL/SQL and you're a student)' from dual;

-- -------------------------------
--   Atributos TYPE Y ROWTYPE 
-- -------------------------------

TYPE : Permite declarar una variable, constante a ser el mismo tipo de dato como
       fue declarada una columna o una variable (sin conocer de que tipo es).

ROWTYPE : proporciona un tipo de registro que representa una fila en una tabla 
        El registro puede almacenar una fila entera de adtos seleccionada de una tabla
        o de un cursor.
        NO hereda constraints.
        
Ejemplo 1. referenciando una columna

DECLARE
  v_salary   employees.salary%TYPE;
  v_name     employees.first_name%TYPE;
BEGIN
  SELECT first_name, salary INTO v_name, v_salary 
  FROM employees
  WHERE employee_id = 100;
  
  DBMS_OUTPUT.PUT_LINE('The salary of ''' || V_NAME ||''' is ' || v_salary);
END;
/


Ejemplo 2. Referenciando una variable, las variables upp_name, low_name y init_name
referencian el tipo de dato de la variable 'name' pero NO heredan su contenido.

DECLARE
  name            varchar2(45) := 'DaNiel BuiTrago';
  upp_name        name%TYPE;
  low_name        name%TYPE;
  init_name       name%TYPE;
BEGIN
  
  upp_name := UPPER(name);
  low_name := LOWER(name);
  init_name := INITCAP(name);  
  
  DBMS_OUTPUT.PUT_LINE('Variable : Valor' );
  DBMS_OUTPUT.PUT_LINE('' );
  DBMS_OUTPUT.PUT_LINE('name:      ' || name);
  DBMS_OUTPUT.PUT_LINE('upp_name:  ' || upp_name);
  DBMS_OUTPUT.PUT_LINE('low_name:  ' || low_name);
  DBMS_OUTPUT.PUT_LINE('init_name: ' || init_name);
END;
/

Ejemplo 3. Lo que NO SE PUEDE HACER es referenciar una constante, variable no nula
como en el siguiente caso, q al tratar de ejectar arroja error.

DECLARE 
  mi_num    CONSTANT varchar2(20) := '40a';
  -- var2      mi_num%TYPE;
BEGIN
  mi_num := 'dasdasdadasd';
  DBMS_OUTPUT.PUT_LINE('CONSTANT : '|| mi_num );
END;
/

DECLARE
   l_employee   employees%ROWTYPE;
BEGIN
   SELECT * INTO l_employee FROM employees
    WHERE employee_id = 138;

   DBMS_OUTPUT.put_line (l_employee.last_name);
END; 
/


-- ----------------------------------------
--  EXCEPTIONS
-- ----------------------------------------


DECLARE
  var1    VARCHAR2(60);
  
BEGIN
  SELECT last_name into var1 FROM employees WHERE employee_id = 99;
  dbms_output.put_line('LAST NAME: '|| var1);
END;
/


-- La clausula UPDATE no genera una exception cuando no encuentra datos,
-- mientras el SELECT si.
BEGIN
  UPDATE employees set last_name = 'daniel'  WHERE employee_id = 99;
EXCEPTION
  WHEN NO_DATA_FOUND THEN 
    dbms_output.put_line('Excepcion capturada! '); -- Nunca se va a ejecutar
END;


BEGIN
  UPDATE employees set last_name = 'daniel'  WHERE employee_id = 99;
  IF SQL%ROWCOUNT = 0 THEN
    dbms_output.put_line('Excepcion capturada! '); 
  END IF;
END;
/


