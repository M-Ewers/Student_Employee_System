**FREE
   Ctl-Opt DftActGrp(*no) ActGrp(*new) BNDDIR('CAPSTONE');

   /Copy qrpgleref,siscpybk

//Varibles
   Dcl-S OptCheck zoned(3);  //OptCheck = 222 means exit ind = *on, logout to log screen
   Dcl-S logged zoned(1:0);  // OptCheck = 999 means cancel ind = *on
   Dcl-S hname char(10);

   Dcl-DS passby1 LIKEDS(passbys);

//MainPGM
   logged = 0;
   DoU (passby1.returncode = 111);        //Leave Do Loop when F3 is pressed on Login
     passby1 = firstLogin(logged);        //Call Login Procedure

     If (passby1.returncode = *zero);     //Exits when F3 is pressed on login screen
       logged = 1;                       //User is now logged in
       Husername = passby1.username1;
       hname = passby1.username1;
       exit = *off;
       clear optmsg;

       DoW (exit = *off);
         If (OptCheck = 999);           //If Back is on from previous screen
           clear optMsg;
           OptCheck = *ZERO;
         EndIf;
         write header;
         write footer;
         ExFmt OptScrn;

         If (AddSubOpt = '1' AND AddCorOpt = *BLANK               //Select Add Subject
             AND AddStuOpt = *BLANK AND AddDetOpt = *BLANK);
             OptCheck = addSubject(hname);
         ElseIf (AddCorOpt = '1' AND AddSubOpt = *BLANK AND       //Select Add Course
                 AddStuOpt = *BLANK AND AddDetOpt = *BLANK);
             OptCheck = Courser(hname);
         ElseIf (AddStuOpt = '1' AND AddSubOpt = *BLANK AND       //Select Add Student
                 AddCorOpt = *BLANK AND AddDetOpt = *BLANK);
             OptCheck = newStud(hname);
         ElseIf (AddDetOpt = '1' AND AddSubOpt = *BLANK           //Select View/Add Details
                 AND AddCorOpt = *BLANK AND AddStuOpt = *BLANK);
             OptCheck = stuDets(hname);
         Else;
             Optmsg = 'Invalid option: Input 1 correct option';
         ENDIF;

       If (OptCheck = 222);             //If Exit is on from options screen
         Leave;                         //Leave option loop and enter login screen
       ENDIF;
       If (refresh = *on);
         clear optmsg;
         clear addsubopt;
         clear addcoropt;
         clear addstuopt;
         clear adddetopt;
       ENDIF;
      EndDo;  // Option Loop

   ENDIF;
   EndDo;    //Login Loop

   *inlr = *on; 
