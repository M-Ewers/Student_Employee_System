**FREE
 Ctl-Opt NOMAIN;

/copy qrpgleref,siscpybk


Dcl-PROC stuDets export;
  Dcl-Pi stuDets zoned(3);
    hname char(10);
  END-PI;

//varibles
  Dcl-S returnCode zoned(3);
  Dcl-S tempStuID zoned(5);
  Dcl-S tempStuName char(25);
  Dcl-S tempStuAddr char(25);
  Dcl-S tempStucourID zoned(5);
  Dcl-S tempSemID zoned(2);
  Dcl-S tempmarks zoned(5);
  Dcl-S tempSubID zoned(5);
  Dcl-S tempsubname char(25);
  Dcl-S tempcoursename char(25);
  Dcl-S tempsemester char(10);

  Exec Sql SET OPTION COMMIT = *NONE;

  cancel = *off;
  exit = *off;
  Husername = hname;
  clear *all(stuDetCTL);
  clear detmsg;
  clear detmsg1;


  subclear3 = *on;
  Write STUDETCTL;
  subclear3 = *off;

  DoW (exit = *off AND cancel = *off);

    Write Footer3;
    Write Header;
    Exfmt StuDetCTL;
    clear DetMsg;
    clear DetMsg1;
//Searching
  //1. Declare Cursor
  //2. Open Cursor
  //3. Fetch First matching record
  //4. Populate & Turn subfile display ind on
  //5. iterate relative record number & write to subfile
  //6. Fetch Next matching record
  //7. Loop through 5 & 6 till complete
  // Note: SubRoutine Assign - assigns all variables to corresponding display varibles
  //                           to reduce clutter

   //******Search All***********
        If ((StuIDInp <> *Zero OR NameInp <> *blank)
              AND (CourIDInp <> *Zero OR CourInp <> *blank)
              AND  (SemInp <> *BLANK));
        //Clear subfile:
          subclear3 = *on;
          Write STUDETCTL;
          subclear3 = *off;
          RRN = 0;
          sflDsp = *off;
          // check if open cursor
          Exec Sql
            Declare Ultcurs CURSOR
            FOR
              SELECT StuID, StuName, StudAddr, StuCourID, SemID, Marks, SubName
                     ,CourseName, Semester
              FROM StuDetLOG
              WHERE (StuID = :StuIDInp OR StuName = :NameInp)
                   AND (StuCourID = :courIDInp OR CourseName = :courInp)
                   AND (Semester = :SemInp);

          Exec Sql Open UltCurs;


          Exec Sql
            FETCH FROM UltCurs INTO :tempStuID, :tempStuName, :tempstuAddr,
                 :tempstucourID, :tempSemID, :tempMarks, :tempsubName, :tempCourseName,
                 :tempsemester;

          ExSr Assign;   //assigns all variables to corresponding display varibles
                         // subroutine to reduce clutter

          If (sqlCode = 0);
           sflDsp = *on;   //turned back on so subfile can display now
          EndIf;

          DoW (SqlCode = 0);      //populate subfile
            RRN += 1;
            write StuDetSFl;

            Exec Sql
              FETCH NEXT FROM UltCurs INTO :tempStuID, :tempStuName, :tempstuAddr,
              :tempstucourID, :tempSemID, :tempMarks, :tempsubName, :tempCourseName,
              :tempsemester;

            ExSr Assign;
          ENDDO;
          Exec Sql Close UltCurs;

    //****Search Student and Course****
        ElseIf ((StuIDInp <> *Zero OR NameInp <> *blank) AND (courIDInp <> 0 OR courInp <> *blank));
        //Clear subfile:
          subclear3 = *on;
          Write STUDETCTL;
          RRN = 0;
          subclear3 = *off;
          sflDsp = *off;

          Exec Sql
            Declare stuCorcurs CURSOR
            FOR
              SELECT StuID, StuName, StudAddr, StuCourID, SemID, Marks, SubName
                     ,CourseName, Semester
              FROM StuDetLOG
              WHERE (StuID = :StuIDInp OR StuName = :NameInp)
                   AND (StuCourID = :courIDInp OR CourseName = :courInp);

         Exec Sql Open StuCorCurs;


          Exec Sql
            FETCH FROM StuCorCurs INTO :tempStuID, :tempStuName, :tempstuAddr,
                 :tempstucourID, :tempSemID, :tempMarks, :tempsubName, :tempCourseName,
                 :tempsemester;

          ExSr Assign;

          If (sqlCode = 0);
           sflDsp = *on;          //turned back on so subfile can display now
          EndIf;

          DoW (SqlCode = 0);      //populate subfile
            RRN += 1;
            write StuDetSFl;

            Exec Sql
              FETCH NEXT FROM StuCorCurs INTO :tempStuID, :tempStuName, :tempstuAddr,
              :tempstucourID, :tempSemID, :tempMarks, :tempsubName, :tempCourseName,
              :tempsemester;

            ExSr Assign;
          ENDDO;
          Exec Sql Close StuCorCurs;

   //***Search Student and Semester****
        ElseIf ((StuIDInp <> *Zero OR NameInp <> *blank) AND  (SemInp <> *BLANK));
         //Clear subfile:
          subclear3 = *on;
          Write STUDETCTL;
          RRN = 0;
          subclear3 = *off;
          sflDsp = *off;

          Exec Sql
          Declare StuSemcurs CURSOR
          FOR
            SELECT StuID, StuName, StudAddr, StuCourID, SemID, Marks, SubName
              ,CourseName, Semester
            FROM StuDetLOG
            WHERE (Semester = :SemInp)
              AND (StuCourID = :courIDInp OR SemId = :semInp);

           Exec Sql Open StuSemCurs;


          Exec Sql
            FETCH FROM StuSemCurs INTO :tempStuID, :tempStuName, :tempstuAddr,
                 :tempstucourID, :tempSemID, :tempMarks, :tempsubName, :tempCourseName,
                 :tempsemester;

          ExSr Assign;

          If (sqlCode = 0);
           sflDsp = *on;   //turned back on so subfile can display now
          EndIf;

          DoW (SqlCode = 0);      //populate subfile
            RRN += 1;
            write StuDetSFl;

            Exec Sql
              FETCH NEXT FROM StuSemCurs INTO :tempStuID, :tempStuName, :tempstuAddr,
              :tempstucourID, :tempSemID, :tempMarks, :tempsubName, :tempCourseName,
              :tempsemester;

            ExSr Assign;
          ENDDO;
          Exec Sql Close StuSemCurs;

    //****Search Course and Semester*****
        ElseIf ((CourIDInp <> *Zero OR CourInp <> *blank) AND  (SemInp <> *BLANK));
          //Clear subfile:
          subclear3 = *on;
          Write STUDETCTL;
          RRN = 0;
          subclear3 = *off;
          sflDsp = *off;

          Exec Sql
           Declare SemCorcurs CURSOR
           FOR
             SELECT StuID, StuName, StudAddr, StuCourID, SemID, Marks, SubName
                 ,CourseName, Semester
             FROM StuDetLOG
             WHERE (Semester = :SemInp)
                 AND (StuCourID = :courIDInp OR CourseName = :courInp);

         Exec Sql Open SemCorCurs;


          Exec Sql
            FETCH FROM SemCorCurs INTO :tempStuID, :tempStuName, :tempstuAddr,
                 :tempstucourID, :tempSemID, :tempMarks, :tempsubName, :tempCourseName,
                 :tempsemester;

          ExSr Assign;

          If (sqlCode = 0);
           sflDsp = *on;   //turned back on so subfile can display now
          EndIf;

          DoW (SqlCode = 0);      //populate subfile
            RRN += 1;
            write StuDetSFl;

            Exec Sql
              FETCH NEXT FROM SemCorCurs INTO :tempStuID, :tempStuName, :tempstuAddr,
              :tempstucourID, :tempSemID, :tempMarks, :tempsubName, :tempCourseName,
              :tempsemester;

            ExSr Assign;
          ENDDO;
          Exec Sql Close SemCorCurs;
  //******Search Student*********
       ElseIf (StuIDInp <> *Zero OR NameInp <> *blank); //search for student via name or ID#

        //Clear subfile:
          subclear3 = *on;
          Write STUDETCTL;
          RRN = 0;
          subclear3 = *off;
          sflDsp = *off;


          Exec Sql
            Declare stuCurs CURSOR
            FOR
              SELECT StuID, StuName, StudAddr, StuCourID, SemID, Marks, SubName
                  ,CourseName, Semester
              FROM StuDetLOG
              WHERE StuID = :StuIDInp OR StuName = :NameInp;

           Exec Sql Open StuCurs;


           Exec Sql
            FETCH FROM StuCurs INTO :tempStuID, :tempStuName, :tempstuAddr,
                 :tempstucourID, :tempSemID, :tempMarks, :tempsubName, :tempCourseName,
                 :tempsemester;

          ExSr Assign;

          If (sqlCode = 0);
           sflDsp = *on;   //turned back on so subfile can display now
          EndIf;

          DoW (SqlCode = 0);      //populate subfile
            RRN += 1;
            write StuDetSFl;

            Exec Sql
              FETCH NEXT FROM StuCurs INTO :tempStuID, :tempStuName, :tempstuAddr,
              :tempstucourID, :tempSemID, :tempMarks, :tempsubName, :tempCourseName,
              :tempsemester;

            ExSr Assign;
          ENDDO;
          Exec Sql Close StuCurs;

  //*******Search Course********
      ElseIf (courIDInp <> 0 OR courInp <> *blank);
           //Clear subfile:
          subclear3 = *on;
          Write STUDETCTL;
          RRN = 0;
          subclear3 = *off;
          sflDsp = *off;

          Exec Sql
          Declare CorCurs CURSOR
          FOR
            SELECT StuID, StuName, StudAddr, StuCourID, SemID, Marks, SubName
              ,CourseName, Semester
            FROM StuDetLOG
            WHERE StuCourID = :courIDInp OR CourseName = :courInp;

          Exec Sql Open CorCurs;


          Exec Sql
            FETCH FROM CorCurs INTO :tempStuID, :tempStuName, :tempstuAddr,
                 :tempstucourID, :tempSemID, :tempMarks, :tempsubName, :tempCourseName,
                 :tempsemester;

          ExSr Assign;

          If (sqlCode = 0);
           sflDsp = *on;   //turned back on so subfile can display now
          EndIf;

          DoW (SqlCode = 0);      //populate subfile
            RRN += 1;
            write StuDetSFl;

            Exec Sql
              FETCH NEXT FROM CorCurs INTO :tempStuID, :tempStuName, :tempstuAddr,
              :tempstucourID, :tempSemID, :tempMarks, :tempsubName, :tempCourseName,
              :tempsemester;

            ExSr Assign;
          ENDDO;
          Exec Sql Close CorCurs;

  //******Search Semester*******
      ElseIf (SemInp <> *blank);

            //Clear subfile:
          subclear3 = *on;
          Write STUDETCTL;
          RRN = 0;
          subclear3 = *off;
          sflDsp = *off;

          Exec Sql
            Declare SemCurs CURSOR
            FOR
              SELECT StuID, StuName, StudAddr, StuCourID, SemID, Marks, SubName
                  ,CourseName, Semester
              FROM StuDetLOG
              WHERE Semester = :SemInp;

          Exec Sql Open SemCurs;


          Exec Sql
            FETCH FROM SemCurs INTO :tempStuID, :tempStuName, :tempstuAddr,
                 :tempstucourID, :tempSemID, :tempMarks, :tempsubName, :tempCourseName,
                 :tempsemester;

          ExSr Assign;

          If (sqlCode = 0);
           sflDsp = *on;   //turned back on so subfile can display now
          EndIf;

          DoW (SqlCode = 0);      //populate subfile
            RRN += 1;
            write StuDetSFl;

            Exec Sql
              FETCH NEXT FROM SemCurs INTO :tempStuID, :tempStuName, :tempstuAddr,
              :tempstucourID, :tempSemID, :tempMarks, :tempsubName, :tempCourseName,
              :tempsemester;

              ExSr Assign;
          ENDDO;

          Exec Sql Close SemCurs;

  //catching all blanks
      Else;
       DetMsg = 'Blanks are not valid';
      EndIF;
 //*********EndOfSearch*************



//**********Subfile Option************
If (sfldsp = *on);
   ReadC StuDetSFL;

//*********************************
//       Update Marks
//*********************************
 If (save = *on);
   Chain StuID StuDetails;
   Marks = DMarks;          //marks from StuDetail = Marks from Dspf
   Update(E) StuDetFMT;
   DMARKS = Marks;
   Update(E) StuDetSFL;
   DetMsg1 = 'Marks Updated';
   clear DetMsg;
 ENDIF;


//***************************
//       Add details         'A'
// **************************
  If (OptInp = 'A');

  //populate window
    AddStuID = Stuid;
    AddStuName = StuName;
    AddCorName = CourseName;
    AddSem = Semester;
    AddSub = Subname;
    addMarks = DMarks;

    DoW (Exit = *Off AND Cancel = *Off);
      ExFmt AddDets;
      Chain StuID StuDetails;

   //selecting the subjectID from subjectmaster file
   //join submaster and subcourlf, a logical that takes subcourse and joins that with
   //cormaster, semmaster, and submaster to give all the IDs in subcourse a name
   //then uses where clause to validate that the subject exist in the course and semester

      Exec Sql
        SELECT sub.SubjectID INTO :tempSubID
        FROM SubMaster AS sub
        JOIN SUBCOURLF AS scour
        ON sub.subjectID = scour.SubjectID
        WHERE scour.CourseName = :Coursename
          AND scour.Semester = :Semester
          AND scour.SubName = :AddSub;

       If (save = *on AND AddSub <> *blank
         AND addMarks <> *ZERO AND SqlCode = 0); //Update Marks and Current Subject
         SubjectID = tempSubID;
         Marks = AddMarks;
         update(E) StuDetFMT;
         AddDetMsg1 = 'Save Successful';

       ElseIf (save = *on AND AddSub <> *blank AND SqlCode <> *ZERO);
         AddDetMsg = ('Not a valid subject');

       EndIF;

  //Indicators
       If (refresh = *on);
         clear AddDetMsg1;
         clear AddDetMsg;
         AddSub = Subname;
         Addmarks = Marks;
       ENDIF;

    ENDDO;

    clear AddDetMsg;
    clear AddDetMsg1;
    clear DetMsg;
    clear optinp;
    Dmarks = Addmarks;
    SubName = AddSub;

    update(E) stuDetSFL;
    cancel = *off;  //to control flow and only back out of window
  ENDIF;

//***************************
//      Change Semester      'C'
// **************************
  If (OptInp = 'C');


   //populate window
      ChgStuID = StuID;
      ChgStuName = StuName;
      ChgCorName = CourseName;
      ChgSem = Semester;

    Chain StuId StuMaster;              //chain stuID from logical to stumaster to update
                                        // semester, changes reflect in logical
    DoW (Exit = *Off AND Cancel = *Off);
      ExFmt ChgSemWin;
      clear chgSemMsg;

      chain StuID StuMaster;
      Exec Sql
          Select SemId INTO :tempSemID
            FROM SemMaster
            WHERE Semester = :ChgSem;
      If (save = *on AND ChgSem <> *BLANK
        AND SqlCode = 0 AND tempSemID > semID);

        SemId = tempSemID;
        update(E) StuMasFmt;
        ChgSemMsg1 = 'Update successful';

      ElseIF (save = *on AND ChgSem <> *BLANK
        AND (SqlCode = 100 OR tempSemID < SemID));
        ChgSemMsg = 'Not a vaild Semester';

      Else;
        ChgSemMsg = 'blanks not valid';   //checks for blanks

      ENDIF;
  //Indicators
    If (refresh = *on);
      clear chgSemMsg;
      clear chgSemMsg1;
      ChgSem = Semester;
    ENDIF;
    EndDo;

    SemID = tempSemID;
    clear optInp;
    clear chgSemMsg;
    clear chgSemMsg1;
    clear DetMsg;
    update(E) StuDetSFL;
    cancel = *off;  //to control flow and only back out of window
  ENDIF;

//***************************
//      Delete            'D'
//***************************
  If (OptInp = 'D');
    DoW (YORN <> 'Y' AND YORN <> 'N');
      clear optInp;
      Exfmt confirmWin;
      If (YORN = 'Y');
        Exec Sql
          Delete From StuDetails
          Where StuID = :StuID AND subjectID =
          (SELECT subjectID
           FROM SUBMaster
           WHERE subname = :subname);
      ENDIF;
    EndDo;
    clear yorn;
    clear DetMsg;
    update StuDetSFL;
  ENDIF;
 ENDIF;   //sfldsp = *on
//************************************************************
//Indicators
  If (exit = *on);
    returncode = 222;
  ElseIf (cancel = *on);
    returnCode = 999;
  ElseIf (refresh = *on);
    clear *all(stuDetCTL);
    clear detmsg;
    clear detmsg1;
  ENDIF; //indicators
EndDo;                 ///EndDo for StuDets Screen

return returnCode;

 BegSr Assign;
     StuID = tempStuId;
     StuName = tempStuName;
     StudAddr = tempStuAddr;
     CourseID = tempstuCourId;
     SemID = tempSemId;
     DMarks = tempMarks;
     SubName = tempsubName;
     CourseName = tempCourseName;
     Semester = tempSemester;
 ENDSR;
End-Proc;

 
