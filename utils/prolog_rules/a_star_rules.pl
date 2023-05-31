
% Encontra o melhor trajeto entre duas cidades usando o algoritmo A*
melhor_trajeto_a_star(CidadeInicial, CidadeFinal, Preferencia, Caminho) :-
    a_star([[0,[CidadeInicial]]], CidadeFinal, Preferencia, CaminhoInvertido),
    reverse(CaminhoInvertido, Caminho).

% Implementação do algoritmo A*
a_star([[_,[CidadeFinal|Caminho]]|_], CidadeFinal, _, [CidadeFinal|Caminho]).
a_star([CaminhoAtual|Caminhos], CidadeFinal, Preferencia, Caminho) :-
    expandir_a_star(CaminhoAtual, CidadeFinal, Preferencia, NovosCaminhos),
    append(Caminhos, NovosCaminhos, ProximosCaminhos),
    sort(ProximosCaminhos, ProximosCaminhosOrdenados),
    a_star(ProximosCaminhosOrdenados, CidadeFinal, Preferencia, Caminho).

% Expande um caminho para incluir todas as cidades conectadas à última cidade do caminho
expandir_a_star([[CidadeAtual|Caminho]], CidadeFinal, Preferencia, NovosCaminhos) :-
    findall(
        [NovoCusto,[ProximaCidade,CidadeAtual|Caminho]],
        (
            conectado(CidadeAtual, ProximaCidade),
            \+ member(ProximaCidade, [CidadeAtual|Caminho]),
            criterio_a_star(Preferencia, [CidadeAtual|Caminho], ProximaCidade, CidadeFinal, NovoCusto)
        ),
        NovosCaminhos
    ).

% Define o critério para expandir o caminho com base na preferência do usuário
criterio_a_star(mais_rapido, Caminho, Cidade, CidadeFinal, Custo) :-
    % heuristica_a_star(mais_rapido, Caminho, Cidade, CidadeFinal, Heuristica),
    distancia(Cidade, CidadeFinal, D),
    velocidademaxima(Cidade, CidadeFinal, V),
    Custo is D / V + Heuristica.
criterio_a_star(mais_seguro, _, _, _, 0).


% Adicione um predicado para calcular a distância em linha reta entre duas coordenadas geográficas
distancia_linha_reta(Lat1, Lon1, Lat2, Lon2, Distancia) :-
    Dlat is Lat2 - Lat1,
    Dlon is Lon2 - Lon1,
    A is sin(Dlat / 2) ** 2 + cos(Lat1) * cos(Lat2) * sin(Dlon / 2) ** 2,
    C is 2 * atan2(sqrt(A), sqrt(1 - A)),
    Distancia is 6371 * C.

% Define a função heurística para estimar o custo restante até a cidade final
% heuristica_a_star(mais_rapido, _, _, _, 0).
% heuristica_a_star(mais_seguro, Caminho, CidadeAtual, CidadeFinal, Heuristica) :-
%     reverse([CidadeAtual|Caminho], CaminhoReverso),
%     heuristica_segura(CaminhoReverso, CidadeFinal, 0, Heuristica).
