

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

	  	Nota : un bloque que no es almacenado en la db y es llamado 'anonymous block' incluso si tiene un label.
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


			DECLARE -- You can assign values here
			  wages 				NUMBER;
			  hours_worked 			NUMBER := 40;
			  hourly_salary 		NUMBER := 22.50;
			  bonus 				NUMBER := 150;
			  country 				VARCHAR2(128);
			  counter 				NUMBER := 0;
			  done 					BOOLEAN;
			  valid_id 				BOOLEAN;
			  emp_rec1 				employees%ROWTYPE;
			  emp_rec2 				employees%ROWTYPE;
			  TYPE commissions IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
			  comm_tab commissions;
			
			 BEGIN -- You can assign values here too
			 	wages := (hours_worked * hourly_salary) + bonus;
				country := 'France';
			 	country := UPPER('Canada');
			 	done := (counter > 100);
			 	valid_id := TRUE;
			 	emp_rec1.first_name := 'Antonio';
			 	emp_rec1.last_name := 'Ortiz';
			 	emp_rec1 := emp_rec2;
			 	comm_tab(5) := 20000 * 0.15;
			 END;
			 /

			
			passes the new_sal variable to a subprogram, and the subprogram updates the variable.

			Example 1–5 Assigning Values to Variables as Parameters of a Subprogram

			DECLARE
			  new_sal NUMBER(8,2);
			  emp_id NUMBER(6) := 126;
			
			  PROCEDURE adjust_salary (
			     emp_id NUMBER,
			     sal IN OUT NUMBER
			   ) IS
			     emp_job VARCHAR2(10);
			     avg_sal NUMBER(8,2);
			   BEGIN

			     SELECT job_id INTO emp_job
			     FROM employees
			     WHERE employee_id = emp_id;
			
			     SELECT AVG(salary) INTO avg_sal
			 	 FROM employees
			 	 WHERE job_id = emp_job;
			
		 		DBMS_OUTPUT.PUT_LINE ('The average salary for '
			 	|| emp_job || ' employees: ' || TO_CHAR(avg_sal) );
			
			 	sal := (sal + avg_sal)/2;
			   END;
			
			 BEGIN
			 	SELECT AVG(salary) INTO new_sal FROM employees;
			
			 	DBMS_OUTPUT.PUT_LINE ('The average salary for all employees: ' || TO_CHAR(new_sal) );
		 		adjust_salary(emp_id, new_sal);
			END;
			/

			The average salary for all employees: 6461.68
			The average salary for ST_CLERK employees: 2785
			PL/SQL procedure successfully completed.
			

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

	+ Inicializar variables en el BODY del procedimiento

		DECLARE 
		  num_1     NUMBER;
		BEGIN
		  num_1 := TO_CHAR(SYSDATE - 5,'YYYYMMDD');
		  dbms_output.put_line('sysdate: ' || SYSDATE|| '  num_1: '||num_1);
		END;
		/

	+ USING %TYPE Provides the data type of a variable or database column

		v_last_name 	employees.last_name%TYPE;

		Advantages:
			1. You need not know the exact data type of the last_name.
			2. If you change the database definition of last_name, the 
				data type of v_last_name changes accordingly at run time.
			3. referencing items do not inherit column constraint or default values from database columns.

	  las variables upper_name, lower_name, init_name hereda el tipo de dato y constraint
	  NOT NULL de la variable name, pero no su valor por defecto, ya que este es nuevamnete asignado

		DECLARE
			name 		VARCHAR2(20) NOT NULL := 'JoHn SmiT';
			upper_name  name%TYPE := UPPER(name);
			lower_name	name%TYPE := LOWER(name);
			init_name 	name%TYPE := INITCAP(name);
		BEGIN
			NULL;
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
		 		jobid employees.job_id%TYPE;
		 		empid employees.employee_id%TYPE := 115;
		 		sal employees.salary%TYPE;
		 		sal_raise NUMBER(3,2);
		BEGIN
		 		SELECT job_id, salary INTO jobid, sal
		 		FROM employees
		 		WHERE employee_id = empid;
		
		 	CASE
		 		WHEN jobid = 'PU_CLERK' THEN
		 			IF sal < 3000 THEN
		 				sal_raise := .12;
		 			ELSE
		 				sal_raise := .09;
		 			END IF;
		
		 		WHEN jobid = 'SH_CLERK' THEN
		 			IF sal < 4000 THEN
		 				sal_raise := .11;
		 			ELSE
		 				sal_raise := .08;
		 			END IF;
			ELSE
			 	BEGIN
			 		.PUT_LINE('No raise for this job: ' || jobid);
			 	END;
			END CASE;
		
			UPDATE employees
			SET salary = salary + salary * sal_raise
			WHERE employee_id = empid;
		END;
		/

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


CHAPTER 3 

-- DATA TYPES

Table Categories of predefined PL/SQL Scalar Data Types


	Category				Description
	--------		--------------------------------------------------------------
	Numeric 		numeric values
	character 		alphanumeric values 
	BOOLEAN 		logical values
	Datetime 		Dates and times 
	Interval		Time intervals


	+ Numeric : let you sotre numeric data, represent quantities

	 	PLS_INTEGER	/ BINARY_INTEGER  signed integer in range -2,147,483,648 
	 	BINARY_INTEGER
	 	BINARY_FLOAT	simple precision IEEE 754-format
	 	BINARY_DOUBLE	doble precision IEEE 754-format
	 	NUMBER

		
		. PLS_INTEGER Y BINARY_INTEGER son tipos de datos identicos, PLS_INTEGER almacena
			enteros con signo. Su rango es -2147483648 to 2147483647, 

			PLS_INTEGER tiene las siguientes ventajas sobre el tipo NUMBER

			 - valores PLS_INTEGER requieren menos espacio.
			 - operaciones PLS_INTEGER usa hardware arithmetic, asi que las operaciones 
			   son mas rapidas que operaciones NUMBER, las cuales usan library arithmetic.

		. NUMBER tiene una precision (el numero total de digitos) y una escala (el numero de digitos 
				a la derecha del punto decimal).

			NUMBER(precision, scale);

			Para la precision, el valor maximo es 38.
			La scale determina donde ocurre el redondeo.

			Una scale negativa redondeada a la izquierda del punto decimal. Por ejemplo, un valor 
			de escala -3 redondea (34462 -> 35000)

				Nota: el redondeo siempre se hace de izq a der incluyendo las scala negativas, ademas
					  si el numero es decimal, con el redondeo se pierde la pate decimal.

					  round(15.193,-1) --> 20 xq la unidad 5 suma 1 a la decena 1 + 1 = 2.
					  round(15.193,-2) --> 0

				SUBTYPES de NUMBER

					DEC, DECIMAL or NUMBER 		Fixed-point number con precision maxima de 38 
					INT, INTEGER or SMALLINT	Enteros con maxima precision de 38
					REAL 		Numeros de punto flotante

	+ Character :  let you store alphanumeric values that represent single characters or string of characters.

		CHAR 		cadena de caracteres de longitud fija
		VARCHAR2 	cadena de caracteres de longitud variable
		RAW			binario de longitud variable 
		NCHAR 		cadena de caracteres nacional de longitud fija
		NVARCHAR2 	cadena de caracteres nacional de longitud variable
		LONG 		cadena de caracteres de longitud variable 
		ROWID 		Identificador de fila fisico, 
		UROWID 		identificador universal de fila


		- CHAR y VARCHAR2 tipos de datos de longitud fija y variable respectivamente. 
			todos los strings literales tiene tipo de dato CHAR.

			especificando items:

			 . CHAR
			 . VARCHAR2
			 . CHAR (10 CHAR)
			 . VARCHAR2 (32 BYTE)


			 comparacion de CHARs, no se tiene en cuenta la longitud de las variables

			 DECLARE
			 	last_name1 CHAR(5) := 'BELLO';
			 	last_name2 CHAR(10) := 'BELLO    ';
			 BEGIN
			 	IF last_name1 = last_name2 THEN
			 		DBMS_OUTPUT.PUTLINE('last_name1 || ' is equal to ' || last_name2')
			 	END IF;
			 END;
			 /

			BELLO is equal to BELLO
			
			PL/SQL procedure successfully completed.


			 comparacion de VARCHAR2s, para que dos variables sean iguales deben tener la misma longitud

			 DECLARE
			 	last_name1 VARCHAR2(10) := 'DOW';
			 	last_name2 VARCHAR2(10) := 'DOW    ';
			 BEGIN
			 	IF last_name1 = last_name2 THEN
			 		DBMS_OUTPUT.PUTLINE('last_name1 || ' is equal to ' || last_name2')
			 	ELSE
			 		DBMS_OUTPUT.PUTLINE('last_name1 || ' is not equal to ' || last_name2')
			 	END IF;
			 END;
			 /

			DOW is not equal to DOW


			DECLARE
			 	last_name1 VARCHAR2(5) := 'STAUB';
			 	last_name2 CHAR(10) := 'STAUB'; -- completado con espacios en blanco
			 BEGIN
			 	IF last_name1 = last_name2 THEN
			 		DBMS_OUTPUT.PUTLINE('last_name1 || ' is equal to ' || last_name2')
			 	ELSE
			 		DBMS_OUTPUT.PUTLINE('last_name1 || ' is not equal to ' || last_name2')
			 	END IF;
			 END;
			 /

			 STAUB is not equal to STAUB

		- ROWID : internamente cada db tiene un ROWID pseudocolumn. Cada rowId represents la direccion
				de almacenamiento de una fila. 

			. physical rowid identifica una fila en una tabla ordinaria.
			. logical rowid identifica una fila en un tabla index-organized

	+ DATE : Se usa para almacenar datetimes. La funcion SYSDATE retorna la fecha y hora actual.
			 Para comparar fechas iguales, hay que tener en cuenta la porcion de tiempo de la fecha,
			 para estos casos en que no se quiere tener en cuenta la hora se usa la funcion TRUNC(date_variable).

			 PL/SQL automaticamente convierte valores de caracteres en el formato de fecha por defecto a valores DATE 

			 El valor por defecto del formato esta en el parametro NLS_DATE_FORMAT.

			 	-- Consulta para saber los parametros 'configuraciones' de la base de datos
				SELECT * FROM v$nls_parameters;

				NLS_DATE_FORMAT: 	DD/MM/RR

				DECLARE 
				  fecha DATE := '11/06/90';
				BEGIN 
				  DBMS_OUTPUT.PUT_LINE('fecha: ' || to_char(fecha,'yyyy-mm-dd HH24:MI:SS'));
				END;
				/

				Procedimiento PL/SQL terminado correctamente.
				fecha: 1990-06-11 00:00:00

			DATE soporta operaciones de '+/-', PL/SQL interpreta los enteros como dias. SYSDATE + 21.

			- TIMESTAMP : extiende de DATE y almacena año, mes, dia, hora, minutos y segundos. SYSTIMESTAMP retorna 
				la hora y fecha actual con fracciones de segundo.

				TIMESTAMP(precision) 	precision un entero 0..9  por defecto es 6

				la precision refiere a la cantidad de digitos en la parte de segundos.

				NLS_TIMESTAMP_FORMAT	DD/MM/RR HH12:MI:SSXFF AM
				
				DECLARE
				  checkout TIMESTAMP(3);
				BEGIN
				  checkout := '11/06/90 04:40:50,154 AM'; -- IMPORTANTE la ',' en fracciones de segundo
				  DBMS_OUTPUT.PUT_LINE('fecha: ' || TO_CHAR(checkout));
				END;
				/

				La diferencia entre DATE y TIMESTAMP esta dada por la precision en la parte de los segundos,
				siendo TIMESTAMP capas de almacenar fracciones de segundos.

			- TIMESTAMP WITH TIME ZONE : extiende de TIMESTAMP e incluye el desplazamiento de time-zone.
				El desplazamiento de time-zone es la diferencia (en horas y minutos) entre la hora local y
				'Coordinated Universal Time' (UTC), anteriormente Greenwich Mean Time (GMT).  La sintaxis es:

					TIMESTAMP(precision) WITH TIME ZONE 

					TZR (time zone region) 
					The TZD format element is an abbreviation of the time zone region 

					PST (tzd) for US/Pacific (tzr)

					-- consulta los time-zone 
					SELECT * FROM V$TIMEZONE_NAMES;

					Dos valores con  TIMESTAMP WITH TIME ZONE son considerados identicos si representan el mismo
					instante en UTC.

					'29-AUG-2004 08:00:00 -8:00'
					'29-AUG-2004 11:00:00 -5:00'


			-- DATES AND TIMESTAMP
			create table table_dt (
			  c_id NUMBER,
			  c_dt DATE
			);

			insert into table_dt values (1,'01-01-03');
			insert into table_dt values (2, DATE '2003-01-01');
			insert into table_dt values (3, TIMESTAMP '2003-01-01 00:00:00 US/Pacific');
			insert into table_dt values (4, TO_DATE('01-JAN-2003','DD-MON-YYYY'));

			ALTER SESSION SET NLS_DATE_FORMAT='DD-MON-YYYY HH24:MI:SS';
			SELECT * FROM table_dt;

	+ Large Object LOB : Referencia objetos grandes que son almacenados separadamente de otros items,
			tales como texto, graficas, imagenes, video clips. 


	+ Definiendo Subtypes 

		DECLARE
			SUBTYPE birthDate IS DATE NOT NULL;
			SUBTYPE counter IS NATURAL;

			TYPE nameList IS TABLE OF VARCHAR2(10);
			SUBTYPE dutyRoster IS nameList;

			TYPE TimeRec IS RECORD (
				minutes	INTEGER,
				hours 	INTEGER
			);
		BEGIN
			NULL;
		END;
		/

		Subtypes pueden incrementar la confiabilidad para detectar valores fuera de rango, en el siguientes
		ejemplo se restringe el subtipo 'pinteger' a almacenar enteros en el rango -9..9. cuando el programacion
		intenta almacenar un numero fuera del rango en una variable pinteger, PL/SQL lanza una excepcion.

		DECLARE
			v_sqlerrm	VARCHAR2(64);

			SUBTYPE pinteger IS PLS_INTEGER RANGE -9..9;
			y_axis 		pinteger;

			PROCEDURE p (x IN pinteger) IS
				BEGIN
					DBMS_OUTPUT.PUT_LINE(x);
				END;
		BEGIN
			y_axis := 9;
			p(10);
		EXCEPTION
			WHEN OTHERS THEN 
			  -- Obtiene el mensaje de error
			  v_sqlerrm := SUBSTR(SQLERRM, 1, 64);
			  DBMS_OUTPUT.PUT_LINE('Error: '|| v_sqlerrm);
		END;
		/

PL/SQL Data type conversion 

  Algunas veces es necesario convertir un valor de un tipo de dato a otro. PL/SQL soporta 
  explicito e implicita convercion de tipos de datos.

  Para mejor confiabilidad y mantenibilidad, use conversion explicita. La conversion implicita
  es sensible al contexto y no siempre predecible. Conversion implicita puede ser mas lenta que 
  la conversion explicita.


  Si ud asigna un valor de una variable de un tipo a una columna de otro tipo de dato, PL/SQL
  convierte el valor de la variable al tipo de dato de la columna. Si PL/SQL no puede determinar
  cual conversion implicita es necesaria, ud va a obtener un error de compilacion. En tal caso 
  ud debe usar una conversion Explicita.


PL/SQL Control Structures.

  1. Selection 	_>  condicionales IF - ELSE 
  		Evalua una condicion, entonces ejecuta un conjunto de sentencias enlugar de otras, dependiendo
  		si la condicion es TRUE o FALSE.
  2. iteracion	_>  ciclos 	FOR LOOP, WHILE , ..
  		Ejecuta un conjunto de sentencias repetidamente, tantas veces como la condicion sea TURE.
  3. Sequencia	_>	procesamiento en serie.
  		Ejecuta las sentencias en el orden en las que aparecen.


  + IF and CASE

  	Hay 3 formas de sentencias IF : IF-THEN, IF-THEN-ELSE y IF-THEN-ELSIF.

  	El CASE es una manera compacta de evaluar un simple condicion y escoger entre muchas alternativas.
  	tiene sentido usar CASE cuando hay 3 o mas alternativas para escoger.


  		IF sales > (quota + 200) THEN
  			something....
  		END IF;

  		Si la condicion es FALSE o NULL, la condicion IF no hace nada.

  		IF sales > (quota + 200) THEN
  			something ...
  		ELSE
  			something2 ..
  		END IF;

  		- IF-THEN-ELSE Anidado

  		IF sales > (quota + 200) THEN
  			something....
  		ELSE
  			IF sales > quota THEN
  				..
  			ELSE
  			    ..
  			END IF;
  		END IF;

  		- IF-THEN_ELSIF

  		IF    sales > 5000 THEN
  			something....
  		ELSIF sales > 35000 THEN
  			...
  		ELSE
  			...
  		END IF;

  		- Extendiendo IF_THEN

  			grade := 'B';

  			IF grade = 'A' THEN
  			  DBMS_OUTPUT.PUT_LINE();
  			ELSIF grade = 'B' THEN
  				DBMS_OUTPUT.PUT_LINE();
  			ELSIF grade = 'C' THEN
  				DBMS_OUTPUT.PUT_LINE();
  			ELSIF grade = 'D' THEN
  				DBMS_OUTPUT.PUT_LINE();
  			ELSIF grade = 'E' THEN
  				DBMS_OUTPUT.PUT_LINE();
  			ELSE 
  				DBMS_OUTPUT.PUT_LINE();
  			END IF;

  		- Usando simple CASE statement

  			grade := 'B';

  			CASE grade
  				WHEN 'A' THEN DBMS_OUTPUT.PUT_LINE();
  				WHEN 'B' THEN DBMS_OUTPUT.PUT_LINE();
  				WHEN 'C' THEN DBMS_OUTPUT.PUT_LINE();
  				WHEN 'D' THEN DBMS_OUTPUT.PUT_LINE();
  				WHEN 'E' THEN DBMS_OUTPUT.PUT_LINE();
  				ELSE DBMS_OUTPUT.PUT_LINE();
  			END CASE;
  				
  		La sentencia CASE es mas legible y mas eficiente. Si se omite la clausula ELSE, PL/SQL añade
  		la clausula implicita :

  			ELSE RAISE CASE_NOT_FOUND;

  		Si la sentencia CASE no hace math con las condiciones WHEN y se omitio la clausula ELSE entonces
  		pl/SQL lanza la excepcion predefinida CASE_NOT_FOUND;

  		- Usando Searched CASE statement

  			grade := 'B';

  			CASE 
  				WHEN grade = 'A' THEN DBMS_OUTPUT.PUT_LINE();
  				WHEN grade = 'B' THEN DBMS_OUTPUT.PUT_LINE();
  				WHEN grade = 'C' THEN DBMS_OUTPUT.PUT_LINE();
  				WHEN grade = 'D' THEN DBMS_OUTPUT.PUT_LINE();
  				WHEN grade = 'E' THEN DBMS_OUTPUT.PUT_LINE();
  				ELSE DBMS_OUTPUT.PUT_LINE();
  			END CASE;

  		La condicion de busqueda se encuentra definida en la clausula WHEN, este es logicamente equivalente al
  		simple CASE statement.

  		- Capturando la excepcion en lugar de definir un ELSE

  		BEGIN
  			grade := 'B';

  			CASE 
  				WHEN grade = 'A' THEN DBMS_OUTPUT.PUT_LINE();
  				WHEN grade = 'B' THEN DBMS_OUTPUT.PUT_LINE();
  				WHEN grade = 'C' THEN DBMS_OUTPUT.PUT_LINE();
  				WHEN grade = 'D' THEN DBMS_OUTPUT.PUT_LINE();
  				WHEN grade = 'E' THEN DBMS_OUTPUT.PUT_LINE();
  				ELSE DBMS_OUTPUT.PUT_LINE();
  			END CASE;

  			EXCEPTION
  				WHEN CASE_NOT_FOUND THEN 
  					DBMS_OUTPUT.PUT_LINE('No such grade');
  		END;
  		/


  	Lineamientos para IF y CASE

  	1. evitar sentencias torpes

  		IF new_balance < minimum_balance THEN 
  			overdrawn := TRUE;
  		ELSE
  			overdrawn := FALSE;
  		END IF;

  		IF overdrawn = TRUE THEN
  		  RAISE insufficient_funds;
  		END IF;

  	2. El valor de una expresion booleana puede ser asignada directamente a una variable booleana,
  		se puede reemplazar la sentencia IF con una simple asignacion.

  		overdrawn := new_balance < minimum_balance

  	3. Una variable booleana es en si TRUE o FALSE, ud puede simplificar la condicion en el IF

  		IF overdrawn THEN ...

  	4. Cuando sea posible use la clausula ELSIF en lugar de IF anidados, el codigo sera mas facil de leer


  		IF condition1 THEN statement1;
			ELSE IF condition2 THEN statement2;
				ELSE IF condition3 THEN statement3; END IF;
			END IF;
		END IF;

		IF condition1 THEN statement1;
			ELSIF condition2 THEN statement2;
			ELSIF condition3 THEN statement3;
		END IF;

+ Controlando las iteraciones de los ciclos (LOOP, EXIT, and CONTINUE)

	sentencias loop:

		. Basic LOOP
		. WHILE LOOP
		. FOR LOOP
		. Cursor FOR LOOP

	Para salir de un loop:

		. EXIT
		. EXIT-WHEN

	Para salir de la iteracion actual de un ciclo:

		. CONTINUE
		. CONTINUE-WHEN

	Para completar un bloque antes de que llegue a su final normal, use RETURN

	- EXIT statement

		x NUMBER := 0;
	LOOP
		X := x +1

		IF x > 3 THEN
			EXIT;
		END IF;
	END LOOP;
	-- after EXIT, control resumes here

	- EXIT-WHEN

		x NUMBER := 0;
	LOOP
		X := x +1

		EXIT WHEN x > 3 ;
	END LOOP;
	-- after EXIT, control resumes here


	- CONTINUE statement 

		x NUMBER := 0;
	LOOP     -- after CONTINUE, control resumes here
		X := x +1

		IF x > 3 THEN
			CONTINUE;
		END IF;
	END LOOP;

+ Simple FOR-LOOP

	BEGIN
		FOR I IN 1..3 LOOP
			sentencia...
		END FOR;
	END;
	/

	- de atras hacia adelante con REVERSE

	BEGIN
		FOR I IN REVERSE 1..3 LOOP
			sentencia...
		END FOR;
	END;
	/

	Los limites de un ciclo pueden ser literales, variables, o expresiones, pero estos deben evaluar a Numeros

		-- limites numericos
		FOR j IN -5..5 LOOP
			NULL;
		END LOOP;

		-- variables numericas

		DECLARE
		  	first 	INTEGER := 100;
		  	last 	INTEGER := 120;
		
		FOR K IN reverse first..last LOOP
			NULL;
		END LOOP;


		-- limite literal numerico - expresion numerica
		FOR STEP IN 0..(TRUNC(first/last)*2) LOOP
			NULL;
		END LOOP;

Usando la sentencia NULL

	La sentencia NULL no hace nada excepto pasar el control a la siguiente sentencia. De NULL statement
	es una practica forma para crear 'placeholder' en un subprograma. Este permite compilar un subprograma
	y luego completar su cuerpo.

	CREATE OR REPLACE PROCEDURE p (
		emp_id 	NUMBER,
		bonus	NUMBER
	) AS

	BEGIN
		NULL;	-- placeholder
	END;
	/

	Se puede usar el NULL para indicar que se esta consiente de una posibilidad, pero que no es necesaria una accion.


	CREATE OR REPLACE FUNCTION f (a INTEGER, b INTEGER)
	AS
	BEGIN
		RETURN (a/b);
	EXCEPTION
		WHEN ZERO_DIVIDE THEN
			ROLLBACK;
		WHEN OTHERS THEN
			NULL;
	END;
	/

PL/SQL Collections y Records

	En un 'collection', los componentes internos son siempre del mismo tipo de dato, y son llamados elementos.
	Las listas y arreglos (list and arrays) son ejemplos tipicos de collections.

	En un 'record', los componentes internos pueden ser de diferentes tipos de datos, y son llamados campos.
	se pueden acceder a cada campo por su nombre. Una variable 'record' puede mantener una fila de tabla o 
	algunas columnas de una tabla row. cada campo corresponde a una columna de la tabla.


	caracteristicas de los tipos de collections.

	-------------------------------------------------------------------------------------------------------------
	Collections 			Number of 			subscript 			Dense or 				
	type 					elements 			type 				sparse
	-------------------------------------------------------------------------------------------------------------

	associative Array 		unbounded 			String or 		 	either
	(or index-by table) 						Integer

	Nested table 			unbounded 			Integer 			starts dense,
																	can become sparse


	Variable-size array 	bounded 			Integer 			always dense


	Unbounded : siginifica que teoricamente, no hay limite del numero de elementos en la coleccion. Actualmente
		hay limites, pero estos son demasiados altos.

	Dense 	  : significa que la coleccion no tiene huecos entre elementos, cada elemento entre el primero y el
		ultimo es definido y tiene un valor (puede ser NULL).

	Una coleccion que es creada en un bloque PL/SQL esta disponible solo

	- Associative array (tambien llamado un index-by table) 

		Es un conjunto de pares key-value. Cada key es unica, y es usado para localizar el correspondiente valor.
		La Key puede ser integer o string.

		Usando un key-value para la primera vez añade un par al arreglo asociado. Usando la misma key con un valor 
		diferente cambia el valor.


		DECLARE
		-- Associative array indexed by string:
		 TYPE population IS TABLE OF NUMBER -- Associative array type
		  INDEX BY VARCHAR2(64);
		 
		 city_population    population;     -- Associative array variable
		 i                  VARCHAR2(64);
		BEGIN

		 -- Add new elements to associative array:
		 city_population('Smallville')  := 2000;
		 city_population('Midland')     := 750000;
		 city_population('Megalopolis') := 1000000;

		 -- Change value associated with key 'Smallville':
		 city_population('Smallville')  := 2001;

		 -- Print associative array:
		 i := city_population.FIRST;

		 WHILE i IS NOT NULL LOOP
		   DBMS_Output.PUT_LINE  ('Population of ' || i || ' is ' || TO_CHAR(city_population(i)));
		   i := city_population.NEXT(i);
		 END LOOP;
		END;
		/


		Un associative array mantiene un conjunto de datos de un tamaño arbitrario, y se puede acceder
		a sus elementos sin conocer su posicion en el Array. Un associative array no puede ser manipulado 
		por sentencias SQL (INSERT y DELETE).

		Un associative array es destinado para almacenar datos temporales. Para hacer un associative 
		array persistente para la vida de una sesion de base de datos, hay que declara el arreglo en un 
		package, y asignarle los valores a este elemento en el package body.

		Cuando se declara un associative array que es indexado por strings, el tipo de string in la declaracion
		debe ser VARCHAR2 o un subtipo de este. Sin embargo los valores de la key pueden ser de cualquier tipo.

	- Nested Tables

		Conceptualmente un nested table es como un array unidimensional con un numero arbitrario de elementos.

		Las diferencias entre un array y una nested table son:

			- Un array tiene un numero maximo de elementos, mientras en la nested table no. El tamaño de esta 
				puede incrementar dinamicamente.
			- Un array es dense (siempre tiene todos los elementos seguidos). Una nested table es dense inicialmente
				pero puede convertirse en sparse, porque se pueden eliminar elementos de este.


Definiendo tipos Collections

	Para crear una collection, se define un tipo collection y entonces se declara la variable de este tipo.

	Se crea el tipo de dato con la sentencia CREATE TYPE. Un type creado dentro de un bloque PL/SQL es 
	disponible solo dentro del bloque.

	Se puede definir una TABLA o VARRAY tipo en la parte de declaraciones de cualquier bloque PL/SQL, subprogram
	o package usando 'TYPE' definition.

	- declarando Nested tables, varrays y associative array
		
		DECLARE
			TYPE nested_type IS TABLE OF VARCHAR2(30);
			TYPE varray_type IS VARRAY(5) OF INTEGER;
			TYPE assoc_array_num_type
			IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
			TYPE assoc_array_str_type
			IS TABLE OF VARCHAR2(32) INDEX BY PLS_INTEGER;
			TYPE assoc_array_str_type2
			IS TABLE OF VARCHAR2(32) INDEX BY VARCHAR2(64);
			v1 nested_type;
			v2 varray_type;
			v3 assoc_array_num_type;
			v4 assoc_array_str_type;
			v5 assoc_array_str_type2;
		BEGIN
			-- an arbitrary number of strings can be inserted v1
			v1 := nested_type('Shipping','Sales','Finance','Payroll');
			v2 := varray_type(1, 2, 3, 4, 5); -- Up to 5 integers
			v3(99) := 10; -- Just start assigning to elements
			v3(7) := 100; -- Subscripts can be any integer values
			v4(42) := 'Smith'; -- Just start assigning to elements
			v4(54) := 'Jones'; -- Subscripts can be any integer values
			v5('Canada') := 'North America';
			-- Just start assigning to elements
			v5('Greece') := 'Europe';
			-- Subscripts can be string values
		END;
		/

		--declaring a procedure parameter as a nested table
		CREATE PACKAGE personnel AS
			TYPE staff_list 	IS TABLE OF employees.employee.id%TYPE;
			PROCEDURE award_bonuses (emp_buenos IN staff_list);
		END personnel;
		/

		CREATE PACKAGE BODY personnel AS

			PROCEDURE award_bonuses (emp_buenos staff_list) IS 
			BEGIN
				FOR i IN emp_buenos.FIRST..emp_buenos.LAST LOOP
					UPDATE employees SET salary = salary + 100
					WHERE employees.employee_id = emp_buenos(i);
				END LOOP;
			END;
		END;
		/

		Para invocar el procedimiento 'personnel.award_bonuses' desde afuera del package, se debe declarar
		una variable de tipo 'personnel.staff_list' y pasar la variable como el parametro.


		-- invocando el procedimiento pasandole como parametro una nested table
		DECLARE
			good_emp 	personnel.staff_list;
		BEGIN
			good_emp := personnel.staff_list(100, 104, 108);
			personnel.award_bonuses (good_emp);
		END;
		/