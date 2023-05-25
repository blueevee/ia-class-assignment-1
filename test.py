from swiplserver import PrologMQI, PrologThread
import os
import posixpath
import time
import tracemalloc


tracemalloc.start()

start_time = time.time()

# Crie o caminho do arquivo no formato Posix
file_path = os.path.join(os.getcwd(), 'maps/map1.pl')
posix_file_path = posixpath.join(*file_path.split(os.sep))
rule_file_path = os.path.join(os.getcwd(), 'utils/knowledge_base_rules.pl')
rules_posix_file_path = posixpath.join(*rule_file_path.split(os.sep))

with PrologMQI() as mqi:
    with mqi.create_thread() as prolog_thread:
        # Carregue a base de conhecimento usando o predicado consult/1 do Prolog
        query = f"consult(['{posix_file_path}', '{rules_posix_file_path}'])"
        result = prolog_thread.query(query)

        # Encontre o melhor trajeto entre duas cidades usando o predicado melhor_trajeto/4
        cidade_inicial = 'rio_branco'
        cidade_final = 'manaus'
        preferencia = 'mais_rapido'
        query = f"melhor_trajeto_bfs({cidade_inicial}, {cidade_final}, {preferencia}, Caminho)"
        result = prolog_thread.query(query)
        print(result)


current_memory, peak_memory = tracemalloc.get_traced_memory()
current_memory = current_memory/ 1024 / 1024
peak_memory = peak_memory / 1024 / 1024
print(f"Current memory usage: {current_memory} MB")
print(f"Peak memory usage: {peak_memory} MB")

end_time = time.time()
elapsed_time = end_time - start_time
print(f"Elapsed time: {elapsed_time} seconds")
