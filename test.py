import os
import posixpath

from swiplserver import PrologMQI


rules_path = os.path.join(os.getcwd(), 'utils/knowledge_base_rules.pl')
posix_rules_path = posixpath.join(*rules_path.split(os.sep))

map_path = os.path.join(os.getcwd(), 'maps/map39.pl')
posix_map_path = posixpath.join(*map_path.split(os.sep))

with PrologMQI() as mqi:
    with mqi.create_thread() as prolog_thread:

        query = f"consult(['{posix_map_path}', '{posix_rules_path}'])"
        result = prolog_thread.query(query)

        query = f"conectado(recife, manaus)"
        result = prolog_thread.query(query)

        print(result)