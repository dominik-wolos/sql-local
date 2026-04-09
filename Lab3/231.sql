
-- https://docs.oracle.com/en/database/oracle/oracle-database/19/lnpls/collection-methods.html#GUID-E43509F6-5044-4B17-9516-2EB4BDDD5173__CIHJFHJE
declare
    type tRec_Osrodek is record (id number, nazwa varchar2(50)) ;
    type tCol_Osrodki is table of tRec_Osrodek ;
    colOsrodki tCol_Osrodki := tCol_Osrodki() ;
    cursor c1 is select id_osrodek, nazwa_osrodek from osrodki order by 2 ;
    x number ;
begin
    for vc1 in c1 loop
            ColOsrodki.extend ;
            ColOsrodki(c1%rowcount) := vc1 ;
        end loop ;
    for i in 1..ColOsrodki.count loop
            dbms_output.put_line(ColOsrodki(i).nazwa || ' (' || ColOsrodki(i).id || ')') ;
        end loop ;
    for i in 1..ColOsrodki.count loop
            begin
                select distinct 1 into x from egzaminy where id_osrodek = ColOsrodki(i).id  ;
            exception
                when no_data_found then
                    ColOsrodki.delete(i) ;
            end ;
        end loop ;

    for i in 1..ColOsrodki.count loop
            if ColOsrodki.EXISTS(i) then
                dbms_output.put_line(ColOsrodki(i).nazwa || ' (' || ColOsrodki(i).id || ')') ;
            end if ;
        end loop ;
end ;
