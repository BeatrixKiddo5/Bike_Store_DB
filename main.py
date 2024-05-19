from exception import CustomException
from logger import logging
import pandas as pd
import numpy as np
import psycopg2
import sys
import os

class csv_to_db_loader:       


    def __init__(self, db_name= "db", n=100):

        """
        Initializes the instance by retrieving the folder name for all the 
        csv tables in from which the files are to be loaded into the database.

        This method searches for folders that have a string 'csv' in it and
        automatically sets the 'folder_name' attribute to it.
        """

        self.n=n
        self.db_name=db_name
        folder_name=''

        for folder in os.listdir(os.getcwd()):                  
            if ('csv' in folder) and ('.csv' not in folder): folder_name=folder                 
        self.folder_name=folder_name                    

    def insert_into_db_tables(self):

        """
        This function encapsulates multiple functionalities that operate on the 
        instance's data.
        """

        def get_tables(self):

            """
            This function returns the table names from the 'folder_name' folder, that 
            contains all the csv files that need to be loaded into the database.

            Returns:
                tables(List): List of table names
            """

            dir = f'{os.getcwd()}\{self.folder_name}'
            files=os.listdir(rf'{dir}')
            tables=[]
            for file in files:
                ffff=f"{file[0:-4]}"
                tables.append(ffff)
            return tables

        def make_dframes(self, tables):

            '''
            This function makes a dictionary of data frames, each containing one csv file to be loaded.

            Returns:
                frames_dict(dictionary): Dictionary of all the csv files as dataframes
            '''

            frames_dict={}
            k = 0
            while k < len(tables):
                key = f'{tables[k]}_df'
                value = pd.read_csv(rf'{os.getcwd()}\{self.folder_name}\{tables[k]}.csv')
                frames_dict[key] = value 
                k += 1
            return frames_dict

        def create_db(self):

            '''
            This function asks the user to enter the name for the database, and creates it.

            Returns:
                cur(cursor object): Stays connected to the database; executes queries
                conn(connection object): Establishes connection to the PgSQL Database
            '''

            conn=psycopg2.connect(host="localhost",database="postgres",user="postgres", password="password")
            conn.set_session(autocommit=True)
            cur=conn.cursor()

            cur.execute(f"DROP DATABASE IF EXISTS {self.db_name}")
            cur.execute(f"CREATE DATABASE {self.db_name}")

            conn.close()

            conn=psycopg2.connect(host="localhost",database=self.db_name,user="postgres",password="password")
            cur=conn.cursor()
            return cur, conn

        def update_dictionary_values(self, A, B):

            '''
            This function swaps values between two dictionaries using matching keys.
            This is used to define the schema for inserting data into the database.

            Parameters:
                A, B(dict): Dictionariy A is the one whose values will be changed using 
                            a dictionary B as a reference
            Returns: 
                new_A(dict): Dictionary with updated values.
            '''

            new_A = {}
            for key, value in A.items():
                if isinstance(value, np.dtype):
                # Check if value is a NumPy dtype
                    new_value = B.get(str(value))  # Convert dtype to string for lookup in B
                    if new_value:
                        new_A[key] = new_value
                    else:
                        # Handle cases where dtype is not found in B (optional)
                        new_A[key] = value  # Keep the original value
                else:
                # Handle cases where key is not a NumPy dtype (optional)
                    new_A[key] = value

            return new_A

        try:
            tables=get_tables(self)
            logging.info(f"Got tables: \n {tables} \n We need to insert {len(tables)} tables into the PgSQL Database- {self.db_name}.")

            frames_dict=make_dframes(self, tables)
            logging.info(f"Created corresponding dataframes.")

            cur, conn= create_db(self)
            logging.info(f"Created DataBase {self.db_name}")

            #n=100
            data_type_dict={'int64':'INTEGER', 'float64':'REAL', 'object': f'VARCHAR({self.n})'}

            for i in range(0, len(tables)):
                table_name=f'{tables[i]}'

                cols= frames_dict.get(f'{tables[i]}_df').columns
                d_types=frames_dict.get(f'{tables[i]}_df').dtypes.values

                schema_dict=dict(zip(cols, d_types))

                updated_schema_dict=update_dictionary_values(self, schema_dict, data_type_dict)

                schema_string=str(updated_schema_dict).replace("'", "").replace("{", "(").replace("}",")").replace(":", "")
                tables_create=f"CREATE TABLE IF NOT EXISTS {table_name}\n{schema_string}"
                
                cur.execute(tables_create)
                logging.info(f"Created table {table_name}")
                
                cols_string=str(list(cols.values)).replace("'", "").replace("[", "(").replace("]", ")")
                ss=('%s '*len(cols)).strip().replace(" ", ",")
                tables_insert=f"INSERT INTO {table_name} {cols_string} VALUES ({ss})"

                for j, row in frames_dict.get(f'{tables[i]}_df').iterrows():
                    cur.execute(tables_insert, list(row))
                conn.commit()
                logging.info(f"Inserted into table {table_name}")
            conn.close()
            logging.info(f"Closed connection to DataBase {self.db_name}")
        
        except Exception as e:
            raise CustomException(e, sys)

csv_to_db_loader(db_name="bike_store_db", n=110).insert_into_db_tables()
logging.info(f"Finished loading all csv files to db!")

