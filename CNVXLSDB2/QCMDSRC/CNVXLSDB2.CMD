             CMD        PROMPT('Convert Excel file to DB')

             PARM       KWD(FROMFILE) TYPE(*CHAR) LEN(255) +
                          PROMPT('Spreadsheet to convert from') MIN(1)
             PARM       KWD(FILETYPE) TYPE(*CHAR) LEN(3) RSTD(*YES) +
                          DFT(XLS) VALUES(('XLS') ('CSV')) +
                          PROMPT('File type of spreadsheet')
             PARM       KWD(DBFILE) TYPE(*CHAR) LEN(10) PROMPT('DB +
                          file to send data to') MIN(1)
             PARM       KWD(DBLIB) TYPE(*CHAR) LEN(10) PROMPT('DB +
                          Library to send data to') MIN(1)
