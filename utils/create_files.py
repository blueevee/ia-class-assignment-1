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

def selectCities(citiesArray):
    random.shuffle(citiesArray)

    maxCities = len(citiesArray)
    selectedCities = citiesArray[0:maxCities]

    return selectedCities

def generate_random_data():
    distance, vel, risk = random.randint(100, 2000), random.randint(60, 120), random.randint(1, 5)

    timeElapsed = round(distance / vel, 2)

    return distance, vel, risk, timeElapsed

def generate_connection(totalCities, connected_cities):
    city1 = random.choice(totalCities)
    city2 = random.choice(totalCities)

    while city1 in connected_cities and len(connected_cities[city1]) == len(totalCities) - 1:
        city1 = random.choice(totalCities)

    while city2 == city1:
        city2 = random.choice(totalCities)

    return city1, city2

def generate_random_coordinates():
    return random.uniform(-90, 90), random.uniform(-180, 180)

diretorio = "./maps"

if not os.path.exists(diretorio):
    os.makedirs(diretorio)

for i in range(1, 101):
    file_name = f"map{i}.pl"
    path_file = os.path.join(diretorio, file_name)
    totalCities = selectCities(cities.copy())
    connected_cities = {}
    
    with open(path_file, "w") as f:
        for _ in range(len(totalCities) * 2):
            initial_city, final_city = generate_connection(totalCities, connected_cities)
            distance, max_speed, risk_level, timeElapsed = generate_random_data()
            f.write(f"aresta({initial_city}, {final_city}, {distance}, {max_speed}, {risk_level}, {timeElapsed}).\n")
            
            if initial_city in connected_cities:
                connected_cities[initial_city].add(final_city)
            else:
                connected_cities[initial_city] = {final_city}
                
        f.write("\n")
        for cidade in totalCities:
            latitude, longitude = generate_random_coordinates()
            f.write(f"coordenadas({cidade}, {latitude}, {longitude}).\n")

    print(f"Arquivo {file_name} criado com sucesso! Cidades conectadas: {connected_cities}")
