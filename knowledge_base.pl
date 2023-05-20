% # FATOS CONTENDO A (CIDADE1, CIDADE2, DISTANCIA, VELOCIDADE MAX, PERICULOSIDADE)
aresta(rio_de_janeiro, sao_paulo, 430, 100, 3).
aresta(sao_paulo, belo_horizonte, 586, 110, 4).
aresta(belo_horizonte, salvador, 1382, 90, 3).
aresta(salvador, fortaleza, 1662, 100, 4).
aresta(fortaleza, recife, 800, 80, 2).
aresta(recife, natal, 289, 90, 2).
aresta(natal, joao_pessoa, 181, 70, 2).
aresta(joao_pessoa, maceio, 523, 80, 3).
aresta(maceio, aracaju, 290, 90, 3).
aresta(aracaju, salvador, 356, 100, 3).
aresta(belo_horizonte, brasilia, 716, 110, 2).
aresta(salvador, brasilia, 1450, 120, 4).
aresta(brasilia, cuiaba, 1360, 110, 3).
aresta(cuiaba, campo_grande, 708, 100, 2).
aresta(campo_grande, goiania, 937, 90, 2).
aresta(goiania, palmas, 1007, 100, 3).
aresta(brasilia, manaus, 3496, 120, 5).
aresta(cuiaba, porto_velho, 1182, 90, 3).
aresta(porto_velho, rio_branco, 526, 80, 2).
aresta(rio_branco, manaus, 780, 90, 2).

conectado(Cidade1,Cidade2) :- 
	aresta(Cidade1,Cidade2,_,_,_); 
	aresta(Cidade2,Cidade1,_,_,_).

distancia(Cidade1,Cidade2,D) :- 
	aresta(Cidade1,Cidade2,D,_,_); 
	aresta(Cidade2,Cidade1,D,_,_).

velocidademaxima(Cidade1,Cidade2,V) :- 
	aresta(Cidade1,Cidade2,_,V,_); 
	aresta(Cidade2,Cidade1,_,V,_).

nivelrisco(Cidade1,Cidade2,N) :- 
	aresta(Cidade1,Cidade2,_,_,N); 
	aresta(Cidade2,Cidade1,_,_,N).


% #  Encontra o caminho mais curto ou mais seguro entre duas cidades usando busca em largura
melhor_trajeto_bfs(CidadeInicial, CidadeFinal, Preferencia, Caminho) :-
    bfs([[CidadeInicial]], CidadeFinal, Preferencia, CaminhoInvertido),
    reverse(CaminhoInvertido, Caminho).

% #  Implementação do algoritmo de busca em largura
bfs([[CidadeFinal|Caminho]|_], CidadeFinal, _, [CidadeFinal|Caminho]).
bfs([CaminhoAtual|Caminhos], CidadeFinal, Preferencia, Caminho) :-
    expandir(CaminhoAtual, Preferencia, NovosCaminhos),
    append(Caminhos, NovosCaminhos, ProximosCaminhos),
    bfs(ProximosCaminhos, CidadeFinal, Preferencia, Caminho).

% # Expande um caminho para incluir todas as cidades conectadas à última cidade do caminho
expandir([CidadeAtual|Caminho], Preferencia, NovosCaminhos) :-
    findall(
        [ProximaCidade,CidadeAtual|Caminho],
        (conectado(CidadeAtual, ProximaCidade), \+ member(ProximaCidade, [CidadeAtual|Caminho]), criterio_bfs(Preferencia, CidadeAtual, ProximaCidade)),
        NovosCaminhos
    ).

% # Define o critério para expandir o caminho com base na preferência do usuário
criterio_bfs(mais_rapido, Cidade1, Cidade2) :- velocidademaxima(Cidade1,Cidade2,_).
criterio_bfs(mais_seguro, Cidade1, Cidade2) :- nivelrisco(Cidade1,Cidade2,N), N =< 3.

% # Encontra o melhor trajeto entre duas cidades usando o algoritmo A*
melhor_trajeto_a_star(CidadeInicial, CidadeFinal, Preferencia, Caminho) :-
    a_star([[0,[CidadeInicial]]], CidadeFinal, Preferencia, CaminhoInvertido),
    reverse(CaminhoInvertido, Caminho).

% # Implementação do algoritmo A*
a_star([[_,[CidadeFinal|Caminho]]|_], CidadeFinal, _, [CidadeFinal|Caminho]).
a_star([CaminhoAtual|Caminhos], CidadeFinal, Preferencia, Caminho) :-
    expandir_a_star(CaminhoAtual, CidadeFinal, Preferencia, NovosCaminhos),
    append(Caminhos, NovosCaminhos, ProximosCaminhos),
    sort(ProximosCaminhos, ProximosCaminhosOrdenados),
    a_star(ProximosCaminhosOrdenados, CidadeFinal, Preferencia, Caminho).

% # Expande um caminho para incluir todas as cidades conectadas à última cidade do caminho
expandir_a_star([CustoAtual,[CidadeAtual|Caminho]], CidadeFinal, Preferencia, NovosCaminhos) :-
    findall(
        [NovoCusto,[ProximaCidade,CidadeAtual|Caminho]],
        (
            conectado(CidadeAtual, ProximaCidade),
            \+ member(ProximaCidade, [CidadeAtual|Caminho]),
            criterio_a_star(Preferencia, CidadeAtual, ProximaCidade, Custo),
            heuristica_a_star(Preferencia, ProximaCidade, CidadeFinal, Heuristica),
            NovoCusto is CustoAtual + Custo + Heuristica
        ),
        NovosCaminhos
    ).

% # Define o critério para expandir o caminho com base na preferência do usuário
criterio_a_star(mais_rapido, Cidade1, Cidade2, Custo) :-
    distancia(Cidade1,Cidade2,D),
    velocidademaxima(Cidade1,Cidade2,V),
    Custo is D / V.
criterio_a_star(mais_seguro, Cidade1, Cidade2, Custo) :-
    nivelrisco(Cidade1,Cidade2,N),
    (N =< 3 -> Custo = 0; Custo = 1000).


% # Adicione um predicado para calcular a distância em linha reta entre duas coordenadas geográficas
distancia_linha_reta(Lat1, Lon1, Lat2, Lon2, Distancia) :-
    Dlat is Lat2 - Lat1,
    Dlon is Lon2 - Lon1,
    A is sin(Dlat / 2) ** 2 + cos(Lat1) * cos(Lat2) * sin(Dlon / 2) ** 2,
    C is 2 * atan2(sqrt(A), sqrt(1 - A)),
    Distancia is 6371 * C.

% # Define a função heurística para estimar o custo restante até a cidade final
% #heuristica_a_star(mais_rapido, _, _, 0).
heuristica_a_star(mais_rapido, CidadeAtual, CidadeFinal, Heuristica) :-
    coordenadas(CidadeAtual, Lat1, Lon1),
    coordenadas(CidadeFinal, Lat2, Lon2),
    distancia_linha_reta(Lat1, Lon1, Lat2, Lon2, Heuristica).
heuristica_a_star(mais_seguro, _, _, 0).

% # Encontra o caminho mais rápido ou mais seguro entre duas cidades usando busca em profundidade
melhor_trajeto_dfs(CidadeInicial, CidadeFinal, Preferencia, Caminho) :-
    dfs(CidadeInicial, CidadeFinal, [CidadeInicial], Preferencia, CaminhoInvertido),
    reverse(CaminhoInvertido, Caminho).

% # Implementação do algoritmo de busca em profundidade
dfs(CidadeFinal, CidadeFinal, Caminho, _, Caminho).
dfs(CidadeAtual, CidadeFinal, CaminhoAtual, Preferencia, Caminho) :-
    conectado(CidadeAtual, ProximaCidade),
    \+ member(ProximaCidade, CaminhoAtual),
    criterio_dfs(Preferencia, CidadeAtual, ProximaCidade),
    dfs(ProximaCidade, CidadeFinal, [ProximaCidade|CaminhoAtual], Preferencia, Caminho).

% # Define o critério para expandir o caminho com base na preferência do usuário
criterio_dfs(mais_rapido, Cidade1, Cidade2) :- velocidademaxima(Cidade1,Cidade2,_).
criterio_dfs(mais_seguro, Cidade1, Cidade2) :- nivelrisco(Cidade1,Cidade2,N), N =< 3.

% # Encontra o melhor trajeto entre duas cidades usando o algoritmo de busca gulosa
melhor_trajeto_greedy(CidadeInicial, CidadeFinal, Preferencia, Caminho) :-
    greedy([[0,[CidadeInicial]]], CidadeFinal, Preferencia, CaminhoInvertido),
    reverse(CaminhoInvertido, Caminho).

% # Implementação do algoritmo de busca gulosa
greedy([[_,[CidadeFinal|Caminho]]|_], CidadeFinal, _, [CidadeFinal|Caminho]).
greedy([CaminhoAtual|Caminhos], CidadeFinal, Preferencia, Caminho) :-
    expandir_greedy(CaminhoAtual, CidadeFinal, Preferencia, NovosCaminhos),
    append(Caminhos, NovosCaminhos, ProximosCaminhos),
    sort(ProximosCaminhos, ProximosCaminhosOrdenados),
    greedy(ProximosCaminhosOrdenados, CidadeFinal, Preferencia, Caminho).

% # Expande um caminho para incluir todas as cidades conectadas à última cidade do caminho
expandir_greedy([_,[CidadeAtual|Caminho]], CidadeFinal, Preferencia, NovosCaminhos) :-
    findall(
        [Heuristica,[ProximaCidade,CidadeAtual|Caminho]],
        (
            conectado(CidadeAtual, ProximaCidade),
            \+ member(ProximaCidade, [CidadeAtual|Caminho]),
            criterio_greedy(Preferencia, CidadeAtual, ProximaCidade),
            heuristica_greedy(Preferencia, ProximaCidade, CidadeFinal, Heuristica)
        ),
        NovosCaminhos
    ).

% # Define o critério para expandir o caminho com base na preferência do usuário
criterio_greedy(mais_rapido, Cidade1, Cidade2) :- velocidademaxima(Cidade1,Cidade2,_).
criterio_greedy(mais_seguro, Cidade1, Cidade2) :- nivelrisco(Cidade1,Cidade2,N), N =< 3.

% # Define a função heurística para estimar o custo restante até a cidade final
heuristica_greedy(mais_rapido, CidadeAtual, CidadeFinal, Heuristica) :-
    coordenadas(CidadeAtual, Lat1, Lon1),
    coordenadas(CidadeFinal, Lat2, Lon2),
    distancia_linha_reta(Lat1, Lon1, Lat2, Lon2, Heuristica).
heuristica_greedy(mais_seguro, _, _, 0).

% # Adiciona fatos para armazenar as coordenadas geográficas de cada cidade
coordenadas(rio_de_janeiro, -22.906847, -43.172896).
coordenadas(sao_paulo, -23.550520, -46.633309).
coordenadas(belo_horizonte, -19.916681, -43.934493).
coordenadas(salvador, -12.977749, -38.501629).
coordenadas(fortaleza, -3.731862, -38.526670).
coordenadas(recife, -8.052240, -34.928610).
coordenadas(natal, -5.779256, -35.200916).
coordenadas(joao_pessoa, -7.119496, -34.845012).
coordenadas(maceio, -9.649849, -35.708949).
coordenadas(aracaju, -10.947247, -37.073082).
coordenadas(brasilia, -15.794229, -47.882166).
coordenadas(cuiaba, -15.598917, -56.094894).
coordenadas(campo_grande, -20.469711, -54.620121).
coordenadas(goiania, -16.686882, -49.264789).
coordenadas(palmas,-10.167451,-48.327663).
coordenadas(manaus,-3.119028,-60.021731).
coordenadas(porto_velho,-8.761161,-63.900430).
coordenadas(rio_branco,-9.975377,-67.824898).