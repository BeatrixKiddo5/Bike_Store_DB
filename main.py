from logger import logging
from exception import CustomException
import sys
from components.create_db import create_db
from components.get_tables import get_tables
from components.make_dframes import make_dframes
from components.insert_into_tables import insert_into_tables

try:
    db_name="Bike_Store_DB"
    cur, conn= create_db(db_name)   
    logging.info(f"Created Database {db_name}")

    tables=get_tables()
    logging.info("Got table names")

    frames_dict=make_dframes(tables)
    logging.info("Made all the dataframes")
        
    n=100
    data_type_dict={'int64':'INTEGER', 'float64':'REAL', 'object': f'VARCHAR({n})'}

    insert_into_tables(frames_dict, tables, data_type_dict, cur, conn)
    logging.info("Inserted data into all tables.")

except Exception as e:
    raise CustomException(e, sys)