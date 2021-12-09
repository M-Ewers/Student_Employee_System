**FREE

Ctl-Opt NOMAIN;

/copy qrpgleref,siscpybk


Dcl-PROC Courser export;
  Dcl-Pi Courser zoned(3);
    hname char(10);
  END-PI;


//Varibles
  Dcl-S returnCode zoned(3);
  Dcl-s courid zoned(5);
  Dcl-s semesiD zoned(2);
  Dcl-s sidesubID zoned(5);

  Exec Sql SET OPTION COMMIT = *NONE;

  cancel = *off;
  exit = *off;
  Husername = hname;
  clear *all(newcourctl);
  clear courmsg;
  clear courmsg1;


   //Clearing subfile
   subclear = *off;
   Write NewCourCtl;
   RRN = 0;
   subclear = *on;

   //Loading Subfile
   SetLL *start subMaster;
   Read subMaster;
   DoU (%EOF(subMaster));
     RRN += 1;
     Write NewCourSFL;
     Read subMaster;
   ENDDO;

   //Writing Subfile: adding course and subjects
   DoW (Exit = *Off AND Cancel = *Off);
     write header;
     write footerCour;
     ExFmt NewCourCtl;
     clear courmsg;
     clear courmsg1;
     ReadC NewCourSFL;

     If (NewCourInp <> *BLANK AND SemInp <> *BLANK AND NwCourOpt = '1' AND save = *on);

          //validating course exist or adding it
         Exec Sql
          Select courseID INTO :courID
          FROM CorMaster
          WHERE courseName = :NewCourInp;
         If (SqlCode = 100);            //autogenerates a new course if it doesn't already exist
            SetGT *hival CorMaster;
            ReadP(N) CorMaster;

            CourseID = (CourseId + 10);
            CourseName = %TRIM(NewCourInp);

            write(E) cormasfmt;
         ENDIF;

        //validating semester exist
         Exec Sql
         Select SemID INTO :SemesID
           FROM semmaster
           WHERE Semester = :SemInp;
         If (SqlCode = 100);
           courMsg = 'Invalid Semester';
         ENDIF;

       //adding subjects if valid semester exists
         If (SqlCode = 0);
           ExSr AddSubject;
         EndIf;
       //throw error for blank input(s)
       Else;
         courMsg = 'Blanks not valid';
       ENDIF; // saving
        //Indicators
        If (exit = *on);
          Returncode = 222;

        ElseIf (cancel = *on);
          ReturnCode = 999;

        ElseIf (refresh = *on);
          clear *all(newcourctl);
          clear courmsg;
          clear courmsg1;
        ENDIF;
   ENDDO;
 return returnCode;

  //------------------------------------------------
  // Adding several subjects to subcourse subroutine
 // ------------------------------------------------
 BegSR AddSubject;
  //Writing first changed record
    RRN = 0;

      SUBJECTID = SUBJECTID;
      If (CourId <> *ZERO);         //If preexisting course is entered
        CourseID = CourId;
      Else;                         //If new courseId is entered
        CourseID = CourseID;
      EndIf;
        SemID = SemesId;

    Exec Sql
        Select SubjectID INTO :sidesubID   //validate that a subid semid and corid
          FROM SubCourLF
          WHERE CourseName = :NewCourInp
          AND Semester = :semInp AND subjectID = :subjectID;

    If (SqlCode = 100);
        Write(e) SUBCORFMT;         // Write to SubCourse File
    EndIf;
      clear nwCourOpt;            // Clear first changed record
      Update(E) NEWCOURSFL;
      NxtChange = *On;
      ReadC NEWCOURSFL;

    //Writing all other changed records after first change
      DoW Not %EoF();
          SUBJECTID = SUBJECTID;
          If (CourId <> *ZERO);
            CourseID = CourId;
          Else;
            CourseID = CourseID;
          EndIf;
          SemID = SemesId;

        Exec Sql
          Select SubjectID INTO :sidesubID   //validate that a subid semid and corid
          FROM SubCourLF
          WHERE CourseName = :NewCourInp
          AND Semester =  :semInp AND subjectID = :subjectID;
        If (SqlCode = 100);
          Write(e) SUBCORFMT;
        EndIf;
          clear nwCourOpt;
          Update(E) NEWCOURSFL;
          ReadC NEWCOURSFL;
      EndDo;
        NxtChange = *off;
        CourMsg1 = ('Subjects added to courseID: ' + %CHAR(CourseID));
        clear *all(NEWCOURCTL);
 EndSr;

END-PROC; 
