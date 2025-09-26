       IDENTIFICATION DIVISION.
       PROGRAM-ID. collatz-conjecture.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-NUMBER PIC S9(8).
       01 WS-STEPS PIC 9(4).
       01 WS-ERROR PIC X(35).

       PROCEDURE DIVISION.
       COLLATZ-CONJECTURE.
           IF WS-NUMBER <= 0
               MOVE "Only positive integers are allowed" TO WS-ERROR
               EXIT PARAGRAPH
           END-IF

           PERFORM UNTIL WS-NUMBER = 1
               ADD 1 TO WS-STEPS
               IF FUNCTION REM(WS-NUMBER, 2) = 1
                   COMPUTE WS-NUMBER = 3 * WS-NUMBER + 1
               ELSE
                   COMPUTE WS-NUMBER = WS-NUMBER / 2
               END-IF
           END-PERFORM.
