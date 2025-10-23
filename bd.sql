-- ============================================================================
-- ETAPA 1: CRIAÇÃO DAS TABELAS
-- SGBD: PostgreSQL
-- ============================================================================


-- Remove tabelas existentes em ordem inversa de dependência para evitar erros.
DROP TABLE IF EXISTS "Osso" CASCADE;
DROP TABLE IF EXISTS "Fossil" CASCADE;
DROP TABLE IF EXISTS "Formacao_Geologica" CASCADE;
DROP TABLE IF EXISTS "Dinossauro" CASCADE;
DROP TABLE IF EXISTS "Descobridor" CASCADE;
DROP TABLE IF EXISTS "Localizacao" CASCADE;
DROP TABLE IF EXISTS "Museu" CASCADE;
DROP TABLE IF EXISTS "Periodo_Geologico" CASCADE;
DROP TABLE IF EXISTS "Tipo_Alimentacao" CASCADE;
DROP TABLE IF EXISTS "Classificacao_Cientifica" CASCADE;


CREATE TABLE "Localizacao" (
    "ID" SERIAL,
    "Cidade" VARCHAR(100) NOT NULL,
    "Estado" VARCHAR(100) NOT NULL,
    "Pais" VARCHAR(100) NOT NULL,
    CONSTRAINT pk_localizacao PRIMARY KEY ("ID"),
    CONSTRAINT uq_localizacao_unica UNIQUE ("Cidade", "Estado", "Pais")
);


CREATE TABLE "Tipo_Alimentacao" (
    "ID" SERIAL,
    "Nome_dieta" VARCHAR(100) NOT NULL,
    CONSTRAINT pk_tipo_alimentacao PRIMARY KEY ("ID"),
    CONSTRAINT uq_nome_dieta UNIQUE ("Nome_dieta")
);


CREATE TABLE "Museu" (
    "ID" SERIAL,
    "Nome_museu" VARCHAR(255) NOT NULL,
    "Cidade_museu" VARCHAR(100),
    "Pais_museu" VARCHAR(100),
    CONSTRAINT pk_museu PRIMARY KEY ("ID"),
    CONSTRAINT uq_nome_museu UNIQUE ("Nome_museu")
);


CREATE TABLE "Classificacao_Cientifica" (
    "ID" SERIAL,
    "Nome_taxon" VARCHAR(255) NOT NULL,
    "Nivel_taxon" VARCHAR(100),
    "Descricao_taxon" TEXT,


    CONSTRAINT pk_classificacao_cientifica PRIMARY KEY ("ID"),
    CONSTRAINT uq_nome_taxon UNIQUE ("Nome_taxon")
);


CREATE TYPE periodo AS ENUM ('Jurássico', 'Triássico', 'Cretáceo');


CREATE TABLE "Periodo_Geologico" (
    "ID" SERIAL,
    "Nome_periodo" periodo NOT NULL,
    "Era_geologica" VARCHAR(100),
    "MA_inicio" NUMERIC(6, 2) NOT NULL,
    "MA_fim" NUMERIC(6, 2) NOT NULL,
    "Clima" TEXT,
    "Flora" TEXT NOT NULL,
    "Eventos_importantes" TEXT NOT NULL,
    "O2_nivel" FLOAT NOT NULL,
    "Fauna_marinha" TEXT NOT NULL,
    "Nivel_mar" VARCHAR(5) NOT NULL,
    "Impacto_eventos" TEXT NOT NULL,



    CONSTRAINT pk_periodo_geologico PRIMARY KEY ("ID"),
    CONSTRAINT uq_nome_periodo UNIQUE ("Nome_periodo")
);


CREATE TABLE "Descobridor" (
    "ID" SERIAL,
    "Nome_descobridor" VARCHAR(255) NOT NULL,
    "Instituicao" VARCHAR(255),
    "Data_nascimento" DATE,
    "ID_localizacao" INT,


    CONSTRAINT pk_descobridor PRIMARY KEY ("ID"),
    CONSTRAINT uq_nome_descobridor UNIQUE ("Nome_descobridor"),
    CONSTRAINT fk_descobridor_localizacao FOREIGN KEY ("ID_localizacao") REFERENCES "Localizacao" ("ID")
);


CREATE TABLE "Dinossauro" (
    "ID" SERIAL,
    "Nome_cientifico" VARCHAR(255) NOT NULL,
    "Nome_popular" VARCHAR(255),
    "Significado_nome" TEXT,
    "Altura_media_m" NUMERIC(5, 2),
    "Comprimento_medio_m" NUMERIC(5, 2),
    "Peso_medio_kg" NUMERIC(10, 2),
    "ID_taxon" INT,
    "ID_dieta" INT,
    "ID_periodo" INT,
    "Imagem" VARCHAR(255) NOT NULL,

    CONSTRAINT pk_dinossauro PRIMARY KEY ("ID"),
    CONSTRAINT uq_nome_cientifico UNIQUE ("Nome_cientifico"),
    CONSTRAINT fk_dino_taxon FOREIGN KEY ("ID_taxon") REFERENCES "Classificacao_Cientifica" ("ID"),
    CONSTRAINT fk_dino_dieta FOREIGN KEY ("ID_dieta") REFERENCES "Tipo_Alimentacao" ("ID"),
    CONSTRAINT fk_dino_periodo FOREIGN KEY ("ID_periodo") REFERENCES "Periodo_Geologico" ("ID")
);


CREATE TABLE "Fossil" (
    "ID" SERIAL,
    "Codigo" VARCHAR(100) NOT NULL,
    "Estado_conservacao" VARCHAR(255),
    "Data_descoberta" DATE,
    "ID_dinossauro" INT NOT NULL,
    "ID_museu" INT,
    "ID_descobridor" INT,
    "ID_localizacao_descoberta" INT,
    "Num_catalogo" INT,


    CONSTRAINT pk_fossil PRIMARY KEY ("ID"),
    CONSTRAINT uq_codigo_fossil UNIQUE ("Codigo"),
    CONSTRAINT fk_fossil_dinossauro FOREIGN KEY ("ID_dinossauro") REFERENCES "Dinossauro" ("ID"),
    CONSTRAINT fk_fossil_museu FOREIGN KEY ("ID_museu") REFERENCES "Museu" ("ID"),
    CONSTRAINT fk_fossil_descobridor FOREIGN KEY ("ID_descobridor") REFERENCES "Descobridor" ("ID"),
    CONSTRAINT fk_fossil_localizacao FOREIGN KEY ("ID_localizacao_descoberta") REFERENCES "Localizacao" ("ID")
);


CREATE TABLE "Osso" (
    "ID" SERIAL,
    "Nome_parte" VARCHAR(255) NOT NULL,
    "Descricao_parte" TEXT,
    "ID_fossil" INT NOT NULL,


    CONSTRAINT pk_osso PRIMARY KEY ("ID"),
    CONSTRAINT fk_osso_fossil FOREIGN KEY ("ID_fossil") REFERENCES "Fossil" ("ID"),
    CONSTRAINT uq_osso_fossil UNIQUE ("Nome_parte", "ID_fossil")
);
