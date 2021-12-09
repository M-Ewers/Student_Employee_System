**FREE

//Files
  Dcl-F SISDIP WorkStn indds(indy) SFILE(newcoursfl:rrn) SFILE(newstudsfl:rrn)
                                   SFILE(studetsfl:rrn);
 //Physical Files
  Dcl-F USERS DISK Usage(*update) Keyed;
  Dcl-F SUBMASTER DISK Usage(*update:*output) Keyed;
  Dcl-F CORMASTER DISK Usage(*update:*output) Keyed;
  Dcl-F SEMMASTER DISK Usage(*update:*output) Keyed;
  Dcl-F STUMASTER DISK Usage(*update:*output) Keyed;
  Dcl-F SUBCOURSE1 DISK Usage(*update:*output) Keyed;
  Dcl-F STUDETAILS DISK Usage(*update:*output) Keyed;
 //Logical Files
  Dcl-F SUBCOURLF DISK;
  Dcl-F STUDETLOG DISK;

  Dcl-DS passbys Qualified;
    returncode Zoned(3:0);
    username1 char(10);
  END-DS;

 //Varibles
  Dcl-S RRN zoned(4:0);

//Indicator Data Structure
  Dcl-DS indy len(99);
    exit ind pos(03);
    refresh ind pos(05);
    save ind pos(08);
    fold ind pos(11);
    cancel ind pos(12);
    subclear3 ind pos(35);
    sfldsp ind pos(36);
    subclear2 ind pos(45);
    subclear ind pos(50);
    nxtChange ind pos(90);
  END-DS;

//Programs
  Dcl-Pr firstLogin LIKEDS(passbys) ExtProc;
    logged zoned(1:0);
  End-Pr;
  Dcl-Pr addsubject zoned(3) ExtProc;
    hname char(10);
  End-Pr;
  Dcl-Pr Courser zoned(3) ExtProc;
    hname char(10);
  End-Pr;
  Dcl-Pr newStud zoned(3) ExtProc;
    hname char(10);
  End-Pr;
  Dcl-Pr stuDets zoned(3) ExtProc;
    hname char(10);
  End-Pr; 
