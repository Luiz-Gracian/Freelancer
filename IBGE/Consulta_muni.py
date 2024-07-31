import requests
import pandas as pd

# URL da API do IBGE para os municípios
url = "https://servicodados.ibge.gov.br/api/v1/localidades/municipios"

# Fazer a requisição GET
response = requests.get(url)

# Verificar se a requisição foi bem-sucedida

if response.status_code == 200:
  
    municipios = pd.json_normalize(response.json())
  
    municipios = municipios[['id', 'nome', 'microrregiao.mesorregiao.UF.nome', 'microrregiao.mesorregiao.UF.sigla']]
    
    municipios.columns = ['codigo', 'nome_municipio', 'nome_estado', 'sigla_estado']
    
    print(municipios)
  
else:
  
    print("Erro ao fazer a requisição à API do IBGE")


# Extração como preferir:
