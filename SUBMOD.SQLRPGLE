**FREE
Ctl-Opt NOMAIN;

  /Copy QRPGLEREF,SISCPYBK

  Dcl-Proc addsubject Export;
    Dcl-Pi addsubject zoned(3);
      hname char(10);
    END-PI;

    Exec Sql SET OPTION COMMIT = *NONE;

//Varibles
    Dcl-S returnCode zoned(3);
    Dcl-S sub char(25);

    Husername = hname;

    Cancel = *off;
    exit = *off;
    Clear addsubinp;
    Clear addSubmsg;
    Clear addSubmsg2;

  DoW (Exit = *off AND Cancel = *off);

    write header;
    write footer2;
    Exfmt addsubscrn;
    clear addSubMsg;
    clear addSubMsg2;

    Exec Sql                 //validation to ensure subject doesn't already exist
    Select subName INTO :sub
      From subMaster
      where subName = :addSubInp;

    SetGT *hival SubMaster;
    ReadP(N) SubMaster;
    If (AddSubInp <> '' AND SqlCode = 100 AND save = *on);

      SubjectID = (SubjectId + 10);  //autogenerates a SubjectId 10 above the last Id in the file
      subName = %TRIM(addSubInp);

      write(E) SUBFMT;
      addSubmsg2 = ('SubjectID: ' + %CHAR(SubjectId) + ' successfully added');

 //Validation
    ElseIf (Save = *on AND SqlCode = 0 AND AddSubInp <> '');
      AddSubMsg = 'Subject already exists';
    ElseIf (AddSubInp = '');
      AddSubMsg = 'No Blanks authorized';
    Else;
      AddSubmsg = 'Press F8 to Save Subject, not Enter Key';
    ENDIF;

 //Indicators
    If (exit = *on);
      returnCode = 222;

    ElseIf (cancel = *On);
      returnCode = 999;

    ElseIf (refresh = *on);
      clear addsubinp;
      clear addsubmsg;
      clear addSubMsg2;
    ENDIF;
  EndDo;

  Return returnCode;
  END-PROC; 
