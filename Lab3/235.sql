-- Utworzyć tabelę bazy danych o nazwie Analityka. Tabela powinna zawierać informacje o
-- liczbie egzaminów poszczególnych egzaminatorów w poszczególnych ośrodkach. W tabeli
-- utworzyć kolumny opisujące ośrodek (identyfikator oraz nazwa), egzaminatora
-- (identyfikator, imię i Nazwisko) oraz liczbę egzaminów egzaminatora w danym ośrodku.
-- Dane dotyczące egzaminatora i liczby jego egzaminów należy umieścić w kolumnie,
-- będącej tabelą zagnieżdżoną. Wprowadzić dane do tabeli Analityka na podstawie danych
-- zgromadzonych w tabelach Egzaminy, Osrodki i Egzaminatorzy.

DECLARE
    TYPE tRec_Egzaminator IS RECORD (id INT, imie varchar2(50), nazwisko varchar2(50), liczba_egzaminow INT);
    TYPE tCol_Egzaminator IS TABLE OF tRec_Egzaminator;

    tempEgzaminatorzy tCol_Egzaminator := tCol_Egzaminator();
    tempEgzaminator tRec_Egzaminator;

    TYPE tRec_Osrodek IS RECORD (id INT, nazwa varchar2(50), egzaminatorzy tCol_Egzaminator);
    TYPE tCol_Osrodek IS TABLE OF tRec_Osrodek;

    tempOsrodek tRec_Osrodek;

    analityka tCol_Osrodek := tCol_Osrodek();

    tempLiczbaEgzaminow INT;

    CURSOR cEgzaminatorzy(osrodekId INT) IS
        SELECT  DISTINCT E.ID_EGZAMINATOR as id, E.IMIE as imie, E.NAZWISKO as nazwisko
            FROM Egzaminatorzy E
            INNER JOIN EGZAMINY Ex ON Ex.ID_EGZAMINATOR = E.ID_EGZAMINATOR
            INNER JOIN OSRODKI O ON Ex.ID_OSRODEK = O.ID_OSRODEK
            WHERE O.ID_OSRODEK = osrodekId
        ;

    CURSOR cOsrodki IS
        SELECT  O.ID_OSRODEK as id, O.NAZWA_OSRODEK as nazwa
            FROM OSRODKI O
    ;

    CURSOR cEgzaminyOsrodekEgzaminator(o_id INT, e_id INT) IS
        SELECT COUNT(*) FROM EGZAMINY Ex WHERE Ex.ID_OSRODEK = o_id AND Ex.ID_EGZAMINATOR = e_id
    ;
BEGIN
    for osrodek IN cOsrodki loop
            tempEgzaminatorzy := tCol_Egzaminator();

            for egzaminator IN cEgzaminatorzy(osrodek.id) loop
                    OPEN cEgzaminyOsrodekEgzaminator(osrodek.id, egzaminator.id);
                    FETCH cEgzaminyOsrodekEgzaminator INTO tempLiczbaEgzaminow;
                    CLOSE cEgzaminyOsrodekEgzaminator;

                    tempEgzaminator := tRec_Egzaminator(
                        egzaminator.id,
                        egzaminator.imie,
                        egzaminator.nazwisko,
                        tempLiczbaEgzaminow
                    );

                    tempEgzaminatorzy.extend;
                    tempEgzaminatorzy(tempEgzaminatorzy.last) := tempEgzaminator;
                end loop;
            tempOsrodek := tRec_Osrodek(osrodek.id, osrodek.nazwa, tempEgzaminatorzy);
            analityka.extend;
            analityka(analityka.last) := tempOsrodek;
        end loop;

    for i in 1..analityka.count loop
            tempOsrodek := analityka(i);
            dbms_output.put_line('============= START Osrodek ' || tempOsrodek.id || '===============');
            dbms_output.put_line(tempOsrodek.id || ' ' || tempOsrodek.nazwa);
            for j in 1..tempOsrodek.egzaminatorzy.count loop
                    tempEgzaminator := tempOsrodek.egzaminatorzy(j);
                    dbms_output.put_line('Egzaminator ' || tempEgzaminator.id || ' - ' || tempEgzaminator.imie || ' ' || tempEgzaminator.nazwisko || ', Liczba przeprowadzonych egzaminów: ' ||tempEgzaminator.liczba_egzaminow);
                end loop ;
            dbms_output.put_line('============= END Osrodek' || tempOsrodek.id || '===============');
        end loop;
end;
