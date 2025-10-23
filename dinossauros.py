import types
import streamlit as st
import psycopg2
import pandas as pd
import plotly.express as px
from dotenv import load_dotenv
import os
import plotly.graph_objects as go
from geopy.geocoders import Nominatim

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

# Função que retorna apenas ID e nome dos dinossauros
def get_dinosaur_names():
    df = get_dinosaur_data()[["id_dinossauro", "nome_popular"]]
    return df.to_dict(orient="records")

# Função que retorna todos os dados de um dinossauro específico
def get_dinosaur_by_id(dino_id):
    rows = get_dinosaur_data().to_dict(orient="records")
    
    rows = [row for row in rows if row["id_dinossauro"] == dino_id]
    
    if not rows:
        return None
    
    dinosaur = {
        "id": dino_id,
        "nome_popular": rows[0]["nome_popular"],
        "nome_cientifico": rows[0]["nome_cientifico"],
        "significado_nome": rows[0]["significado_nome"],
        "altura_media_m": rows[0]["altura_media_m"],
        "comprimento_medio_m": rows[0]["comprimento_medio_m"],
        "peso_medio_kg": rows[0]["peso_medio_kg"],
        "imagem": rows[0]["imagem_dinossauro"],
        "nome_dieta": rows[0]["nome_dieta"],
        "nome_periodo": rows[0]["nome_periodo"],
        "ma_inicio": rows[0]["ma_inicio"],
        "ma_fim": rows[0]["ma_fim"],
        "clima": rows[0]["clima"],
        "fossil": []
    }
    
    # Adiciona fósseis e ossos
    for row in rows:
        if row["codigo_fossil"]:
            fossil_list = dinosaur["fossil"]
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
    
    return dinosaur

def create_dinosaur_selector():
    st.sidebar.header("Seleção de Dinossauro")
    dinos = get_dinosaur_names()
    
    if not dinos:
        st.sidebar.warning("Nenhum dinossauro encontrado.")
        return None

    dino_dict = {d["nome_popular"]: d["id_dinossauro"] for d in dinos}

    sorted_names = sorted(dino_dict.keys())

    selected_name = st.sidebar.selectbox("Selecione um dinossauro", sorted_names)
    
    return dino_dict.get(selected_name)

# Função para gráfico de Peso x Maior Peso Médio conhecido
def plot_peso_comparativo(dino):
    # Supondo que o maior peso médio de um dinossauro seja 80000 kg (exemplo)
    maior_peso = 80000
    df = pd.DataFrame({
        "Peso (kg)": [dino["peso_medio_kg"], maior_peso],
        "Categoria": [dino["nome_popular"], "Maior Peso Já Registrado"]
    })
    fig = px.bar(
        df,
        x="Categoria",
        y="Peso (kg)",
        color="Categoria",
        title="Peso Comparativo"
    )
    fig.update_layout(showlegend=False, height=300)
    return fig
    
def main():
    # Seleção de dinossauro
    dinosaur_id = create_dinosaur_selector()
    if not dinosaur_id:
        st.stop()
    dinosaur = get_dinosaur_by_id(dinosaur_id)
    
    # Detalhes do dinossauro selecionado
    col1, col2, col3 = st.columns(3)

    with col1:
        st.image(dinosaur["imagem"], width=300, caption=dinosaur["nome_popular"])
    with col2:
        st.header(f"{dinosaur['nome_popular']}")
        st.subheader(f"*{dinosaur['nome_cientifico']}*")
        st.markdown(f"**Significado do Nome:** {dinosaur['significado_nome']}")
        st.markdown(f"**Altura Média:** {dinosaur['altura_media_m']} m")
        st.markdown(f"**Comprimento Médio:** {dinosaur['comprimento_medio_m']} m")
        st.markdown(f"**Peso Médio:** {dinosaur['peso_medio_kg']} kg")
    with col3:
        if(dinosaur["nome_dieta"] == "Carnívoro"):
            st.header(f"**🥩{dinosaur['nome_dieta']}**")
        elif(dinosaur["nome_dieta"] == "Herbívoro"):
            st.header(f"**🥬{dinosaur['nome_dieta']}**")
        else:
            st.header(f"**🍽️{dinosaur['nome_dieta']}**")
        st.plotly_chart(plot_peso_comparativo(dinosaur), use_container_width=True)
    
    # Criar abas
    tab1, tab2, tab3 = st.tabs([
        "Período Geológico", 
        "Fósseis e Descobertas",
        "Localização de Descoberta"])
    
    with tab1:
        st.subheader(f"**{dinosaur['nome_periodo']}**")
        st.markdown(f"**Início:** {dinosaur['ma_inicio']} milhões de anos atrás")
        st.markdown(f"**Fim:** {dinosaur['ma_fim']} milhões de anos atrás")
        st.markdown(f"**Clima:** {dinosaur['clima']}")

    with tab2:
        if not dinosaur["fossil"]:
            st.info("Nenhum fóssil encontrado para este dinossauro.")
        else:
            for fossil in dinosaur["fossil"]:
                # Cria um expander para cada fóssil
                with st.expander(f"Fóssil: {fossil['codigo']}"):
                    st.markdown(f"**Data de Descoberta:** {fossil['data_descoberta']}")
                    st.markdown(f"**Descobridor:** {fossil['nome_descobridor']}")
                    
                    # Local de descoberta
                    local = fossil["local_descoberta"]
                    st.markdown(f"**Local de Descoberta:** {local['cidade']}, {local['estado']}, {local['pais']}")
                    
                    # Museu
                    museu = fossil["museu"]
                    st.markdown(f"**Museu:** {museu['nome']} ({museu['cidade']}, {museu['pais']})")
                    
                    # Ossos encontrados
                    if fossil["ossos"]:
                        st.markdown("**Ossos encontrados:**")
                        for osso in fossil["ossos"]:
                            st.markdown(f"- {osso}")
                    else:
                        st.markdown("Nenhum osso registrado para este fóssil.")
    
    with tab3:

        if not dinosaur["fossil"]:
            st.info("Nenhum fóssil encontrado para este dinossauro.")
        else:
            fig = go.Figure()
            geolocator = Nominatim(user_agent="dino_app")

            for fossil in dinosaur["fossil"]:
                local = fossil["local_descoberta"]
                endereco = f"{local['cidade']}, {local['estado']}, {local['pais']}"

                try:
                    location = geolocator.geocode(endereco)
                    if location:
                        lat, lon = location.latitude, location.longitude
                        fig.add_trace(go.Scattergeo(
                            lat=[lat],
                            lon=[lon],
                            text=[f"Fóssil {fossil['codigo']}"],
                            mode='markers+text',
                            marker=dict(size=10, color='red'),
                            textfont=dict(color="black"),
                            textposition="top center"
                        ))
                    else:
                        st.warning(f"Não foi possível localizar o endereço do fóssil {fossil['codigo']}.")
                except:
                    st.warning(f"Erro ao geocodificar o fóssil {fossil['codigo']}.")

            fig.update_geos(
                projection_type="orthographic",
                showcountries=True,
                showland=True,
                landcolor="rgb(243, 243, 243)",
                oceancolor="rgb(204, 224, 255)",
            )

            fig.update_layout(height=500, margin={"r":0,"t":0,"l":0,"b":0})
            st.plotly_chart(fig)

    
if __name__ == "__main__":
    main()