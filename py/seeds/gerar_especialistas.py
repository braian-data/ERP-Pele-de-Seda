import pandas as pd
import random
from faker import Faker
from sqlalchemy import create_engine  # criar engine de conexão

string_conexao = 'postgresql+psycopg2://usuario:senha@host:porta/banco'
engine = create_engine(string_conexao)  # engine de conexão criada
fake = Faker('pt_BR')  # gerar dados em pt_BR
lista_especialistas = []

lista_especialidades = [
    'Dermatologista', 'Esteticista', 'Biomédico Esteta',
    'Cirurgião Plástico', 'Tricologista', 'Fisioterapeuta Dermatofuncional'
]

print("⏳ Fabricando 10 especialistas na memória...")
# controle de fluxo - if, elif e else também é um controle de fluxo
for _ in range(10):
    # Tratamento de dados
    cpf_sujo = fake.cpf()
    cpf_limpo = cpf_sujo.replace('.', '').replace('-', '').replace(' ', '')
    crm_falso = f"{fake.numerify('######')}-{fake.estado_sigla()}"

    especialista = {
        'tipo_specialist': random.choice(lista_especialidades),
        'nome': fake.name(),
        'cpf': cpf_limpo,
        'crm': crm_falso,
    }
    lista_especialistas.append(especialista)

df_especialistas = pd.DataFrame(lista_especialistas)
print("✅ Tabela pronta no Python! Iniciando injeção no PostgreSQL...")
print(df_especialistas.head())

# Tratamento de Erros
try:
    # Conectividade - Jogar um DataFrame direto pro banco
    df_especialistas.to_sql(name='especialistas', con=engine, if_exists='append',
                            index=False)  # engine chamada aqui para enviar sql
except Exception as erro:
    print("❌ DEU RUIM NO BANCO DE DADOS. Veja o erro abaixo:")
    print(erro)
