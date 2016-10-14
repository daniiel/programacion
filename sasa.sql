DECLARE
  mno_Id    number(2) := 11;
  mnoName   varchar(45);
BEGIN 
  select mno_name into mnoName
  from mno
  where id_mno = mno_Id;
  
  DBMS_OUTPUT.PUT_LINE('El nombre del mno es: ' || mnoName  );
END;
/