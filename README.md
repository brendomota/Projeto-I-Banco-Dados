# 🦖 Dinossauros — Dashboard Interativo com PostgreSQL

Um **dashboard interativo** desenvolvido com **Streamlit**, **PostgreSQL** e **Plotly**, que exibe informações detalhadas sobre dinossauros, seus fósseis, períodos geológicos e locais de descoberta.  

O projeto conecta-se a um banco de dados relacional e permite explorar, de forma visual e dinâmica, diversos dados paleontológicos.

---

## 🚀 Funcionalidades

- **Consulta dinâmica ao banco de dados PostgreSQL**
  - Recupera informações completas sobre dinossauros, dietas, períodos geológicos, fósseis e museus.  
- **Interface interativa com Streamlit**
  - Seleção de dinossauro por nome.
  - Exibição de imagens, medidas e classificação alimentar.  
- **Visualizações gráficas com Plotly**
  - Gráfico de barras comparando o peso médio do dinossauro com o maior peso já registrado.
  - Mapa geográfico mostrando os locais de descoberta dos fósseis.  
- **Cache de dados otimizado**
  - Usa `@st.cache_data` e `@st.cache_resource` para melhorar o desempenho e reduzir consultas repetidas ao banco.

---

## 🧩 Tecnologias Utilizadas

| Tecnologia | Descrição |
|-------------|------------|
| **Python 3.11+** | Linguagem principal do projeto |
| **Streamlit** | Framework para construção do dashboard interativo |
| **PostgreSQL** | Banco de dados relacional |
| **psycopg2** | Driver de conexão com o PostgreSQL |
| **Plotly** | Biblioteca de gráficos interativos |
| **Pandas** | Manipulação e análise de dados |
| **Geopy** | Geocodificação dos locais de descoberta dos fósseis |
| **dotenv** | Carregamento de variáveis de ambiente a partir de um arquivo `.env` |

---

## ⚙️ Estrutura do Projeto
├── 📄 dinossauros.py # Script principal da aplicação Streamlit <br>
├── 📄 .env # Variáveis de ambiente (configurações do banco)<br>
├── 📁 .venv # Ambiente virtual Python<br>
├── 📄 requirements.txt # Dependências do projeto<br>
└── 📄 README.md # Este arquivo

---

## 🔑 Configuração do Banco de Dados

No arquivo `.env`, configure as variáveis de ambiente com suas credenciais PostgreSQL:

