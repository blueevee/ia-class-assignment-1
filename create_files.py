import os
import random

cidades = [
    "rio_de_janeiro",
    "sao_paulo",
    "belo_horizonte",
    "salvador",
    "fortaleza",
    "recife",
    "natal",
    "joao_pessoa",
    "maceio",
    "aracaju",
    "brasilia",
    "cuiaba",
    "campo_grande",
    "goiania",
    "palmas",
    "manaus",
    "porto_velho",
    "rio_branco"
]

def generate_random_data():
    return random.randint(100, 2000), random.randint(60, 120), random.randint(1, 5)

def generate_random_cities():
    return random.sample(cidades, 2)

def generate_random_coordinates():
    return random.uniform(-90, 90), random.uniform(-180, 180)

diretorio = "./maps"

if not os.path.exists(diretorio):
    os.makedirs(diretorio)

for i in range(1, 101):
    nome_arquivo = f"map{i}.pl"
    caminho_arquivo = os.path.join(diretorio, nome_arquivo)
    
    with open(caminho_arquivo, "w") as f:
        for _ in range(len(cidades)*2):
            cidade1, cidade2 = generate_random_cities()
            distancia, velocidade, periculosidade = generate_random_data()
            f.write(f"aresta({cidade1}, {cidade2}, {distancia}, {velocidade}, {periculosidade}).\n")
            
        f.write("\n")
        for cidade in cidades:
            latitude, longitude = generate_random_coordinates()
            f.write(f"coordenadas({cidade}, {latitude}, {longitude}).\n")

    print(f"Arquivo {nome_arquivo} criado com sucesso!")
