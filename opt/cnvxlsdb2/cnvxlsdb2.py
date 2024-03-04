# XLS/CSV file importer utility for IBM i DB2 databases
# To be run on IBM i OS only
# Library specified must have automatic journaling enabled (via STRJRNLIB)
# python39 recommend
# requires IBM i Access ODBC driver (see https://ibmi-oss-docs.readthedocs.io/en/latest/odbc/installation.html)

import sqlalchemy as sa                 # This is the sqlalchemy-ibmi WIP variant provided by IBM (https://github.com/IBM/sqlalchemy-ibmi/)
import pandas as pd                     # install python39-pandas via open source package management                    
from argparse import ArgumentParser
import sys

# command line arguement handler
def create_parser():
    parser = ArgumentParser(description="File Details")
    parser.add_argument("-i", "--import_file", help="XLS or XLSX file to convert")
    parser.add_argument("-t", "--import_type", help="Type of file to convert: XLS or CSV")
    parser.add_argument("-l", "-d", "--library", help="Library (Database) Name")
    parser.add_argument("-f", "--file", help="File (Table) Name")
    return parser

# Import command line arguements
args = create_parser().parse_args()
inputFile = args.import_file
inputType = args.import_type
exportTable = args.file
exportDB = args.library

# Confirm parameters exist
if inputFile == None: sys.exit("An input file must be specified")

# Import File into Pandas DataFrame
if inputType == 'CSV':
    convertFile = pd.read_csv(inputFile)
elif inputType == 'XLS':
    convertFile = pd.read_excel(inputFile)
else:
    sys.exit("Import Type not support")

# Connection details for the database
userID = "<user>"       # Update with IBM i user to connect with
passWD = "<password>"   # Update with IBM i user's password
rdbEntry = "<rdb>"      # Update with IBM i local RDBE (WRKRDBE?)
connection_string = "ibmi://" + userID + ":" +  passWD + "@localhost/" + rdbEntry

# Create connection
engine = sa.create_engine(connection_string)
cnxn = engine.connect()

# Export Pandas DataFrame to DB2
convertFile.to_sql(exportTable.lower(),schema=exportDB.lower(),con=cnxn,if_exists='replace')
