--5. refleja el progreso de las 20 operaciones mas demoradas:
select * 
from (
  select elapsed_seconds, message 
  from v$session_longops 
  order by elapsed_seconds desc) 
where rownum < 20;

-- TOP SQL, sentencias que mas consumen recursos
-- unidades de medicion, columnas de tiempo (in microseconds)
-- hours = microseconds ÷ 3,600,000,000
SELECT * FROM
(SELECT  sql_fulltext, sql_id, sharable_mem, CPU_TIME, elapsed_time, child_number, disk_reads, 
    executions, first_load_time, last_load_time 
  FROM    v$sql
  ORDER BY elapsed_time DESC)
WHERE ROWNUM < 11;

-- consulta de uso tablespace 
select a.tablespace_name,
       a.bytes / 1024 / 1024  "Sum MB",
       (a.bytes - b.bytes) / 1024 / 1024  "used MB",
       b.bytes / 1024 / 1024 "free MB",
       round(((a.bytes - b.bytes) / a.bytes) * 100, 2)||'%' "percent_used"
  from (select tablespace_name, sum(bytes) bytes
          from dba_data_files
         group by tablespace_name) a,
       (select tablespace_name, sum(bytes) bytes, max(bytes) largest
          from dba_free_space
         group by tablespace_name) b
 where a.tablespace_name = b.tablespace_name
 order by ((a.bytes - b.bytes) / a.bytes) desc;
 
 -- Numero de conexiones actuales a Oracle agrupado por aplicación que realiza la conexión
select program Aplicacion, count(program) Numero_Sesiones
from v$session
group by program 
order by Numero_Sesiones desc;

--1. consultas que se estan ejecutando 
select SID, s.SERIAL#, SPID, a.sql_text 
from v$session s, v$process p, v$sqlarea a 
where s.paddr   = p.addr
  and s.sql_id  = a.sql_id
order by 4;

--2. query para encontrar quien bloquea a quien:
SELECT s1.username || '@' || s1.machine
  || ' ( SID = ' || s1.SID || ' ) is blocking '
  || s2.username || '@' || s2.machine || ' ( SID = ' || s2.SID || ' ) ' AS blocking_status
FROM v$lock l1, v$session s1, v$lock l2, v$session s2
WHERE s1.SID = l1.SID AND s2.SID = l2.SID
  AND l1.BLOCK = 1 AND l2.request > 0
  AND l1.id1 = l2.id1 AND l1.id2 = l2.id2 
ORDER BY 1;

--3. Conocer la sentencia que esta ejecutando un determinado SID
SELECT a.sid, a.serial#, b.sql_text
FROM v$session a, v$sqlarea b
WHERE a.sql_address = b.address
AND sid             = 2132;

--4. Kill sessions  'sid,serial#'
execute sys.kill_osds_session(2756, 23709);

-- la sesion (Waiting_session) esta esperando a que la session (holding_session)
-- libere algun recurso
SELECT * FROM dba_waiters;

-- enq: TX - row lock contention
select w.event, count(1)
from gv$session s, gv$session_wait w
where s.sid = w.sid
group by w.event
order by 2;

-- identificar usuarios, programas y a q tablas intentan acceder las sessiones
-- que tienen lock 'enq: TX - row lock contention'
SELECT object_name, b.username, b.program, count(1)
from v$session b, dba_objects o
where o.object_id = ROW_WAIT_OBJ#
and   event       = 'enq: TX - row lock contention'
group by object_name,  b.username, b.program, ROW_WAIT_FILE#, ROW_WAIT_BLOCK#, ROW_WAIT_ROW#
order by 4;

-- Conocer los parametros de INI_TRANS y MAX_TRANS
SELECT table_name, ini_trans, max_trans 
FROM dba_tables
WHERE table_name    = 'MSISDN_TARGET'
  AND owner         = 'ACAADMIN';
  
-- Sample query (query de ejemplo) to find unindexed foreign key constraints
SELECT * 
FROM (
  SELECT c.table_name, cc.column_name, cc.position column_position
  FROM   user_constraints c, user_cons_columns cc
  WHERE  c.constraint_name = cc.constraint_name
  AND    c.constraint_type = 'R'
  MINUS
  SELECT i.table_name, ic.column_name, ic.column_position
  FROM   user_indexes i, user_ind_columns ic
  WHERE  i.index_name = ic.index_name
  )
ORDER BY table_name, column_position;
  
-- Actualizar INIT y MAX_TRANS
alter table ACAADMIN.MSISDN_TARGET INITRANS 20 MAXTRANS 255;

-- Parametros de configuracion de la base   
SELECT * FROM V$NLS_PARAMETERS;

--give you queries currently running for more than 2 horas
select s.username,s.sid,s.serial#,s.last_call_et/60 mins_running,q.sql_text from v$session s 
join v$sqltext_with_newlines q
on s.sql_address = q.address
 where status='ACTIVE'
and type <>'BACKGROUND'
and last_call_et> 7200
order by sid,serial#,q.piece;

-- =============================================

-- verificar el estados de las cuentas de usarios (LOKED,EXPIRED,OPEN)
select username, account_status from dba_users;

select a.session_id,a.oracle_username, a.os_user_name, b.owner "OBJECT OWNER", b.object_name,b.object_type,a.locked_mode from 
(select object_id, SESSION_ID, ORACLE_USERNAME, OS_USER_NAME, LOCKED_MODE from v$locked_object) a, 
(select object_id, owner, object_name,object_type from dba_objects) b
where a.object_id=b.object_id;  

-- Kill sessions  'sid,serial#'
execute sys.kill_osds_session(485, 3554);
ALTER SYSTEM KILL SESSION '485, 3554'; -- this statement need more privileges

-- Saber el SID/SERIAL y el PID del Sistema operativo
col "SID/SERIAL" format a10
col username format a15
col osuser format a15
col program format a40
select     s.sid || ',' || s.serial# "SID/SERIAL"
,     s.username
,     s.osuser
,     p.spid "OS PID"
,     s.program
from     v$session s,     v$process p
Where     s.paddr = p.addr
order      by to_number(p.spid);
/

column sql_text format a90
-- a90 -> significa alphanumeric 

-- Ver la ruta donde se encuentra el alert.log file
show parameter BACKGROUND_DUMP_DEST;


-- ORA-08102: index key not found, obj# 471147, file 280, block 2482795 (2)
--1. conocer el objecto que esta fallando.
select object_name, object_type
from dba_objects
where object_id = 471147;

SELECT ind.owner,
  ind.tablespace_name tbs,
  ind.index_name,
  ind.status,
  ind.table_owner,
  col.column_name,
  col.descend
FROM dba_indexes ind,
  dba_ind_columns col
WHERE ind.index_name = col.index_name
AND ind.owner        = col.index_owner
AND ind.table_name   = upper ('&table_name')
ORDER BY ind.owner,
  ind.table_owner,
  ind.table_name,
  ind.index_name,
  col.column_position