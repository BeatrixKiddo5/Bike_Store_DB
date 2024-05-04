import os
from logger import logging

def get_tables():    
    files=os.listdir(rf'C:\Users\user\Desktop\DS Stuff\bikestore\Files (csv)')
    tables=[]
    for file in files:
        ffff=f"{file[0:-4]}"
        tables.append(ffff)
    return tables