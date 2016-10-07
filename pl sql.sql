

									PL/SQL ORACLE


	. block is defined by the keywords: 

		DECLARE 
		  -- declaracion de tipos locales, variables y subprogramas
		BEGIN
		  -- sentencias (las cuales pueden usar items declarados in la parte de declaracion)
		  EXCEPTION [opcional]
		    -- Manejador de Excepciones lanzadas en la parte ejecutable
		END

		The block is not stored in the database.

	  	Nota : un bloque que no es almacenado en la db es llamado 'anonymous block' incluso si tiene un label.
	  		   un bloque PL/SQL nombrado (un subprograma) puede ser invocado repetidamete (mas detalle despues)
	
	. PL/SQL Input and Output

		To display the output you can use the package DBMS_OUTPUT, but , you first issue the SQL*Plus 


	. variables:

		- 		  SQL data type : DATE, CHAR, NUMBER
		- PL/SQL-only data type : BOOLEAN, PLS_INTEGER
		- 	   data abstraction : Cursores, %TYPE attribute, %ROWTYPE attirbute, collections, records, object types

		DECLARE
			part_num		NUMBER(6); 		-- SQL data type
			part_name		VARCHAR2(20);	-- SQL data type
			in_stock		BOOLEAN;		-- PL/SQL-only data type
			part_price		NUMBER(4,2)		-- SQL data type
		BEGIN
			NULL;
		END;
		/

		+ asignacion de valores 

			1. operador (:=)
			2. clausule (into)
			3. pasando como un OUT o IN OUT parameter


			SQL> DECLARE -- You can assign values here
			2 wages NUMBER;
			3 hours_worked NUMBER := 40;
			4 hourly_salary NUMBER := 22.50;
			5 bonus NUMBER := 150;
			6 country VARCHAR2(128);
			7 counter NUMBER := 0;
			8 done BOOLEAN;
			9 valid_id BOOLEAN;
			10 emp_rec1 employees%ROWTYPE;
			11 emp_rec2 employees%ROWTYPE;
			12 TYPE commissions IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
			13 comm_tab commissions;
			14
			15 BEGIN -- You can assign values here too
			16 	wages := (hours_worked * hourly_salary) + bonus;
			17	country := 'France';
			18 	country := UPPER('Canada');
			19 	done := (counter > 100);
			20 	valid_id := TRUE;
			21 	emp_rec1.first_name := 'Antonio';
			22 	emp_rec1.last_name := 'Ortiz';
			23 	emp_rec1 := emp_rec2;
			24 	comm_tab(5) := 20000 * 0.15;
			25 END;
			26 /

			
			passes the new_sal variable to a subprogram, and the subprogram updates the variable.

			Example 1–5 Assigning Values to Variables as Parameters of a Subprogram

			SQL> DECLARE
			2 new_sal NUMBER(8,2);
			3 emp_id NUMBER(6) := 126;
			4
			5 PROCEDURE adjust_salary (
			6 emp_id NUMBER,
			7 sal IN OUT NUMBER
			8 ) IS
			9 emp_job VARCHAR2(10);
			10 avg_sal NUMBER(8,2);
			11 BEGIN
			12 SELECT job_id INTO emp_job
			13 FROM employees
			14 WHERE employee_id = emp_id;
			15
			16 SELECT AVG(salary) INTO avg_sal
			17 FROM employees
			18 WHERE job_id = emp_job;
			19
			20 DBMS_OUTPUT.PUT_LINE ('The average salary for '
			21 || emp_job || ' employees: ' || TO_CHAR(avg_sal) );
			25
			26 sal := (sal + avg_sal)/2;
			27 END;
			28
			29 BEGIN
			30 SELECT AVG(salary) INTO new_sal
			31 FROM employees;
			32
			33 DBMS_OUTPUT.PUT_LINE ('The average salary for all employees: ' || TO_CHAR(new_sal) );
			36
			37 adjust_salary(emp_id, new_sal);
			38 END;
			39 /
			The average salary for all employees: 6461.68
			The average salary for ST_CLERK employees: 2785
			PL/SQL procedure successfully completed.
			SQL>

	+ Declarar PL/SQL CONSTANTS

		La variable debe llevar la palabra 'CONSTANT' e inmediatamente asignar el valor a la constante.

			constant_name  CONSTANT NUMBER := 500.00;

			No se permite nuevas asignaciones a la constante.

		def. BIND VARIABLES : Son variables que se crean en SQL*Plus y son referenciadas en PL/SQL.

			- para crear una variable 'bind variable' se usa el comando 'VARIABLE'

				VARIABLE ret_val NUMBER

				se crea la variable nombrada ret_val de tipo NUMBER.

			- referenciando 'bind variable', se usa el colon (:) seguido del nombre de la variable 

				:ret_val := 1;

				para cambiar el valor en SQL*PLUS se usa un bloque PL/SQL 

					BEGIN
						:ret_val := 4;
					END;
					/

				para ver el valor de la variable se usa el comando 'PRINT'.

					print ret_val;

	+ Inicializar variables usando la palabra clave DEFAULT 

		Se pude hacer uso de 'DEFAULT' en lugar del operador de asignacion para inicializar variables.
		Use DEFAULT para variables que tienen un valor tipico. Use el operador de asignacion para 
		variables (tales como counters y accumulators) que no tienen un valor tipico.

		DECLARE
			blood_type		CHAR DEFAULT 'O'; 		-- same as blood_type CHAR := 'O';
			hours_worked	INTEGER DEFAULT 40;		-- typical value
			employee_count	INTEGER := 0;			-- No ttypical value
		BEGIN
			NULL;
		END;
		/

	+ USING %TYPE Provides the data type of a variable or database column

		v_last_name 	employees.last_name%TYPE;

		Advantages:
			1. You need not know the exact data type of the last_name.
			2. If you change the database definition of last_name, the 
				data type of v_last_name changes accordingly at run time.

	  las variables upper_name, lower_name, init_name hereda el tipo de dato y constraint
	  NOT NULL de la variable name, pero no su valor por defecto, ya que este es nuevamnete asignado

		DECLARE
			name 		VARCHAR2(20) NOT NULL := 'JoHn SmiT';
			upper_name  name%TYPE := UPPER(name);
			lower_name	name%TYPE := LOWER(name);
			init_name 	name%TYPE := INITCAP(name);
		BEGIN
		END;
		/

	+ USGIN %ROWTYPE provides a record type that represents a row in a table.

	The record can store an enteri row data selectd from the table or fetched from a cursor

		dept_rec 		departaments%ROWTYPE;  -- declare record variable

		use the dot notation to reference fields

			v_deptId := dept_rec.departament_id;

	
	+ Naming Conventions 


	Nombres deben ser simples, diciente, remoto o ambos, qualified and remote.

	. simple - procedure name only:
		
		raise_salary(employee_id, amount);

	. qualified - procedure name preceded by the name of the package that contains it 
		(esto es llamado notacion punto "dot notation")

		emp_actions.raise_salary(employee_id, amount);

	. remote - procedure name followed by the remote acess indicator (@) and a link to the db
		on which the procedure is sotred:

		raise_salary@newyork(employee_id, amount);

	. quialified and remote:

		emp_actions.raise_salary@newyork(employee_id, amount);


	Name Resolution

	In ambiguous SQL statements, the names of database columns take precedence over the names
	of local variables and formal parameters.

		Ej: Si una variable y una columna con el mismo nombre son usados en un WHERE, SQL considera 
			ambos nombres se refieren a la columna.


	Escape character

	% = wildcard (comodin)

	para hacer una busqueda literal del caracter '%' es necesario escapar el caracter.

	expresion :   LIKE '50% off!' -> puede haber cualquier tipo de caracteres entre el '50' y el ' off'
				  LIKE '50\% off!' ESCAPE '\' -> usa el '\'' para no tomar el % como comodin sino como un caracter
				   

	+ collections

	In PL/SQL, array types are known as varrays (short for variable-size array), Each kind of collection
	is an ordered group of elements, all of the same type.

	Para declarar una coleccion se usa el comando 'TYPE'.

		DECLARE
		  TYPE servId_list IS TABLE OF service.id_service%TYPE; -- definir un arreglo de tipo id_service
		  serv_ids   servId_list;                               -- Creando una variable de tipo servId_List
		  sname     service.commercial_name%TYPE;
		BEGIN
		  serv_ids := servId_list(372, 377, 395);
		  
		  FOR i IN serv_ids.FIRST..serv_ids.LAST LOOP
		  
		    SELECT commercial_name INTO sname
		    FROM service
		    WHERE id_service = serv_ids(i);
		    
		    DBMS_OUTPUT.PUT_LINE (to_char(serv_ids(i)) || ' : ' || sname);
		    
		  END LOOP;

		END;
		/


	The collection can be passed as parameters, so that subprograms can process arbitrary numbers of elements.

	(MAS EXPLICACION MAS ADELANTE)

	+ Records 

	The records are a composite data structures whose fields can have different data types.
	When declaring records, you use a TYPE definition.

		DECLARE
			TYPE timeRec IS RECORD (
				hours 		SMALLINT,
				minutes		SMALLINT
			);

			TYPE meeting_type IS RECORD (
				date_held	DATE,
				duration	timeRec,
				location	VARCAHR2(20),
				purpose		VARCHAR2(50)
			);
		BEGIN
			NULL;
		END;
		/

	+ Conditional control

	. IF - THEN - ELSE , CASE

			DECLARE
		2 		jobid employees.job_id%TYPE;
		3 		empid employees.employee_id%TYPE := 115;
		4 		sal employees.salary%TYPE;
		5 		sal_raise NUMBER(3,2);
		6 	BEGIN
		7 		SELECT job_id, salary INTO jobid, sal
		8 		FROM employees
		9 		WHERE employee_id = empid;
		10
		11 CASE
		12 		WHEN jobid = 'PU_CLERK' THEN
		13 			IF sal < 3000 THEN
		14 				sal_raise := .12;
		15 			ELSE
		16 				sal_raise := .09;
		17 			END IF;
		18
		19 		WHEN jobid = 'SH_CLERK' THEN
		20 			IF sal < 4000 THEN
		21 				sal_raise := .11;
		22 			ELSE
		23 				sal_raise := .08;
		24 			END IF;
		33 ELSE
		34 		BEGIN
		35 			DBMS_OUTPUT.PUT_LINE('No raise for this job: ' || jobid);
		36 		END;
		37 END CASE;
		38
		39 UPDATE employees
		40 SET salary = salary + salary * sal_raise
		41 WHERE employee_id = empid;
		42 END;
		43 /

	. FOR - LOOP

		BEGIN
			FOR i IN 1..100 LOOP
				-- statements
			END LOOP;
		END;

	. WHILE LOOP

		BEGIN
			WHILE sal <= 500 LOOP
				-- statements
			END LOOP;
		END;

	. EXIT WHEN

		this statement lets you complete a loop. When the EXIT statement is encountered, the 
		condition in the WHEN clause is evaluated. if the condition is TRUE, the loop completes and 
		the control passes to the next statement.

		DECLARE
			counter 	NUMBER(6) := 0;
		BEGIN
			LOOP
				counter := counter + 1;
				total := total + counter * counter;
				EXIT WHEN total > 25000;
			END LOOP;
		END;

	. CONTINUE-WHEN 

		similar to EXIT-WHEN but the statement inmediately transfers control to the next iteration
		of the loop


	. Subprograms, A PL/SQL subprogram is a named PL/SQL block tat can be invoked with a set of
	  parameters.

	DECLARE
		 in_string VARCHAR2(100) := 'Test string';
		 out_string VARCHAR2(200);

		 PROCEDURE double (
		 original IN VARCHAR2,
		 new_string OUT VARCHAR2
		 ) AS
		 BEGIN
		 	new_string := original || original;
		 END;

	 BEGIN
		 DBMS_OUTPUT.PUT_LINE ('in_string: ' || in_string);
		 double (in_string, out_string);
		 DBMS_OUTPUT.PUT_LINE ('out_string: ' || out_string);
	 END;
	 /

	  NOTA: Usando el OUT en el procedimiento se define que ese parametro sera devuelto como resultado
	  		del procedimiento.


	. PACKAGEs . Un paquete PL/SQL es un conjunto de tipos relaciones logicamente de variables, cursores,
				y subprogramas  dentro de un obejcto de base de datos llamado un package.

		Un paquete usualmente tiene 2 partes: una especificacion y un cuerpo.

		. La especificacion define la interfaz de programacion de la aplicacion.

		- Invoking a Procedure in a package

		SQL> CALL emp_actions.hire_employees (1, 'param');

			Call completed

		SQL> BEGIN
				emp_actions.fire_employees(300);
			 END;
			 /

		Invoking a packaged subprogram for the first time loads the whole package and caches it in memory, saving
		on disk I/O for subsequent invocations.

	. Embedded SQL statements

		BEGIN
			FOR someone IN (SELECT * FROM employees WHERE employee_id < 120) LOOP
				DBMS_OUTPUT.PUTLINE('First name = ' || someone.first_name || ', Last name = ' || someone.last_name);
			END LOOP;
		END;
		/




-- --------------------------------------------------------
--   Usar un Array como una tabla OPERADOR 'TABLE'
-- --------------------------------------------------------
-- crear el tipo de dato numberArray
create TYPE numberArray IS TABLE OF NUMBER ;
/
DECLARE
  scenId_array              NumberArray;
BEGIN

  select id_mno bulk collect into  scenId_array from mno;
  
  for i in 1..scenId_array.count loop
    dbms_output.put_line(scenId_array(i));
  end loop;
  
  insert into dnl_t2
   select column_value
   from table (scenId_array);

END;
/

-- ------------------------------------------------
--  Conversiones Implicitas
-- ------------------------------------------------

-- sumar un caracter a un numero
select salary, salary + '10' from employees;

-- comparar caracter con uno no numerico
select first_name from employees where hire_date = '05/02/06';

-- transformacion automatica de formato de fecha '17-JUN-03' to '17/06/03'
select * from employees where hire_date = '17-JUN-03';

-- ------------------------------------------------
--  Conversiones Explicitas
-- ------------------------------------------------

to_char(), to_number(), to_date(), to_timestamp(), ...