-- Wskazać trzy przedmioty, z których przeprowadzono najwięcej egzaminów.
-- W odpowiedzi umieścić nazwę przedmiotu oraz liczbę egzaminów.

DECLARE
    CURSOR cExamCount IS
        SELECT COUNT(*) examNum FROM EGZAMINY
        GROUP BY ID_PRZEDMIOT
        ORDER BY 1 DESC
            FETCH FIRST 3 ROWS ONLY
    ;
    CURSOR cExams(examNum NUMBER) IS
        SELECT PRZEDMIOTY.NAZWA_PRZEDMIOT FROM PRZEDMIOTY
                                                   INNER JOIN EGZAMINY ON PRZEDMIOTY.ID_PRZEDMIOT = EGZAMINY.ID_PRZEDMIOT
        GROUP BY PRZEDMIOTY.NAZWA_PRZEDMIOT
        HAVING COUNT(PRZEDMIOTY.NAZWA_PRZEDMIOT) = examNum
    ;
BEGIN
    for row in cExamCount loop
            for iRow in cExams(row.examNum) loop
                    DBMS_OUTPUT.PUT_LINE(iRow.NAZWA_PRZEDMIOT || ' ' || row.examNum);
                end loop;
        end loop;
end;
