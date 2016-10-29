ORACLE, SQL*PLUS, PL/SQL 

	@AUTOR 		: DANIEL BUITRAGO
    @VERSION 	: v.3.2.0
    			< comando , 2da opcion de uso de un comando, cambio de forma >

mostrar todo los comandos de SQL*Plus 
	
	SQL> help index;

+ Consultas con LIKE

  select * from table where atributo like 'cadena'
	
	variantes: 
		% estrella de kleene
		_ comodin para un solo caracter  
 
+ Diferencia entre count(*) y count(atributo)

	<*> especifica la cantidad de registros incluyendo los que tienen valor nulo
	<atributo> cuanta la cantidad de registros sin incluir nulos para ese atributo

+ Clausula NVL(atributo, valor a mostrar)
	
	se usa para especificar el tratamiento con los valores nulos en una consulta,
	para el ejemplo los valores nulos de b mostrara un 0.
	
	select a, nvl(b,0) from ab;
	
+ Consultar version de database

	select * from product_component_version;

+ Consultar tablas del usuario

	select table_name from user_tables;
	select table_name from all_tables where owner='';

+ Listar todos los objetos creados

	select table_name from all_tables;
	select index_name from all_indexes;
	select sequence_name from all_sequences;
	select trigger_name from all_triggers;

+ Mirar la estructura de una Tabla

	DESCRIBE <table_name> ; 
	DESC <table_name>		-- esta forma sin ";" solo aplica para oracle
	
+ Particionamiento por List

	CREATE TABLE sales_list (
  	  salesman_id NUMBER(5), 
	  salesman_name VARCHAR2(30),
	  sales_state VARCHAR2(20),
	  sales_amount NUMBER(10))
	PARTITION BY LIST(sales_state) 	(
		PARTITION sales_west VALUES('California', 'Hawaii'),
		PARTITION sales_east VALUES ('New York', 'Virginia'),
		PARTITION sales_other VALUES(DEFAULT))
	;
	
+ Consulta sobre tablas particionadas
 	
	SELECT * FROM schema.table PARTITION(part_name);

+ agregar una particion a una tabla ya particionadas
 	alter table table_name ADD PARTITION partition_name values ($ID_MNO) TABLESPACE data_aca;

+ borrar particion
    alter table table_name DROP PARTITION partition_name;

+ mover de tablespace una particion
	ALTER TABLE table_name MOVE PARTITION partition_name TABLESPACE data_aca; 

+ renombrar particion
	ALTER TABLE table_name RENAME PARTITION partition_name TO new_partition_name;

+ dividir particion
	ALTER TABLE table_name SLIP PARTITION partition_name INTO (PARTITION p1, PARTITION p2);

+ truncar particion
	ALTER TABLE table_name TRUNCATE PARTITION partition_name;

+ Crear SEQUENCE  

	CREATE SEQUENCE nombre_secuencia
	INCREMENT BY numero_incremento
	START WITH numero_por_el_que_empezara
	MAXVALUE valor_maximo | NOMAXVALUE 
	MINVALUE valor_minimo | NOMINVALUE
	CYCLE | NOCYCLE
	ORDER | NOORDER
	
	CREATE SEQUENCE s_id_mno
	START WITH     1
	INCREMENT BY   1
	NOCACHE
	NOCYCLE;
	
	CREATE SEQUENCE nombre_sequence;
	
	- variaciones 
	
		-Si se omite el MAXVALUE el valor por defecto sera 
		999999999999999999999999999
		- CACHE value significa cuantos valores de la secuencia mantendra
		en cache para un acceso mas rapido

	- Uso de las secuencias dentro de un insert. 
	
		create table clientes (
		  codigo number not null primary key, 
		  nombre varchar2(100) unique not null, 
		  cif varchar2(15) unique, 
		  fechaalta date 
		);

		insert into clientes values (nombreSecuencia.NextVal, 'AjpdSoft', sysdate);
		
	- Consultar el valor de una sequence
	
		select <sequence_name>.currval from dual;
	
	- Aumnetar el valor de la sequence 
	
		select <sequence_name>.nextval from dual;
		
+ Modificar el valor de incremento de una SEQUENCE, el valor puede ser tanto positivo
  como negativo.

	Alter sequence sequence_name increment by #;

	
	
+ TRIGGER

	CREATE OR REPLACE TRIGGER <nombreTrigger>
	[BEFORE|AFTER] [INSERT|UPDATE|DELETE] ON <table>
	FOR EACH ROW
	BEGIN
		sentencias ...
	END;
	/
	
	- Trigger con sequence
	
		CREATE OR REPLACE TRIGGER t_provider_mno
	    AFTER INSERT ON mno FOR EACH ROW
	    DECLARE
		  v_id_provider NUMBER;
		BEGIN
		   SELECT ST_ID_PROVIDER.nextval INTO v_id_provider FROM dual;

		   INSERT INTO provider (id_provider,provider_name,trigram,factor_tax,enabled)
		   VALUES (v_id_provider,:NEW.mno_name,:NEW.trigram,0,1);

		   INSERT INTO mno_provider (id_mno,id_provider)
		   VALUES (:NEW.id_mno,v_id_provider);
		 END;
		 /
		 
		 - variaciones
			Las secuencias para poder ser usadas se tiene que consultar mediante SELECT			
	
	- Si el TRIGGER es compilado con errores se pueden ver los errores con:
		
		Warning: Procedure created with compilation errors.
		
		SHOW ERRORS 

-- Consultar triggers
	select trigger_name as name , trigger_type as type,triggering_event as event, table_name, 
	status from ALL_TRIGGERS;

-- dehabilitar Trigger
	ALTER TRIGGER T_SUSCRIPTION DISABLE;

-- Ver codigo fuente de un trigger especifico
	select trigger_body from ALL_TRIGGERS where trigger_name='TDW_DMSETL';

-- Consultar los procedimientos y funciones
	SELECT DISTINCT name, type FROM ALL_SOURCE 
	WHERE OWNER = USER AND TYPE IN ('PROCEDURE','FUNCTION')ORDER BY 2;

-- Ver codigo fuente de un procedimiento
	select text from user_source where type='PROCEDURE'and name='<PROCEDURE>';

+ Cambiar formato a la fecha del sistema DATE.

	alter session set NLS_DATE_FORMAT = 'YYYY-MM-DD'
	
+ Ejecutar un fichero

	sqlplus user/pass@OSID @<ruta>
	sqlplus user/pass@OSID @/home/gxs/sql/createTables.sql

+ Guardar consulta en una variable bash

	MNO_NAME=`sqlplus -s acaadmin/acaadmin@osds<<FIN
		set pagesize 0 feedback off
		select mno_name from mno where id_mno = $ID_MNO;
		FIN`
	MNO_NAME=`echo -n $MNO_NAME`
	
+ Cargar archivos externos usando SQL-LOADER.

  Oracle ofrece la posibilidad de cargar archivos a la base de datos mediante SQL-LOADER,
  que lo que hace es crear un archivo con extension .ctl que especifica la forma de cargar
  los datos del archivo deseado a la base de datos.
  
  La estructura del archivo ctl es :

  'archivo.ctl'
		
	OPTIONS (SKIP=1, SILENT=(HEADER, FEEDBACK),ERRORS=10)
	LOAD DATA 
	INFILE '/home/datos.csv'
	INFILE '/home/datos2.csv'
	...
	INFILE '/home/datosn.csv'
	BADFILE '_INFILE_.bad'
	APPEND INTO TABLE test
	FIELDS TERMINATED BY "," OPTIONALLY ENCLOSED BY '"'
	TRAILING NULLCOLS
	(
	 ID_MNO CONSTANT 1,
	 id_provider EXPRESSION "(SELECT id_provider FROM provider WHERE lower(provider_name) = LOWER(:cp))",
	 ID_CAMPAIGN EXPRESSION "st_id_campaign.nextval",
     CAMPAIGN_NAME,
     SCENARIO_NAME BOUNDFILLER CHAR,
     ID_SCENARIO EXPRESSION "(SELECT DISTINCT ID_SCENARIO FROM SCENARIO S INNER JOIN RCA R ON (S.ID_RCA=R.ID_RCA) INNER JOIN OTA O ON (R.ID_OTA=O.ID_OTA) WHERE SCENARIO_NAME=:SCENARIO_NAME AND ID_MNO=_ID_MNO_)",
     CSTART_DATE BOUNDFILLER CHAR,
     START_DATE EXPRESSION "to_date(:CSTART_DATE,'DD-MM-YY HH24:MI')",
     CEND_DATE BOUNDFILLER CHAR,
     END_DATE EXPRESSION "to_date(:CEND_DATE,'DD-MM-YY HH24:MI')",
     BASE_NAME BOUNDFILLER CHAR,
     BASE_ID_LIST EXPRESSION "(SELECT ID_LIST from LIST WHERE ID_MNO=_ID_MNO_ AND LIST_NAME=:BASE_NAME and type_list = 'white list')",
     SMSC_MODE "NVL(:SMSC_MODE,10)",
     VALIDITY_PERIOD,
     TARGET_SIZE,
     OPT_LIST_MAND_TARGETS BOUNDFILLER CHAR,
     MANDATORY_ID_LIST EXPRESSION "(SELECT ID_LIST from LIST WHERE ID_MNO=_ID_MNO_ AND LIST_NAME=:OPT_LIST_MAND_TARGETS and type_list = 'white list')",
     TRANS_DATE TIMESTAMP  "YYYYMMDD HH24:MI:SS"
    )
	
	- OPTIONS : [SKIP=1] ignorar el 1er registro del archivo (cabecera),
	  [SILENT=(HEADER, FEEDBACK)] silencia "no muestra" el resultado del ctl
	  [ERRORS=10] permite un maximo de 10 errores en la carga de los datos, si el
	  ctl produce mas de estos errores se detiene la carga de los datos.
	- LOAD DATA  indica a SQL loader que se insertaran datos 
	- INFILE : especifica el directorio del archivo que se va a cargar.
	- BADFILE : se especifica un archivo donde se insertan las filas que no son cargadas
	  por que tienen algun error.
	- APPEND : insertar datos sin borrar los datos preexistentes
	- id, name, tel, apellido : nombre del campos de la tabla "test" para este ejemplo, el
	  orden de los atributos corresponde netamente al orden en que aparecen los datos en el
	  archivo que se quiere cargar.
	- FIELDS TERMINATED BY "," : especifico el separdor del archivo en este caso los datos 
	  estan separados por comas.
	- TRAILING NULLCOLS : completa con null los campos que no sean definidos en el ctl.
	- BOUNDFILLER : el valor de esa columna no se inserta en la tabla pero si se utiliza dentro del ctl
	- COMENTARIOS : Para colocar comentarios solo basta con usar el operador (--) 


	+ Cargar un dato timestamp dentro de un ctl

	LOAD DATA
	 INFILE 'aaa.csv'
	APPEND INTO TABLE ba
	FIELDS TERMINATED BY ','
	TRAILING NULLCOLS
	( times timestamp "YYYYMMDD HH24:MI" )


		20150701 08:03
		20150701 08:02
		20150701 15:03

		 
	+ Comando para ejecutar, 'sin necesidad de inicar el sqlplus'
		
		$FILE=archivo.ctl
		
		sqlldr acaadmin/acaadmin@osds control=archivo.ctl log=archivo.log
		sqlldr acaadmin/acaadmin@osds control=$FILE log=${FILE/.ctl/.log}
		
		si se omite el log=archivo.log, sqlldr lo creara por defecto con el mismo nombre del
		archivo ctl en la ruta donde este ejecutada la setencia.
		
+ Manejo de Tablespace

	# Asiganar un tablespace a una tabla en la creacion
	
		CREATE TABLE table_name (
			atributos,
			...
		)
		TABLESPACE tablespace_name ;
		
	# Modificar Tablespace
	
		ALTER TABLE table_name MOVE TABLESPACE tablespace_name ;
		
+ Manipular Columnas
	
	# Añadir columnas
		ALTER TABLE <table_name> ADD <column> <type_data()>;
		
	# Eliminar colummas 
		ALTER TABLE <table_name> DROP COLUMN <column>;
		
	# Cambiar el tamaño de una columna
		ALTER TABLE <table_name> MODIFY <column> <type_data()>;
		
	# Modificar valor por defecto
		ALTER TABLE <table_name> <type_data()> DEFAULT '<value>';
		
	# Modificar null una columna
		ALTER TABLE <table_name> MODIFY columna NOT NULL/NULL;
		alter table campaign_fact modify billing_code NULL;
		
	# Renombrar una columna
		ALTER TABLE <table_name> RENAME COLUMN <old_column_name> to <new_column_name>;

	# Renombrar una tabla
		ALTER TABLE <table_name> RENAME TO <new_table_name>;
		
	# Añadir restriccion de Foreign key	
		ALTER TABLE service
		add CONSTRAINT fk_service_content_type1
		   FOREIGN KEY (content_type)
		   REFERENCES content_type (content_type);

+ Crear una tabla usando el schema de otra
	
	create table <table_name> as (select * from <table_name_original>);
	truncate table <table_name>; -- elimina los datos que quedaron de la tabla original
	
+ Truncar tabla

    TRUNCATE TABLE <table_name>;

+ Truncar particion especifica
 
 	ALTER TABLE tableName TRUNCATE PARTITION partition;
  
+ Crear un Index

	CREATE INDEX index_name ON table_name (column);

	- Crear una tabla forzando el uso de un indice especifico

	CREATE TABLE a (
		colmn1 INT PRIMARY KEY USING INDEX (CREATE INDEX index_name ON a (column1))
	);


	DROP INDEX <index_name>;

+ Crear SINONIMOS
  
   CREATE [PUBLIC] SYNONYM synonym_name FOR object;

   CREATE PULBIC SYNONYM camp_fact FOR campaign_fact;

  - Las sentencias que admiten 'sinonimos' son: 
  		SELECT, AUDIT, INSERT, NOAUDIT, UPDATE, GRANT, DELETE, REVOKE, EXPLAIN PLAN,
  		COMMENT y LOCK TABLE.

+ Query date
	
	select * from campaign_dim WHERE trunc(start_date) = to_date('2013-11-06', 'YYYY-MM-DD')
	
	# consulta paginada
	
	select * from <table> where <condicion> and rownum <100;

	ALTER INDEX fk_users_Role1_idx REBUILD TABLESPACE DATA_ACA;

-- Consultar indices de una tablas

select table_owner, index_name, column_position pos, substr(column_name, 1, 30) column_name 
from all_ind_columns
where table_name = upper('campaign_fact')
order by table_owner, index_name, pos;

SELECT DISTINCT name, type FROM ALL_SOURCE 
WHERE OWNER = USER AND TYPE IN ('TRIGGER','')ORDER BY 2;

-- actualizar TIMESTAMP
update list set date_upload=to_timestamp('22-02-14 10:00:00','dd-mm-yy hh24:mi:ss') where id_list=2026;
update list set list_name='WhiteClaroPos01_25-02-14' , date_upload=to_timestamp('25-02-14 10:00:00','dd-mm-yy hh24:mi:ss') where id_list=2378;

-- Crear una primera particion.
CREATE TABLE a(I INT, J INT) tablespace  data_aca PARTITION BY LIST (I) ( PARTITION seg_tcb values (1));

-- Agrego una particion
alter table a ADD PARTITION seg_col values (2);

-- consultar particiones de una tabla 
select partition_name, high_value, TABLE_NAME, TABLESPACE_NAME from user_tab_partitions;

-- imprimir el numero de registros de un cursor
DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT);

-- Insert Select
insert into a (select * from mno where id_mno not in (12,4));

-- crear tabla con estructura de otra
create table a as select * from mno;
truncate table a;

-- crear tablas particionadas y subparticionadas
CREATE TABLE emp_sub_template (deptno NUMBER, empname VARCHAR(32), grade NUMBER)   
     PARTITION BY RANGE(deptno) SUBPARTITION BY HASH(empname)
     SUBPARTITION TEMPLATE
         (SUBPARTITION a TABLESPACE ts1,
          SUBPARTITION b TABLESPACE ts2,
          SUBPARTITION c TABLESPACE ts3,
          SUBPARTITION d TABLESPACE ts4
         )
    (PARTITION p1 VALUES LESS THAN (1000),
     PARTITION p2 VALUES LESS THAN (2000),
     PARTITION p3 VALUES LESS THAN (MAXVALUE)
 );
 
ALTER TABLE sales 
      ADD PARTITION jan96 VALUES LESS THAN ( '01-FEB-1999' )
      TABLESPACE tsx;
	  

insert into a values (to_timestamp('2014-02-12 12:27:05.955','YYYY-MM-DD HH24:MI:SS:FF'));

	
+ Modificar PRIMARY KEY
	
	ALTER TABLE <table_name> DROP PRIMARY KEY;	
	ALTER TABLE <table_name> ADD CONSTRAINT <contraint_name_pk> PRIMARY KEY (campos1,campo2,..);

exec dbms_mview.refresh( 'mv_last_succ_global', '?' );

                
select segment_name, TABLESPACE_NAME, bytes, bytes/1024/1024 EspacioMB from user_segments where segment_name in ('CAMPAIGN_FACT','DMS_ELT','SUS_ETL','MV_LAST_SUCC_BY_SRV_TRAN','MV_LAST_SUCC_GLOBAL');

select segment_name, bytes, bytes/1024/1024 EspacioMB from user_segments where TABLESPACE_NAME='DATA_ACA' ORDER BY BYTES ASC;
SELECT SUM(bytes), SUM(bytes)/1024/1024 EspacioMB from user_segments where TABLESPACE_NAME='DATA_ACA';

+ OBTENCION DE LAS SENCIAS DDL (DATA DEFINITION LANGUAGE)

select dbms_metadata.get_ddl( 'TABLE', 'CAMPAIGN_FACT') FROM DUAL;
select dbms_metadata.get_ddl( 'TABLE', 'SUSCRIPTION_FACT') FROM DUAL;
   Nota: Aqui se puede obtener no solo el ddl de las tablas sino de (TRIGGER, PROCEDURE, ..),
		lo importante es siempre colocar todo en mayusculas, sino la consulta saldra vacia.
 
 /* opciones mat view
REFRESH COMPLETE
        ON DEMAND
        START WITH TRUNC(SYSDATE + 2/24) + 22.5/24
        NEXT TRUNC(SYSDATE, 'HH24') + 4.5/24
        WITH PRIMARY KEY
  */      
-- exec dbms_mview.refresh( 'mv_last_succ_global', '?' );
/*Type of Refresh		Description
F, f 	Fast Refresh
C, c 	Complete Refresh
A 	Always perform complete refresh
? 	Use the default option
*/
    
-- Creo con una primera particion.

CREATE TABLE a(I INT, J INT) tablespace  data_aca PARTITION BY LIST (I) ( PARTITION seg_tcb values (1));


-- Agrego una particion
alter table a ADD PARTITION seg_col values (2);

-- o de una vez varias
CREATE TABLE b(I INT, J INT) tablespace  data_aca PARTITION BY LIST (I) ( PARTITION seg_tcb values (1),
PARTITION seg_col values (2),
PARTITION seg_cmo values (3)
);

+ TABLAS TEMPORALES

	En Oracle no existe el concepto de Tablas temporales tal y como se utiliza en SQL Server. 

	Lo mas parecido que existe son tablas que puedes crearlas para que los datos se borren al cerrar la sesión o al hacer COMMIT pero la tabla preserva su existencia (no se borra). 

	ON COMMIT PRESERVE ROWS (Borrar datos al cerrar 
	sesión) 

	ON COMMIT DELETE ROWS (Borrar datos al hacer COMMIT) 

	Ejm. 

	CREATE GLOBAL TEMPORARY TABLE gtt_zip ( 
	zip_code VARCHAR2(5), 
	by_user VARCHAR2(30), 
	entry_date DATE) 
	ON COMMIT PRESERVE ROWS; 

	CREATE GLOBAL TEMPORARY TABLE gtt_zip ( 
	zip_code VARCHAR2(5), 
	by_user VARCHAR2(30), 
	entry_date DATE) 
	ON COMMIT DELETE ROWS;

-- consultar dml de un objeto de la base

  select dbms_metadata.get_ddl( 'PROCEDURE', UPPER('sp_upd_montly_impacts')) FROM DUAL;

-- Configuraciones Sqlplus*

!IMPORTANTE!
set trimspool on Ayuda a que la consulta no quede con espacios al final.
  ej .:
  .sin :  set trimspool on

  573160000002				$
  573160000003				$

  .con :  set trimspool on

  573160000002$
  573160000003$

set lin[esize] numero de caracteres por linea
set pages[ize] define el tamaño de la pagina. Cuando termina vuelve a escrbir las cabeceres
set ti[me] {on/off} visualiza la hora antes del PROMPT (13:24:45 SQL >)
set timi[ng] {on/off} indica el tiempo que tardo en realizar la consulta.
set hea[ding] {on/off} elimina las cabeceras de los registros
set sqlprompt Dan>  El prompt pasa a ser de "SQL>" a  "Dan>"
set serveroutput On size 20000 activa la impresion por consola a maximo 20000 bytes
set define off deshabilita el uso del comando '&' para definir variables. Esto sirve para pdoer hacer busquedas que contengan el caracter '&'

-- Exportar consultas a un CSV SQL*PLUS
sqlplus -s acaadmin/acaadmin@osds<<FIN 1>/dev/null
	set heading off  feedback off  pagesize 0  numw 15
	SPOOL /PROCESSING/segmentation/praaca/lists/tmp/suceeded_msisdn.csv CREATE/APPEND
	select msisdn from campaign_fact c,state_dim s where id_mno = 4 and s.id_state = c.id_state and s.state = 'SUCCEEDED' and id_date between 20130315 and 20140404;
	SPOOL OFF;
	exit
FIN

  HEADING OFF NO Imprime las cabeceras
  FEEDBACK OFF Desactiva los resultados ".. 8 rows selected. .."
  PAGESIZE 0 Muestra la consulta continua y sin espacios
  TERMOUT OFF la consulta no se imprime en pantalla
  NUMW define la presicion en que se muestra los tipos de datos numericos
    1>/dev/null si el TERMOUT OFF no funciona y sigue imprimiendo en pantalla, por bash se envia la
	salida a NULL
  COLSEP ";" Define el separador de salida
 
-- Consulta de particiones
-- El nombre de la tabla debe ir en mayusculas
Select partition_name, high_value, TABLE_NAME from user_tab_partitions where table_name = 'CAMPAIGN_FACT';

-- bloques PL/SQL

set serveroutput on
begin
  DBMS_OUTPUT.put_line('!Hola mundo!');
end;
/

DECLARE
   l_employee   employees%ROWTYPE;
BEGIN
   SELECT * INTO l_employee FROM employees
    WHERE employee_id = 138;

   DBMS_OUTPUT.put_line (l_employee.last_name);
END; 


create table a (a varchar2(8),b varchar2(8));
create table b (a varchar2(8), c varchar2(8));

create or replace trigger prueba
before update of b on a for each row 
begin 

	update b set c= :NEW.a where a='aa';
end;
/

SET serveroutput ON -- IMPORTANTE!!!


CREATE OR REPLACE PROCEDURE prueba
AS
CURSOR c1 IS SELECT * from mno;
v_mno	c1%ROWTYPE;

BEGIN 
	OPEN c1;
	LOOP
		FETCH c1 INTO v_mno;
		EXIT WHEN c1%NOTFOUND;
		DBMS_OUTPUT.PUT_LINE(v_mno.id_mno || ' '||v_mno.trigram ||',' ||v_mno.project_code);
	END LOOP;
END;
/

-- Ingresar valores timestamp

create table a (a timestamp);
insert into a values (to_timestamp('2014-02-12 12:27:05.955','YYYY-MM-DD HH24:MI:SS:FF'));
 
   -- Formatos:
   
	YYYY	4-digit year
	MM		Month (01-12; JAN = 01).
	MON		Abbreviated name of month.
	MONTH	Name of month, padded with blanks to length of 9 characters.
	DD		Day of month (1-31).
	HH		Hour of day (1-12).
	HH12	Hour of day (1-12).
	HH24	Hour of day (0-23).
	MI		Minute (0-59).
	SS		Second (0-59).
	
	
-- Insertar registro con el Timestamp actual del sistema
insert into list values(3000,2,'cualquiera','cualquiera',0,CURRENT_TIMESTAMP,'white list',1,null);

-- Consultar si una tabla es foranea de otra
select owner, table_name from user_constraints 
    where R_CONSTRAINT_NAME = (select constraint_name from user_constraints where table_name = upper('&table') and constraint_type = 'P'); 

create or replace procedure cambia as
  cursor values_cursor is
  select id_provider, commercial_name, id_service from service where id_mno=4;
  v_cursor values_cursor%rowtype;
  proveedor provider.provider_name%type;
begin
  open values_cursor;
  loop
  fetch values_cursor into v_cursor;
  exit when values_cursor%NOTFOUND;
  select provider_name into proveedor from provider where id_provider = v_cursor.id_provider;
  update service set commercial_name = proveedor||' - '||v_cursor.commercial_name where id_service= v_cursor.id_service;
  end loop;
end;
/

-- -----------------------------------
-- MANEJO DE TIMEZONE 
-- -----------------------------------

-- consulta timestamp 
select cast (systimestamp at time zone 'America/Bogota' as timestamp) from dual;

-- Consulta lista de Time Zone ORACLE
SELECT DISTINCT tzname FROM V$TIMEZONE_NAMES ORDER BY 1;

select * from V$TIMEZONE_NAMES;
select * from V$TIMEZONE_NAMES where lower(TZNAME) like 'u%';
select DISTINCT(TZNAME) from V$TIMEZONE_NAMES where lower(TZNAME) like 'america%';

 -- otra alternativa
   SELECT * FROM V$TIMEZONE_NAMES; -- aparece la abreviatura
   
-- Obtener la diferencia de TIMEZONE 
SELECT TZ_OFFSET('America/bogota') FROM DUAL;

		TZ_OFFS
		-------
		-05:00

-- FUNCION CURRENT_DATE
 CURRENT_DATE devuelve la fecha actual de la zona horaria de la sesión. El valor de retorno es una fecha del calendario gregoriano.
 
 -- Mostrar la fecha actual y el timezone de la sesion actual.
 
 SELECT SESSIONTIMEZONE, CURRENT_DATE FROM DUAL;
 
		SESSIONTIMEZONE        CURRENT_D
		---------------------  ---------
		-03:00                 21-MAR-14
		
-- Alterar el time zone y obtener la fecha con ese nuevo time zone

  ALTER SESSION SET TIME_ZONE = '-5:0';
  SELECT SESSIONTIMEZONE, CURRENT_DATE FROM DUAL;
  
  
		SESSIONTIMEZONE       CURRENT_D
		--------------------- ---------
		-05:00                 21-MAR-14

ALTER SESSION SET TIME_ZONE = 'America/Sao_Paulo';
 
PL/SQL

-- simbolos Simples

	+				operacion de adicion
	-				operacion de substraccion
	*				operacion de multiplicacion
	/
	=				operador relacional
	@				indicador de acceso remoto
	;				terminador de sentencias
	
-- Simbolos			significado

	<>				operador relacinoal (diferente)
	!=				operador relacional
	||				concatenacion
	--				comentario de linea
	/*				inicio de comentario delimintado
	*/				final de comentario delimintado
	:=				asignacion
	
+ PL/SQL soporta el lenguaje de manipulacion de datos (DML)
- PL/SQL NO soporta el lenguaje de definicion de datos (DDL)
+ se puede controlar una transaccion con comandos como COMMIT, ROLLBACK, o SAVEPOINT
+ se pueden capturar las excepciones de un bloque con NO_DATA_FOUND y TOO_MANY_ROWS.


-- Configuracion de prefijos y subfijos.

	-----------------------------------------------------------------------------
	| Identifier				| Naming convention			| Example			|
	-----------------------------------------------------------------------------
	| variable					| v_name					| v_sal				|
	| constant					| c_name					| c_company_name	|
	| cursor					| name_cursor				| emp_cursor		|
	| exception					| e_name					| e_too_many		|
	| table type				| name_table_type			| amonut_table_type |
	| table 					| name_table				| countries			|
	| record type				| name_recor_type			| emp_record_type	|
	-----------------------------------------------------------------------------

-- Atributos de un cursor SQL

	SQL%ROWCOUNT		numero de filas afectadas por la sentencia SQL mas reciente
	SQL%NOTFOUND		booleano que evalua a TRUE si la declaracion SQL mas reciente no afecta alguna fila
	
	
	-- eg.
	VARIABLE rows_deleted	VARCHAR2(30)
	DECLARE
	  v_employeed_id	employees.employee_id%TYPE := 176;
	BEGIN
	  delete from employees where employee_id = v_employeed_id;
	  :rows_deleted := (SQL%ROWCOUNT||'row deleted');
	END;
	/
	
-- Sentencias IF

	IF-THEN-END IF
	IF-THEN-ELSE-END IF
	IF-THEN-ELSIF-END IF
 	
	Operadores Logicos AND, OR y NOT

	ejemplo 1.

	declare 
	  v_hola varchar(39) := 'hola';
	begin 
	  if v_hola = 'hola' or v_hola = 'chao' then 
	     DBMS_OUTPUT.PUT_LINE('true') ;
	  else 
	     DBMS_OUTPUT.PUT_LINE('false') ;
	  end if;
	END;
	/

	result : true

-- Expresion CASE

	BEGIN
		v_appraisal :=
			CASE v_grade
				WHEN 'A' THEN 'Excellent'
				WHEN 'B' THEN 'Good'
				ELSE 'No such grade'
			END;

-- Cursores con parametros

	DECLARE
		CURSOR emp_cursor (p_deptno NUMBER, p_job VARCHAR2) IS
		  select employee_id, last_name from employees where department_id = p_deptno AND job_id = p_job;
		  
	BEGIN
		OPEN emp_cursor(80,'SA_REP');
		..
		CLOSE emp_cursor;
		OPEN emp_cursor(60,'IT_PROG');
		..
	END;
	/
	
	
-- EXCEPTIONS

	EXCEPTION
	  WHEN exception1 [OR exception2 ..] THEN
		statement1;
		statement2;
		..
	  WHEN exception3 [OR exception4 ..] THEN 
	    statement1;
		statement2;
		..
	  WHEN OTHERS THEN 
	    statement1;
		statement2;
		..
	END;
	/
	
-- eg1.
 
	DECLARE 
		e_emps_renaining EXCEPTION;
	BEGIN
		delete from departments where ...
	EXCEPTION
		WHEN e_emps_renaining THEN
			DBMS_OUTPUT.PUT_LINE('no se puede eliminar dept');
	END;
	/
	
-- Funciones para atrapar exceptions

	DECLARE
	  v_error_code		NUMBER;
	  v_error_message	VARCHAR2(255);
	BEGIN
	  ..
	EXCEPTION
	  ..
	  WHEN OTHERS THEN 
	    ROLLBACK;
		v_error_code := SQLCODE;
		v_error_message := SQLERRM;
		insert into errors values (v_error_code,v_error_message);
	END;

-- Pasar multiples valores varchar a un solo parametro 


exec procedure(q'['black list','unsupported']');

los [] se pueden cambiar por dos caracteres distintos {}, <>, (), etc..

+ Uso de Hints (sugerencias)

	El uso de los hint se hace para influenciar el optimizador de oracle.
	Para la misma consulta, pueden existir distintos caminos para conseguir el mismo resultado
	por lo que el servidor es reponsable por decidir el camino para conseguir el mejor rendimiento

	El camino seguido por el servidor para la ejecucion de una consulta se denomina 'plan de ejecucion'

	cosas a tener en cuenta:

		1. si no es posible efectuar el hint, oracle lo ignorar
		2. los hints fuerzan el uso del optimizador por costes
		3. no afectan a subconsultas en la misma sentencia SQL

	SELECT /*+ HINT */ . . .

	
	/*+ ALL_ROWS */ Pone la consulta a costes y la optimiza para que consuma el menor número
	de recursos posibles.
	/*+ FIRST_ROWS */ Pone la consulta a costes la optimiza para conseguir el mejor tiempo de
	respuesta.
	/*+ CHOOSE */ Pone la consulta a costes.
	/*+ RULE */ Pone la consulta a reglas.
	/*+ INDEX( tabla índice ) */ Fuerza la utilización del índice indicado para la tabla indicada
	/*+ ORDERED */ Hace que las combinaciones de las tablas se hagan en el mismo orden en
	que aparecen en el join.


	convertir de Milisegundos a date

	select to_char(to_date('1970-01-01 00','yyyy-mm-dd hh24') + (1432044216522-18000000)/1000/60/60/24 , 'YYYY-MM-DD HH12:MI:SS am') "date" from dual;

	1432044216522	-> milisegundos (valor a cambiar)
	-18000000		-> resta de 5 horas para convertir en UTF -5 Colombia


	+ Crear una restriccion sin validacion de datos.

	crea un nuevo constraint sin importar si los datos existente cumplen o no la nueva restriccion

	ALTER TABLE SCENARIO ADD CONSTRAINT uniq_scen_rca unique(ID_SERVICE_VERSION, ID_RCA) DEFERRABLE INITIALLY DEFERRED ENABLE NOVALIDATE;
	SET CONSTRAINT uniq_scen_rca IMMEDIATE;

	+ imprimir TIMESTAMP en formato de id

	select to_number(to_char(systimestamp, 'yyyymmddhh24miss')) from dual

+ Plan de Ejecucion
  
  Explica el plan de ejecucion escogio por el optimizador de oracle para SELECT, UPDATE, INSERT y DELETE.
  Un plan de ejecucion es la secuencia de operaciones realiza oracle para correr una sentencia.

  The row source tree is the core of the execution plan. It shows the following information:

	An ordering of the tables referenced by the statement
	An access method for each table mentioned in the statement
	A join method for tables affected by join operations in the statement
	Data operations like filter, sort, or aggregation.

	sql> explain plan for select * from provider;

	Explained.

	sql> select plan_table_output
	from table(dbms_xplan.display('plan_table',null,'basic')); 

	PLAN_TABLE_OUTPUT
	--------------------------------------------------------------------------------
	Plan hash value: 4018530972

	--------------------------------------
	| Id  | Operation         | Name     |
	--------------------------------------
	|   0 | SELECT STATEMENT  |          |
	|   1 |  TABLE ACCESS FULL| PROVIDER |
	--------------------------------------

	8 rows selected.


 + acceder a la db desde otra VM (IBM).

 	sqlplus acaadmin/acaadmin@10.170.240.17:1525/osds

 -- ---------------------------
 -- Parametros database
 -- ---------------------------
	
	SELECT * FROM V$NLS_PARAMETERS;

	NLS_LANGUAGE	LATIN AMERICAN SPANISH
	NLS_TERRITORY	COLOMBIA
	NLS_CURRENCY	$
	NLS_ISO_CURRENCY	COLOMBIA
	NLS_NUMERIC_CHARACTERS	,.
	NLS_CALENDAR	GREGORIAN
	NLS_DATE_FORMAT	DD/MM/RR
	NLS_DATE_LANGUAGE	LATIN AMERICAN SPANISH
	NLS_CHARACTERSET	UTF8
	NLS_SORT	SPANISH
	NLS_TIME_FORMAT	HH12:MI:SSXFF AM
	NLS_TIMESTAMP_FORMAT	DD/MM/RR HH12:MI:SSXFF AM
	NLS_TIME_TZ_FORMAT	HH12:MI:SSXFF AM TZR
	NLS_TIMESTAMP_TZ_FORMAT	DD/MM/RR HH12:MI:SSXFF AM TZR
	NLS_DUAL_CURRENCY	$
	NLS_NCHAR_CHARACTERSET	AL16UTF16
	NLS_COMP	BINARY
	NLS_LENGTH_SEMANTICS	BYTE
	NLS_NCHAR_CONV_EXCP	FALSE


+ WITH clausula.

	La clausula puede ser procesada como una 'vista' en una sola linea <inline> o resuelta como 
	una tabla temporal.

		-- sin usar the WITH clause
		SELECT e.ename AS employee_name, dc.dept_count AS emp_dept_count
		FROM   emp e,
       		(SELECT deptno, COUNT(*) AS dept_count
        	FROM   emp
        	GROUP BY deptno) dc
		WHERE  e.deptno = dc.deptno;

		-- con WITH clause
		WITH dept_count AS (
		  SELECT deptno, COUNT(*) AS dept_count
		  FROM   emp
		  GROUP BY deptno)
		SELECT e.ename AS employee_name,
		       dc.dept_count AS emp_dept_count
		FROM   emp e,
		       dept_count dc
		WHERE  e.deptno = dc.deptno;


+ Comando DEFINE y UNDEFINE

sirve para declara una variable mientras la session esta activa, esto se usa en conjunto con substitucion de variables

	DEFINE employee_num = 200

	SELECT employee_id, last_name 
	FROM employees
	WHERE employee_id = &employee_num;

	UNDEFINE

En el ejemplo anterior se define una variable employee_num que se usa en el momento del select y automaticamente oracle
reemplaza &employee_num por el valor correspondiente que es 200. Luego se elimina esta variable.

-- =========================================================
-- 	FUNCIONES
-- =========================================================

Quien esta refenciando a una tabla (foreign key reference)

select table_name, constraint_name, status, owner
from all_constraints
where r_owner = 'ACAADMIN'
and constraint_type = 'R'
and r_constraint_name in
 (
   select constraint_name from all_constraints
   where constraint_type in ('P', 'U')
   and table_name = 'CAMPAIGN_TMP'
   and owner = 'ACAADMIN'
 )
order by table_name, constraint_name;

-- =========================================================
-- 		ARRAY
-- =========================================================

declare
 type NumberArray is table of number ;
 myArray NumberArray;
begin
  select id_mno BULK COLLECT INTO myArray from mno;
  
  FOR i IN 1..myArray.count LOOP
    dbms_output.put_line(myArray(i));
  END LOOP;
end;


 declare
      type NumberVarray is varray(100) of NUMERIC(10);
      myArray NumberVarray;
    BEGIN
      myArray := NumberVarray(1,10,100,1000,10000);

      myArray(1) = 2;

      for i in myArray.first..myArray.last
      loop
        dbms_output.put_line('myArray(' || i || '): ' || myArray(i));
      end loop;  
    end;

-- =========================================================
-- 		TIMEZONE
-- =========================================================

ALTER SESSION SET TIME_ZONE = 'America/Bogota';
select SYSDATE, CURRENT_TIMESTAMP from dual;

-- Generar la hora en timestamp con el timezone que se desea
-- CET : time_zone de la base de datos. En este caso Francia
 SELECT from_tz(CAST(SYSDATE AS TIMESTAMP),'CET') at TIME zone 'AMERICA/BOGOTA' FROM dual;


IF condition_1 THEN
  statements_1
ELSIF condition_2 THEN
  statements_2
[ ELSIF condition_3 THEN
    statements_3
]...
[ ELSE
    else_statements
]
END IF;

-- =========================================================
--  FORMATEO DE UNA QUERY
-- =========================================================
- El comando COLUMN + HEADING puede ser usado para reemplazar la 
  cabecera en el resultado de la query.
  Es una forma mas limpia de hacer el column AS "NAME"

	COLUMN LAST_NAME        HEADING 'LAST NAME'
	COLUMN SALARY           HEADING 'MONTHLY SALARY'
	COLUMN COMMISSION_PCT   HEADING COMMISSION
	SELECT LAST_NAME, SALARY, COMMISSION_PCT
	FROM EMP_DETAILS_VIEW
	WHERE JOB_ID='SA_MAN';


LAST NAME                 MONTHLY SALARY COMMISSION
------------------------- -------------- ----------
Russell                            14000         .4
Partners                           13500         .3
Errazuriz                          12000         .3
Cambrault                          11000         .3
Zlotkey                            10500         .2


- Split a column HEADING 

 + Para que la cabecera quede en dos filas se usa el caracter (|)

	COLUMN SALARY HEADING 'MONTHLY|SALARY'
	COLUMN LAST_NAME HEADING 'LAST|NAME'

	LAST                         MONTHLY
	NAME                          SALARY COMMISSION
	------------------------- ---------- ----------
	Russell                        14000         .4
	Partners                       13500         .3
	Errazuriz                      12000         .3
	Cambrault                      11000         .3
	Zlotkey                        10500         .2

- formatear una column numerica 

	COLUMN SALARY FORMAT $99,990

	LAST                       MONTHLY
	NAME                        SALARY COMMISSION
	------------------------- -------- ----------
	Russell                    $14,000         .4
	Partners                   $13,500         .3
	Errazuriz                  $12,000         .3
	Cambrault                  $11,000         .3
	Zlotkey                    $10,500         .2


  - Reiniciar el formato de una columna
	
		COLUMN column_name CLEAR

+ Nota: El nuevo nombre de la columna queda defnida para la sesion
	o hasta que se renombre la columna.


-- ========================================
--  FUNCIONES NUMERICAS
-- ========================================

- function ROUND

SQL> select ROUND(46.96) from dual;
46

SQL> select ROUND(46.96,2) from dual;
46.96

SQL> select ROUND(46.96,3) from dual;
46.96

SQL> select ROUND(46.96,1) from dual;
47

SQL> select ROUND(46.94,1) from dual;
46.9

SQL> select ROUND(36.76,1) from dual;
47


-- ========================================
-- 		JOINS
-- ========================================

-- query 1: INNER JOIN with ON CLAUSE
SQL> SELECT emp_name, dept_name
	 FROM emp
	   INNER JOIN dept ON (emp.EMP_ID = dept.EMP_ID);

-- query 2: INNER JOIN with USING CLAUSE
SQL> SELECT emp_name, dept_name
	 FROM emp
	   INNER JOIN dept USING (EMP_ID = EMP_ID);


	   Apuntes SQL / Oracle

CREATE TABLE prueba (A VARCHAR2(10));

INSERT INTO prueba VALUES ('uno');
INSERT INTO prueba VALUES ('dos');
INSERT INTO prueba VALUES ('tres');
INSERT INTO prueba VALUES ('cuatro');
INSERT INTO prueba VALUES ('cinco');


CREATE OR REPLACE VIEW V_PRUEBA AS
  SELECT A AS COLM1 FROM prueba;

SELECT * from V_PRUEBA;

-- =========================================================
-- 		CONCLUSIONES
-- =========================================================
-- 1. despues de un DROP se hace un COMMIT implicito;
-- 2. despues de borrar una tabla que se usaba en una vista
--		la vista queda con errores/ No se puede leer
-- 3. DELETE * FROM table;   es una sentencia incorrecta
!* revisar structura delete
	structura MERGE

-- 4. date format default dd-mon-rr
-- la creacion de una tabla nueva desde una subquery hereda las restricciones de nulidad
-- la funcion TO_DATE se puede usar para : Convert any character literal to a date
-- INDEX, They can be created on tables and clusters.
-- Creaacion de una tabla:
	-- no puede iniciar por un numero (#) ni (caracter _ / )
	-- NUMBER puede ir sin especificar longitud
	-- VARCHAR debe ir con la longitud => VARCHAR2(25)
	-- CLOB va sin longitud *!



sue -> alice -> reena -> timber 

create table tabla1 (col1 VARCHAR2(10) NOT NULL);
INSERT INTO tabla1 VALUES ('HOLA');
INSERT INTO tabla1 VALUES ('TU');
commit;


create table tabla2 as select col1 from tabla1;
desc tabla2;

COL1 		NOT NULL 	VARCHAR2(10)


create table tabla_noNull (col1 varchar2(5));
insert into tabla_noNull values ('a');
insert into tabla_noNull values ('b');
insert into tabla_noNull values ('c');
commit;

desc tabla_noNull;

COL1		NULL 		VARCHAR2(5)


-- los SAVEPOINTS pueden ser usados por:
  . ROLLBACKS
  . DML statements

-- SUB-QUERIES
  . SELECT - FROM
     select col1 from (select .. from ..) b
  . SELECT - WHERE 

  . INSERT - INTO
     insert into employees select * from tabla1;
  . UPDATE - SET
     update employee set dept_id = (select deptno from ..)
  . DELETE
  	 delete from employee where dept_id = (select ..)

-- NVL ( condicion, valor_retorno) ;
	valor_retorno
	. DATE
	. NUMBER
	. CHARACTER
	NOTE: el tipo de dato de la condicion y el valor de retorno deben ser iguales*

	select NVL(number, caracter);
	select NVL(5,'a'); * ORA-01722 : invalid number


-- Numero de filas afectadas por SQL comando 'SQL%ROWCOUNT'.
	IF V_LAST_UNSUP_L IS NULL THEN
       dbms_output.put_line('. [WARNING] => No unsupported list was found');
    ELSE
       dbms_output.put_line('. => Adding MSISDN to unsupported handsets');
       execute IMMEDIATE 'truncate table MSISDN_UNSUPPORTED_LIST';
      
       dbms_output.put_line('. => Adding MSISDN related to unsupported handsets');
       execute IMMEDIATE 'INSERT INTO msisdn_unsupported_list 
                              SELECT MSISDN FROM MSISDN 
                              WHERE LIST_ID_LIST = ' ||V_LAST_UNSUP_L;
       V_ROWS := SQL%ROWCOUNT;
       
       dbms_output.put_line('REGISTROS INSERTADOS SQL_ROWCOUNT '||V_ROWS);
       
       select count(1) into I_TARGET_COUNTER from msisdn_unsupported_list;
       
       dbms_output.put_line('REGISTROS INSERTADOS COUNT '||I_TARGET_COUNTER);
       
    END IF;


-- -----------------------------------
--  PLAN DE EJECUCION DE UNA QUERY
-- -----------------------------------

    set linesize 121
set echo on
                                                                                          
                                  
drop table t;
                                                                                          
                                  
create table t
as
select * from all_objects;
                                                                                          
                                  
alter table t add constraint t_pk primary key(object_id);
exec dbms_stats.gather_table_stats( user, 'T', cascade=>true );
                                                                                          
                                  
set autotrace traceonly
select distinct owner, object_name, object_type from t;
select owner, object_name, object_type from t group by owner, object_name, object_type;
set autotrace off
alter session set sql_trace=true;
set autotrace traceonly
select distinct owner, object_name, object_type from t;
select distinct owner, object_name, object_type from t;
select distinct owner, object_name, object_type from t;
select owner, object_name, object_type from t group by owner, object_name, object_type;
select owner, object_name, object_type from t group by owner, object_name, object_type;
select owner, object_name, object_type from t group by owner, object_name, object_type;
set autotrace off


select distinct owner, object_name, object_type from t
                                                                                          
                                  
call     count       cpu    elapsed       disk      query    current        rows
------- ------  -------- ---------- ---------- ---------- ----------  ----------
Parse        3      0.00       0.00          0          0          0           0
Execute      3      0.00       0.00          0          0          0           0
Fetch     9525      0.92       0.83          0       1992          0      142815
------- ------  -------- ---------- ---------- ---------- ----------  ----------
total     9531      0.92       0.83          0       1992          0      142815
                                                                                          
                                  
Rows     Row Source Operation
-------  ---------------------------------------------------
  47605  SORT UNIQUE (cr=664 pr=0 pw=0 time=177034 us)
  47938   TABLE ACCESS FULL T (cr=664 pr=0 pw=0 time=48087 us)
********************************************************************************
select owner, object_name, object_type from t group by owner, object_name, object_type
                                                                                          
                                  
                                                                                          
                                  
call     count       cpu    elapsed       disk      query    current        rows
------- ------  -------- ---------- ---------- ---------- ----------  ----------
Parse        3      0.00       0.00          0          0          0           0
Execute      3      0.00       0.00          0          0          0           0
Fetch     9525      0.93       0.85          0       1992          0      142815
------- ------  -------- ---------- ---------- ---------- ----------  ----------
total     9531      0.93       0.85          0       1992          0      142815
                                                                                          
                                  
Rows     Row Source Operation
-------  ---------------------------------------------------
  47605  SORT GROUP BY (cr=664 pr=0 pw=0 time=166792 us)
  47938   TABLE ACCESS FULL T (cr=664 pr=0 pw=0 time=48006 us)
 
Reviews	Write a Review
 Thanks Tom

+ Bloque DECLARE - BEGIN - END

DECLARE
  deptid        employees.department_id%TYPE;
  jobid         employees.job_id%TYPE;
  emp_rec       employees%ROWTYPE;
  TYPE emp_tab IS TABLE OF employees%ROWTYPE INDEX BY PLS_INTEGER;
  all_emps      emp_tab;
BEGIN
  SELECT department_id, job_id INTO deptid, jobid 
     FROM employees WHERE employee_id = 140;
  IF SQL%FOUND THEN 
    DBMS_OUTPUT.PUT_LINE('Dept Id: ' || deptid || ', Job Id: ' || jobid);
  END IF;
  SELECT * INTO emp_rec FROM employees WHERE employee_id = 105;
  SELECT * BULK COLLECT INTO all_emps FROM employees;
  DBMS_OUTPUT.PUT_LINE('Number of rows: ' || SQL%ROWCOUNT);
END;
/


+ Uso del comando RANK.

[OSP server]

Solo es reemplazar ## por el id de la lista 

Sqlplus acaadmin/acaadmin@osds

select state,count(*) 
from (
   select msisdn,state, rank() over (partition by msisdn order by id_date desc)  "RANK"
   from campaign_fact cf, state_dim sd
   where cf.id_state = sd.id_state and cf.id_mno=6 and cf.id_campaign in (select id_campaign from campaign where base_id_list = ##) 
where RANK = 1 group by state ;  



SQL> create table bowie (id number, code number, name varchar2(42));
 
Table created.
 
SQL> insert into bowie select rownum, mod(rownum,10), 'DAVID BOWIE' from dual connect by level <= 1000000;
 
1000000 rows created.


SELECT column_name ||' : '|| comments
FROM user_col_comments
WHERE table_name='CEE_TARGET';



SELECT 'comment on column '||table_name||'.'||column_name||' is '''||comments||''';'
FROM user_col_comments
WHERE comments is not null;



DELETE
FROM campaign
WHERE id_mno          in (3)
AND TRUNC(start_date) < to_date(20150320,'yyyymmdd')

Error report -
SQL Error: ORA-08102: index key not found, obj# 471147, file 280, block 2482795 (2)
08102. 00000 -  "index key not found, obj# %s, file %s, block %s (%s)"
*Cause:    Internal error
*Action:   Send trace file to your customer support representative, along
           with information on reproducing the error



 + Salir de un procedimiento con la clausula RETURN

    DECLARE
	  employee_rec employees%ROWTYPE;
	BEGIN
	  BEGIN
	    SELECT * INTO employee_rec FROM employees WHERE employee_id = 0;
	  EXCEPTION
	  WHEN NO_DATA_FOUND THEN
	    dbms_output.put_line('in the exception');
	    RETURN;
	  END;
	  dbms_output.put_line('after exception');
	END;
	/


	+ Configurar el SERVEROUTPUT by default?

	Open a new worksheet.

	Code this line

	SET SERVEROUTPUT ON
	
	Save to ‘startup.sql’

	Open Tools – Preferences

	Go to the Database page

	On the ‘Filename for connection startup script’ – point to the ‘startup.sql’ file you just created.

	Restart SQL Developer.