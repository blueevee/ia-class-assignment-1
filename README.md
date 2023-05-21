# Primeiro trabalho do semestre da matéria de IA
> ## Especificações
> Formule um agente solucionador de problemas que calcule a rota de um motorista Uber para levar passageiros até o seu destino. Cada instância do problema inicia quando o motorista aceita uma viagem. O agente deve planejar o melhor caminho para ir da posição atual do carro até o ponto de partida do passageiro e depois de lá até o ponto de destino do mesmo.
> A cidade onde o Uber trafega pode ser modelada como um grafo que identifica localizações tendo as arestas como as ruas que ligam estas localizações.
> A quantidade de localidades e as ligações entre as localidades deve ser informada no início de cada instância do problema. Ou seja, não há número fixo de localidades e cada localidade pode estar ligada diretamente (por uma aresta) a qualquer quantidade de outras localidades. Mas não pode ser um grafo totalmente conectado (com todas as localidades ligadas diretamente umas as outras), precisa refletir uma situação de um mapa realista.
> Cada aresta do grafo, representa uma distância em km, uma velocidade máxima a ser obedecida e um nível de risco (de 1 a 5), sendo 5 muito arriscado e 1 muito seguro. Ao pegar o passageiro ele deve informar se prefere um trajeto mais seguro ou mais rápido.
>
> Formule o problema para um agente solucionador de problemas definindo conjunto de estados, estados finais, conjunto de ações, função de custo do caminho (g(n) e função heurística (h(n)).
>
> Implemente o seu agente utilizando as seguintes estratégias de busca:
> 1) Busca em Largura
> 2) Busca em Profundidade
> 3) Busca Gulosa
> 4) A*
>
> Execute 100 instâncias diferentes do problema para cada estratégia, usando diferentes mapas (os mesmos mapas devem ser usados com cada estratégia) e apresente um relatório destes testes comparando a performance das 04 estratégias. Qual foi a melhor (encontra a melhor solução)? Qual a que teve menor custo de busca (expande menos nós)? Explique a diferença na performance entre as estratégias.
> Você deve provar que sua função heurística é admissível e explicar como criou a função heurística.

## Sobre
- Escolhemos usar o `swiplserver` para conseguir usar as bases de conhecimento de prolog em um ambiente python
> ## Parte 1: Entendendo prolog
> Esses tutoriais foram bastante úteis para entender o básico de como funciona o prolog
> https://www.youtube.com/watch?v=omLANiMqbuY
> ## Parte 2: Entendendo a tarefa
> Após entender o básico de prolog, começamos a dividir a tarefa em sub tarefas para completar o objetivo da mesma:
> 1. Criar uma base de conhecimento prolog que representasse cidades e suas conexões, com distância, velocidade máxima da via, nível de periculosidade:
>> Criamos um spcript python que criasse 100 arquivos contendo bases de conhecimento com diferentes conexões entre as cidades, e diferentes valores para velocidade nível de periculosidade e distância.
> 2. Encontrar um caminho entre duas cidades:
>> Entendemos que algumas regras prolog seria necessárias, como `conectado` para verificar se uma cidade está diretamente ligada a outra, `distancia` para verificar qual a distância entre duas cidades, `velocidademaxima` para saber qual a velocidade máxima do trecho e `nivelrisco` para saber qual o nível de risco do trecho, já que o caminho pode ser escolhido com o mais rápido ou o mais seguro.
>> Além dessas, precisavamos de regras específicas para calcular o melhor trajeto, usando as 4 estratégias solicitadas pelo professor, essas 4 estratégias usariam as regras acima para tomar as decisões
> 3. Executar e testar o agente:
>> Após isso criamos um script para executar 100 vezes a instância criada, cada vez com um dos mapas diferente rodamos 4 vezes com cada algoritmo diferente, ao final de cada uma das 4 execuções foi gerado um arquivo `.csv` com as seguintes informações:
>>> - Qual o arquivo mapa usado para essa iteração
>>> - Mémoria atual
>>> - Pico de memória usado
>>> - Tempo gasto na execução
>>> - Caminho encontrado
> 4. Gerar gáficos com os dados coletados:
> 5. Gerar um relatório de desempenho:
