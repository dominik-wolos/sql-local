-- Wskazać tych egzaminatorów, którzy przeprowadzili egzaminy w ciągu trzech ostatnich
-- dni egzaminowania. W odpowiedzi umieścić datę egzaminu oraz dane identyfikujące
-- egzamnatora tj. identyfikator, imię i nazwisko.

DECLARE
    CURSOR cExams IS
        SELECT DISTINCT e.DATA_EGZAMIN data
        FROM EGZAMINY e
        ORDER BY e.DATA_EGZAMIN DESC
            FETCH FIRST 3 ROWS ONLY
    ;
    CURSOR cExaminers(vDate DATE) IS
        SELECT e.ID_EGZAMINATOR id ,e.IMIE fName, e.NAZWISKO lName  FROM EGZAMINATORZY e
                                                                             INNER JOIN EGZAMINY x ON e.ID_EGZAMINATOR = x.ID_EGZAMINATOR
        WHERE x.DATA_EGZAMIN = vDate
    ;
BEGIN
    for cExam in cExams loop
            for cExaminer in cExaminers(cExam.data) loop
                    DBMS_OUTPUT.PUT_LINE(cExam.data || ' ' ||cExaminer.id || ' ' || cExaminer.fName || ' ' || cExaminer.lName);
                end loop;
        end loop;
end;
