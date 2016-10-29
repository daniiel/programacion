DECLARE
  name1     VARCHAR2(10);
  name2     CHAR(10);
BEGIN
  name1 := 'Oracle';
  name2 := 'Oracle';
  IF name1 = name2 THEN
    DBMS_OUTPUT.PUT_LINE('Las 2 variables son iguales');
  ELSE
    DBMS_OUTPUT.PUT_LINE('Las 2 variables son diferentes');
  END IF;
END;
/

-- 1. Que imprime el anterior bloque PL/SQL ? 
-- a. Iguales         b. Diferentes       c. error

DECLARE
  v_salary   employees.salary%TYPE;
  v_name     employees.first_name%TYPE;
BEGIN
  SELECT first_name, salary INTO v_name v_salary 
  FROM employees;
  
  DBMS_OUTPUT.PUT_LINE('The salary of ''' || V_NAME ||''' is ' || v_salary);
END;
/

-- 2. Cuales son los errores en el codigo anterior ?
-- a.__________________________________________
-- b.__________________________________________
-- c.__________________________________________
-- d. No hay errores 

select 1 + 1 from dual;
select 1 from dual;
select sysdate from dual;

-- 3. Cuales sentencia ejecutan correctamente
-- a. 1 y 2   b. 2 y 3   c. solo 3   d. todas las anteriores

DECLARE
  num1    NUMBER(9,2) := 1234567.123456;
BEGIN
  DBMS_OUTPUT.PUT_LINE(num1);
END;
/

-- 4. Que valor se imprime?
-- a. 1234567.12    b. 1234567.13   c. error


DECLARE
  num1    NUMBER(14,4) := 1234567.123456;
BEGIN
  DBMS_OUTPUT.PUT_LINE(num1);
END;
/

-- 5. Que valor se imprime?
-- a. 1234567.1234    b. 1234567.1235   c. error


select 'Smiths'' from dual;

-- 6. El resultado de la consulta es?
-- a. Smiths'   b. Smiths   c. error







