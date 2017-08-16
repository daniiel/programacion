-- -------------------
-- ERRORES ORACLE
-- -------------------

[CMD] sqlplus / as sysdba;
SQL> select * from global_name;

GLOBAL_NAME
--------------------------------------------------------------------------------
ORCL
SQL> conn hr/hr
ERROR:
ORA-28000: the account is locked


Warning: You are no longer connected to ORACLE.

SQL> select username, account_status from dba_users;
SP2-0640: Not connected


-- *! Solucion: Conectar con la db

SQL> connect sys
Enter password: 
ERROR:
ORA-28009: connection as SYS should be as SYSDBA or SYSOPER


SQL> connect as sysdba
Enter user-name: sys
Enter password: 
Connected.