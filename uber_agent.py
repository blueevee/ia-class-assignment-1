from swiplserver import PrologMQI, PrologThread
import os
import posixpath
import time
import tracemalloc
import csv

from utils.enum.Enum import Preference

def exec_best_path(i, alg, initial_city, final_city, path_choice):
    result = best_path(alg, f'maps/map{i}.pl', initial_city, final_city, path_choice)
    best_result = result[0]['Caminho'] if result else result
    result_len = len(result[0]['Caminho']) if result else 0

    return result, best_result, result_len
    


def hundred_maps(alg, uber_city, passenger_city, destiny_city, path_choice):
    """
    Realiza 100 execuções em mapas diferentes com o algoritmo passado para encontrar o melhor caminho entre 2 cidades, cria um arquivo no diretório local contendo 'Memória atual (MB)', 'Pico de memória(MB)', 'Tempo gasto (segundos)', 'Comprimento do caminho', 'Lista de cidades do caminho' para cada mapa executado.

    Parameters
    ----------
    alg : String
        Nome da abordagem a ser usada para definir o melhor caminho
    initial_city : String
        Cidade de partida
    final_city : String
        Cidade de destino
    path_choice : String
        Preferência do caminho `mais seguro`, `mais rápido`
    """

    # Iniciando tracking de mémoria
    tracemalloc.start()

    csv_file = open(f'results_{alg}.csv', 'w', newline='')
    csv_writer = csv.writer(csv_file)
    csv_writer.writerow(['File', 'Current Memory (MB)', 'Peak Memory (MB)', 'Elapsed Time (seconds)', 'Result Length', 'Result'])

    for i in range(1, 101):
        start_time = time.time()
        
        toPassengerResult, toPassengerBestResult, toPassengerResultLen = exec_best_path(i, alg, uber_city, passenger_city, Preference.FAST.value)
        toDestinyResult, toDestinyBestResult, toDestinyResultLen = exec_best_path(i, alg, passenger_city, destiny_city, path_choice)
        
        finalBestResult = toPassengerBestResult + toDestinyBestResult
        finalResultLen = toPassengerResultLen + toDestinyResultLen        

        current_memory, peak_memory = tracemalloc.get_traced_memory()
        current_memory = current_memory/ 1024 / 1024
        peak_memory = peak_memory / 1024 / 1024

        end_time = time.time()
        elapsed_time = end_time - start_time

        csv_writer.writerow([i, current_memory, peak_memory, elapsed_time, finalResultLen, finalBestResult])
        print(f"ENCONTROU O MELHOR CAMINHO PARA O MAPA: {i}")

    csv_file.close()

def best_path(alg, city_map, initial_city, final_city, path_choice):
    """
    Econtra o melhor trajeto entre `initial_city` e `final_city` de acordo com a abordagem, o mapa e a preferência escolhidas.

    Parameters
    ----------
    alg : String
        Nome da abordagem a ser usada para definir o melhor caminho
    map : String
        Caminho do arquivo prolog que representa o mapa da cidade com as arestas e coordenadas
    initial_city : String
        Cidade de partida
    final_city : String
        Cidade de destino
    path_choice : String
        Preferência do caminho `mais seguro`, `mais rápido`
    """

    rules_path = os.path.join(os.getcwd(), 'utils/knowledge_base_rules.pl')
    posix_rules_path = posixpath.join(*rules_path.split(os.sep))

    map_path = os.path.join(os.getcwd(), city_map)
    posix_map_path = posixpath.join(*map_path.split(os.sep))

    with PrologMQI() as mqi:
        with mqi.create_thread() as prolog_thread:

            query = f"consult(['{posix_map_path}', '{posix_rules_path}'])"
            result = prolog_thread.query(query)

            query = f"melhor_trajeto_{alg}({initial_city}, {final_city}, {path_choice}, Caminho)"
            result = prolog_thread.query(query)

    return result

def what_distance(city_map, initial_city, final_city):
    """
    Econtra qual a distância entre `initial_city` e `final_city` caso elas estejam conectadas.

    Parameters
    ----------
    map : String
        Caminho do arquivo prolog que representa o mapa da cidade com as arestas e coordenadas
    initial_city : String
        Cidade de partida
    final_city : String
        Cidade de destino
    """

    rules_path = os.path.join(os.getcwd(), 'utils/knowledge_base_rules.pl')
    posix_rules_path = posixpath.join(*rules_path.split(os.sep))

    map_path = os.path.join(os.getcwd(), city_map)
    posix_map_path = posixpath.join(*map_path.split(os.sep))

    with PrologMQI() as mqi:
        with mqi.create_thread() as prolog_thread:

            query = f"consult(['{posix_map_path}', '{posix_rules_path}'])"
            result = prolog_thread.query(query)
            query = f"distancia({initial_city}, {final_city}, Distancia)"
            result = prolog_thread.query(query)

    return result