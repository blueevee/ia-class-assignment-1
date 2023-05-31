
% Encontra o caminho mais rápido ou mais seguro entre duas cidades usando busca em profundidade
melhor_trajeto_dfs(CidadeInicial, CidadeFinal, Preferencia, Caminho) :-
    dfs(CidadeInicial, CidadeFinal, [CidadeInicial], Preferencia, CaminhoInvertido),
    reverse(CaminhoInvertido, Caminho).

% Implementação do algoritmo de busca em profundidade
dfs(CidadeFinal, CidadeFinal, Caminho, _, Caminho).
dfs(CidadeAtual, CidadeFinal, CaminhoAtual, Preferencia, Caminho) :-
    conectado(CidadeAtual, ProximaCidade),
    \+ member(ProximaCidade, CaminhoAtual),
    criterio_dfs(Preferencia, CidadeAtual, ProximaCidade),
    dfs(ProximaCidade, CidadeFinal, [ProximaCidade|CaminhoAtual], Preferencia, Caminho).

% Define o critério para expandir o caminho com base na preferência do usuário
criterio_dfs(mais_rapido, Cidade1, Cidade2) :- tempoViagem(Cidade1,Cidade2,_).
criterio_dfs(mais_seguro, Cidade1, Cidade2) :- nivelrisco(Cidade1,Cidade2,N), N =< 3.
