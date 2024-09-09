CREATE TABLE IF NOT EXISTS tabela01_pais(
	id serial primary key,
	nome_pais varchar(50) not null unique
);
/* ==================================================================================== */
CREATE TABLE IF NOT EXISTS tabela02_provincia(
	id serial primary key,
	nome_provincia varchar(100) not null unique,
	id_pais int not null,
	foreign key (id_pais) references tabela01_pais (id) on delete cascade	
);
/* ==================================================================================== */
CREATE TABLE IF NOT EXISTS tabela03_municipio(
	id serial primary key,
	nome_municipio varchar(100) not null,
	id_provincia int not null,
	foreign key (id_provincia) references tabela02_provincia (id) on delete cascade	
);
/* ==================================================================================== */
CREATE TABLE IF NOT EXISTS tabela04_bairro(
	id serial primary key,
	nome_bairro varchar(100),
	id_municipio int not null,
	foreign key (id_municipio) references tabela03_municipio (id) on delete cascade	
);
/* ==================================================================================== */
CREATE TABLE IF NOT EXISTS tabela05_rua(
	id serial primary key,
	nome_rua varchar(100),
	id_bairro int not null,
	foreign key (id_bairro) references tabela04_bairro (id) on delete cascade	
);
/* ==================================================================================== */
CREATE TABLE IF NOT EXISTS tabela06_localizacao(
	id serial primary key,
	id_rua int not null,
	foreign key (id_rua) references tabela05_rua(id) on delete cascade,
	id_bairro int not null,
	foreign key (id_bairro) references tabela04_bairro(id) on delete cascade,
	id_municipio int not null,
	foreign key (id_municipio) references tabela03_municipio(id) on delete cascade,
	id_provincia int not null,
	foreign key (id_provincia) references tabela02_provincia(id) on delete cascade,
	id_pais int not null,
	foreign key (id_pais) references tabela01_pais(id) on delete cascade
);
/* ==================================================================================== */
CREATE TABLE IF NOT EXISTS tabela07_tipo_imovel(
	id serial primary key,
	tipo_imovel varchar(100) not null,
	estado bool not null default true
);
/* ==================================================================================== */
CREATE TABLE IF NOT EXISTS tabela08_natureza_imovel(
	id serial primary key,
	id_tipo_imovel int not null,
	foreign key (id_tipo_imovel) references tabela07_tipo_imovel(id) on delete cascade,
	dimensao varchar(100),
	tipologia varchar(100),
	id_localizacao int not null,
	foreign key (id_localizacao) references tabela06_localizacao(id) on delete cascade
);
/* ==================================================================================== */
CREATE TABLE IF NOT EXISTS tabela09_funcionario(
	id serial primary key,
	nome varchar(100) not null,
	telefone varchar(12) not null unique,
	email varchar(100) not null unique,
	estado varchar(20) not null, /*MUDAR PARA ENUM*/
	senha text not null,
	id_provincia int not null,
	foreign key (id_provincia) references tabela02_provincia(id) on delete cascade,
	nivel int not null
);
/* ==================================================================================== */
CREATE TABLE IF NOT EXISTS tabela10_cliente_proprietario(
	id serial primary key,
	nome varchar(100) not null,
	telefone varchar(12) not null unique,
	email varchar(100) not null unique,
	estado varchar(20) not null, /*MUDAR PARA ENUM*/
	senha text not null
);
/* ==================================================================================== */
CREATE TABLE IF NOT EXISTS tabela11_cliente_solicitante(
	id serial primary key,
	nome varchar(100) not null,
	telefone varchar(12) not null unique,
	estado varchar(20) not null, /*MUDAR PARA ENUM*/
	senha text not null
);
/* ==================================================================================== */
CREATE TABLE IF NOT EXISTS tabela12_imovel(
	id serial primary key,
	id_cliente_proprietario int not null,
	foreign key (id_cliente_proprietario) references tabela10_cliente_proprietario (id) on delete cascade,
	descricao text not null,
	data_solicitacao date not null,
	estado varchar(50) not null, /*MUDAR PARA ENUM*/
	tipo_publicidade varchar(50) not null, /*MUDAR PARA ENUM*/
	preco decimal not null default 0,
	id_natureza_imovel int not null,
	foreign key (id_natureza_imovel) references tabela08_natureza_imovel(id) on delete cascade
);
/* ==================================================================================== */
CREATE TABLE IF NOT EXISTS tabela13_foto(
	id serial primary key,
	imagem text not null unique,
	id_imovel int not null,
	foreign key (id_imovel) references tabela12_imovel(id) on delete cascade
);
/* ==================================================================================== */
CREATE TABLE IF NOT EXISTS tabela14_publicacao(
	id serial primary key,
	id_corretor int not null,
	foreign key (id_corretor) references tabela09_funcionario(id) on delete cascade,
	id_imovel int not null,
	foreign key (id_imovel) references tabela12_imovel(id) on delete cascade,
	data_publicacao date not null,
	gostei int not null default 0,
	nao_gostei int not null default 0,
	total_comentarios int not null default 0,
	estado varchar(100), /*MUDAR PARA ENUM*/ 
	data_conclusao date not null
);
/* ==================================================================================== */
CREATE TABLE IF NOT EXISTS tabela15_notificar_proprietario(
	id serial primary key,
	id_corretor int not null,
	foreign key (id_corretor) references tabela09_funcionario(id) on delete cascade,
	id_cliente_proprietario int not null,
	foreign key (id_cliente_proprietario) references tabela10_cliente_proprietario (id) on delete cascade,
	id_imovel int not null,
	foreign key (id_imovel) references tabela12_imovel(id) on delete cascade,
	descricao text not null,
	data_notificacao date not null
);
/* ==================================================================================== */
CREATE TABLE IF NOT EXISTS tabela16_solicitacao_cliente(
	id serial primary key,
	id_cliente_solicitante int not null,
	foreign key (id_cliente_solicitante) references tabela11_cliente_solicitante(id) on delete cascade,
	preco_minimo decimal not null default 0,
	preco_maximo decimal not null default 0,
	id_tipo_imovel int not null,
	foreign key (id_tipo_imovel) references tabela07_tipo_imovel(id) on delete cascade,
	id_localizacao int not null,
	foreign key (id_localizacao) references tabela06_localizacao(id) on delete cascade
);
/* ==================================================================================== */
CREATE TABLE IF NOT EXISTS tabela17_notificar_cliente(
	id serial primary key,
	mensagem text not null,
	id_publicacao int not null,
	foreign key (id_publicacao) references tabela14_publicacao(id) on delete cascade,
	id_solicitacao int not null,
	foreign key (id_solicitacao) references tabela16_solicitacao_cliente(id) on delete cascade,
	data_notificacao date not null
);
/* ==================================================================================== */
CREATE TABLE IF NOT EXISTS tabela18_lead(
	id serial primary key,
	id_publicacao int not null,
	foreign key (id_publicacao) references tabela14_publicacao(id) on delete cascade,
	id_cliente_solicitante int not null,
	foreign key (id_cliente_solicitante) references tabela11_cliente_solicitante(id) on delete cascade,
	estado varchar(100), /*MUDAR PARA ENUM*/ 
	data_abertura date not null,
	data_conclusao date not null
);
/* ==================================================================================== */
CREATE TABLE IF NOT EXISTS tabela19_chat(
	id serial primary key,
	id_corretor int not null,
	foreign key (id_corretor) references tabela09_funcionario(id) on delete cascade,
	id_lead int not null,
	foreign key (id_lead) references tabela18_lead(id) on delete cascade,
	id_cliente_solicitante int not null,
	foreign key (id_cliente_solicitante) references tabela11_cliente_solicitante(id) on delete cascade,
	mensagem text not null,  
	data_mensagem date not null,
	pergunta_mensagem text,
	id_pergunta int not null,
	foreign key (id_pergunta) references tabela19_chat(id) on delete cascade,
	data_conclusao date not null
);


