% Fatos de exemplo para o grafo
conectado(a, b, 2).
conectado(b, a, 2).
conectado(a, c, 4).
conectado(c, a, 4).
conectado(b, d, 6).
conectado(d, b, 6).
conectado(b, e, 9).
conectado(e, b, 9).
conectado(c, f, 1).
conectado(f, c, 1).
conectado(c, g, 2).
conectado(g, c, 2).
conectado(d, h, 8).
conectado(h, d, 8).
conectado(e, h, 6).
conectado(h, e, 6).
conectado(f, h, 9).
conectado(h, f, 9).
conectado(g, h, 10).
conectado(h, g, 10).

% Função principal BFS
bfs(Inicio, Destino, Solucao) :-
    bfs_aux([[Inicio]], Destino, Solucao).

% Caso base: quando o nó atual é o destino, a solução é encontrada
bfs_aux([[Destino|Caminho]|_], Destino, Solucao) :-
    reverse([Destino|Caminho], Solucao).

% Caso recursivo: expande o próximo nó e adiciona os vizinhos não visitados à fronteira
bfs_aux([Caminho|OutrosCaminhos], Destino, Solucao) :-
    extend(Caminho, NovosCaminhos),
    append(OutrosCaminhos, NovosCaminhos, Fronteira),
    bfs_aux(Fronteira, Destino, Solucao).

% Função para expandir um caminho
extend([Estado|Caminho], NovosCaminhos) :-
    findall([ProximoEstado, Estado|Caminho],
            (conectado(Estado, ProximoEstado),
            \+ member(ProximoEstado, [Estado|Caminho])),
            NovosCaminhos).