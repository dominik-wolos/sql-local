-- -- Zad. dodatkowe 1.
-- -- Utworzyć w bazie danych tabelę o nazwie EgzaminyStat. Tabela ta powinna zawierać następujące 3 kolumny:
-- -- 1. Numer roku
-- -- 2. Numer miesiąca
-- -- 3. Lista przedmiotów wraz z liczbą egzaminowanych studentów i liczbą egzaminów w danym miesiącu danego roku
-- -- Następnie proszę uzupełnić danymi powyższą tabelkę na podstawie danych z tabel Egzaminy i Przedmioty. Po uzupełnieniu tej tabeli, proszę wyświetlić zawartość
-- -- tabeli EgzaminyStat.
-- --
-- -- W kolejnym kroku proszę utworzyć trigger dla tabeli Egzaminy, który spowoduje aktualizację danych w tabeli EgzaminyStat w momencie wstawienia nowego rekordu do tabeli
-- -- Egzaminy. Przeprowadzić test poprawności działania kodu w triggerze.
-- --
--

-- DROP TABLE EgzaminStat;
-- DROP TYPE es_tEgzaminStat;
-- DROP TYPE es_tColPrzedmiot;
-- DROP TYPE es_tPrzedmiot;
--
-- CREATE OR REPLACE TYPE es_tPrzedmiot IS OBJECT (
--     nazwa VARCHAR2(50),
--     qStudent NUMBER,
--     qEgzaminMiesiac NUMBER
-- );
-- CREATE OR REPLACE TYPE es_tColPrzedmiot IS TABLE OF es_tPrzedmiot;
-- CREATE OR REPLACE TYPE es_tEgzaminStat IS OBJECT (
--     rok NUMBER,
--     miesiac NUMBER,
--     przedmioty es_tColPrzedmiot
-- );
-- --
-- CREATE TABLE EgzaminStat (rok NUMBER, miesiac NUMBER, przedmioty es_tColPrzedmiot) NESTED TABLE przedmioty STORE AS ntPrzedmiot;

DECLARE
    tEgzaminStat es_tEgzaminStat;
    tColPrzedmiot es_tColPrzedmiot;
    tPrzedmiot es_tPrzedmiot;

    CURSOR cOkresy IS
        SELECT
            EXTRACT(YEAR  FROM DATA_EGZAMIN) AS rok,
            EXTRACT(MONTH FROM DATA_EGZAMIN) AS miesiac
        FROM EGZAMINY
        GROUP BY
            EXTRACT(YEAR  FROM DATA_EGZAMIN),
            EXTRACT(MONTH FROM DATA_EGZAMIN)
        ORDER BY rok, miesiac;

    CURSOR cPrzedmioty(rok NUMBER, miesiac NUMBER) IS
        SELECT
            EGZAMINY.ID_PRZEDMIOT as id,
            PRZEDMIOTY.NAZWA_PRZEDMIOT AS nazwa,
            COUNT(DISTINCT ID_STUDENT) as qStudent,
            COUNT(EGZAMINY.ID_PRZEDMIOT) as qEgzaminMiesiac
        FROM EGZAMINY INNER JOIN PRZEDMIOTY ON EGZAMINY.ID_PRZEDMIOT = PRZEDMIOTY.ID_PRZEDMIOT
        WHERE EXTRACT(YEAR  FROM DATA_EGZAMIN) = rok AND EXTRACT(MONTH FROM DATA_EGZAMIN) = miesiac
        GROUP BY PRZEDMIOTY.NAZWA_PRZEDMIOT, EGZAMINY.ID_PRZEDMIOT;
BEGIN
    for okres in cOkresy loop

        DBMS_OUTPUT.PUT_LINE(okres.rok || ' ' || okres.miesiac);
        tColPrzedmiot := es_tColPrzedmiot();
        for przedmiot in cPrzedmioty(okres.rok, okres.miesiac) loop
                tPrzedmiot := es_tPrzedmiot(przedmiot.nazwa, przedmiot.qStudent, przedmiot.qEgzaminMiesiac);
                tColPrzedmiot.extend;
                tColPrzedmiot(tColPrzedmiot.last) := tPrzedmiot;
            end loop;
        tEgzaminStat := es_tEgzaminStat(okres.rok, okres.miesiac, tColPrzedmiot);

        INSERT INTO EgzaminStat VALUES (tEgzaminStat.rok, tEgzaminStat.miesiac, tColPrzedmiot);
        end loop;
end;

SELECT * FROM EgzaminStat;


CREATE OR REPLACE TRIGGER trg_EgzaminStat_Insert
    AFTER INSERT ON EGZAMINY
    FOR EACH ROW
DECLARE
    v_rok NUMBER := EXTRACT(YEAR  FROM :NEW.DATA_EGZAMIN);
    v_miesiac NUMBER := EXTRACT(MONTH FROM :NEW.DATA_EGZAMIN);
    record es_tEgzaminStat;
    qStudent NUMBER;
    qEgzamin NUMBER;
    nPrzedmiotNazwa VARCHAR2(50);
    statCount NUMBER;
    colPrzedmiot es_tColPrzedmiot := es_tColPrzedmiot();
BEGIN

    SELECT NAZWA_PRZEDMIOT into nPrzedmiotNazwa FROM PRZEDMIOTY WHERE ID_PRZEDMIOT = :NEW.ID_PRZEDMIOT;

    SELECT COUNT(*) INTO statCount FROM EgzaminStat WHERE rok = v_rok AND miesiac = v_miesiac;

    IF statCount > 0 THEN
        SELECT * INTO record FROM EgzaminStat WHERE rok = v_rok AND miesiac = v_miesiac;

        SELECT COUNT(DISTINCT ID_STUDENT) INTO qStudent FROM EGZAMINY
            WHERE ID_PRZEDMIOT = :NEW.ID_PRZEDMIOT
            AND EXTRACT(YEAR  FROM DATA_EGZAMIN) = v_rok
            AND EXTRACT(MONTH FROM DATA_EGZAMIN) = v_miesiac;

        SELECT COUNT(ID_EGZAMIN) INTO qEgzamin FROM EGZAMINY WHERE ID_PRZEDMIOT = :NEW.ID_PRZEDMIOT
            AND EXTRACT(YEAR  FROM DATA_EGZAMIN) = v_rok
            AND EXTRACT(MONTH FROM DATA_EGZAMIN) = v_miesiac;

        for i in 1..record.przedmioty.count loop
                if nPrzedmiotNazwa = record.przedmioty(i).nazwa then
                record.przedmioty(i).qStudent := qStudent;
                record.przedmioty(i).qEgzaminMiesiac := qEgzamin;

                UPDATE EGZAMINSTAT
                    SET przedmioty = record.przedmioty
                    WHERE rok = v_rok AND miesiac = v_miesiac;
                return;
            end if;
        end loop;

        record.PRZEDMIOTY.extend;
        record.przedmioty(record.przedmioty.last) := es_tPrzedmiot(nPrzedmiotNazwa, 1, 1);
        UPDATE EGZAMINSTAT
        SET przedmioty = record.przedmioty
        WHERE rok = v_rok AND miesiac = v_miesiac;
    ELSE
        colPrzedmiot.extend;
        colPrzedmiot(colPrzedmiot.last) := es_tPrzedmiot(nPrzedmiotNazwa, 1, 1);

        INSERT INTO EgzaminStat
            VALUES (v_rok, v_miesiac, colPrzedmiot);
    END IF;
end;
