-- Tabelas dimensão/Catálogo: Nascem primeiro, sem depender de ninguém. Evitando Deadlock.

CREATE TABLE clientes (
    id_cliente      bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nome            varchar(255) NOT NULL,
    telefone        varchar(20) NOT NULL CHECK (length(telefone) >= 8),
    cpf             varchar(11) UNIQUE,
    endereco        varchar(255),
    data_nascimento date
);

CREATE TABLE especialistas (
    id_especialista bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    cpf             varchar(11) NOT NULL UNIQUE,
    crm             varchar(20) UNIQUE,
    nome            varchar(255) NOT NULL,
    tipo_specialist varchar(30)
);

CREATE TABLE filiais (
    id_filial       bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nome_fantasia   varchar(100) NOT NULL,
    cod_interno     varchar(10) UNIQUE,
    ativo           boolean DEFAULT true
);

CREATE TABLE produtos (
    id_produto          bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nome                varchar(50) NOT NULL,
    status_produto      boolean DEFAULT true,
    qnt_estoque_fechado int NOT NULL DEFAULT 0,
    qnt_estoque_aberto  decimal(10,2) NOT NULL DEFAULT 0,
    fator_conversao     int NOT NULL DEFAULT 1 CHECK (fator_conversao > 0),
    preco_venda         numeric(10,2) NOT NULL,
    unidade_medida      varchar(5) NOT NULL DEFAULT 'UN'
);

CREATE TABLE pacotes (
    id_pacote       bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    pct_preco       numeric(10,2) NOT NULL,
    pct_descricao   text NOT NULL
);

CREATE TABLE servicos (
    id_servico      bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    desc_serv       text NOT NULL,
    preco_serv      numeric(10,2) NOT NULL
);

-- TABELAS DE ASSOCIAÇÃO SIMPLES

CREATE TABLE escala (
    id_escala       int GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_especialista bigint NOT NULL REFERENCES especialistas(id_especialista),
    id_filial       bigint NOT NULL REFERENCES filiais(id_filial),
    dia_semana      smallint
);

-- REGISTRO DE EVENTO 

CREATE TABLE atendimentos (
    id_atendimento  bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    data_hora_abert timestamp DEFAULT current_timestamp,
    data_hora_fecha timestamp,
    at_status       varchar(20) DEFAULT 'aberto',
    descricao       text,
    
    -- FKs para as tabelas Mestre
    id_filial       bigint NOT NULL REFERENCES filiais(id_filial),
    id_cliente      bigint NOT NULL REFERENCES clientes(id_cliente),
    id_especialista bigint NOT NULL REFERENCES especialistas(id_especialista),

    CONSTRAINT ck_fluxo_temporal 
        CHECK (data_hora_fecha IS NULL OR data_hora_fecha >= data_hora_abert)
);

-- TABELAS DE DETALHE / ITENS DO ATENDIMENTO

CREATE TABLE atendimento_consumos (
    id_consumo      bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_atendimento  bigint NOT NULL REFERENCES atendimentos(id_atendimento),
    id_produto      bigint NOT NULL REFERENCES produtos(id_produto),
    qnt_consum      numeric(10,2) NOT NULL
);

CREATE TABLE atendimento_vendas (
    id_venda        bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_atendimento  bigint NOT NULL REFERENCES atendimentos(id_atendimento),
    id_produto      bigint NOT NULL REFERENCES produtos(id_produto),
    qnt_vendida     int NOT NULL CHECK(qnt_vendida > 0),
    valor_final     numeric(10,2) NOT NULL CHECK(valor_final > 0)
);

CREATE TABLE atendimento_servicos (
    id_execucao     bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_atendimento  bigint NOT NULL REFERENCES atendimentos(id_atendimento),
    id_servico      bigint NOT NULL REFERENCES servicos(id_servico),
    valor_cobrado   numeric(10,2) NOT NULL
);

CREATE TABLE atendimento_pacotes (
    id_venda_pct    bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_atendimento  bigint NOT NULL REFERENCES atendimentos(id_atendimento),
    id_pacote       bigint NOT NULL REFERENCES pacotes(id_pacote),
    valor_cobrado   numeric(10,2) NOT NULL
);
