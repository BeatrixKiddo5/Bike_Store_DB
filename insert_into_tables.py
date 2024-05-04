import pandas as pd
import numpy as np 
from logger import logging

def update_dictionary_values(A, B):  
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

def insert_into_tables(frames_dict, tables, data_type_dict, cur, conn):
    for i in range(0, len(tables)):
        table_name=f'{tables[i]}'

        cols= frames_dict.get(f'{tables[i]}_df').columns
        d_types=frames_dict.get(f'{tables[i]}_df').dtypes.values

        schema_dict=dict(zip(cols, d_types))

        updated_schema_dict=update_dictionary_values(schema_dict, data_type_dict)

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