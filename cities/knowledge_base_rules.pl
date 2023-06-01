conectado(Cidade1,Cidade2) :- 
	aresta(Cidade1,Cidade2,_,_,_,_); 
	aresta(Cidade2,Cidade1,_,_,_,_).

distancia(Cidade1,Cidade2,D) :- 
	aresta(Cidade1,Cidade2,D,_,_,_); 
	aresta(Cidade2,Cidade1,D,_,_,_).

velocidademaxima(Cidade1,Cidade2,V) :- 
	aresta(Cidade1,Cidade2,_,V,_,_); 
	aresta(Cidade2,Cidade1,_,V,_,_).

nivelrisco(Cidade1,Cidade2,N) :- 
	aresta(Cidade1,Cidade2,_,_,N,_); 
	aresta(Cidade2,Cidade1,_,_,N,_).

tempoViagem(Cidade1,Cidade2,T) :- 
	aresta(Cidade1,Cidade2,_,_,_,T); 
	aresta(Cidade2,Cidade1,_,_,_,T).


% #  Encontra o caminho mais curto ou mais seguro entre duas cidades usando busca em largura
melhor_trajeto_bfs(CidadeInicial, CidadeFinal, Preferencia, Caminho) :-
    bfs([[CidadeInicial]], CidadeFinal, Preferencia, CaminhoInvertido),
    reverse(CaminhoInvertido, Caminho).

% #  Implementação do algoritmo de busca em largura
bfs([[CidadeFinal|Caminho]|_], CidadeFinal, _, [CidadeFinal|Caminho]).
bfs([CaminhoAtual|Caminhos], CidadeFinal, Preferencia, Caminho) :-
    menor_custo([CaminhoAtual|Caminhos], MenorCusto),
    expandir(CaminhoAtual, Preferencia, MenorCusto, NovosCaminhos),
    append(Caminhos, NovosCaminhos, ProximosCaminhos),
    bfs(ProximosCaminhos, CidadeFinal, Preferencia, Caminho).

% # Expande um caminho para incluir todas as cidades conectadas à última cidade do caminho
expandir([CidadeAtual|Caminho], Preferencia, MenorCusto, NovosCaminhos) :-
    findall(
        [ProximaCidade,CidadeAtual|Caminho],
        (conectado(CidadeAtual, ProximaCidade), \+ member(ProximaCidade, [CidadeAtual|Caminho]), criterio_bfs(Preferencia, CidadeAtual, ProximaCidade, MenorCusto)),
        NovosCaminhos
    ).

% # Define o critério para expandir o caminho com base na preferência do usuário
criterio_bfs(mais_rapido, Cidade1, Cidade2, MenorCusto) :- tempoViagem(Cidade1,Cidade2,T), T < MenorTempo.
criterio_bfs(mais_seguro, Cidade1, Cidade2, MenorCusto) :- nivelrisco(Cidade1,Cidade2,N), N < MenorCusto.

calcula_custo(mais_rapido, Cidade1, Cidade2, Custo) :- tempoViagem(Cidade1,Cidade2,T), Custo is T.
calcula_custo(mais_seguro, Cidade1, Cidade2, Custo) :- nivelrisco(Cidade1,Cidade2,N), Custo is N.

menor_custo([X], MenorCusto).
menor_custo([CaminhoAtual|Caminhos], MenorCusto) :-
    menor_custo(Caminhos, Menor),
    somar_custo(CaminhoAtual, 0, CustoAtual),
    (CustoAtual < Menor -> MenorCusto = CustoAtual ; MenorCusto = Menor).

somar_custo([], Acumulador, Resultado) :-
    Resultado = Acumulador.
somar_custo([X|Resto], Acumulador, Resultado) :-
    NovoAcumulador is Acumulador + X,
    somar_custo(Resto, NovoAcumulador, Resultado).

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
criterio_dfs(mais_rapido, Cidade1, Cidade2) :- tempoViagem(Cidade1,Cidade2,_).
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
criterio_greedy(mais_rapido, Cidade1, Cidade2) :- tempoViagem(Cidade1,Cidade2,_).
criterio_greedy(mais_seguro, Cidade1, Cidade2) :- nivelrisco(Cidade1,Cidade2,N), N =< 3.

% # Define a função heurística para estimar o custo restante até a cidade final
heuristica_greedy(mais_rapido, CidadeAtual, CidadeFinal, Heuristica) :-
    coordenadas(CidadeAtual, Lat1, Lon1),
    coordenadas(CidadeFinal, Lat2, Lon2),
    distancia_linha_reta(Lat1, Lon1, Lat2, Lon2, Heuristica).
heuristica_greedy(mais_seguro, _, _, 0).