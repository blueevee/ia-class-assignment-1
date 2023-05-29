from enum import Enum

class Cities(Enum):
    RJ = "rio_de_janeiro"
    SP = "sao_paulo"
    BH = "belo_horizonte"
    SSA = "salvador"
    FOR = "fortaleza"
    REC = "recife"
    NT = "natal"
    JP = "joao_pessoa"
    MC = "maceio"
    AC = "aracaju"
    BS = "brasilia"
    CB = "cuiaba"
    CG = "campo_grande"
    GN = "goiania"
    PM = "palmas"
    MA = "manaus"
    PV = "porto_velho"
    RB = "rio_branco"

class Approachs(Enum):
    A_ESTRELA = "a_star"
    BFS = "bfs"
    DFS = "dfs"
    BUSCA_GULOSA = "greedy"

class Preference(Enum):
    FAST = "mais_rapido"
    SECURE = "mais_seguro"