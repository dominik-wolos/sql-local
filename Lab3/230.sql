-- Utworzyć tabelę zagnieżdżoną o nazwie NT_Osrodki, której elementy będą rekordami.
-- Każdy rekord zawiera dwa pola: Id oraz Nazwa, odnoszące się odpowiednio do
-- identyfikatora i nazwy ośrodka. Następnie zainicjować tabelę, wprowadzając do jej
-- elementów kolejne ośrodki z tabeli Osrodki. Po zainicjowaniu wartości elementów należy
-- wyświetlić ich wartości. Dodatkowo określić i wyświetlić liczbę elementów powstałej
-- tabeli zagnieżdżonej.



declare
    type tRec_Osrodek is record (id number, nazwa varchar2(50)) ;
    type tCol_Osrodki is table of tRec_Osrodek ;
    colOsrodki tCol_Osrodki := tCol_Osrodki();
    cursor c1 is select id_osrodek, nazwa_osrodek from osrodki order by 2 ;
begin
    for vc1 in c1 loop
        colOsrodki.extend;
        colOsrodki(c1%rowcount) := vc1 ;
    end loop ;

    for i in 1..colOsrodki.count loop
        dbms_output.put_line(colOsrodki(i).id || ' ' || colOsrodki(i).nazwa);
        end loop ;
end ;
