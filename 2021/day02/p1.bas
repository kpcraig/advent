1 REM This is CBM Basic
2 V% = 0
3 H% = 0
4 SKIP% = 0
10 OPEN 1,1,0,"input"
20 GET#1,C$ : REM Get "command"
25 IF C$ = CHR$(199) THEN 200: REM if eof, then quit
30 IF C$ = "f" THEN SKIP% = 6
31 IF C$ = "d" THEN SKIP% = 3
32 IF C$ = "u" THEN SKIP% = 1
40 FOR S = 0 TO SKIP%
45 GET#1,A$: REM dump
50 NEXT S
60 GET#1,A$
70 IF C$ = "f" THEN H% = H% + VAL(A$)
71 IF C$ = "d" THEN V% = V% + VAL(A$)
72 IF C$ = "u" THEN V% = V% - VAL(A$)
100 GET#1,A$: REM Consume carriage return
110 GOTO 20
200 CLOSE 1
210 PRINT V%
220 PRINT H%
230 PRINT V% * H%
