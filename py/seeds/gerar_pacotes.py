import pandas as pd
from faker import Faker
from sqlalchemy import create_engine
import random
fake = Faker('pt_BR')
engine = create_engine('postgresql+psycopg2://postgres:XXXX@localhost:5432/postgres')
tipos = ['Combo', 'Pacote', 'Programa', 'Especial']
temas = ['Verão', 'Noiva', 'Detox', 'Glow Facial', 'Renovação']
procedimentos = [
    'Limpeza de Pele', 'Drenagem Linfática', 'Peeling Químico',
    'Microagulhamento', 'Massagem Relaxante', 'Preenchimento Labial',
    'Fios de PDO', 'Toxina Botulínica'
]
lista_pacotes = []

print(" Fabricando 10 pacotes na memória...")

for i in range(5):
    nome_pacote = f"{random.choice(tipos)} {random.choice(temas)}"
    qnt_itens = random.randint(2, 8)
    itens_sorteados = random.sample(procedimentos, k=qnt_itens)
    procedimentos_texto = ", ".join(itens_sorteados)
    preco_aleatorio = round(random.uniform(300.00, 3000.00), 2)
    procedimento = f"{nome_pacote}: {procedimentos_texto}"
    pacote = {
        'pct_descricao': procedimento,
        'pct_preco': preco_aleatorio
    }
    lista_pacotes.append(pacote)
df_pacotes = pd.DataFrame(lista_pacotes)
print(" Tabela pronta no Python! Iniciando injeção no PostgreSQL... ")
print(df_pacotes)
df_pacotes.to_csv('dados_pacotes.csv', index=False, encoding='utf-8')
df_pacotes.to_excel('dados_pacotes.xlsx', index=False, sheet_name='Pacotes')
df_pacotes.to_json('dados_pacotes.json', orient='records', force_ascii=False)
try:
    df_pacotes.to_sql(name='pacotes', con=engine, if_exists='append', index=False)
    print(" Dados inseridos com sucesso no PostgreSQL!")
except Exception as erro:
    print(" Falha isolada na injeção do Banco de Dados:")
    print(erro)
