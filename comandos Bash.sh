PROGRAMACION EN BASH 
   
   @AUTOR 	: DANIEL BUITRAGO
   @VERSION : v.4.8.3
   			  < comando , 2da opcion de uso de un comando, cambio de forma >

+ short cuts
 
   ctrl + s  	scroll lock
   crtl + q 	desactiva el bloqueo anterior

+ comando ECHO.

	echo "Hola mundo"
	Hola mundo
	
	echo -e "Hola \n mundo"
	Hola
	 mundo
	 
	echo -E "\t Hola \n mundo"
	\t Hola \n mundo

	echo -e "\e[0;31m[ERROR] \e[0m"
	[ERROR]				-- en color ROJO

	echo -e "\e[1;32m[INFO] \e[0m"
	[INFO]				-- en color VERDE

	echo -e "\e[0;33m[WARNING]\e[0m"
	[WARNING]			-- en color NARANJA

	codigo de colores en ANSI
	
	black		0;30
	blue		0;34
	green 		0;32
	cyan 		0;36
	red 		0;31
	purple 		0;35
	orange 		0;33
	ligth gray 	0;37 
	dark gray	1;30
	light blue 	1;34
	light green 1;32
	light Cyan 	1;36
	light red 	1;31
	light purpl 1;35
	yellow		1;33
	white 		1;37
	
	parametros
	
	-e habilita las sequencias de escape
	-E No interpreta las sequencias de escape
	-n evita el salto de linea

	MNO=`echo -n $MNO`				#evita el salto de linea
	
+ comando MKDIR. Sirve para la creacion de directorios
	
	mkdir dir
	mkdir -p dir/dir2/dir3
	
	la opcion -p crea TODOS los subdirectorios que sean necesarios

+ Sentencia IF

	if condicion ; then
		sentencia
	elif condicion ; then 
		sentencia 2
	else
		sentencia 3
	fi

	+ Sentencia IF en linea
	   
	if [ 5 -gt 3 ]; then echo "verdad"; else echo "false"; fi
	
+ Comparacion numerica 
	
	-lt : less than <
	-le : less than or equal <=
	-eq : equal ==
	-ge : greater than or equal >=
	-gt : greater than >
	-ne : not equal !=
	
+ Comprobaciones 

	- Comprobar si el archivo $1 existe sino comprueba si $2 existe

	if [ -e $1 ]; then 
		echo "existe el archivo, pero no se valida si esta vacio o no"
	elif [ -e $2 ] ; then 
		echo "existe el archivo2"
	fi

	- Comprueba si un archivo existe y no esta vacio

	if [ -s file.txt ]; then
		echo "el archivo existe y no esta vacio"
	fi
	
	- Comprueba si un directorio existe
	
	if [ -d /directorio/ ]; then 
		echo "Existe"
	fi
	
	- Si la variable "var" es distinto de vacio imprima algo
      (similar al isEmpty de java)
	
	if [ ! -z $var ]; then echo "hola mundo"; fi
	

	variaciones:
		-s fichero existe y no esta vacio
		-r fichero existe y podemos leerlo
		-e fichero existe
		-f fichero existe y es un fichero regular
			para implementarlo, lo mejor es con la negacion ya que  
			"if [ ! -f $var ] .. " si no existe el archivo entonces ..
		-h, -L fichero existe y es un enlace simbolico
		-d directorio existe
		-z comprueba si la variable esta vacia
			A="algo"
			if [ -z $A ]; then echo "vacio"; else echo "llena";fi
			variable vacia = TRUE


$ BL_ID_LIST=`sqlplus -s acaadmin/acaadmin@osds<<EOF
   set pagesize 0 feedback off
   select nvl(max(id_list),-1)
   from list
   where id_mno = 54 and type_list = 'black list';
EOF`

$ echo $BL_ID_LIST
40043

$ if [ "$BL_ID_LIST" == "40043" ]; then echo "igual"; fi
$
$ BL_ID_LIST=`echo -n $BL_ID_LIST`

$ if [ "$BL_ID_LIST" == "40043" ]; then echo "igual"; fi
igual
$


+ validaciones parametros - fecha yyyy-mm-dd

      if [ $# -eq 1 ] && [ ${#1} -ne 10 ] ; then
      	 echo -e "\e[0;31m[ERROR] Error parameters, \n\t parameter 1. date in format YYYY-MM-DD \e[0m"
      	 exit
      fi
		
+ validaciones : folder → carpeta que se quiere validar

	- validar si el archivo esta vacio
		if [ ! -s file ]; then echo "archivo vacio"; fi

	- validar si el directorio existe
		if [ ! -d folder ]; then echo "no existe la carpeta"; fi

	- validar si el directorio esta vacio
		if [ ! "$(ls -A folder)" ]; then echo "esta vacia la carpeta"; fi

	- validar si el directorio No existe o esta vacio
		if [ ! -d folder ] || [ ! "$(ls -A folder)" ]; then echo "no existe o esta vacio" ;fi



+ Variante comprobar si $1.* y todas sus posibles extensiones existes con ls y wc
	
	ls $1.* 2>/dev/null | wc -l 
	
	explicacion
		si $1 no existe ls saca "No such file or directory"
		para que esto no salga solo se redirije el error a null
		y wc imprime 0 que no existe el archivo

+ Comprobar la longitud de un parametro, variable
	
	if [ ${#variable} -eq 1 ]; then
	  echo "longitud 1"
	elif [ ${#variable} -eq 10 ]; then
	  echo "longitud 10"
	else
	  echo "nada"
	fi
	
+ Manejo de PARAMETROS

    $0	Contiene el nombre del script tal como es invocado (./file.sh)
	$*	El conjunto de todos los parametros en un solo argumento
	$#	Numero de parametros pasados al script
	$?	codigo de retorno del ultimo comando
	$$	El PID del shell que ejecuta el script

+ Salidas standar (stdout). Para redirigir la salida se usa el operador ">"

	+ redirigir la salida standar de un comando a un archivo
	
      cat file > /home/../file2 

+ Salida standar de error (stderr). redirigir la salida de error a un archivo "2>"

	ls -7 2> err.log
	cat err.log
-d		ls: opción incorrecta -- '7'
		Pruebe 'ls --help' para más información

	+ especificar tanto la salida como los errores al mismo archivo.
        
        se hace con 2>&1
	
	+ Manejo de errores 2> . Redirige la salida de error a un 'archivo.log'

	    cat file.csv | awk -F'|' '{print $1}' > column1.csv 2> file.log
	
	+ Redirigir la salida de error a Null, cualquier error no es impreso en pantalla
	
	    cat file.csv | awk -F'|' '{print $1}' > column1.csv 2>/dev/null

+ Validaciones de cantidad de parametros recibidos y salir del script inmediatamente si no lo correctos

	if [ $# == 0 ]; then
		echo 'no hay parametros'
		exit
	fi
	
+ Comprobar si el archivo NO existe

	if [ ! -e $1 ]; then 
		echo "el archivo $1 no existe"
	fi
	
+ Operaciones logicas AND, OR 

	if [ -e ] && [ $LINE -gt 5 ]
	
	if [ -e ] || [ $LINE -gt 5 ]
    
    + Operadores Logicos

        -a (AND)
        exp1 -a exp2
	
        -o (OR)
        exp1 -o exp2
	
+ Comparar ultimos n caracteres de una cadena

	if [ "${1:(-4)}" == ".bz2" ]; then
        sentencia
    fi
	
+ COMANDO WC. Contar numero de componentes de un archivo  

	wc -l file
		#lines (8) file_name
	
	cat file | wc -l
		#lineas (8)
		
	variaciones
		-c imprime numero de bytes
		-m imprime numero de caracteres
		-L imprime longitud de la linea mas larga
		-w imprime numero de palabras

+ Funcion con retorno

	function suma(){
		c=$(expr $1 + $2)
		return $c
	}
	
	fPath() {
        echo "22" 
	}
	
	if [ `fPath` -eq "22" ]; then
        echo "devolvio 22"
	else
        echo "devolvio 0"
	fi

+ Manejo de Cadenas
	
	var="hola mundo"
	
	+ longitud de una variable
	
	  echo ${#var} -> 10
	
	+ Sustraer subcadenas
		
	Alias=typaca
	
	${Alias::3} -> typ   [toma las tres primeras letras]
	${Alias:4} -> ca 	el indice empieza en 0. Apartir del indice 4 traiga todo
	
	+ Usando AWK
	
	echo $Alias|awk '{print substr($1,1,3)}'
	 
	 - substr(var,posicionInicial,# de caracteres a tomar)
	   los indices de las cadenas inician en 1 , a diferencia del anterior ejemplo
	   hay que especificar una posicion inicial y uno de caracteres a tomar

+ Quitar ultimos caracteres de una variable

	var="hola.txt"
	echo ${var//.txt/} => "hola"
	
	+  variantes 
	
		echo ${var::${#var}-4} => hola

+ Comando SED. Eliminar, insertar y Reemplazar cadenas de texto 

	sed [-ns] ...

	-n: No mostrar por stdout las líneas que están siendo procesadas.
	-s: Tratar todos los archivos entrantes como flujos separados.

	la 's' inicial significa sustituto y la 'g' al final significa global

	Eliminar primer espacio de cada fila
	
		sed -i 's/^ //g' archivo.xxx
	
	Elimina lineas que contenga la palabra "cadena"
	
	    sed -i '/cadena/d' archivo.xxx
	
	Insertar palabra antes de una deteminada linea de un archivo
	
	    sed -i '1i \texto' archivo.xxx
		
		(n)a inserta el texto despues de la linea, n es cualquier numero
		
		HEAD="hola mundo"
		sed -i "1i \\$HEAD" file
		
		+ Insertar cadena al final de un archivo
		cadena="texto"
		
		sed "\$i $cadena" file
        
        + eliminar cualquier cosa que no sea numerico
        
        sed 's/[^0-9]//g'
        
        34er23  -> 3423
		
	Reemplazar cadena1 por cadena2
	
	    sed -i 's/cadena1/cadena2/g' archivo.xxx
		
	Eliminar lineas vacias
	
		sed -i '/^$/d' archivo.xxx
	
	Eliminar comilla simple 
		
		sed -i "s/'//g" archivo.xxx
		
	
	varios sed en la misma linea

	sed "s:_DATE_:$DESIRED_DATE:g; s:_ID_MNO_:$ID_MNO:g;" file.txt
	
	variaciones
	
		-i sobreescribe directamente el archivo

	uso de SED en templates
	
	sed s:_INFILE_:$TMP_CSV_FROM_XML:g $CAMPAIGN_FACT_CTL_TEMPLATE > $TMP_CAMPAIGN_FACT_CTL

	sqlldr acaadmin/acaadmin@osds control=$TMP_CAMPAIGN_FACT_CTL log=${TMP_CAMPAIGN_FACT_CTL/.ctl/.log}

	sed -r 's/;([^n][^o][^n][^e][^;])/g'


	+ imprimir resultados CTL

	echo "[INFO ] Finished load"
	echo -e "[INFO ] Result of the upload : \n"
	echo -e "\e[0;32m     `cat ${TMP_CTL/.ctl/.log} | grep "Rows successfully"` \e[0m"
	echo -e "\e[0;31m     `cat ${TMP_CTL/.ctl/.log} | grep "Rows not loaded due"` \e[0m"

+ Comando TR. Elimina los espacios, tabulaciones , lineas vacias..

	cat file | tr -d ' \t\r\f' 

		
+ Comprimir y descomprimir archivos [ gzip comprime mas en archivos csv ]

	bzip2 fileName.xxx  =>  fileName.xxx.bz2
	bzip2 -d fileName.xxx.bz2  => fileName.xxx
	gzip -q fileName.xxx  =>  fileName.xxx.gz
	gzip fileName.xxx  =>  fileName.xxx.gz
	gzip -d fileName.xxx.gz  => fileName.xxx
	zip file_name.zip file1 file2 => file_name.zip
	unzip fileName.zip => fileName
	unrar e fileName.rar => fileName
	tar zxvf fileName.tgz => fileName, fileName2, fileName3 
	  <el tar.gz o tgz es usado para comprimir vario archivos dentro de uno solo>
	tar zxvf fileName.tgz -C /path/donde/quiere/dejarlo => fileName, fileName2, fileName3 
	
	tar -xzvf archivo.tar.gz => archivo archivo

	+ ver contenido de un archivo comprimido
	
        cat file
        bzcat file.bz2
        zcat file.gz / file.zip
        unrar p file.rar

+ comprimir carpeta

	folder : lib

	$ zip -r lib lib 

	resultado : lib lib.zip


	
+ Comando LS. Listar solo directorios y archivos con un formato especifico

	ls -d */
	
	ls *.{mp3,exe,mp4}
	
	ls -a (muestra los archivos ocultos tambien)
	
+ Encontrar una subcadena con case sensitive
	
	+ usando FOR

	- continuar el ciclo si se cumple alguna condicion 

	for i in {1..10}
	do 
		if [ "$i" == "5" ]; then 
			continue
		fi
		echo $i
	done

	- for con inicio y fin dados como parametros. init - end son los valores 

	for i in `seq $init $end`
	do
  		echo $i
	done

	$ init=1
	$ end=5

	$ 1
	  2
	  3
	  4
	  5

	
	for i in *
	do
		shopt -s nocasematch
		if [[ $i = *"trans"* ]]; then
			echo "$i contien trans or TRANS"
		fi
	done
	
	variantes
	
	for i in * = for i in `ls`
	
	+ usando FIND. especificando un directorio
	
	find /home/user/ -iname '*.bad'

+ Comando TAC, imprime el contenido del archivo pero desde la ultima linea hasta la primera

	tac archivo 

+ Comando DATE. IMPORTANTE comillas raras (``)
	
	$ date
    Mon Feb  9 14:26:26 BRST 2015
	
	DATE=`date +%Y-%m-%d_%T`
	
	+ Fecha en formato yyyy-mm-dd pasandole la zona horaria

	  export TZ=America/Bogota

	  or
	
  	  DATE=`TZ=America/Bogota date +%F`
		
	+ Sumar o Restar dias a una fecha Desde la fecha actual en distintos formatos
		-- resultados obtenidos con fecha 2014-01-10 e i=5
														
		$ date -d "2014-04-28 -1day" +%FCAMPAIGNCAMPAIGN
		2014-04-27
														
		IdDate=`date -d "$i day" +%Y%m%d`				[20140115]
		Date=`date -d "$i day" +%F`						[2014-01-15]
		Dateshort=`date +%d-%m-%y`						[15-01-14]	dia-mes-año
		FullDateDesc=`date -d "$i day" +"%b %d,%Y"`		[Jan 15,2014]
		Year=`date -d "$i day" +%Y`						[2014]
		YearShort=`date +%y`							[14]
		MonthNum=`date -d "$i day" +%m`					[01]
		MonthName=`date -d "$i day" +%B`				[January]
		MonthShort=`date -d "$i day" +%b`				[Jan]
		WeekNum=`date -d "$i day" +%V`					[03] 	hay otra opcion diferente a V que varian segun si la
																primera semana empieza en 1 o 0 con la opcion U
		DayName=`date -d "$i day" +%A`					[Wednesday]
		DayNameShort=`date -d "$i day" +%a`				[Wed]
		DayNum=`date -d "$i day" +%d`					[15]
		vWeekdayIndicator=""
		if [ $(date -d "$i day" +%u) -gt 5 ]; then
			vWeekdayIndicator="weekend"
		else
			vWeekdayIndicator="weekdays"
		fi
		
	+ Sumar o restar dias desde una fecha especifica
	
        var=2013-12-20
        var2=`date -d "$var 4day" +%F`
        echo $var2   ->  2013-12-24

+ COMANDO cal. Muestra el dia actual en un calendario impreso en pantalla, el dia 
	actual se muestra resaltado, por cuestiones de ser un txt no se resalta el dia.

		   February 2014
		Su Mo Tu We Th Fr Sa
						   1
		 2  3  4  5  6  7  8
		 9 10 11 12 13 14 15
		16 17 18 19 20 21 22
		23 24 25 26 27 28

	+ Variante "cal -3 "muestra el mes anterior y posterior, junto con el actual
		(fecha actual february 25)
	
				January 2014         February 2014           March 2014
		Su Mo Tu We Th Fr Sa  Su Mo Tu We Th Fr Sa  Su Mo Tu We Th Fr Sa
				  1  2  3  4                     1                     1
		 5  6  7  8  9 10 11   2  3  4  5  6  7  8   2  3  4  5  6  7  8
		12 13 14 15 16 17 18   9 10 11 12 13 14 15   9 10 11 12 13 14 15
		19 20 21 22 23 24 25  16 17 18 19 20 21 22  16 17 18 19 20 21 22
		26 27 28 29 30 31     23 24 25 26 27 28     23 24 25 26 27 28 29
													30 31
	
+ Convertir una variable a numerica

	let var=13
	
+ Operaciones matematicas 
	
	echo  20/3|bc				=> 6		# division entera
	echo "scale=1; 20/3" |bc	=> 6.6		# punto flotante
	echo "scale=1; 20/3*5" |bc	=> 33.0		# '/' tiene mayor precedencia que '*'
	
+ Buscar fichero con fecha de modificacion "hace dos dias al actual" y con formato .csv o .bad
	
	find -mtime 2 -name '*.csv' -o -name '*.bad'
	find -mtime 2 -name '*.bad' -o -mtime 2 -name '*.bad'
	find /mnt/nas_aca_2/tbcaca/tmp/ -mtime 2
	
	+alternativa -iname case sensitive
	
        list2=$(find -mtime 2 -name '*.bad' -o -name '*.bad')
 
+ Recorrer una variable con un FOR
 
   VAR="cadena1 cadena2 cadena3 cadena4"
 
   for i in $VAR
   do
     echo "$i"
   done

+ Comando DOS2UNIX Convertir un archivo de windows a unix. 

	dos2unix file 
	dos2unix -q file    # no imprime en pantalla "..dos2unix: converting file .."

    
+ Comando SORT
	
    sort file > file_ordenado
	
		- variaciones 
		  -o ordena en el mismo archivo, no hay necesidad de redigir la salida, (NO RECOMENDADO)
		   NOTA: el -o tiene un pesimo rendimiento para archivos demasidos grandes
		         si se ejecuta con la opcion -o si se cancela la ejecucion se pierden
				 la informacion del archivo.
                 
    + indicar la particion temporal para ordenarlo
    
        sort -T <path particion /PROCESSING/tmp/> file 
	
+ Comando COMM. permite comparar dos archivos y obtener elementos en comun, que estan en
  un archivo y que no estan en el otro.. [Nota: para poder comparar los archivos deben estar 
  ordenados (sort -o file)]
  
  file1
  1
  2
  3
  
  file2
  3
  4
  5
  
  $comm file1 file2
  1
  2
			3
		4
		5

	- La primera columna muestra los elementos que solo se encuentran en el file1,
	- La segunda columna muestra los elementos que solo se encuentran el el file2
	- La tercera muestra los elementos comunes en los dos archivos
	
		+ variaciones
		para obtener unicamente una de estas columnas se usa las opciones 
		-1, -2, -3 para indicar cuales columnas no se mostraran.
		
		$ comm -12 file1 file2 
		3
		
+ Consola Screen

	+ Crear un screen nuevo
	  screen -S name
	  
	  + salir del screen 
	  ctrl + A  luego D
	  
	+ Lista los nombres de las screen que hay con el identificador #####
	  screen -r 
	
	+ Ingresar a un screen specifico
	  screen -r name 
	  
	 + Traer el screen que no se deja traer con "screen -r name" 
	  screen -rd name
	
	+ Matar screen
	  kill -9 ##### (numero que ha sido asignado al screen)
	  
 + comentar una linea

	# echo "Hola mundo"
	echo "Hola mundo"
	
 + comentar varias lineas 
 
  : '
	codigo comentado, un espcio despues de los dos puntos
	codigo comentado, un espcio despues de los dos puntos
	codigo comentado, un espcio despues de los dos puntos
  '
  
<<COMMENT
	codigo comentado, un espcio despues de los dos puntos
	codigo comentado, un espcio despues de los dos puntos
	codigo comentado, un espcio despues de los dos puntos
COMMENT
  
+ Eliminar una variable
 
  unset $PATH ...

+ Consultas del sistema

	+ especificaciones de la maquina
  
		cat /proc/cpuinfo
		
	+ consultar version sistema operativo
		
		cat /etc/issue
		lsb_release -a     [no funciona en todos los so]
		uname -srv
	+ consultas IPs servidores
	
		cat /etc/hots

+ Comando GREP. Comando para hacer busquedas 

	-- busca la cadena '070716_4_TYP_15814_24057573768226375' en el directorio actual
	-- omitiendo diferencias ente mayusculas y minusculas
	-- Retorna el archivo donde encuentra la cadena y la linea
	-- miArchivo:1: Linea : 4

	$ grep -in 070716_4_TYP_15814_24057573768226375 *
	$ 1F:4:070716_4_typ_15814_24057573768226375,typ_15814_2405757376822 ...

	-- se agrega la opcion '-r' para hacer la busqueda recursivamente
	-- por lo que se encontro una segunda coincidencia en un subfoler 'custom'

	$ grep -inr 070716_4_TYP_15814_24057573768226375 *
	1F:4:070716_4_typ_15814_24057573768226375,typ_15814_24057573768226375,07-07-16 10:10,07-07-16 11:45,070716_4_typ_15814_24057573768226375.target,MT,1,1200
	custom/1F:4:070716_4_typ_15814_24057573768226375,typ_15814_24057573768226375,07-07-16 10:10,07-07-16 11:45,070716_4_typ_15814_24057573768226375.target,MT,1,1200



	grep -rl "name"
	
	variaciones
	 r la busqueda sea recursiva (busca dentro de los folder del directorio actual)
	 n muestra el archivo donde la encontro y no la linea

	 $ cat file
	 gato 
	 perro 
	 Perro 
	 rata 
	 oveja 

	 $ grep \^[\p\P] file
	 Perro 
	 perro 

	 $ grep -i \^\[\b] file
	 Perro 
	 perro s

	 sacar las lineas que contienen caracteres mayusculas / minusculas
	 $ echo -e '123\n 12s3\n aaa \n bbbbb \n AAAA' | egrep -i '[a-z]'

+ Expresiones regulares

  grep [-E] 'regex' fichero

  command | grep [-E] 'regex'

  - opcion -E : es para usar expresiones regulares extendidas

 		
+ Administracion de procesos

	+ Comando PS. Permite informar sobre el estado de los procesos
		
		ps -l muestra opciones como NI,PPID,C,ADDR,UID,S 
		ps -e muestra todos los procesos
		ps -ef muestra opciones completas
		ps -eF muestra opciones completas extras
		ps -eH muestra arbol de procesos
		ps -eo user,pid,tty (-o output personalizado) se indican los campos separados por coma
		ps eo pid,cmd|grep sqlplus
		
		- columnas del comando PS
			
		PID process ID
		PPID parent process ID
		UID user ID, usuario propietario del proceso
		TTY terminal asociada al proceso
		TIME tiempo de uso de cpu acumulado por el proceso
		CMD nombe del programa o comando que inicio el proceso
		NI muestra el valor nice (prioridad) de un proceso
		S estatus del proceso, los valores pueden ser:
			R: runnable, en ejecucion
			S: sleeping, en ejecucion pero sin actividad, o esperando por algun evento para continuar.
			T: sTopped, detenido totalmente, puede ser reiniciado
			Z zombi, proceso que no termino de manera correcta
			D: uninterruptible sleep, procesos asociados a acciones de IO del sistema
			X: dead, muerto, proceso terminado que aun aparece
			
		
	se abre un proceso cualquiera en este caso el reproductor de musica 
		xmms
		presiona ctrl+z para detener el proceso.
	para saber el identificador de la tarea en segundo plano
		jobs -l
		
		xmms 3956
		kmail 3667
	para hacer un kill de un trabajo o proceso
		kill 3956
		
	+ Comando Kill
		-s especifica la señal a enviar
		-pid identificador de proceso o trabajo
		-9 fuerza el kill de un proceso
	
+ Comandos Varios.

	+ ver diferencias entre archivos, indica la linea en que se encuentra la diferencia.
		diff file1 file2
		
		1c1
		< ihola
		---
		> iihola
		
+ Comando WHILE. leer un archivo csv separado con comas.
	
	IFS=,
	while read campo1 campo2
	do
		statement
	done < file.csv
    
   sqlplus -s acaadmin/acaadmin@osds <<FIN 2>&1> /dev/null
     set pagesize 0 trimspool on feedback off heading off linesize 600
     spool $FILE
     select distinct prov_email 
     from v_info_campaign 
     where id_mno = 2 and trunc(start_date) = to_date ('2014-11-22','yyyy-mm-dd');
FIN

	FILE="/PROCESSING/segmentation/tcbaca/tmp/mov01_camp_list.csv"
	while read campId campName listName
	do
		echo "CAMP1: $campId, CAMP2:$campName, CAMP3:$listName"
	done < $FILE


    IFS='|'
    while read EMAIL
    do
      echo " $EMAIL"
    done < $FILE

+ Comando AWK. 

	Sintaxis
	
		awk expresion {accion}
		
		+ Comandos
		  $0	mostrar la linea completas
		  $1 .. $n	mostrar las columnas especificadas
		  FS	definir separador ( valores por defecto son ESPACIO o TAB)
		  NF	numero de columnas en cada linea
		  substr(var,indice inial, numero de caracteres) el inidice empieza en 1

	Para explicar el uso de awk se usara el siguiente archivo
	
	file
		colum1|colum2|colum3
		colum1|colum2|colum3
		colum1|colum2|colum3
		
	+ Usar variables globales con '-v' y doble impresion dentro del cuerpo del AWK.

	let vPrefix=57
	cat datos.csv  |awk -F"," -v vPrefix=$vPrefix -v var2=$val2'{ if( substr($1,0,2) == vPrefix ) print "true"; else print "false" }{ print vPrefix}'
		
	+ Eliminar columna 2. [ Problema: se pierden los separadores]
		
		awk -F'|' '{$2 = "";  print}' file
		
		colum1  colum3
		colum1  colum3
		colum1  colum3

	+ substraer subcadenas
	$ cat aa.csv
	593912345678
	5939912345678
	59312345678
	
	$ cat aa.csv | awk 'length($1) == 12 {print substr($1,5,length($1))} length($1) == 11 {print substr($1,4,length($1))} length($1) == 13 {print substr($1,6,length($1))}'
	12345678
	12345678
	12345678

+ Conteo de registros unicos UNIQ. Para sacar los registros unicos de un archivo lo 
  primero que se debe tener es el archivo ordenado para eso se usa el comando SORT.

	awk -F'|' '{print \"|\" \$1 \"|\" \$3 \"|\" \$7 \"|\"}' file.csv|sort|uniq -c
	
	 + variantes
	 
		-c cuenta el numero de veces que aparace cada registro unico
		
+ Manejo de procesos

 ctrl + z 	para el proceso
 fg # proceso <1>     reanudar el proceso 
 
+ Comando DU. conocer el tamaño de un archivo o directorio
 
  du file    -> 25408 file
  du -h file ->   12M file
  du -h folder -> 1.8 G folder

  opciones :
    -h 	human-readable (Mostrar unidades MB, GB, etc..)
    -s  mostrar solamente el tamaño total de cada argumento

    ej: tmp/
        |_ claro/
        |_ files/

    $ du -h tmp
    4.0K    tmp/claro
	4.0K    tmp/files
	1.8G    tmp

	$ du -sh tmp
	1.8G    tmp


  
	+ variacion con el comando LS
	
	ls -lh file -> -rw-rw-r--   1 user   xx          12M Feb  6 15:34 file

+ extraer nombres y directorios. BASENAME y DIRNAME 
	
	+ Comando BASENAME. devuelve el nombre de un archivo o carpeta de un path

		$ basename /home/user/hola.txt	-> hola.txt
		$ basename /home/user/			-> user

	+ Comando dirname. devuelve el path del archivo

		$ dirname /home/user/hola.txt 	-> /home/user

	+ extarer nombre, extension de una ruta

		fullfile=/home/aca/lista34_sas.txt

		filename=$(basename "$fullfile")
		extension="${filename##*.}"
		filename2="${fullfile%.*}"

		echo "1. $filename 2. $extension 3. $filename2"

		$ 1. lista34_sas 2. txt 3. lista34_sas

	
+ Diferencia entre * y ?

	rm a? 
	rm a*
	
	el a? elimina solo los archivos que comience con a y cualquier caracter depues (solo uno)
	el a* elimina cualquier archivo que comience con a sin importar el resto

+ Comando TZSELECT. Consultar lista de TIMEZONE.

	tzselect
	
	Please identify a location so that time zone rules can be set correctly.
	Please select a continent or ocean.
	 1) Africa
	 2) Americas
	 3) Antarctica
	 4) Arctic Ocean
	 5) Asia
	 6) Atlantic Ocean
	 7) Australia
	 8) Europe
	 9) Indian Ocean
	10) Pacific Ocean
	11) none - I want to specify the time zone using the Posix TZ format.
	#? 2
	Please select a country.
	 1) Anguilla                       28) Haiti
	 2) Antigua & Barbuda              29) Honduras
	 3) Argentina                      30) Jamaica
	 4) Aruba                          31) Martinique
	 5) Bahamas                        32) Mexico
	 6) Barbados                       33) Montserrat
	 7) Belize                         34) Nicaragua
	 8) Bolivia                        35) Panama
	 9) Bonaire Sint Eustatius & Saba  36) Paraguay
	10) Brazil                         37) Peru
	11) Canada                         38) Puerto Rico
	12) Cayman Islands                 39) Sint Maarten
	13) Chile                          40) St Barthelemy
	14) Colombia                       41) St Kitts & Nevis
	15) Costa Rica                     42) St Lucia
	16) Cuba                           43) St Martin (French part)
	17) Curacao                        44) St Pierre & Miquelon
	18) Dominica                       45) St Vincent
	19) Dominican Republic             46) Suriname
	20) Ecuador                        47) Trinidad & Tobago
	21) El Salvador                    48) Turks & Caicos Is
	22) French Guiana                  49) United States
	23) Greenland                      50) Uruguay
	24) Grenada                        51) Venezuela
	25) Guadeloupe                     52) Virgin Islands (UK)
	26) Guatemala                      53) Virgin Islands (US)
	27) Guyana	

+ Comando de VI

	:w 		guardar
	:q 		salir
	:wq		guardar y salir
	:q!		forzar salida sin guardar cambios
	
	ctrl+z 	devolver cambios <u>
	ctrl+y 	rehacer <ctrl+r >
	
	shift +g ir al final del documento
	(#) + G ir a la linea deseada
		8 + G   ira a la linea 8 del documento

+ Conecciones SSH y SCP.

	Para conectarse remotamente a un maquina remota se usa el comando SSH, los
	parametros son:
	
		ssh -C -o "$OPTION" -p $PORT_REMOTO -i $KEY $USER_REMOTA@$IP_REMOTA".. statement .."
		
		variantes
		
			-o da la posivilidad de usar un proxycommand si fuera necesario
			-i especifica la ruta de la key para acceder a la maquina remota
			-C compresion habilitada
			STATEMENTE: son instrucciones que se van hacer en la maquina remota.
			
	Para copiar o enviar archivos de una maquina a otra se usa SCP. la forma de usar
	este es:
	
	
		para copiar archivos desde una maquina remota:
		
		scp -C -P $PORT -i $KEY $USER_REMOTA@$IP_REMOTA:"path_file" $path_file_dest

		scp -C -P $PORT -i $KEY "path_file" $USER_REMOTA@$IP_REMOTA:"remote_path" 
		
		la sintaxis es similar al ssh, aqui despues de la ip de la maquina remota 
		especificamos el path del archivo que se quiere copiar seguido del path donde
		sera copiado.
        
			

 + Problemas con los Crontab
 
 Aveces cuando se deja correr un script en el crontrab y este no se ejecuta, una posible solucion es
 definir en la cabecera del script la linea de  #!/bin/bash
 

 + Cron. Es el mecanismo con el cual se pueden prograr la ejecucion de scripts en el servidor. 

	##########################################################
	#minuto (0-59),                                          #
	#|  hora (0-23),                                         #
	#|  |  día del mes (1-31),                               #
	#|  |  |  mes (1-12),                                    #
	#|  |  |  |  día de la semana (0-6 donde 0=Domingo)      #
	#|  |  |  |  |       comandos                            #
	##########################################################
	15 02  *  *  *	Comando a ser ejecutado


 + Envio de correos 
 
 ~/daily_reports_aca/sendEmail -f no-reply@gemalto.com  $OSP_EMAILS -s 10.170.247.68 -u "Reporte efectividad de campanias PERIODO $INIT_DATE - $END_DATE" -a $FILE -o message-file=/PROCESSING/segmentation/mensaje_proveedores.txt
 
 OSP_EMAILS=" -t emai_1@gg.com -t email_2@gg.com -t email_3@gg.com .." 
 
	opciones
	-f correo desde el que se desea enviar
	-t correos destinatarios
	-u subject
	-a archivo adjunto
	-o archivo con el mensaje del email
 
 -- ------------------------------------------------
 -- Funciones
 -- ------------------------------------------------

#----------------------------------------
#  function: selection decompress command
#----------------------------------------
fFirstCmd() {
    if [ "${1:(-4)}" == ".bz2" ]; then
        vFirstCmd="bzcat"
    elif [ "${1:(-3)}" == ".gz" ] || [ "${1:(-4)}" == ".zip" ]; then
        vFirstCmd="zcat"
    else
        vFirstCmd="cat"
    fi
}

#----------------------------------------
#  function: selection decompress command v2
#  la comparacion es Case Sensitive
#----------------------------------------

FILE="file.csv.gz"
extension="${FILE##*.}"
fFirstCmd $extension

fFirstCmd() {
    if [ "$1" == "bz2" ]; then
        vFirstCmd="bzcat"
    elif [ "$1" == "gz" ] || [ "$1" == "zip" ]; then
        vFirstCmd="zcat"
    else
        vFirstCmd="cat"
    fi
}
 
 # -----------------------------------
 #  Check if a dir is Empty
 # -----------------------------------
 fDirIsEmpty() {
    [ "$(ls -A $1)" ] && echo "Not empty. sentencia 1" || echo "empty sentencia 2"
 }
 
	$1. directorio que se desea comprobar si esta vacio
	&& si la condicion se evaluo true hace la sentencia 1
	|| si la condicion se evaluo false hace sentencia 2

#--------------------------------------------------------
#  function: check prefix 
#  
#  return: A list with: msisdn with prefix, with the correct 
#          length and without trash
#--------------------------------------------------------
CLEAN_LIST=cleanList.txt
PREFIX=1
LEN_MSISDN=10
fun_checkPrefix() {

  cat $1 | egrep -v '^$' | tr -d ' \t\r\f' | sed -e 's/[^0-9]//g' | awk -v vPrefix=$PREFIX -v vlen=$LEN_MSISDN '{ if( substr($1,0,length(vPrefix)) != vPrefix && (vlen-length(vPrefix)) == length($1)) msisdn = vPrefix$1 ; else if( vlen ==length($1) ) msisdn=$1 }{ print msisdn}' | sort -T /PROCESSING/tmp/ -u > $CLEAN_LIST
}


#--------------------------------------------------------
#  function: concatenate fields 
#  
#  return: A variable with the fileds concatenate by ','
#--------------------------------------------------------
fun_concatenate() {
  MSISDN_LIST=""
  
  while read msisdn
  do

    if [ -z $msisdn ]; then continue; fi

    if [ -z "$MSISDN_LIST" ]; then
      MSISDN_LIST=$msisdn
    else
      MSISDN_LIST=$MSISDN_LIST","$msisdn
    fi
  done < $1
}

	
+ Redireccion de salida

	&>filename
      # Redirect both stdout and stderr to file "filename."
      # This operator is now functional, as of Bash 4, final release.
	  
	2>&1
      # Redirects stderr to stdout.
      # Error messages get sent to same place as standard output.
        >>filename 2>&1
            bad_command >>filename 2>&1
            # Appends both stdout and stderr to the file "filename" ...
        2>&1 | [command(s)]
            bad_command 2>&1 | awk '{print $5}'   # found
            # Sends stderr through a pipe.
            # |& was added to Bash 4 as an abbreviation for 2>&1 |.
	
	+ redirigir salida como stderr <&2
	
	func() {
    echo "algo"
    echo "hola" >&2
    rm dada.csv
	}

	func > salida 2> salidaErr

	$ cat salida
	algo
	$ cat salidaErr
	hola
	rm: cannot remove 'dada.csv': No such file or directory
    
   + Aprovisionar KEY en un servidor
   
   - en el servidor 
   $ pwd 
   /home/gxs
   
   $ mkdir .ssh ; chmod 700 .ssh
   $ cd .ssh
   $ touch authorized_keys; chmod 600 authorized_keys
   (modificar el archivo y colocar la key)
   
   + Crear un Alias
   
   $ pwd
   /home/gxs
   
   $ vi .bash
   alias cmoaca="ssh cmoaca@200.186.92.67 -p 23522 -i /home/gxs/.ssh/ckey"

   + Usar los ALIAS dentro de un script

    . ~/.bashrc
	shopt -s expand_aliases
   
   
   + Crear un for para invocar un script pasandole la fecha 
   
   for i in {31..70}
   do
     DATE=`date -d "-$i day" +%F` 
     echo $DATE
     ./aca_ota.sh $DATE 
   done

    for i in {1..10};  do  DATE=`date -d "-$i day" +%F` ; echo $DATE  ; ./aca_ota.sh $DATE done


    + Sumar enteros a una variable

     A=570000000000

    for i in {1..5}
    do 
      B=$((A + i))
      echo $B
    done

    - SUMAR ENTEROS

    num=$((EXPRESION))
    num=$((num1 + num2))
    num=$(($num1 + $num2))
    num=$((num1 + 1 + 2))
   
+ crear un grupo llamado 'aca'
	groupadd aca
	
+ editar los grupos [ como sudo ]
    vi /etc/group

+ editar permisos de un usario
    vi /etc/password
 
+ cambiar grupo de una carpeta 
   chgrp -R aca folder_name
   
+ Saber la arquitectura de linux 64 o 32 bits Comando UNAME
    
    uname -m
  
    x86_64 = Arquitectura de 64 bits.
    i686 = Para arquitecturas de 32 bits.

    $ uname -m
	9000/800
	$ uname -a
	HP-UX uxpga072 B.11.11 U 9000/800 31740275 unlimited-user license
	$ cat /etc/issue
	GenericSysName [HP Release B.11.11] (see /etc/issue)
	$ getconf KERNEL_BITS -- no sirve en todos los UNIX 
	64


+ remover la extesion de un archivo
	
	$ basename campanha_2015.target	.target
	$ campanha_2015

	- para varios archivos 
	
	campanha_2015.target
	campanha_2015_1.target.
   
	$ for i in *.target; do mv -i $i `basename $i .target`; done

+ Operaciones matematicas

  Para asignar el valor de una operacion aritmetica a una variable se puede hacer de 2 formas 

   - forma 1. usando doble parentesis y el comando '$'

    $ A=$((60*15))
    $ echo $A
    $ 900

+ comando SPLIT. este sirve para dividir archivos dependiendo del parametro que quiera el usuario

	SPLIT [opcion] [ archivo [prefijo_output]]


   + opciones 
    -l numero de lineas
    -b tamaño de los archivos de salida (debe ser un múltiplo del sufijo: b 512, kB 1000, K 1024, 
    									MB 1000*1000, M 1024*1024, GB 1000*1000*1000, G 1024*1024*1024)

   dividir un archivo, en archivos de 15 lineas cada uno y que el nombre de los archivos creados tengan versionamiento numerico

   $ split -l 15 -d file.csv  file.
   $ ls file.*
   $ file.00
     file.01
     file.02
     ...

   versionamiento alfabetico

   $ split -l 15 file.csv file.
   $ ls file.*
   $ file.aa
     file.ab 
     file.ac
     ...

  + Enlaces simbolicos

    Creacion de un enlace simbolico ln -s <path a la que se quiere apuntar, folder fisico real> <path por el que se va acceder>

    ln -s /storage/cch_claro /home/aca/smeaca/clarocd
	ln -s /storage/cch_contenta /home/aca/smeaca/contenta

	Elimnar un enlace se usa el comando UNLINK y el enlace que se quiere eliminar

  + Comando LS - l 

	el comando ls -l lista los permisos de los archivos del directorio actual.

	$ ls -l 
	-rwxrw-r--  1 daniel gxs       71 Jan  2  2014 updSus.sh

	  + columnas

	  1. tipo de archivo y los permisos
	  		- el primer caracter representa el tipo de archivo
	  				'-' representa un archivo comun (texto, html,jpg,etc)
	  				'd' representa un directorio
	  				'l' representa un link
	  		- los siguientes 9 caracteres representa los permisos del archivo
	  				rwx 		rwx 		rwx
	  				usuario		grupo 		otros
	  2. (1) es el numero de enlaces al archivo
	  3. daniel representa el propietario del archivo
	  4. gxs representa el grupo al que pertenece
	  5. tamaño
	  6. fecha y hora de la ultima modificacion
	  7. nombre del archivo o directorio


	  	r = 4
		w = 2
		x = 1

		La combinación de bits encendidos o apagados en cada grupo da ocho posibles combinaciones de valores, es decir la suma de los bits encendidos:
		- - -	= 0	no se tiene ningún permiso
		- - x	= 1	solo permiso de ejecución
		- w -	= 2	solo permiso de escritura
		- w x	= 3	permisos de escritura y ejecución
		r - -	= 4	solo permiso de lectura
		r - x	= 5	permisos de lectura y ejecución
		r w -	= 6	permisos de lectura y escritura
		r w x	= 7	todos los permisos establecidos, lectura, escritura y ejecución


if [ -z $CMP_LIST ]; then
    CMP_LIST="'$cmp""'"
else
    CMP_LIST="$CMP_LIST","'$cmp""'"
fi


Comando CUT: ayuda a seprar cadenas de string o archivos completos <similar awk> y ocultar columnas

	H="hola;como;estas"
	echo $H | cut -d';' -f1
	hola
	$ echo $H | cut -d';' -f2
	como
	$ echo $H | cut -d';' -f3

	MNO_INFO=`sqlplus -s acaadmin/acaadmin@osds<<EOF
  set pagesize 0 feedback off
  select TRIGRAM ||'aca' ||'|'|| MSISDN_LEN ||'|'|| PREFIX  from mno where id_mno = $ID_MNO;
EOF`

	USER_MNO=`echo $MNO_INFO | cut -d '|' -f1`
	MSISDN_LEN=`echo $MNO_INFO | cut -d '|' -f2`
	PREFIX=`echo $MNO_INFO | cut -d '|' -f3`

sort: can not write /tmp/sortA3aLjF: No space left on device

Para solucionar esto, es necesario cambiar el directorio temporal a uno de mayor capacidad, así:

Sort --temporary-directory=DIR archivo -> donde DIR sera la partición con mayor capacidad




- Comando XARGS. Cuando corre xargs, este corre comandos una vez para cada palabra pasada a este
	por standar input.

	$ find ./ -name "*~" | xargs -d "\n" rm

		. la primera parte encuentra todos los archivos in el actual directorio o subdirectorios
		. esta lista es entonces pasada a xargs, cual añade a cada entrada su propio comando rm
		 	Nota:   los problemas pueden aparecer si el nombre de los archivos contienen espacios
		 			ya que por defecto xargs usa ambos, spacios y nueva linea (salto de linea) como
		 			delimitadores.

		 	option
		 		-d "\n" le dice a xargs usar solo nueva linea como delimitador. El comando find separa 
		 				cada nombre de archivo encontrado con un salto de linea.

	- borrar los archivos del directorio
	$ ls | xargs rm -rf 

- Comando CAT. muestra el contenido de un archivo, tambien sirve para combinar archivos.

	cat first.txt second.txt > combined.txt

	options
		. -E para ver donde finaliza la linea, el resultado es un dolar en el final de cada linea ($)
			$ cat -E list.txt
			linea uno$
			linea dos$
		. -n añade el numero de linea;
		  -b enumera solo las lineas con texto

		    20  v
		    21  b
		    22  n

		    23  n
		    24  n

		.

-- crea un alias para el ls para que los archivos y directorios se muestren en color

	alias ls='ls --color=auto'
	-- poner color
	echo "alias ls='ls --color=auto'" >> .bashrc
	-- quitar color
	echo "alias ls='ls --color=never'" >> .bashrc

	echo "alias ll='ls -l'" >> .bashrc

	BASH Documentacion

1. Procesos Zombi

 . Un proceso Zombi es aquel q nunca recibio una señal por parte del proceso padre que lo creo.

  - Con el comando TOP podemos saber cuantos hay pero no cuales son.

 	$ top

 	top - 12:33:12 up 153 days, 11:21, 26 users,  load average: 1.85, 3.58, 4.09
	Tasks: 535 total,   1 running, 519 sleeping,   8 stopped,   7 *ZOMBIE*
	Cpu(s): 16.7%us,  3.1%sy,  0.0%ni, 79.6%id,  0.0%wa,  0.0%hi,  0.6%si,  0.0%st
	Mem:  18402220k total, 14986000k used,  3416220k free,   112568k buffers
	Swap:  4194288k total,   837256k used,  3357032k free,  5448576k cached

  	PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND

  - Con los siguientes comandos se pueden ver cuales son exactamente los procesos

  	$ ps -el |grep 'Z' 			
  	$ ps -A -ostat,ppid,pid,cmd | grep -e '^[Zz]'

  	F S   UID   PID  PPID  C PRI  NI ADDR SZ WCHAN  TTY          TIME CMD
	0 Z   507  2310  2308  0  80   0 -     0 exit   pts/51   00:00:00 getFilesFTPDom. <defunct>
	0 Z   507  2454  2333  0  80   0 -     0 exit   pts/68   00:03:41 java <defunct>
	0 Z   507  3468  3063  0  80   0 -     0 exit   ?        00:00:00 sh <defunct>
	0 Z   507 19880 19770  0  80   0 -     0 exit   ?        00:00:00 sh <defunct>
	0 Z   507 22607 22576  0  80   0 -     0 exit   ?        00:00:00 mk_hourly.sh <defunct>
	0 Z   507 24485 24399  0  80   0 -     0 exit   pts/12   01:08:09 java <defunct>
	0 Z   507 31627 31540  1  80   0 -     0 exit   pts/79   01:38:55 java <defunct>

  - Para matar los procesos basta con usar KILL.

    $ kill -9 2310

    # variables de oracle
    export ORACLE_HOME=/opt/oracle/client10/
	export LD_LIBRARY_PATH=/opt/oracle/client10/lib:/lib:/usr/lib:/usr/local/lib
	PATH=$PATH:$HOME/bin:/opt/oracle/client10/bin

+ Saber si una variable contiene un valor numerico

	Una posible solución sería utilizar una expresión regular como la siguiente:

	es_numero='^-?[0-9]+([.][0-9]+)?$'
	if ! [[ $argumento =~ $es_numero ]] ; then
	echo "ERROR: No es un número" >&amp;2; exit 1
	fi
	Esta expresión regular tiene en cuenta los números enteros, los decimales y los números negativos. Si necesitas una comprobación más simple, puedes utilizar las siguientes expresiones regulares alternativas:

	^[0-9]+$, números enteros positivos.
	^[0-9]+([.][0-9]+)?$, números enteros o decimales positivos.


+ Modificar fecha de un archivo

	touch -t timeStamp file

	touch -t 201606110100.30 file

	seria el año 2016, el mes 06, el día 11 a la 1 y oo minutos y 30 segundos

	para ver el resultado con un 'ls -l file'  o 'ls -l --full-time file'

		opciones:

		.  -a : modificar timestamp de acceso
		.  -m : modificar timestamp de modificacion

Check with netstat -ntlp | grep :8009 to see what process is using 8009 already.

jmap -histo:live PID

Con esto podrán obtener un histograma con la cantidad de memoria en detalle que consume cada una de las class del proceso y el total de memoria consumida por el procesos 
PID es el número del proceso que requieren validar


Checkear si un puerto esta arriba
Validar si un servidor esta disponible (system is reachable)

	Single port:

	nc -zv 127.0.0.1 80
	Multiple ports:

	nc -zv 127.0.0.1 22 80 8080
	Range of ports:

	nc -zv 127.0.0.1 20-30


	Netcat is a useful tool:

	nc 127.0.0.1 123 &> /dev/null; echo $?

	Will output 0 if port 123 is open, and 1 if it's closed.

	#!/bin/bash

	wget -q --spider http://google.com

	if [ $? -eq 0 ]; then
	    echo "Online"
	else
	    echo "Offline"
	fi

	-q : Silence mode
	--spider : don't get, just check page availability
	$? : shell return code
	0 : shell "All OK" code


	+Comando TREE. divide la salida mostrandola por consola pero tambien escribiendola en los archivos 
					especificados

		command | tree file.log

		