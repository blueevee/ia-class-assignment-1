import os
import random

cities = [
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

def generate_random_cities(connected_cities):
    city1 = random.choice(cities)
    city2 = random.choice(cities)

    while city1 in connected_cities and len(connected_cities[city1]) == len(cities) - 1:
        city1 = random.choice(cities)

    while city2 == city1:
        city2 = random.choice(cities)

    return city1, city2

def generate_random_coordinates():
    return random.uniform(-90, 90), random.uniform(-180, 180)

diretorio = "./maps"

if not os.path.exists(diretorio):
    os.makedirs(diretorio)

for i in range(1, 101):
    file_name = f"map{i}.pl"
    path_file = os.path.join(diretorio, file_name)
    connected_cities = {} 
    
    with open(path_file, "w") as f:
        for _ in range(len(cities) * 2):
            initial_city, final_city = generate_random_cities(connected_cities)
            distance, max_speed, risk_level = generate_random_data()
            f.write(f"aresta({initial_city}, {final_city}, {distance}, {max_speed}, {risk_level}).\n")
            
            if initial_city in connected_cities:
                connected_cities[initial_city].add(final_city)
            else:
                connected_cities[initial_city] = {final_city}
                
        f.write("\n")
        for cidade in cities:
            latitude, longitude = generate_random_coordinates()
            f.write(f"coordenadas({cidade}, {latitude}, {longitude}).\n")

    print(f"Arquivo {file_name} criado com sucesso! Cidades conectadas: {connected_cities}")
