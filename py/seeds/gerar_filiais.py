import pandas as pd
from faker import Faker
from sqlalchemy import create_engine
import random

fake = Faker('pt_BR')
engine = create_engine('postgresql+psycopg2://usuario:senha@host:porta/banco')
lista_filiais = []
for i in range(5):
    nome_fantasia = fake.company()
    cod_interno = f"{fake.numerify(text="####")}-{fake.estado_sigla()}"
    telefone_sujo = fake.cellphone_number()
    telefone_limpo = (
        telefone_sujo.replace('(', '')
            .replace(' ','')
                .replace('-','')
                    .replace(')','')
                        .replace('+',''))
    status_ativo = random.choices([True, False], weights=[85,15], k=1)[0]
    filial = {
        'nome_fantasia': nome_fantasia,
        'cod_interno': cod_interno,
        'telefone': telefone_limpo,
        'ativo': status_ativo
    }
    lista_filiais.append(filial)
df_lista_filiais = pd.DataFrame(lista_filiais)
print(df_lista_filiais.head())
try:
    df_lista_filiais.to_sql(name='filiais', con=engine, if_exists='append', index=False)
except Exception as erro:
    print("Deu ruim no DB. Veja o erro abaixo: ")
    print(erro)
