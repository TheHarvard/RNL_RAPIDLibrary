MODULE SSLibLog(SYSMODULE,NOSTEPIN)

    ! Rev 2018-12-05
    ! SS/RN

    ! Manualy create folders "HOME/logs" and "HOME/logs/archive" or add permissions to add folders in HOME+subfolders

    ! Max size logfolder (Bytes)
    CONST num nSSArchiveMax:=2000000;
    ! Name logfolder (Located in HOME)
    CONST string stLogFolder:="logs";

    PROC SSWriteLog(string stLine,\string FileName)
        VAR string stRead:="";
        VAR string stFileName:="default.log";
        IF Present(FileName) stFileName:=FileName;
        IF IsFile("HOME:/"+stLogFolder\Directory)=FALSE MakeDir "HOME:/"+stLogFolder;
        IF IsFile("HOME:/"+stLogFolder+"/archive"\Directory)=FALSE MakeDir "HOME:/"+stLogFolder+"/archive";
        IF IsFile("HOME:/"+stLogFolder+"/"+stFileName) THEN
            stRead:=CurrentReadDate("HOME:/"+stLogFolder+"/"+stFileName);
            IF stRead<>CDate() THEN
                CurrentMove;
                CurrentCreate "HOME:/"+stLogFolder+"/"+stFileName;
            ENDIF
        ENDIF
        CurrentWrite stLine,"HOME:/"+stLogFolder+"/"+stFileName;
    ERROR
        RAISE ;
    ENDPROC

    LOCAL FUNC string CurrentReadDate(string Filename)
        VAR string stText;
        VAR iodev logfile;
        Open Filename,logfile\Read;
        stText:=ReadStr(logfile);
        Close logfile;
        RETURN stText;
    ERROR
        Close logfile;
        RAISE;
	UNDO
		Close logfile;
		RAISE;
    ENDFUNC

    LOCAL PROC CurrentMove()
        VAR dir dDirectory;
        VAR string stFilename;
        VAR string stFileN1;
        VAR string stFileN2;
        OpenDir dDirectory,"HOME:/"+stLogFolder;
        WHILE ReadDir(dDirectory,stFilename) DO
            IF StrLen(stFilename)>4 THEN
                IF StrPart(stFilename,(StrLen(stFilename)-3),4)=".log" THEN
                    CurrentMoveFile stFilename;
                ENDIF
            ENDIF
        ENDWHILE
        CloseDir dDirectory;
        CleanUpArchive;
    ERROR
        IF ERRNO=ERR_FILEACC THEN
            IF RemainingRetries()>0 THEN
                WaitTime 0.2;
                RETRY;
            ENDIF
            CloseDir dDirectory;
        ENDIF
        RAISE ;
	UNDO
		CloseDir dDirectory;
		RAISE;
    ENDPROC

    PROC CurrentMoveFile(string FileName)
        VAR string FileDate;
        VAR string stDummy;
        VAR string stFilePrename;
        FileDate:=CurrentReadDate("HOME:/"+stLogFolder+"/"+FileName);
        IF FileDate=CDate() RETURN ;
        IF IsFile("HOME:/"+stLogFolder+"/"+FileName) AND StrSplit2(FileName,".",stFilePrename,stDummy) THEN
            IF IsFile("HOME:/"+stLogFolder+"/archive/"+FileName) RemoveFile("HOME:/"+stLogFolder+"/archive/"+FileName);
            CopyFile "HOME:/"+stLogFolder+"/"+FileName,"HOME:/"+stLogFolder+"/archive/"+FileName;
            IF IsFile("HOME:/"+stLogFolder+"/archive/"+stFilePrename+"_"+FileDate+".log") RemoveFile("HOME:/"+stLogFolder+"/archive/"+stFilePrename+"_"+FileDate+".log");
            RenameFile "HOME:/"+stLogFolder+"/archive/"+FileName,"HOME:/"+stLogFolder+"/archive/"+stFilePrename+"_"+FileDate+".log";
            RemoveFile "HOME:/"+stLogFolder+"/"+FileName;
        ENDIF
    ERROR
        RAISE ;
    ENDPROC

    LOCAL PROC CurrentCreate(string FileName)
        VAR iodev logfile;
        Open FileName,logfile\Write;
        Write logfile,CDate();
        Close logfile;
    ERROR
        RAISE ;
	UNDO
		Close logfile;
		RAISE;
    ENDPROC

    LOCAL PROC CurrentWrite(string Text,string FileName)
        VAR iodev logfile;
        Open FileName,logfile\Append;
        Write logfile,CTime()+" "\NoNewLine;
        Write logfile,Text;
        Close logfile;
    ERROR
        Close logfile;
        RAISE ;
	UNDO
		Close logfile;
		RAISE;
    ENDPROC

    PROC CleanUpArchive()
        VAR dir dDirectory;
        VAR string stFilename;
        VAR string stOldestFilename;
        VAR num nFilesize;
        VAR num nArchiveSize;
        VAR string stOldestDate;
        VAR string stFileDate;
        ! Sjekk om arkivmappe er for stor
        nArchiveSize:=nSSArchiveMax+1;
        WHILE nArchiveSize>nSSArchiveMax DO
            nArchiveSize:=0;
            stOldestDate:="3000-01-01";
            OpenDir dDirectory,"HOME:/"+stLogFolder+"/archive";
            WHILE ReadDir(dDirectory,stFilename) DO
                IF IsFile("HOME:/"+stLogFolder+"/archive/"+stFilename\RegFile) AND StrLen(stFilename)>4 THEN
                    IF StrPart(stFilename,StrLen(stFilename)-3,4)=".log" THEN
                        ! Finn filestørrelse
                        nFilesize:=FileSize("HOME:/"+stLogFolder+"/archive/"+stFilename);
                        ! Legg til totalstørrelse
                        Add nArchiveSize,nFilesize;
                        ! Les fildato
                        stFileDate:=CurrentReadDate("HOME:/"+stLogFolder+"/archive/"+stFilename);
                        ! Finn den eldste filen
                        IF StrOrder(stFileDate,stOldestDate,"0123456789-") THEN
                            stOldestFilename:=stFilename;
                            stOldestDate:=stFileDate;
                        ENDIF
                    ENDIF
                ENDIF
            ENDWHILE
            CloseDir dDirectory;
            ! Hvis arkiv er for stort, slett den eldste filen og sjekk mappe igjen
            IF nArchiveSize>nSSArchiveMax THEN
                RemoveFile "HOME:/"+stLogFolder+"/archive/"+stOldestFilename;
            ENDIF
        ENDWHILE
    ERROR
        CloseDir dDirectory;
        RAISE ;
	UNDO
        CloseDir dDirectory;
        RAISE ;
    ENDPROC

ENDMODULE
