			COMANDOS PARA DBA 

@AUTHOR: 	DANIEL
@DATE:		2015-10-29

-- entrar como dba
-- connect_user/password@database_name as sysdba

[cmd] sqlplus / as sysdba

SQL> select name from v$database;
XE
SQL> select * from global_name;
XE

-- conocer la version de la base 
SQL> select * from v$version;

BANNER
---------------------------------
Oracle database 11g Express Edition Release 11.2.0.2.0 - 64bit Production
PL/SQL Release 11.2.0.2.0 - Production
CORE 	11.2.0.2.0 	Production
TNS for 64-bit Windows: Version 11.2.0.2.0 - Production
NLSRTL Version 11.2.0.2.0 - Production

SQL> show user;
USER is ""

SQL> conn hr/hr
ERROR:
ORA-28000: the account is locked

-- Explicacion : After installation of Oracle, there is a problem  with the login
-- Solucion :  from your command prompt, type:

SQL> sqlplus / as sysdba

-- Once logged in as SYSDBA, you need to unlock the hr account
SQL> select username, account_status from dba_users;

USERNAME 			ACCOUNT_STATUS
------------------- ------------------
HR 					EXPIRED & LOCKED

SQL> alter user hr account unlock;

SQL> select username, account_status from dba_users;

USERNAME 			ACCOUNT_STATUS
------------------- ------------------
HR 					EXPIRED

-- Cambiar psswd de un usuario
SQL> alter user userName identified by newPasswd;

SQL> grant connect, resource to HR;

Grant succeeded.

SQL> conn HR (verificar si es HR o HR/HR)

ERROR
ORA-28001: the password has EXPIRED

changing password for HR
New password: 
..

-- Saber los usuarios de Oracle
SQL> select username, user_id, account_status from dba_users;
SQL> select username, account_status from dba_users;
SQL> select username, account_status, authentication_type from dba_users; -- only Oracle 11g en adelante
SQL> select username, account_status, profile from dba_users;


-- logearse en la base de datos sin ningun usario
-- sin espacio despues del (/)
[cmd] sqlplus /nolog

SQL> show user;
USER is ""

SQL> conn hr/hr
connect

[cmd] set ORACLE_SID=orcl
[cmd] echo %ORACLE_SID%
orcl

-- coneccion a otra maquina
-- user : sys , psswd: oracle
[cmd] sqlplus sys/oracle as sysdba@192.168.11.104:1521/orcl




-- =====================================================
--  Data Manipulation Language 
-- =====================================================

-- tabla con opcion ON DELETE SET NULL
CREATE TABLE authors (
	author_id 		NUMBER(3),
	author_name		VARCHAR2(30)
);

CREATE TABLE books (
	book_id			NUMBER(3),
	book_title		VARCHAR2(30),
	book_author_id	NUMBER(3) CONSTRAINT bok_col3_fk
	REFERENCES authors(author_id) ON DELETE SET NULL
);

-- Cuando se ejecuta una sentencia delete sobre la tabla AUTHORS los datos que son referenciados
-- por la tabla books van a ser actualizados con el valor NULL, a diferencia de una refencia sin
-- esta propiedad donde mostraria un error al tratar de hacer el borrado.

book_id 	book_title 		book_author_id
----------- --------------- ----------------
1			SQL 			1
2			Java			2
3			PHP 			3
4			JavaScript		2
5			Unix			1

DELETE FROM authors WHERE author_id = 1;

book_id 	book_title 		book_author_id
----------- --------------- ----------------
1			SQL 			(null)
2			Java			2
3			PHP 			3
4			JavaScript		2
5			Unix			(null)


-- tabla con opcion ON DELETE CASCADE

CREATE TABLE books (
	book_id			NUMBER(3),
	book_title		VARCHAR2(30),
	book_author_id	NUMBER(3) CONSTRAINT bok_col3_fk
	REFERENCES authors(author_id) ON DELETE CASCADE
);

-- Esta clausula no es muy recomendada, por le hecho de que si se borran los de la tabla principal
-- la base borrara cualquier registro que estubiera siendo referenciada.

book_id 	book_title 		book_author_id
----------- --------------- ----------------
1			SQL 			1
2			Java			2
3			PHP 			3
4			JavaScript		2
5			Unix			1

DELETE FROM authors WHERE author_id = 1;

book_id 	book_title 		book_author_id
----------- --------------- ----------------
2			Java			2
3			PHP 			3
4			JavaScript		2


-- rename table
ALTER TABLE tableName RENAME TO tableNewName;

-- add column
ALTER TABLE tableName ADD newColumn dataType(size);

	. ALTER TABLE hr ADD newColumn VARCHAR2(30);

-- remove column
ALTER TABLE tableName DROP COLUMN columnTodelete ;

	. ALTER TABLE employees DROP COLUMN salary;

-- rename column
ALTER TABLE tableName RENAME COLUMN colOld TO colNew;

-- ====================
-- 	JOINS
-- ====================

-- NATURAL JOIN
-- SCEN 1. where there is only one common column between source and target table

DESC departments;
DESC locations;
SELECT department_name, city FROM departments NATURAL JOIN locations;
-- Departments.location_id = Locations.location_id

-- SCEN 2. there are more than 1 common columns

DESC employees;
DESC departments;
SELECT first_name, department_name FROM employees NATURAL JOIN departments;

-- NATURAL JOIN USING ON CLAUSE
SELECT first_name, department_name FROM employees JOIN departments
	ON (employees.manager_id = departments.manager_id
	 	AND employees.department_id = departments.department_id);
-- its the same query that the before statement

-- SCEN 3. Natural join USING clause
SELECT first_name, department_name FROM employees JOIN departments USING(manager_id);



Type of JOINS
----
	|_> Inner Join
	|_> Outer Join
	|	----
	|		|_> right
	|		|_> left
	|		|_> full
	|_> Cross Join
	|_> Self Join

. Join conditions
	1. Equi Join
	2. Non-Equi Join

	
-- Mirar todas las variables del sistema [SQL*Plus]
SHOW ALL

-- ======================================
--  Parametros de la db
-- ======================================

-- ayuda a ver las mascaras para los tipos de fecha
select * from v$nls_parameters;

...
NLS_DATE_FORMAT			DD/MM/RR
NLS_DATE_LANGUAGE		LATIN AMERICAN SPANISH
NLS_CHARACTERSET		AL32UTF8
NLS_SORT				SPANISH
NLS_TIME_FORMAT			HH12:MI:SSXFF AM
NLS_TIMESTAMP_FORMAT	DD/MM/RR HH12:MI:SSXFF AM
NLS_TIME_TZ_FORMAT		HH12:MI:SSXFF AM TZR
NLS_TIMESTAMP_TZ_FORMAT	DD/MM/RR HH12:MI:SSXFF AM TZR
..


-- ======================================
-- 	MASK
-- ======================================

-- TIME
HH24:MI:SS AM 		15:45:32 PM

-- ======================================
--  Shortcuts
-- ======================================

alt + F10 	abre la ventana para una nueva conexion