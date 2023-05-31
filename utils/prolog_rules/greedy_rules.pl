
% Encontra o melhor trajeto entre duas cidades usando o algoritmo de busca gulosa
melhor_trajeto_greedy(CidadeInicial, CidadeFinal, Preferencia, Caminho) :-
    greedy([[0,[CidadeInicial]]], CidadeFinal, Preferencia, CaminhoInvertido),
    reverse(CaminhoInvertido, Caminho).

% Implementação do algoritmo de busca gulosa
greedy([[_,[CidadeFinal|Caminho]]|_], CidadeFinal, _, [CidadeFinal|Caminho]).
greedy([CaminhoAtual|Caminhos], CidadeFinal, Preferencia, Caminho) :-
    expandir_greedy(CaminhoAtual, CidadeFinal, Preferencia, NovosCaminhos),
    append(Caminhos, NovosCaminhos, ProximosCaminhos),
    sort(ProximosCaminhos, ProximosCaminhosOrdenados),
    greedy(ProximosCaminhosOrdenados, CidadeFinal, Preferencia, Caminho).

% Expande um caminho para incluir todas as cidades conectadas à última cidade do caminho
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

% Define o critério para expandir o caminho com base na preferência do usuário
criterio_greedy(mais_rapido, Cidade1, Cidade2) :- tempoViagem(Cidade1,Cidade2,_).
criterio_greedy(mais_seguro, Cidade1, Cidade2) :- nivelrisco(Cidade1,Cidade2,N), N =< 3.

% Adicione um predicado para calcular a distância em linha reta entre duas coordenadas geográficas
distancia_linha_reta(Lat1, Lon1, Lat2, Lon2, Distancia) :-
    Dlat is Lat2 - Lat1,
    Dlon is Lon2 - Lon1,
    A is sin(Dlat / 2) ** 2 + cos(Lat1) * cos(Lat2) * sin(Dlon / 2) ** 2,
    C is 2 * atan2(sqrt(A), sqrt(1 - A)),
    Distancia is 6371 * C.

% Define a função heurística para estimar o custo restante até a cidade final
heuristica_greedy(mais_rapido, CidadeAtual, CidadeFinal, Heuristica) :-
    coordenadas(CidadeAtual, Lat1, Lon1),
    coordenadas(CidadeFinal, Lat2, Lon2),
    distancia_linha_reta(Lat1, Lon1, Lat2, Lon2, Heuristica).
heuristica_greedy(mais_seguro, _, _, 0).