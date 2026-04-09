CREATE OR REPLACE TRIGGER examCountTrigger
    BEFORE
        INSERT
    ON EGZAMINY
    FOR EACH ROW
DECLARE
    studentId NUMBER;
    subjectId NUMBER;
    tooManyExams EXCEPTION;
    PRAGMA EXCEPTION_INIT (tooManyExams, -20001);
    PROCEDURE verifyExamCount(studentId NUMBER, subjectId NUMBER) IS
        examCount NUMBER;
    BEGIN
        SELECT COUNT(*) INTO examCount FROM EGZAMINY x WHERE x.ID_STUDENT = studentId AND x.ID_PRZEDMIOT = subjectId;

        IF (examCount < 3) THEN
            RETURN;
        END IF;

        raise_application_error(-20001, 'Student ' || studentId || ' already took 3 exams from this subject');
    END verifyExamCount;
    PROCEDURE verifyNotPassedYet(studentId NUMBER, subjectId NUMBER) IS
        passedExamId NUMBER;
    BEGIN
        SELECT x.ID_EGZAMIN INTO passedExamId FROM EGZAMINY x
            WHERE x.ID_STUDENT = studentId
                AND x.ID_PRZEDMIOT = subjectId
                AND x.ZDAL = 'T'
            ;

        IF (passedExamId IS NOT NULL) THEN
            RETURN;
        END IF;

        raise_application_error(-20002, 'Student ' || studentId || ' already passed this subject');
    END verifyNotPassedYet;
BEGIN
    CASE
        WHEN INSERTING THEN
            studentId := :NEW.ID_STUDENT;
            subjectId := :NEW.ID_PRZEDMIOT;
            verifyNotPassedYet(studentId, subjectId);
            verifyExamCount(studentId, subjectId);
        END CASE;
END;

DECLARE
    studentId NUMBER := 0000001;
    tooManyExams EXCEPTION;
    passedAlready EXCEPTION;
    PRAGMA EXCEPTION_INIT (tooManyExams, -20001);
    PRAGMA EXCEPTION_INIT (passedAlready, -20002);
BEGIN
    INSERT INTO EGZAMINY (
        ID_EGZAMIN,
        ID_STUDENT,
        ID_PRZEDMIOT,
        ID_EGZAMINATOR,
        DATA_EGZAMIN,
        ID_OSRODEK,
        ZDAL,
        PUNKTY
    )
    VALUES (
        1000004,
        studentId,
        1,
        '0003',
        DATE '2012-06-14',
        7,
        'T',
        2.91
    );
    COMMIT;
EXCEPTION
    WHEN tooManyExams THEN
        DBMS_OUTPUT.PUT_LINE('Student ' || studentId ||' already took 3 exams from this subject');
    WHEN passedAlready THEN
        DBMS_OUTPUT.PUT_LINE('Student ' || studentId ||' already passed this subject');
END;
