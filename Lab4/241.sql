-- DROP TABLE Przedmioty_Terminy;
--
-- CREATE TABLE Przedmioty_Terminy
-- (
--     nazwaPrzedmiotu varchar2(50),
--     daty tColDates
-- ) NESTED TABLE daty STORE AS ntDaty;
-- /



DECLARE
    CURSOR cPrzedmioty IS SELECT p.ID_PRZEDMIOT, p.NAZWA_PRZEDMIOT
                          FROM PRZEDMIOTY p
                          ORDER BY p.NAZWA_PRZEDMIOT
    ;

    CURSOR cDatyEgzaminy(idPrzedmiot NUMBER) IS
        SELECT DISTINCT DATA_EGZAMIN
        FROM EGZAMINY e
        WHERE e.ID_PRZEDMIOT = idPrzedmiot
        ORDER BY e.DATA_EGZAMIN
    ;
    cDaty tColDates := tColDates();

BEGIN
    for przedmiot in cPrzedmioty loop
            cDaty := tColDates();
            for egzamin in cDatyEgzaminy(przedmiot.ID_PRZEDMIOT) loop
                    cDaty.extend;
                    cDaty(cDaty.last) := egzamin.DATA_EGZAMIN;
                end loop;

            INSERT INTO Przedmioty_Terminy VALUES (przedmiot.NAZWA_PRZEDMIOT, cDaty);
        end loop;
end;


SELECT * FROM Przedmioty_Terminy;
