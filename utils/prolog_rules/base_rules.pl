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

