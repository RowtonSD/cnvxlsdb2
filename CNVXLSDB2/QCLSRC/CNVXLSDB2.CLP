/*----------------------------------------------------------------------------*/
/* Converts an XLS, XLSX or CSV file into a DB2 table                         */
/*----------------------------------------------------------------------------*/
             PGM        PARM(&SRC &TYPE &FILE &LIB)

/*----------------------------------------------------------------------------*/
/* Variables                                                                  */
/*----------------------------------------------------------------------------*/
             DCL        VAR(&SRC) TYPE(*CHAR) LEN(255)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(3)
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PYCMD) TYPE(*CHAR) LEN(255)
             DCL        VAR(&SQLSTMT) TYPE(*CHAR) LEN(50)

/*----------------------------------------------------------------------------*/
/* Delete Table                                                               */
/*----------------------------------------------------------------------------*/
            CHKOBJ OBJ(&LIB/&FILE) OBJTYPE(*FILE)
            MONMSG  MSGID(CPF9801)  EXEC(GOTO RUNSCRIPT)
            SNDPGMMSG MSGDTA('Table already exists. Attempting to drop') +
                MSGTYPE(*STATUS) TOPGMQ(*EXT) MSGID(CPF9898) MSGF(QCPFMSG)
            SNDPGMMSG MSG('Table already exists. Attempting to drop')
            CHGVAR VAR(&SQLSTMT) VALUE('DROP TABLE IF EXISTS ' || &LIB |< '/' |< &FILE)
            RUNSQL SQL(&SQLSTMT) COMMIT(*NONE)
            MONMSG MSGID(CPF0000)
            DLYJOB DLY(1)

/*----------------------------------------------------------------------------*/
/* Check if delete was succesful                                              */
/*----------------------------------------------------------------------------*/
            CHKOBJ OBJ(&LIB/&FILE) OBJTYPE(*FILE)
            MONMSG  MSGID(CPF9801)  EXEC(GOTO RUNSCRIPT)
            SNDPGMMSG MSGDTA('Unable to remove existing table. Check for locks') +
                MSGTYPE(*COMP) TOPGMQ(*EXT) MSGID(CPF9899) MSGF(QCPFMSG)
            SNDPGMMSG MSG('Unable to remove existing table. Check for locks')
            GOTO EXITF

/*----------------------------------------------------------------------------*/
/* Run Python Script                                                          */
/*----------------------------------------------------------------------------*/
RUNSCRIPT:  CHGVAR     VAR(&PYCMD) +
                          VALUE('/QOpenSys/pkgs/bin/python3 +
                          /opt/cnvxlsdb/cnvxlsdb.py -i ''' |< &SRC +
                          |< ''' -t ''' |< &TYPE |< ''' -l ''' |< +
                          &LIB |< ''' -f ''' |< &FILE |< '''')

            QSH CMD(&PYCMD)
            SNDPGMMSG MSG('File converted.')

EXITF:      ENDPGM

