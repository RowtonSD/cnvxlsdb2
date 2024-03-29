# CNVXLSDB2 - Convert XLS/CSV files to IBM i DB2 tables
Note: This is WIP. Primarily intended as a template for further modification, rather than a complete command. No error checking is implemented currently. Use at own risk.

## About
IBM i command CNVXLSDB2, that takes an input CSV or XLS file and coverts it to a database file on the IBM i. This is a simplified version of the CNVDB tool (https://github.com/RowtonSD/cnvdb), which handles conversion between XLS, DB2, and external SQL DB sources via python dataframes. 
The primary purpose of these tools is to provide template code for import IBM i DB2 data, in and out of dataframes in python.

## Limitations
* Destination library must have automatic journaling enabled (via STRJRNLIB). Process will fail if not
* Only first sheet of an excel spreadsheet is converted, all other sheets are ignored. Parameter to allow user to specify sheet number will be added in 0.02
* All character fields are interpreted as CLOB fields, as such, there are limitations to viewing data in 5250 based tools.
* Requires user/pass to specified in plain text in the python file. This is due to be moved to the command in next version.

## Setup
1. Install the open source enviroment on the IBM
2. Install Python 3.9
3. Install the IBM i Access ODBC driver (see https://ibmi-oss-docs.readthedocs.io/en/latest/odbc/installation.html)
4. Download IBM i WIP variant of python module sql-alchemy (https://github.com/IBM/sqlalchemy-ibmi)
5. Copy CLP and CMD source files to CNVXLSDB2 library and compile as normal
6. Copy python script to /opt/cnvxlsdb2. (Any folder or naming changes will have to be relected in CLP)
7. Edit cnvxlsdb2.py, and update userID, passWD, rdbEntry fields approriate for you server. (see limitations notes)

## Execution Example
The following example takes an Excel spreadsheet names "supplier.xlsx", stored in the share "accounts" on remote server "FileSrv1", and imports into table ACCDTA/SUPPLIER.

CNVXLSDB2 FROMFILE('/QNTC/FileSrv1/accounts/supplier.xlsx') FILETYPE(XLS) DBFILE(SUPPLIER) DBLIB(ACCDTA) 
