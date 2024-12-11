CREATE TABLE tabela01_pais (
    id SERIAL PRIMARY KEY,
    nome_pais VARCHAR NOT NULL UNIQUE
);
INSERT INTO tabela01_pais (nome_pais) VALUES ('Angola');

CREATE TABLE tabela02_provincia (
    id SERIAL PRIMARY KEY,
    nome_provincia VARCHAR NOT NULL UNIQUE,
    id_pais INT NOT NULL,
    FOREIGN KEY (id_pais) REFERENCES tabela01_pais (id)
);
INSERT INTO tabela02_provincia (nome_provincia, id_pais) VALUES ('Luanda', 1);

CREATE TABLE tabela03_municipio (
    id SERIAL PRIMARY KEY,
    nome_municipio VARCHAR NOT NULL UNIQUE,
    id_provincia INT NOT NULL,
    FOREIGN KEY (id_provincia) REFERENCES tabela02_provincia (id)
);

CREATE TABLE tabela04_bairro (
    id SERIAL PRIMARY KEY,
    nome_bairro VARCHAR NOT NULL,
    id_municipio INT NOT NULL,
    FOREIGN KEY (id_municipio) REFERENCES tabela03_municipio (id)
);

CREATE TABLE tabela05_rua (
    id SERIAL PRIMARY KEY,
    nome_rua VARCHAR NOT NULL,
    id_bairro INT NOT NULL,
    FOREIGN KEY (id_bairro) REFERENCES tabela04_bairro (id)
);

CREATE TABLE tabela06_localizacao (
    id SERIAL PRIMARY KEY,
    id_rua INT NOT NULL,
    id_bairro INT NOT NULL,
    id_municipio INT NOT NULL,
    id_provincia INT NOT NULL,
    id_pais INT NOT NULL,
    FOREIGN KEY (id_rua) REFERENCES tabela05_rua (id),
    FOREIGN KEY (id_bairro) REFERENCES tabela04_bairro (id),
    FOREIGN KEY (id_municipio) REFERENCES tabela03_municipio (id),
    FOREIGN KEY (id_provincia) REFERENCES tabela02_provincia (id),
    FOREIGN KEY (id_pais) REFERENCES tabela01_pais (id)
);

CREATE TABLE tabela07_tipo_imovel (
    id SERIAL PRIMARY KEY,
    tipo_imovel VARCHAR NOT NULL UNIQUE,
    estado BOOLEAN NOT NULL
);

CREATE TABLE tabela08_caracteristica_imovel (
    id SERIAL PRIMARY KEY,
    caracteristica VARCHAR NOT NULL,
    descricao VARCHAR NOT NULL,
    id_tipo_imovel INT NOT NULL,
    FOREIGN KEY (id_tipo_imovel) REFERENCES tabela07_tipo_imovel (id)
);

CREATE TABLE tabela09_funcionario (
    id SERIAL PRIMARY KEY,
    nome VARCHAR NOT NULL,
    telefone VARCHAR NOT NULL,
    email VARCHAR NOT NULL,
    senha VARCHAR NOT NULL,
    estado VARCHAR NOT NULL,
    id_provincia INT NOT NULL,
    nivel VARCHAR NOT NULL,
    avatar VARCHAR,
    FOREIGN KEY (id_provincia) REFERENCES tabela02_provincia (id)
);
INSERT INTO tabela09_funcionario (nome, telefone, email, senha, estado, id_provincia, nivel, avatar)
VALUES ('admin', '944203358', 'root@.com', '99ADC231B045331E514A516B4B7680F588E3823213ABE901738BC3AD67B2F6FCB3C64EFB93D18002588D3CCC1A49EFBAE1CE20CB43DF36B38651F11FA75678E8', 'Activo', 1, 'Gerente', 'http://192.168.1.158:5254/images/944203358/avatar.jpg');

CREATE TABLE tabela10_cliente_proprietario (
    id SERIAL PRIMARY KEY,
    nome VARCHAR NOT NULL,
    telefone VARCHAR NOT NULL,
    email VARCHAR NOT NULL,
    senha VARCHAR NOT NULL,
    estado VARCHAR NOT NULL
);

CREATE TABLE tabela11_cliente_solicitante (
    id SERIAL PRIMARY KEY,
    nome VARCHAR NOT NULL,
    telefone VARCHAR NOT NULL,
	email VARCHAR NOT NULL,
    senha VARCHAR NOT NULL,
    estado VARCHAR NOT NULL
);

CREATE TABLE tabela12_imovel (
    codigo_imovel VARCHAR PRIMARY KEY,
    id_cliente_proprietario INT NOT NULL,
    id_corretor INT NOT NULL,
    descricao VARCHAR NOT NULL,
    data_solicitacao TIMESTAMP NOT NULL,
    estado VARCHAR NOT NULL,
    tipo_publicidade INT NOT NULL,
    preco DECIMAL(10, 2) NOT NULL,
    id_natureza_imovel INT NOT NULL,
    id_localizacao INT NOT NULL,
    FOREIGN KEY (id_cliente_proprietario) REFERENCES tabela10_cliente_proprietario (id),
    FOREIGN KEY (id_corretor) REFERENCES tabela09_funcionario (id),
    FOREIGN KEY (id_natureza_imovel) REFERENCES tabela08_caracteristica_imovel (id),
    FOREIGN KEY (id_localizacao) REFERENCES tabela06_localizacao (id)
);

CREATE TABLE tabela13_foto (
    id SERIAL PRIMARY KEY,
    imagem VARCHAR NOT NULL,
    codigo_imovel VARCHAR NOT NULL,
    FOREIGN KEY (codigo_imovel) REFERENCES tabela12_imovel (codigo_imovel)
);

CREATE TABLE tabela14_publicacao (
    codigo_publicacao VARCHAR PRIMARY KEY UNIQUE,
    data_publicacao TIMESTAMP NOT NULL,
    gostei INT NOT NULL,
    nao_gostei INT NOT NULL,
    total_comentarios INT NOT NULL,
    estado BOOLEAN NOT NULL,
    data_conclusao TIMESTAMP NOT NULL,
	FOREIGN KEY (codigo_publicacao) REFERENCES tabela12_imovel (codigo_imovel)
);

CREATE TABLE tabela15_notificar_proprietario (
    id SERIAL PRIMARY KEY,
    id_corretor INT NOT NULL,
    id_cliente_proprietario INT NOT NULL,
    codigo_imovel VARCHAR NOT NULL,
    descricao VARCHAR NOT NULL,
    data_notificacao TIMESTAMP NOT NULL,
    FOREIGN KEY (id_corretor) REFERENCES tabela09_funcionario (id),
    FOREIGN KEY (id_cliente_proprietario) REFERENCES tabela10_cliente_proprietario (id),
    FOREIGN KEY (codigo_imovel) REFERENCES tabela12_imovel (codigo_imovel)
);

CREATE TABLE tabela16_solicitacao_cliente (
    id SERIAL PRIMARY KEY,
    id_cliente_solicitante INT NOT NULL,
    preco_minimo DECIMAL NOT NULL,
    preco_maximo DECIMAL NOT NULL,
    id_tipo_imovel INT NOT NULL,
    localizacao VARCHAR NOT NULL,
    FOREIGN KEY (id_cliente_solicitante) REFERENCES tabela11_cliente_solicitante (id),
    FOREIGN KEY (id_tipo_imovel) REFERENCES tabela07_tipo_imovel (id)
);

CREATE TABLE tabela17_notificar_cliente (
    id SERIAL PRIMARY KEY,
    mensagem VARCHAR NOT NULL,
    id_publicacao VARCHAR NOT NULL,
    id_solicitacao INT NOT NULL,
    data_notificacao TIMESTAMP NOT NULL,
    FOREIGN KEY (id_publicacao) REFERENCES tabela14_publicacao (codigo_publicacao),
    FOREIGN KEY (id_solicitacao) REFERENCES tabela16_solicitacao_cliente (id)
);

CREATE TABLE tabela18_lead (
    id SERIAL PRIMARY KEY,
    id_publicacao VARCHAR NOT NULL,
    id_cliente_solicitante INT NOT NULL,
    estado VARCHAR NOT NULL,
    data_abertura TIMESTAMP NOT NULL,
    data_conclusao TIMESTAMP NOT NULL,
    FOREIGN KEY (id_publicacao) REFERENCES tabela14_publicacao (codigo_publicacao),
    FOREIGN KEY (id_cliente_solicitante) REFERENCES tabela11_cliente_solicitante (id)
);

CREATE TABLE tabela19_chat (
    id SERIAL PRIMARY KEY,
    id_corretor INT NOT NULL,
    id_lead INT NOT NULL,
    id_cliente_solicitante INT NOT NULL,
    mensagem TEXT NOT NULL,
    data_mensagem TIMESTAMP NOT NULL,
    pergunta_mensagem TEXT NOT NULL,
    id_pergunta INT NOT NULL,
    data_conclusao TIMESTAMP NOT NULL,
    FOREIGN KEY (id_corretor) REFERENCES tabela09_funcionario (id),
    FOREIGN KEY (id_lead) REFERENCES tabela18_lead (id),
    FOREIGN KEY (id_cliente_solicitante) REFERENCES tabela11_cliente_solicitante (id)
);

CREATE TABLE tabela20_token (
    id SERIAL PRIMARY KEY,
    token TEXT NOT NULL
);

CREATE TABLE tabela21_venda_arrendamento (
    id SERIAL PRIMARY KEY,
    descricao TEXT NOT NULL
);
INSERT INTO tabela21_venda_arrendamento (descricao) VALUES ('Arrendamento'),('Venda'),('Comprar'),('Vender');

CREATE TABLE tabela22_favorito (
    id SERIAL PRIMARY KEY,
    codigo_publicacao VARCHAR NOT NULL,
    id_cliente_solicitante INT NOT NULL,
	FOREIGN KEY (id_cliente_solicitante) REFERENCES tabela11_cliente_solicitante (id),
	FOREIGN KEY (codigo_publicacao) REFERENCES tabela14_publicacao (codigo_publicacao)
);

