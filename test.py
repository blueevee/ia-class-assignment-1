from swiplserver import PrologMQI, PrologThread
import os
import posixpath
import time
import tracemalloc


# Iniciando tracking de mémoria
tracemalloc.start()

# Iniciando tracking de tempo
start_time = time.time()

# Crie o caminho do arquivo no formato Posix
file_path = os.path.join(os.getcwd(), 'knowledge_base.pl')
posix_file_path = posixpath.join(*file_path.split(os.sep))

# Inicie o PrologMQI e crie uma instância do PrologThread
with PrologMQI() as mqi:
    with mqi.create_thread() as prolog_thread:
        # Carregue a base de conhecimento usando o predicado consult/1 do Prolog
        query = f"consult('{posix_file_path}')"
        result = prolog_thread.query(query)
        
        # Consulte a distância entre duas cidades usando o predicado distancia/3
        # city_1 = 'porto_velho'
        # city_2 = 'rio_branco'
        # query = f"nivelrisco({city_1}, {city_2}, Risco)"
        # result = prolog_thread.query(query)
        # print(result)

        # Encontre o melhor trajeto entre duas cidades usando o predicado melhor_trajeto/4
        cidade_inicial = 'rio_de_janeiro'
        cidade_final = 'salvador'
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