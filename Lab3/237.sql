-- Utworzyć tabelę bazy danych o nazwie Analityka_Studenci. Tabela powinna zawierać
-- informacje o liczbie egzaminów każdego studenta w każdym z ośrodków. W tabeli
-- utworzyć kolumny opisujące studenta (identyfikator, Nazwisko i imię), ośrodek
-- (identyfikator i nazwa) oraz liczbę egzaminów studenta w danym ośrodku. Dane dotyczące
-- ośrodka i liczby egzaminów należy umieścić w kolumnie, będącej tabelą zagnieżdżoną.
-- Wprowadzić dane do tabeli Analityka_Studenci na podstawie danych zgromadzonych w
-- tabelach Egzaminy, Osrodki i Studenci.

DECLARE
    TYPE tRec_Osrodek IS RECORD (id INT, nazwa varchar2(50), liczba_egzaminow INT);
    TYPE tCol_Osrodki IS TABLE OF tRec_Osrodek;

    tempOsrodki tCol_Osrodki := tCol_Osrodki();
    tempOsrodek tRec_Osrodek;

    TYPE tRec_Student IS RECORD (id INT, imie varchar2(50), nazwisko varchar2(50), osrodki tCol_Osrodki);
    TYPE tColStudenci IS TABLE OF tRec_Student;

    tempStudent tRec_Student;
    tempLiczbaEgzaminow INT;

    analitykaStudentow tColStudenci := tColStudenci();

    CURSOR cStudenci IS
        SELECT  S.ID_STUDENT as id, S.IMIE as imie, S.NAZWISKO as nazwisko
        FROM STUDENCI S
    ;

    CURSOR cOsrodki IS
        SELECT  O.ID_OSRODEK as id, O.NAZWA_OSRODEK as nazwa
        FROM OSRODKI O
    ;

BEGIN
    for student in cStudenci loop
            tempOsrodki := tCol_Osrodki();
            for osrodek in cOsrodki loop
                    SELECT COUNT(*) INTO tempLiczbaEgzaminow FROM EGZAMINY WHERE ID_OSRODEK = osrodek.id AND ID_STUDENT = student.id;
                    tempOsrodek := tRec_Osrodek(osrodek.id, osrodek.nazwa, tempLiczbaEgzaminow);
                    tempOsrodki.extend;
                    tempOsrodki(tempOsrodki.count) := tempOsrodek;
                end loop;
            analitykaStudentow.extend;
            analitykaStudentow(analitykaStudentow.count) := tRec_Student(student.id, student.imie, student.nazwisko, tempOsrodki);
    end loop;
    for i in 1..analitykaStudentow.count loop
            tempStudent := analitykaStudentow(i);
            dbms_output.put_line('============= START Student ' || tempStudent.id || '===============');
            dbms_output.put_line(tempStudent.id || ' ' || tempStudent.imie || ' ' || tempStudent.nazwisko);
            for j in 1..tempStudent.osrodki.count loop
                    tempOsrodek := tempStudent.osrodki(j);
                    dbms_output.put_line('Osrodek ' || tempOsrodek.id || ' - ' || tempOsrodek.nazwa || ', Liczba egzaminów: ' || tempOsrodek.liczba_egzaminow);
                end loop ;
            dbms_output.put_line('============= END Student' || tempOsrodek.id || '===============');
        end loop;
end;
