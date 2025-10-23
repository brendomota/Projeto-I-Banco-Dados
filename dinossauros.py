import types
import streamlit as st
import psycopg2
import pandas as pd
import plotly.express as px
from dotenv import load_dotenv
import os

# Configuração da página
st.set_page_config(
    page_title="Dinossauros",
    page_icon="🦖",
    layout="wide"
)

# Título da aplicação
st.title("🦖 Dinossauros")
st.markdown("Dashboard interativo sobre dinossauros utilizando dados de um banco PostgreSQL.")

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

        return conn
    except Exception as e:
        st.error(f"Erro na conexão: {e}")
        return None

conn = init_connection()

@st.cache_data(ttl=3600)
def run_query(query, params=None):
    """Executa query e retorna DataFrame"""
    try:
        df = pd.read_sql_query(query, conn, params=params)
        return df
    except Exception as e:
        st.error(f"Erro na execução da query: {e}")
        return pd.DataFrame()

def get_dinosaur_data():
    query = """
    SELECT
        d."ID" AS id_dinossauro,
        d."Nome_popular" AS nome_popular,
        d."Nome_cientifico" AS nome_cientifico,
        d."Significado_nome" AS significado_nome,
        d."Altura_media_m" AS altura_media_m,
        d."Comprimento_medio_m" AS comprimento_medio_m,
        d."Peso_medio_kg" AS peso_medio_kg,
        d."Imagem" AS imagem_dinossauro,
        die."Nome_dieta" AS nome_dieta,
        p."Nome_periodo" AS nome_periodo,
        p."MA_inicio" AS ma_inicio,
        p."MA_fim" AS ma_fim,
        p."Clima" AS clima,
        f."Codigo" AS codigo_fossil,
        f."Data_descoberta" AS data_descoberta,
        des."Nome_descobridor" AS nome_descobridor,
        l."Cidade" AS cidade_descoberta,
        l."Estado" AS estado_descoberta,
        l."Pais" AS pais_descoberta,
        m."Nome_museu" AS nome_museu,
        m."Cidade_museu" AS cidade_museu,
        m."Pais_museu" AS pais_museu,
        o."Nome_parte" AS parte_osso
    FROM "Dinossauro" d
    LEFT JOIN "Tipo_Alimentacao" die ON d."ID_dieta" = die."ID"
    LEFT JOIN "Periodo_Geologico" p ON d."ID_periodo" = p."ID"
    LEFT JOIN "Fossil" f ON f."ID_dinossauro" = d."ID"
    LEFT JOIN "Descobridor" des ON f."ID_descobridor" = des."ID"
    LEFT JOIN "Localizacao" l ON f."ID_localizacao_descoberta" = l."ID"
    LEFT JOIN "Museu" m ON f."ID_museu" = m."ID"
    LEFT JOIN "Osso" o ON o."ID_fossil" = f."ID"
;
    """
    return run_query(query)

# Função de processamento dos dinossauros
def process_dinosaur_data():
    rows = get_dinosaur_data().to_dict(orient="records")

    dinosaurs = {}

    for row in rows:
        dino_id = row["id_dinossauro"]

        if dino_id not in dinosaurs:
            dinosaurs[dino_id] = {
                "id": dino_id,
                "nome_popular": row["nome_popular"],
                "nome_cientifico": row["nome_cientifico"],
                "significado_nome": row["significado_nome"],
                "altura_media_m": row["altura_media_m"],
                "comprimento_medio_m": row["comprimento_medio_m"],
                "peso_medio_kg": row["peso_medio_kg"],
                "imagem": row["imagem_dinossauro"],
                "nome_dieta": row["nome_dieta"],
                "nome_periodo": row["nome_periodo"],
                "ma_inicio": row["ma_inicio"],
                "ma_fim": row["ma_fim"],
                "clima": row["clima"],
                "fossil": []
            }

        # Adiciona fóssil se existir
        if row["codigo_fossil"]:
            fossil_list = dinosaurs[dino_id]["fossil"]
            fossil = next((f for f in fossil_list if f["codigo"] == row["codigo_fossil"]), None)

            if not fossil:
                fossil = {
                    "codigo": row["codigo_fossil"],
                    "data_descoberta": row["data_descoberta"],
                    "nome_descobridor": row["nome_descobridor"],
                    "local_descoberta": {
                        "cidade": row["cidade_descoberta"],
                        "estado": row["estado_descoberta"],
                        "pais": row["pais_descoberta"]
                    },
                    "museu": {
                        "nome": row["nome_museu"],
                        "cidade": row["cidade_museu"],
                        "pais": row["pais_museu"]
                    },
                    "ossos": []
                }
                fossil_list.append(fossil)

            if row["parte_osso"] and row["parte_osso"] not in fossil["ossos"]:
                fossil["ossos"].append(row["parte_osso"])

    dino_list = [dinosaurs[key] for key in sorted(dinosaurs.keys())]

    return dino_list

def create_dinosaur_selector():
    st.sidebar.header("Seleção de Dinossauro")

    dino_list = process_dinosaur_data()

    if not dino_list or len(dino_list) == 0:
        st.sidebar.warning("Nenhum dinossauro encontrado no banco de dados.")
        return None

    dino_dict = {d["nome_popular"]: d["id"] for d in dino_list}

    nomes = list(dino_dict.keys())

    selected_name = st.sidebar.selectbox(
        "Selecione um dinossauro",
        options=nomes,
        index=0 if nomes else None
    )

    return dino_dict.get(selected_name)


def main():
    dinosaur_id = create_dinosaur_selector()

    if not dinosaur_id:
        st.stop()

    st.success(f"Você selecionou o dinossauro de ID: {dinosaur_id}")

    
if __name__ == "__main__":
    main()