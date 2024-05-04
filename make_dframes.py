import pandas as pd
from logger import logging

def make_dframes(tables):
    frames_dict={}
    k = 0
    while k < len(tables):
        key = f'{tables[k]}_df'
        value = pd.read_csv(rf'C:\Users\user\Desktop\DS Stuff\bikestore\Files (csv)\{tables[k]}.csv')
        frames_dict[key] = value 
        k += 1
    return frames_dict