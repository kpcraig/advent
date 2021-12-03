10 REM READ FILE
11 DIM V(3)
12 I% = 0
15 OPEN 1,1,0,"input"
20 FOR S=0 TO 1
30 GET#1,A$
31 IF A$ = CHR$(13) THEN 49: REM If CR, do nothing
33 IF A$ = "x" OR A$ = CHR$(10) THEN 36: REM x or eol, store num
34 NUM$ = NUM$ + A$
35 GOTO 49: REM Done for numeric character
36 V(I%) = VAL(NUM$)
37 NUM$ = "": I% = I% + 1
38 IF A$ = "x" THEN 49: REM All done, if LF, process values
40 REM All values stored
41 GOSUB 1000: REM puts values
42 T = T + M + VO
48 I% = 0
49 REM
50 S=255 AND ST
60 NEXT S
70 CLOSE 1
75 PRINT T
80 END
1000 REM handle v%s
1009 M = 0
1010 P1 = 2 * V(0) + 2 * V(1)
1011 P2 = 2 * V(1) + 2 * V(2)
1012 P3 = 2 * V(0) + 2 * V(2)
1013 IF P1 <= P2 THEN M = P1
1014 IF P2 < P1 THEN M = P2
1015 IF P3 < M THEN M = P3
1017 VO = V(0) * V(1) * V(2)
1020 RETURN
