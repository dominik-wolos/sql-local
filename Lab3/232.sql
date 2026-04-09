-- Utworzyć kolekcję typu tablica zagnieżdżona o nazwie Indeks. Tabela powinna zawierać informacje o
-- studencie (identyfikator, Nazwisko, imię), przedmiotach (nazwa przedmiotu), z których
-- student zdał już swoje egzaminy oraz datę zdanego egzaminu. Lista przedmiotów wraz z
-- datami dla danego studenta powinna być kolumną typu tabela zagnieżdżona. Dane w tabeli
-- Indeks należy wygenerować na podstawie zawartości tabeli Egzaminy, Studenci oraz
-- Przedmioty.



-- Zad. 232 - Dominik Wołos

-- CREATE OR REPLACE type tRec_Przedmiot is OBJECT (nazwaPrzedmiot varchar2(50), dataEgzaminu date);
-- CREATE OR REPLACE TYPE tColPrzedmioty is table of tRec_Przedmiot;
-- CREATE OR REPLACE TYPE tRec_Student is OBJECT (id number, fName varchar2(50), lName varchar2(50), przedmioty tColPrzedmioty);
-- CREATE OR REPLACE TYPE tColStudenci is table of tRec_Student;
--
-- CREATE TABLE T_STUDENCI (ID NUMBER, fName VARCHAR2(50), lName VARCHAR2(50), przedmioty tColPrzedmioty) NESTED TABLE przedmioty STORE AS rPrzedmioty;

DECLARE
--     type tRec_Przedmiot is record (nazwaPrzedmiot varchar2(50), dataEgzaminu date);
    rPrzedmiot tRec_Przedmiot;

--     type tCol_Przedmioty is table of tRec_Przedmiot;
    colPrzedmioty tColPrzedmioty := tColPrzedmioty();

--     type tRec_Student is record (id number, fName varchar2(50), lName varchar2(50), przedmioty tColPrzedmioty);
    rStudent tRec_Student;

    type tCol_Studenci is table of tRec_Student;
    colStudenci tCol_Studenci := tCol_Studenci();

    CURSOR cStudenci is SELECT ID_STUDENT as id, IMIE as fName, NAZWISKO as lName FROM STUDENCI;
    CURSOR cPrzedmioty(id number) is
        SELECT PRZEDMIOTY.NAZWA_PRZEDMIOT AS NazwaPrzedmiot,
               MIN(EGZAMINY.DATA_EGZAMIN)  AS dataEgzaminu
        FROM PRZEDMIOTY
                 INNER JOIN EGZAMINY ON PRZEDMIOTY.ID_PRZEDMIOT = EGZAMINY.ID_PRZEDMIOT
        WHERE EGZAMINY.ID_STUDENT = id
          AND EGZAMINY.ZDAL='T'
        GROUP BY PRZEDMIOTY.NAZWA_PRZEDMIOT
    ;
BEGIN
    for student in cStudenci loop
            colStudenci.extend;
            -- rStudent.id := student.id;

            colPrzedmioty := tColPrzedmioty(); --czyscimy kolekcje

            for przedmiot in cPrzedmioty(student.id) loop
                    colPrzedmioty.extend;
                    rPrzedmiot := tRec_Przedmiot(przedmiot.NazwaPrzedmiot, przedmiot.dataEgzaminu);

                    colPrzedmioty(colPrzedmioty.last) := rPrzedmiot;
                end loop;

            -- rStudent.fName := student.fName;
            -- rStudent.lName := student.lName;
            -- rStudent.przedmioty := colPrzedmioty;
            rStudent := tRec_Student(student.id, student.fName, student.lName, colPrzedmioty);
            colStudenci(colStudenci.last) := rStudent;
            INSERT INTO T_STUDENCI VALUES (rStudent.id, rStudent.fName, rStudent.lName, colPrzedmioty);
        end loop;

    for i in 1..colStudenci.count loop
            rStudent := colStudenci(i);
            dbms_output.put_line('============= START Student ' || rStudent.id || '===============');
            dbms_output.put_line(rStudent.id || ' ' || rStudent.fName || ' ' || rStudent.lName);
            for j in 1..rStudent.przedmioty.count loop
                    rPrzedmiot := rStudent.przedmioty(j);
                    dbms_output.put_line('Przedmiot: ' || rPrzedmiot.nazwaPrzedmiot || ' ' ||', Data zdanego egzaminu: ' ||rPrzedmiot.dataEgzaminu);
                end loop ;
            dbms_output.put_line('============= END Student' || rStudent.id || '===============');
        end loop;
end;
