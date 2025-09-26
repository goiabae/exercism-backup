       IDENTIFICATION DIVISION.
       PROGRAM-ID. DARTS.
       ENVIRONMENT DIVISION.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-X PIC 99V9.
       01 WS-Y PIC 99V9.
       01 WS-DIST PIC 99V999.
       01 WS-RESULT PIC 99.
       PROCEDURE DIVISION.
       DARTS.
           COMPUTE WS-DIST = FUNCTION SQRT(WS-X * WS-X + WS-Y * WS-Y)
           IF WS-DIST > 10
               MOVE 0 TO WS-RESULT
           ELSE
               IF WS-DIST > 5
                   MOVE 1 TO WS-RESULT
               ELSE
                   IF WS-DIST > 1
                       MOVE 5 TO WS-RESULT
                   ELSE
                       MOVE 10 TO WS-RESULT
                   END-IF
               END-IF
           END-IF.
