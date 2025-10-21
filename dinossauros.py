import streamlit as st
import psycopg2
import pandas as pd
import plotly.express as px
from dotenv import load_dotenv
import os

@st.cache_resource
def init_connection():
    load_dotenv(dotenv_path="C:/Users/brend/OneDrive/Documentos/Github/Projeto-I-Banco-Dados/.venv/.env")
    try:
        conn = psycopg2.connect(
            host=os.getenv('DB_HOST'),
            database=os.getenv('DB_NAME'),
            user=os.getenv('DB_USER'),
            password=os.getenv('DB_PASSWORD'),
            port=os.getenv('DB_PORT')
        )

        cur = conn.cursor()
        cur.execute("SELECT version();")
        version = cur.fetchone()
        st.success(f"Conexão bem-sucedida! ✅\nVersão do PostgreSQL: {version[0]}")
        cur.close()
        return conn
    except Exception as e:
        st.error(f"Erro na conexão: {e}")
        return None

conn = init_connection()
