import psycopg2
from logger import logging

def create_db(s):
       
    conn=psycopg2.connect(host="localhost",database="postgres",user="postgres",password="password")
    conn.set_session(autocommit=True)
    cur=conn.cursor()

    cur.execute(f"DROP DATABASE IF EXISTS {s}")
    cur.execute(f"CREATE DATABASE {s}")

    conn.close()

    conn=psycopg2.connect(host="localhost",database=s,user="postgres",password="password")
    cur=conn.cursor()
    return cur, conn