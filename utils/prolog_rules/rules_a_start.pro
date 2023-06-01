% Predicados existentes
conectado(Cidade1, Cidade2) :-
    aresta(Cidade1, Cidade2, , , , );
    aresta(Cidade2, Cidade1, , , , ).

distancia(Cidade1, Cidade2, D) :-
    aresta(Cidade1, Cidade2, D, , , );
    aresta(Cidade2, Cidade1, D, , , ).

velocidademaxima(Cidade1, Cidade2, V) :-
    aresta(Cidade1, Cidade2, , V, , );
    aresta(Cidade2, Cidade1, , V, , ).

nivelrisco(Cidade1, Cidade2, N) :-
    aresta(Cidade1, Cidade2, , , N, );
    aresta(Cidade2, Cidade1, , , N, ).

tempoViagem(Cidade1, Cidade2, T) :-
    aresta(Cidade1, Cidade2, , , , T);
    aresta(Cidade2, Cidade1, , , , T).

% Função heurística
h(Cidade, H) :-
    distancia(Cidade, CidadeFinal, D),
    H is D.

% Predicado para selecionar a preferência
preferencia(maisrapido, D, V, , D / V).
preferencia(maisseguro, , _, N, N).

% Predicado principal
melhor_trajeto_astar(CidadeInicial, CidadeFinal, Preferencia, Caminho) :-
    estrela([CidadeInicial-0], CidadeFinal, Preferencia, [], Caminho).

% Predicado auxiliar para o algoritmo A*
estrela([], , , , ) :-
    write('Caminho não encontrado.').

estrela([CidadeAtual-|], CidadeAtual, , Caminho, CaminhoReverso) :-
    reverse(Caminho, CaminhoReverso).

estrela([CidadeAtual-CustoAtual | OutrosCaminhos], CidadeFinal, Preferencia, CaminhoAtual, CaminhoReverso) :-
    findall(NovaCidade-NovoCusto, (conectado(CidadeAtual, NovaCidade), + member(NovaCidade-, CaminhoAtual), preferencia(Preferencia, Distancia, Velocidade, Risco, ), NovoCusto is CustoAtual + Distancia, h(NovaCidade, H), G is NovoCusto + H, NovaCidade-G), Lista),
    append(OutrosCaminhos, Lista, NovosCaminhos),
    sort(2, @=<, NovosCaminhos, CaminhosOrdenados),
    percorrer_caminhos(CaminhosOrdenados, CidadeFinal, Preferencia, [CidadeAtual-CustoAtual | CaminhoAtual], NovoCaminho),
    estrela(NovoCaminho, CidadeFinal, Preferencia, CaminhoAtual, CaminhoReverso).

percorrercaminhos([Cidade-ProximoCusto | ], Cidade, _, CaminhoAtual, [Cidade-ProximoCusto | CaminhoAtual]).
percorrer_caminhos([Cidade-ProximoCusto | OutrosCaminhos], CidadeFinal, Preferencia, CaminhoAtual, NovoCaminho) :-
    estrela([Cidade-ProximoCusto | OutrosCaminhos], CidadeFinal, Preferencia, CaminhoAtual, NovoCaminho).