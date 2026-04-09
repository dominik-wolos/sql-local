DECLARE
    subjectCount INT;
    lastExamDate DATE;
    IsUpdated BOOLEAN;
    CURSOR cStudent IS
        SELECT s.ID_STUDENT as student FROM STUDENCI s;

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

    PROCEDURE setStudentData(studentId INT, lastExamDate DATE, IsUpdated OUT BOOLEAN) IS
    BEGIN
        UPDATE STUDENCI SET NR_ECDL = studentId, DATA_ECDL = lastExamDate WHERE ID_STUDENT = studentId;
        COMMIT;
        IsUpdated := TRUE ;
    exception
        WHEN Others THEN
            IsUpdated := FALSE ;
    end setStudentData;

BEGIN
    subjectCount := getSubjectsCount();
    FOR student IN cStudent LOOP
            IF checkStudentPassedExamsFromAllSubjects(student.student, subjectCount) THEN
                lastExamDate := getLastExamDate(student.student);
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

