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
where s.paddr=p.addr and s.sql_id=a.sql_id;

-- encontrar sessiones de bloqueo 
SELECT s.blocking_session, s.sid, 
   s.serial#, s.seconds_in_wait
FROM v$session s
WHERE blocking_session IS NOT NULL;

--2. query para encontrar quien bloquea a quien:
SELECT s1.username || '@' || s1.machine
|| ' ( SID=' || s1.SID || ' ) is blocking '
|| s2.username || '@' || s2.machine || ' ( SID=' || s2.SID || ' ) ' AS blocking_status
FROM v$lock l1, v$session s1, v$lock l2, v$session s2
WHERE s1.SID = l1.SID AND s2.SID = l2.SID
  AND l1.BLOCK = 1 AND l2.request > 0
  AND l1.id1 = l2.id1
  AND l1.id2 = l2.id2 
ORDER BY 1;

--3. Conocer el SQL que esta ejecutando un determinado SID
SELECT a.sid, a.serial#, b.sql_text
FROM v$session a,
  v$sqlarea b
WHERE a.sql_address = b.address
AND sid             = 1014;


-- Conocer los parametros de 
SELECT table_name, ini_trans, max_trans 
FROM dba_tables
WHERE table_name    = 'MSISDN_TARGET'
  AND owner         = 'ACAADMIN';
  
-- * Actualizar INIT y MAX_TRANS
alter table ACAADMIN.MSISDN_TARGET INITRANS 20 MAXTRANS 255;

-- Parametros de configuracion de la base   
SELECT * FROM V$NLS_PARAMETERS;

-- consultas activas en este momento
 select
  object_name, 
  object_type, 
  session_id, 
  type,         -- Type or system/user lock
  lmode,        -- lock mode in which session holds lock
  request, 
  block, 
  ctime         -- Time since current mode was granted
from
  v$locked_object, all_objects, v$lock
where
  v$locked_object.object_id = all_objects.object_id AND
  v$lock.id1 = all_objects.object_id AND
  v$lock.sid = v$locked_object.session_id
order by
  session_id, ctime desc, object_name;


--give you queries currently running for more than 2 horas
select s.username,s.sid,s.serial#,s.last_call_et/60 mins_running,q.sql_text from v$session s 
join v$sqltext_with_newlines q
on s.sql_address = q.address
 where status='ACTIVE'
and type <>'BACKGROUND'
and last_call_et> 7200
order by sid,serial#,q.piece;

select inst_id, program, module, SQL_ID, machine
from gv$session
where type!='BACKGROUND'
and status='ACTIVE' 
and sql_id is not null;

-- =============================================

-- verificar el estados de los usarios (LOKED,EXPIRED,OPEN)
select username, account_status from dba_users;


SELECT sys_context('USERENV','SID') FROM dual;

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

SELECT sesion.sid,
  sql_text
FROM v$sqltext sqltext,
  v$session sesion
WHERE sesion.sql_hash_value = sqltext.hash_value
AND sesion.sql_address      = sqltext.address
AND sesion.username        IS NOT NULL
ORDER BY sqltext.piece;

-- Ver la ruta donde se encuentra el alert.log file
show parameter BACKGROUND_DUMP_DEST;
