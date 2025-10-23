-- ============================================================================
-- ETAPA 2: POPULAÇÃO DO BANCO DE DADOS
-- Observações: Dados fictícios gerados por IA para fins de teste.
-- ============================================================================


INSERT INTO "Localizacao" ("Cidade", "Estado", "Pais") VALUES
('Uberaba', 'Minas Gerais', 'Brasil'), ('Marília', 'São Paulo', 'Brasil'),
('Hell Creek', 'Montana', 'EUA'), ('Neuquén', 'Patagônia', 'Argentina'),
('Zigong', 'Sichuan', 'China'), ('Solnhofen', 'Baviera', 'Alemanha'),
('Ica', 'Ica', 'Peru'), ('Lisboa', 'Lisboa', 'Portugal'),
('Calgary', 'Alberta', 'Canadá'), ('Santa Cruz', 'Santa Cruz', 'Argentina');


INSERT INTO "Tipo_Alimentacao" ("Nome_dieta") VALUES
('Herbívoro'), ('Carnívoro'), ('Onívoro'), ('Piscívoro');


INSERT INTO "Periodo_Geologico" (
    "Nome_periodo", "Era_geologica", "MA_inicio", "MA_fim", "Clima",
    "Flora", "Eventos_importantes", "O2_nivel", "Fauna_marinha", "Nivel_mar", "Impacto_eventos"
) VALUES
('Cretáceo', 'Mesozoica', 145.0, 66.0, 'Quente e úmido, com mares interiores rasos.',
 'Plantas com flores, angiospermas.', 'Extinção dos dinossauros no final do período.', 21.0,
 'Diversificação de peixes ósseos e moluscos.', 'Alto', 'Impacto de asteroide e vulcanismo.'),
('Jurássico', 'Mesozoica', 201.3, 145.0, 'Quente e árido no início, tornando-se mais úmido.',
 'Samambaias, cicadáceas e coníferas.', 'Separação de continentes.', 26.0,
 'Dominado por répteis marinhos.', 'Médio', 'Diversificação de dinossauros.'),
('Triássico', 'Mesozoica', 251.9, 201.3, 'Predominantemente quente e seco.',
 'Samambaias, musgos e gimnospermas.', 'Extinção permiana e surgimento dos dinossauros.', 16.0,
 'Recuperação da fauna marinha após extinção.', 'Baixo', 'Formação de Pangeia e primeiros dinossauros.');




INSERT INTO "Museu" ("Nome_museu", "Cidade_museu", "Pais_museu") VALUES
('Museu de Paleontologia de Marília', 'Marília', 'Brasil'),
('Museu dos Dinossauros', 'Uberaba', 'Brasil'),
('Museo Argentino de Ciencias Naturales', 'Buenos Aires', 'Argentina'),
('Royal Tyrrell Museum of Palaeontology', 'Calgary', 'Canadá'),
('Zigong Dinosaur Museum', 'Zigong', 'China'),
('Museum für Naturkunde', 'Berlim', 'Alemanha'),
('Field Museum of Natural History', 'Chicago', 'EUA'),
('American Museum of Natural History', 'Nova Iorque', 'EUA'),
('Museu da Lourinhã', 'Lisboa', 'Portugal'),
('Museo de La Plata', 'La Plata', 'Argentina');


INSERT INTO "Classificacao_Cientifica" ("Nome_taxon") VALUES
('Tyrannosauridae'), ('Titanosauria'), ('Stegosauria'), ('Ceratopsidae'),
('Dromaeosauridae'), ('Hadrosauridae'), ('Abelisauridae'), ('Carcharodontosauridae'),
('Spinosauridae'), ('Ankylosauridae');


INSERT INTO "Descobridor" ("Nome_descobridor", "Instituicao", "ID_localizacao") VALUES
('Barnum Brown', 'American Museum of Natural History', (SELECT "ID" FROM "Localizacao" WHERE "Cidade" = 'Hell Creek')),
('Llewellyn Ivor Price', 'DNPM', (SELECT "ID" FROM "Localizacao" WHERE "Cidade" = 'Uberaba')),
('José Bonaparte', 'Museo Argentino de Ciencias Naturales', (SELECT "ID" FROM "Localizacao" WHERE "Cidade" = 'Neuquén')),
('William H. Walker', 'Independente', (SELECT "ID" FROM "Localizacao" WHERE "Cidade" = 'Marília')),
('Sue Hendrickson', 'Independente', (SELECT "ID" FROM "Localizacao" WHERE "Cidade" = 'Hell Creek')),
('Othniel Charles Marsh', 'Yale University', (SELECT "ID" FROM "Localizacao" WHERE "Cidade" = 'Hell Creek')),
('Werner Janensch', 'Museum für Naturkunde', (SELECT "ID" FROM "Localizacao" WHERE "Cidade" = 'Solnhofen')),
('Roy Chapman Andrews', 'American Museum of Natural History', (SELECT "ID" FROM "Localizacao" WHERE "Cidade" = 'Zigong')),
('Paul Sereno', 'University of Chicago', (SELECT "ID" FROM "Localizacao" WHERE "Cidade" = 'Neuquén')),
('Mary Anning', 'Independente', (SELECT "ID" FROM "Localizacao" WHERE "Cidade" = 'Lisboa'));


INSERT INTO "Dinossauro" (
    "Nome_cientifico",
    "Nome_popular",
    "Significado_nome",
    "Altura_media_m",
    "Comprimento_medio_m",
    "Peso_medio_kg",
    "ID_dieta",
    "ID_periodo",
    "ID_taxon",
    "Imagem"
) VALUES
('Tyrannosaurus Rex', 'T-Rex',
 'Rei dos lagartos tiranos',
 4.0, 12.8, 8000.00,
 (SELECT "ID" FROM "Tipo_Alimentacao" WHERE "Nome_dieta" = 'Carnívoro'),
 (SELECT "ID" FROM "Periodo_Geologico" WHERE "Nome_periodo" = 'Cretáceo'),
 (SELECT "ID" FROM "Classificacao_Cientifica" WHERE "Nome_taxon" = 'Tyrannosauridae'),
 'https://raw.githubusercontent.com/brendomota/Projeto-I-Banco-Dados/refs/heads/main/Imagens_Dinossauros/Tyrannosaurus_Rex.png'),

('Triceratops horridus', 'Tricerátops',
 'Rosto com três chifres',
 3.0, 9.0, 6000.00,
 (SELECT "ID" FROM "Tipo_Alimentacao" WHERE "Nome_dieta" = 'Herbívoro'),
 (SELECT "ID" FROM "Periodo_Geologico" WHERE "Nome_periodo" = 'Cretáceo'),
 (SELECT "ID" FROM "Classificacao_Cientifica" WHERE "Nome_taxon" = 'Ceratopsidae'),
 'https://raw.githubusercontent.com/brendomota/Projeto-I-Banco-Dados/refs/heads/main/Imagens_Dinossauros/Triceratops_horridus.png'),

('Stegosaurus stenops', 'Estegossauro',
 'Lagarto coberto ou telhado',
 4.0, 9.0, 5000.00,
 (SELECT "ID" FROM "Tipo_Alimentacao" WHERE "Nome_dieta" = 'Herbívoro'),
 (SELECT "ID" FROM "Periodo_Geologico" WHERE "Nome_periodo" = 'Jurássico'),
 (SELECT "ID" FROM "Classificacao_Cientifica" WHERE "Nome_taxon" = 'Stegosauria'),
 'https://raw.githubusercontent.com/brendomota/Projeto-I-Banco-Dados/refs/heads/main/Imagens_Dinossauros/Stegosaurus_stenops.png'),

('Argentinosaurus huinculensis', 'Argentinossauro',
 'Lagarto da Argentina',
 7.0, 35.0, 70000.00,
 (SELECT "ID" FROM "Tipo_Alimentacao" WHERE "Nome_dieta" = 'Herbívoro'),
 (SELECT "ID" FROM "Periodo_Geologico" WHERE "Nome_periodo" = 'Cretáceo'),
 (SELECT "ID" FROM "Classificacao_Cientifica" WHERE "Nome_taxon" = 'Titanosauria'),
 'https://raw.githubusercontent.com/brendomota/Projeto-I-Banco-Dados/refs/heads/main/Imagens_Dinossauros/Argentinosaurus_huinculensis.png'),

('Velociraptor mongoliensis', 'Velociraptor',
 'Ladrão veloz',
 0.5, 2.0, 15.00,
 (SELECT "ID" FROM "Tipo_Alimentacao" WHERE "Nome_dieta" = 'Carnívoro'),
 (SELECT "ID" FROM "Periodo_Geologico" WHERE "Nome_periodo" = 'Cretáceo'),
 (SELECT "ID" FROM "Classificacao_Cientifica" WHERE "Nome_taxon" = 'Dromaeosauridae'),
 'https://raw.githubusercontent.com/brendomota/Projeto-I-Banco-Dados/refs/heads/main/Imagens_Dinossauros/Velociraptor_mongoliensis.png'),

('Brachiosaurus altithorax', 'Braquiossauro',
 'Lagarto de braços longos',
 12.0, 26.0, 56000.00,
 (SELECT "ID" FROM "Tipo_Alimentacao" WHERE "Nome_dieta" = 'Herbívoro'),
 (SELECT "ID" FROM "Periodo_Geologico" WHERE "Nome_periodo" = 'Jurássico'),
 (SELECT "ID" FROM "Classificacao_Cientifica" WHERE "Nome_taxon" = 'Titanosauria'),
 'https://raw.githubusercontent.com/brendomota/Projeto-I-Banco-Dados/refs/heads/main/Imagens_Dinossauros/Brachiosaurus_altithorax.png'),

('Ankylosaurus magniventris', 'Anquilossauro',
 'Lagarto fundido ou rígido',
 1.7, 8.0, 8000.00,
 (SELECT "ID" FROM "Tipo_Alimentacao" WHERE "Nome_dieta" = 'Herbívoro'),
 (SELECT "ID" FROM "Periodo_Geologico" WHERE "Nome_periodo" = 'Cretáceo'),
 (SELECT "ID" FROM "Classificacao_Cientifica" WHERE "Nome_taxon" = 'Ankylosauridae'),
 'https://raw.githubusercontent.com/brendomota/Projeto-I-Banco-Dados/refs/heads/main/Imagens_Dinossauros/Ankylosaurus_magniventris.png'),

('Giganotosaurus carolinii', 'Giganotossauro',
 'Lagarto gigante do sul',
 4.0, 13.0, 8000.00,
 (SELECT "ID" FROM "Tipo_Alimentacao" WHERE "Nome_dieta" = 'Carnívoro'),
 (SELECT "ID" FROM "Periodo_Geologico" WHERE "Nome_periodo" = 'Cretáceo'),
 (SELECT "ID" FROM "Classificacao_Cientifica" WHERE "Nome_taxon" = 'Carcharodontosauridae'),
 'https://raw.githubusercontent.com/brendomota/Projeto-I-Banco-Dados/refs/heads/main/Imagens_Dinossauros/Giganotosaurus_carolinii.png'),

('Allosaurus fragilis', 'Alossauro',
 'Lagarto diferente',
 4.5, 10.0, 2200.00,
 (SELECT "ID" FROM "Tipo_Alimentacao" WHERE "Nome_dieta" = 'Carnívoro'),
 (SELECT "ID" FROM "Periodo_Geologico" WHERE "Nome_periodo" = 'Jurássico'),
 (SELECT "ID" FROM "Classificacao_Cientifica" WHERE "Nome_taxon" = 'Carcharodontosauridae'),
 'https://raw.githubusercontent.com/brendomota/Projeto-I-Banco-Dados/refs/heads/main/Imagens_Dinossauros/Allosaurus_fragilis.png'),

('Edmontosaurus regalis', 'Edmontossauro',
 'Lagarto de Edmonton',
 3.0, 12.0, 4000.00,
 (SELECT "ID" FROM "Tipo_Alimentacao" WHERE "Nome_dieta" = 'Herbívoro'),
 (SELECT "ID" FROM "Periodo_Geologico" WHERE "Nome_periodo" = 'Cretáceo'),
 (SELECT "ID" FROM "Classificacao_Cientifica" WHERE "Nome_taxon" = 'Hadrosauridae'),
 'https://raw.githubusercontent.com/brendomota/Projeto-I-Banco-Dados/refs/heads/main/Imagens_Dinossauros/Edmontosaurus_regalis.png');




INSERT INTO "Fossil" (
    "Codigo", "ID_dinossauro", "ID_museu", "Data_descoberta",
    "ID_localizacao_descoberta", "ID_descobridor", "Num_catalogo"
) VALUES
-- Tyrannosaurus Rex
('RTMP 81.6.1',
 (SELECT "ID" FROM "Dinossauro" WHERE "Nome_cientifico" = 'Tyrannosaurus Rex'),
 (SELECT "ID" FROM "Museu" WHERE "Nome_museu" = 'Royal Tyrrell Museum of Palaeontology'),
 '1981-06-01',
 (SELECT "ID" FROM "Localizacao" WHERE "Cidade" = 'Calgary'),
 (SELECT "ID" FROM "Descobridor" WHERE "Nome_descobridor" = 'Sue Hendrickson'),
 1001
),
('AMNH 5027',
 (SELECT "ID" FROM "Dinossauro" WHERE "Nome_cientifico" = 'Tyrannosaurus Rex'),
 (SELECT "ID" FROM "Museu" WHERE "Nome_museu" = 'American Museum of Natural History'),
 '1908-01-01',
 (SELECT "ID" FROM "Localizacao" WHERE "Cidade" = 'Hell Creek'),
 (SELECT "ID" FROM "Descobridor" WHERE "Nome_descobridor" = 'Barnum Brown'),
 1002
),
('FMNH PR 2081',
 (SELECT "ID" FROM "Dinossauro" WHERE "Nome_cientifico" = 'Tyrannosaurus Rex'),
 (SELECT "ID" FROM "Museu" WHERE "Nome_museu" = 'Field Museum of Natural History'),
 '1990-08-12',
 (SELECT "ID" FROM "Localizacao" WHERE "Cidade" = 'Hell Creek'),
 (SELECT "ID" FROM "Descobridor" WHERE "Nome_descobridor" = 'Sue Hendrickson'),
 1003
),


-- Triceratops horridus
('RTMP 99.55.1',
 (SELECT "ID" FROM "Dinossauro" WHERE "Nome_cientifico" = 'Triceratops horridus'),
 (SELECT "ID" FROM "Museu" WHERE "Nome_museu" = 'Royal Tyrrell Museum of Palaeontology'),
 '1999-01-01',
 (SELECT "ID" FROM "Localizacao" WHERE "Cidade" = 'Calgary'),
 (SELECT "ID" FROM "Descobridor" WHERE "Nome_descobridor" = 'William H. Walker'),
 1004
),


-- Ankylosaurus magniventris
('RTMP 2002.1.1',
 (SELECT "ID" FROM "Dinossauro" WHERE "Nome_cientifico" = 'Ankylosaurus magniventris'),
 (SELECT "ID" FROM "Museu" WHERE "Nome_museu" = 'Royal Tyrrell Museum of Palaeontology'),
 '2002-01-01',
 (SELECT "ID" FROM "Localizacao" WHERE "Cidade" = 'Calgary'),
 (SELECT "ID" FROM "Descobridor" WHERE "Nome_descobridor" = 'William H. Walker'),
 1005
),


-- Edmontosaurus regalis
('RTMP 2005.12.5',
 (SELECT "ID" FROM "Dinossauro" WHERE "Nome_cientifico" = 'Edmontosaurus regalis'),
 (SELECT "ID" FROM "Museu" WHERE "Nome_museu" = 'Royal Tyrrell Museum of Palaeontology'),
 '2005-01-01',
 (SELECT "ID" FROM "Localizacao" WHERE "Cidade" = 'Calgary'),
 (SELECT "ID" FROM "Descobridor" WHERE "Nome_descobridor" = 'William H. Walker'),
 1006
),


-- Stegosaurus stenops
('ML 434',
 (SELECT "ID" FROM "Dinossauro" WHERE "Nome_cientifico" = 'Stegosaurus stenops'),
 (SELECT "ID" FROM "Museu" WHERE "Nome_museu" = 'Museu da Lourinhã'),
 '1998-05-20',
 (SELECT "ID" FROM "Localizacao" WHERE "Cidade" = 'Lisboa'),
 (SELECT "ID" FROM "Descobridor" WHERE "Nome_descobridor" = 'Mary Anning'),
 1007
),


-- Brachiosaurus altithorax
('ML 370',
 (SELECT "ID" FROM "Dinossauro" WHERE "Nome_cientifico" = 'Brachiosaurus altithorax'),
 (SELECT "ID" FROM "Museu" WHERE "Nome_museu" = 'Museu da Lourinhã'),
 '1995-07-15',
 (SELECT "ID" FROM "Localizacao" WHERE "Cidade" = 'Lisboa'),
 (SELECT "ID" FROM "Descobridor" WHERE "Nome_descobridor" = 'Mary Anning'),
 1008
),


-- Allosaurus fragilis
('ML 565',
 (SELECT "ID" FROM "Dinossauro" WHERE "Nome_cientifico" = 'Allosaurus fragilis'),
 (SELECT "ID" FROM "Museu" WHERE "Nome_museu" = 'Museu da Lourinhã'),
 '2001-09-01',
 (SELECT "ID" FROM "Localizacao" WHERE "Cidade" = 'Lisboa'),
 (SELECT "ID" FROM "Descobridor" WHERE "Nome_descobridor" = 'Mary Anning'),
 1009
),


-- Giganotosaurus carolinii
('MACN-CH 894',
 (SELECT "ID" FROM "Dinossauro" WHERE "Nome_cientifico" = 'Giganotosaurus carolinii'),
 (SELECT "ID" FROM "Museu" WHERE "Nome_museu" = 'Museo Argentino de Ciencias Naturales'),
 '1993-07-25',
 (SELECT "ID" FROM "Localizacao" WHERE "Cidade" = 'Neuquén'),
 (SELECT "ID" FROM "Descobridor" WHERE "Nome_descobridor" = 'José Bonaparte'),
 1010
);




INSERT INTO "Osso" ("Nome_parte", "ID_fossil") VALUES
('Crânio', (SELECT "ID" FROM "Fossil" WHERE "Codigo" = 'RTMP 81.6.1')), ('Fêmur Direito', (SELECT "ID" FROM "Fossil" WHERE "Codigo" = 'RTMP 81.6.1')), ('Costela 1', (SELECT "ID" FROM "Fossil" WHERE "Codigo" = 'RTMP 81.6.1')),
('Crânio', (SELECT "ID" FROM "Fossil" WHERE "Codigo" = 'RTMP 99.55.1')), ('Chifre Frontal', (SELECT "ID" FROM "Fossil" WHERE "Codigo" = 'RTMP 99.55.1')),
('Placa Dérmica 1', (SELECT "ID" FROM "Fossil" WHERE "Codigo" = 'ML 434')), ('Placa Dérmica 2', (SELECT "ID" FROM "Fossil" WHERE "Codigo" = 'ML 434')), ('Vértebra Caudal', (SELECT "ID" FROM "Fossil" WHERE "Codigo" = 'ML 434')),
('Úmero', (SELECT "ID" FROM "Fossil" WHERE "Codigo" = 'ML 370')), ('Fêmur', (SELECT "ID" FROM "Fossil" WHERE "Codigo" = 'ML 370')),
('Crânio', (SELECT "ID" FROM "Fossil" WHERE "Codigo" = 'ML 565')), ('Dente', (SELECT "ID" FROM "Fossil" WHERE "Codigo" = 'ML 565'));
