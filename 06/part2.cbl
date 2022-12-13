      * Compile: `cobc -x part2.cbl`
       IDENTIFICATION DIVISION.
       PROGRAM-ID.  AOC06PT1.


       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
         FILE-CONTROL.
           SELECT INFILE ASSIGN TO "input.txt"
           ORGANIZATION IS SEQUENTIAL
           ACCESS MODE IS SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.
         FD INFILE.
         01 CURRENTCHAR PIC X.

       WORKING-STORAGE SECTION.
         01 WS-CURRENTCHAR PIC X.
         01 WS-LAST PIC X(13) VALUE '-------------'.
         01 WS-IDX PIC 9999 VALUE 0000.
         01 WS-MORE-RECORDS-SW PIC X VALUE 'Y'.
            88 MORE-RECORDS-SW VALUE 'Y'.
            88 NO-MORE-RECORDS-SW VALUE 'N'.
         01 WS-NEEDED-OFFSET PIC 99 VALUE 14.
         01 WS-CTX PIC 99.

       PROCEDURE DIVISION.
           PERFORM 000-INIT THRU 000-EXIT.
           PERFORM 100-MAIN THRU 100-EXIT
                   UNTIL NO-MORE-RECORDS-SW.
           PERFORM 200-CLEANUP THRU 200-EXIT.
           GOBACK.

       000-INIT.
           OPEN INPUT INFILE.
       000-EXIT.
           EXIT.

       100-MAIN.
           READ INFILE INTO WS-CURRENTCHAR 
               AT END MOVE "N" TO WS-MORE-RECORDS-SW
               GO TO 100-EXIT
           END-READ.

           ADD 1 TO WS-IDX.

           PERFORM 150-CMP-CHARS THRU 150-EXIT
           VARYING WS-CTX FROM 1 BY 1 UNTIL WS-CTX = 14.

           IF WS-NEEDED-OFFSET <= 0 THEN
              MOVE "N" TO WS-MORE-RECORDS-SW
              GO TO 100-EXIT
           END-IF.

           MOVE WS-LAST(2:12) TO WS-LAST(1:12).
           MOVE WS-CURRENTCHAR TO WS-LAST(13:1).
           SUBTRACT 1 FROM WS-NEEDED-OFFSET.
       100-EXIT.
           EXIT.

       150-CMP-CHARS.
           IF WS-LAST(WS-CTX:1) = WS-CURRENTCHAR
           AND WS-CTX > WS-NEEDED-OFFSET
           THEN
           MOVE WS-CTX TO WS-NEEDED-OFFSET
           END-IF.
       150-EXIT.

       200-CLEANUP.
           CLOSE INFILE.
           DISPLAY WS-IDX.
       200-EXIT.
           EXIT.
