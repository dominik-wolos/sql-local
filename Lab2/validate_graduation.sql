CREATE OR REPLACE PACKAGE validate_graduation IS
    FUNCTION getSubjectsCount RETURN INT;
    FUNCTION checkStudentPassedExamsFromAllSubjects(studentId INT, subjectCount INT) RETURN BOOLEAN;
    FUNCTION getLastExamDate(studentId INT) RETURN DATE;
END validate_graduation;

CREATE OR REPLACE PACKAGE BODY validate_graduation IS
    FUNCTION getSubjectsCount RETURN INT IS
        subjectsCount INT;
    BEGIN
        SELECT COUNT(*) INTO subjectsCount FROM PRZEDMIOTY;
        RETURN subjectsCount;
    END getSubjectsCount;

    FUNCTION checkStudentPassedExamsFromAllSubjects(studentId INT, subjectCount INT) RETURN BOOLEAN IS
        studentExamsPassedCount INT;
    BEGIN
        SELECT COUNT(DISTINCT(EGZAMINY.ID_PRZEDMIOT)) INTO studentExamsPassedCount FROM EGZAMINY
        WHERE ID_STUDENT = studentId AND ZDAL = 'T'
        GROUP BY ID_STUDENT
        ;
        RETURN studentExamsPassedCount = subjectCount;
    END checkStudentPassedExamsFromAllSubjects;

    FUNCTION getLastExamDate(studentId INT) RETURN DATE IS
        lastExamDate DATE;
        examDateInFuture EXCEPTION;
    BEGIN
        SELECT x.DATA_EGZAMIN INTO lastExamDate FROM EGZAMINY x
        WHERE x.ID_STUDENT = studentId
        ORDER BY x.DATA_EGZAMIN DESC
            FETCH FIRST 1 ROWS ONLY
        ;

        IF lastExamDate > SYSDATE THEN
            raise examDateInFuture;
        END IF;

        RETURN lastExamDate;
    EXCEPTION
        WHEN examDateInFuture THEN
            DBMS_OUTPUT.PUT_LINE('Student ' || studentId || ' has last exam date in the future');
            RETURN SYSDATE;
    END getLastExamDate;
END validate_graduation;

CREATE OR REPLACE PROCEDURE setStudentData(studentId INT, lastExamDate DATE, IsUpdated OUT BOOLEAN) IS
BEGIN
    UPDATE STUDENCI SET NR_ECDL = studentId, DATA_ECDL = lastExamDate WHERE ID_STUDENT = studentId;
    COMMIT;
    IsUpdated := TRUE ;
exception
    WHEN Others THEN
        IsUpdated := FALSE ;
end setStudentData;

DECLARE
    subjectCount INT;
    lastExamDate DATE;
    IsUpdated BOOLEAN;
    CURSOR cStudent IS
        SELECT s.ID_STUDENT as student FROM STUDENCI s;

BEGIN
    subjectCount := validate_graduation.getSubjectsCount();
    FOR student IN cStudent LOOP
            IF validate_graduation.checkStudentPassedExamsFromAllSubjects(student.student, subjectCount) THEN
                lastExamDate := validate_graduation.getLastExamDate(student.student);
                DBMS_OUTPUT.PUT_LINE(student.student || ' has passed all subjects at '|| lastExamDate);
                setStudentData(student.student, lastExamDate, IsUpdated);

                IF isUpdated THEN
                    DBMS_OUTPUT.PUT_LINE('Student' || student.student || ' - data has been updated ');
                ELSE
                    DBMS_OUTPUT.PUT_LINE('Student' || student.student || ' - data update failed');
                END IF;
            ELSE
                DBMS_OUTPUT.PUT_LINE(student.student || ' HAS NOT PASSED ALL SUBJECTS');
            END IF;
        END LOOP;
end;

