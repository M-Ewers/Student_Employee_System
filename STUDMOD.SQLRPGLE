**FREE

Ctl-Opt NOMAIN;

/copy qrpgleref,siscpybk


Dcl-PROC newStud export;
  Dcl-Pi newStud zoned(3);
    hname char(10);
  END-PI;

//varibles
  Dcl-S returnCode zoned(3);
  Dcl-S detID zoned(5);

//clearing for call
  cancel = *off;
  exit = *off;
  Husername = hname;
  clear *all(newstudctl);
  clear nwstudopt;
  clear courmsg;
  clear courmsg1;

  Exec Sql SET OPTION COMMIT = *NONE;


 //populating the subrecord
   subclear2 = *off;
   Write NewStudCtl;
   RRN = 0;
   subclear2 = *on;

   SetLL *start corMaster;
   Read corMaster;
   DoU (%EOF(corMaster));
     RRN += 1;
     Write NewStudSFL;
     Read corMaster;
   ENDDO;

   DoW (Exit = *Off AND Cancel = *Off);
     write header;
     write footerCour;
     ExFmt NewStudCtl;
     ReadC newStudSFL;
     clear courmsg;
     clear courmsg1;

//Saving a New Student
     SetGT *hival StuMaster;
     ReadP(N) StuMaster;
     If (NewStudInp <> *BLANK AND AddrInp <> *BLANK AND NwStudOpt = '1' AND save = *on);

       StuID += 10;          //auto generate stuID to 10 past the last one
       detID = StuID;
       SemID = 1;            // auto generate Semester ID to one making all new studs freshman
       StuName = %TRIM(newStudInp);
       StudAddr = %TRIM(AddrInp);
       StuCourID = courseID;

       write(E) stumasfmt;

       Read StuDetails;
       StuId = detID;        //auto enroll new student in College 101, subid 10
       SubjectID = 10;
       Marks = 0;

       write(E) StuDetFmt;

       clear *all(newstudctl);
       clear nwstudopt;
       update(E) newstudsfl;
       courmsg1 = ('Success New StuID: ' + %CHAR(stuID));

    //throw error for blank
      Else;
        courMsg = 'Blanks not valid';
      ENDIF; // saving

 //Indicators
      If (exit = *on);
        ReturnCode = 222;

      ElseIf (cancel = *on);
        ReturnCode = 999;

      ElseIf (refresh = *on);
        clear *all(newstudctl);
        clear nwstudopt;
        clear courmsg;
        clear courmsg1;
      ENDIF;
   ENDDO;

 return returnCode;

END-PROC; 
