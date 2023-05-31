
%  Encontra o caminho mais curto ou mais seguro entre duas cidades usando busca em largura
melhor_trajeto_bfs(CidadeInicial, CidadeFinal, Preferencia, Caminho) :-
    bfs([[CidadeInicial]], CidadeFinal, Preferencia, CaminhoInvertido),
    reverse(CaminhoInvertido, Caminho).

%  Implementação do algoritmo de busca em largura
bfs([[CidadeFinal|Caminho]|_], CidadeFinal, _, [CidadeFinal|Caminho]).
bfs([CaminhoAtual|Caminhos], CidadeFinal, Preferencia, Caminho) :-
    expandir(CaminhoAtual, Preferencia, NovosCaminhos),
    append(Caminhos, NovosCaminhos, ProximosCaminhos),
    bfs(ProximosCaminhos, CidadeFinal, Preferencia, Caminho).

% Expande um caminho para incluir todas as cidades conectadas à última cidade do caminho
expandir([CidadeAtual|Caminho], Preferencia, NovosCaminhos) :-
    findall(
        [ProximaCidade,CidadeAtual|Caminho],
        (conectado(CidadeAtual, ProximaCidade), \+ member(ProximaCidade, [CidadeAtual|Caminho]), criterio_bfs(Preferencia, CidadeAtual, ProximaCidade)),
        NovosCaminhos
    ).

% Define o critério para expandir o caminho com base na preferência do usuário
criterio_bfs(mais_rapido, Cidade1, Cidade2) :- tempoViagem(Cidade1,Cidade2,_).
criterio_bfs(mais_seguro, Cidade1, Cidade2) :- nivelrisco(Cidade1,Cidade2,N), N =< 3.
