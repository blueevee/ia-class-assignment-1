from swiplserver import PrologMQI, PrologThread
import os
import posixpath
import time
import tracemalloc
import csv

# Iniciando tracking de mémoria
tracemalloc.start()

csv_file = open('results_bfs.csv', 'w', newline='')
csv_writer = csv.writer(csv_file)
csv_writer.writerow(['File', 'Current Memory (MB)', 'Peak Memory (MB)', 'Elapsed Time (seconds)', 'Result Lenght', 'Result'])


rules_path = os.path.join(os.getcwd(), 'utils/knowledge_base_rules.pl')
posix_rules_path = posixpath.join(*rules_path.split(os.sep))

for i in range(1, 101):
    start_time = time.time()

    map_path = os.path.join(os.getcwd(), f'maps/map{i}.pl')
    posix_map_path = posixpath.join(*map_path.split(os.sep))

    # Inicia o PrologMQI e cria uma instância do PrologThread
    with PrologMQI() as mqi:
        with mqi.create_thread() as prolog_thread:

            query = f"consult(['{posix_map_path}', '{posix_rules_path}'])"
            # query = f"consult('{posix_file_path}')"
            result = prolog_thread.query(query)

            # Encontre o melhor trajeto entre duas cidades usando melhor_trajeto
            cidade_inicial = 'rio_branco'
            cidade_final = 'manaus'
            preferencia = 'mais_rapido'
            query = f"melhor_trajeto_bfs({cidade_inicial}, {cidade_final}, {preferencia}, Caminho)"
            result = prolog_thread.query(query)
            best_result = result[0]['Caminho'] if result else result
            result_len = len(result[0]['Caminho']) if result else 0

    current_memory, peak_memory = tracemalloc.get_traced_memory()
    current_memory = current_memory/ 1024 / 1024
    peak_memory = peak_memory / 1024 / 1024

    end_time = time.time()
    elapsed_time = end_time - start_time

    csv_writer.writerow([map_path.split('/')[-1], current_memory, peak_memory, elapsed_time, result_len, best_result])
    print(f"EXECUTOU ARQUIVO: {i}")

csv_file.close()