
	PL/SQL TRAINING


-- Hierarchical query
SELECT last_name emp, prior last_name mgr
from employees
connect by prior employee_id = manager_id;

SELECT last_name emp, prior last_name mgr
from employees
start with employee_id = 101
connect by prior employee_id = manager_id;


-- 1. Un bloque BEGIN-END, DEBE TENER algun contenido entre estas dos clausulas

	BEGIN
		null;
	END;

-- Def: Un PROCEDURE es un subprograma almacenado que sale y hace algo.
--      Un PL/SQL block nombrado que realiza una sequencia de acciones y opcional
-- 		retorna un valor o valores.
--		Usado para promover la reusabilidad y la mantenibilidad.

-- By Default, si no se especifica el tipo de modo 'IN, OUT, IN OUT' por defecto es IN

CREATE OR REPLACE PROCEDURE proName (
	p_cust_id NUMBER, p_cust_lName VARCHAR2
)
IS
...
END;
/

-- Def: Una FUNCTION, es un bloque nombrado que DEBE retornar un valor
-- 		Llamado/Invocado como parte de una expresion o usado para proporcionar un
--		valor de parametro

CREATE OR REPLACE FUNCTION tax (p_amount NUMBER)
RETURN NUMBER IS
BEGIN
	RETURN p_amount*.19;
END;
/

SQL> EXECUTE proName (param1, param2);
Jackson

SQL> EXECUTE tax(20400);
ERROR!
-- una funcion no puede ser invocada directamente, debe ser parte de una expresion
-- una forma de validar puede ser con el dbms_output.put_line que es un subprograma
-- que recibe un parametro

SQL> dbms_output.put_line(tax(20400));
1234



