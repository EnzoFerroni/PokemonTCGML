# Pokemon TCG ML
# Aplicação de Aprendizado de Máquina em Jogos de Cartas Digitais: Um Estudo de Caso com Pokémon TCG Pocket

## Resumo

Este artigo apresenta o desenvolvimento de uma aplicação interativa para macOS, baseada no jogo de cartas Pokémon TCG Pocket, com suporte a predições de jogadas usando aprendizado de máquina. Utilizando o framework CoreML da Apple em conjunto com SwiftUI, o sistema é capaz de prever a jogada ideal do oponente com base na carta selecionada pelo jogador. A abordagem adotada contempla desde o processamento e modelagem dos dados até a integração de um modelo treinado com interface gráfica amigável e responsiva.

## 1. Introdução

Jogos de cartas colecionáveis como o Pokémon TCG envolvem estratégias baseadas em tipos e fraquezas. O objetivo deste trabalho foi explorar a integração de modelos preditivos em um jogo digital, utilizando dados reais das cartas e um modelo supervisionado de classificação, para simular uma jogada inteligente por parte do oponente.

## 2. Metodologia

### 2.1 Coleta e Processamento dos Dados

Os dados das cartas foram obtidos em formato JSON contendo atributos como nome, tipo, subtipo, elemento e fraqueza. Após filtragem (type = "pokemon", subtype = "Basic"), os dados foram transformados em um CSV com as colunas: name, element, type, subtype, weakness.

### 2.2 Construção do Dataset de Treinamento

Inicialmente foram consideradas combinações com cinco cartas disponíveis para o oponente. No entanto, o modelo final foi simplificado para trabalhar com o conceito de jogada ideal baseada exclusivamente na fraqueza da carta escolhida pelo jogador, ignorando a mão do oponente.

O dataset final tem a seguinte estrutura:

* input\_element: elemento da carta escolhida
* input\_weakness: fraqueza da carta escolhida
* ideal\_choice: igual à fraqueza (o modelo aprende que o oponente deve usar o tipo que é fraqueza do jogador)

Foram geradas 3.000 amostras sintéticas para treino e teste, distribuídas em 80% treino e 20% teste.

### 2.3 Treinamento com CreateML

Utilizou-se o CreateML com o template Tabular Classification, onde o modelo aprendeu a prever o elemento ideal (ideal\_choice) com base nos atributos de entrada. O modelo foi exportado como ModeloPokemonNew\.mlmodel.

## 3. Desenvolvimento da Aplicação

### 3.1 Arquitetura

A aplicação foi desenvolvida em SwiftUI com foco em compatibilidade com macOS. A estrutura foi organizada em:

* Modelo de dados Card
* GameViewModel com lógica de negócio e integração CoreML
* Interface gráfica com ContentView e CardView

### 3.2 Lógica de Jogo

* O jogador recebe 5 cartas com elementos distintos
* Oponente pode escolher qualquer elemento do jogo (não está limitado a uma mão)
* Jogador escolhe uma carta
* O modelo prevê o elemento ideal para contra-atacar, com base na fraqueza da carta escolhida
* A resposta do modelo é exibida na interface

### 3.3 Interface do Usuário

A interface foi estilizada com gradientes, sombras, botões personalizados e layout responsivo. As cartas apresentam informações como nome, elemento e fraqueza, com destaque visual para a carta selecionada.

## 4. Resultados e Discussão

O modelo apresentou bom desempenho ao prever elementos baseados unicamente na fraqueza da carta escolhida. A simplificação do dataset contribuiu para maior precisão. A integração com o SwiftUI demonstrou ser eficaz para criar uma interface intuitiva e responsiva. A nova abordagem (sem considerar uma mão fixa para o oponente) torna o modelo mais direto e eficaz para um comportamento básico e estratégico.

### Tela Inicial do Jogo
<img width="910" alt="Screenshot 2025-05-08 at 16 14 16" src="https://github.com/user-attachments/assets/35ffc079-f62c-4446-87a2-69e9bf74d494" />

Na tela principal, o jogador visualiza 5 cartas aleatórias de Pokémon com elementos distintos. A interface apresenta título, instruções e design colorido com animações suaves.

### Gerando Nova Partida
<img width="910" alt="Screenshot 2025-05-08 at 16 46 45" src="https://github.com/user-attachments/assets/17601f47-d83e-4d37-9800-e020f75eb65d" />

Ao clicar no botão “Nova Partida”, uma nova mão com 5 cartas diferentes é sorteada. Cada carta exibe nome, elemento e fraqueza. Essa rotação permite testar diferentes cenários para o modelo.

### Jogada Inteligente com CoreML
<img width="910" alt="Screenshot 2025-05-08 at 16 47 23" src="https://github.com/user-attachments/assets/5f5406f0-b966-44d0-92ae-6ffb61af8ff6" />

Quando o jogador seleciona uma carta, ela é destacada com uma nova cor de fundo. O modelo CoreML, treinado previamente, faz a previsão do elemento ideal que o oponente deveria jogar, baseado exclusivamente na fraqueza da carta escolhida.

## 5. Conclusão

O projeto demonstrou como modelos supervisionados simples podem ser aplicados em jogos para simular decisões inteligentes. A estrutura modular permite fácil expansão, como inclusão de novos atributos ou adaptação para outros jogos.

## 6. Trabalhos Futuros

* Incorporar mais atributos (HP, raridade, ataques)
* Analisar jogadas anteriores para construir um modelo sequencial
* Exportar para plataformas iOS e multiplataforma
* Implementar pontuação, turnos e multiplayer local
* Evoluir o modelo para também considerar cartas disponíveis do oponente (realismo tático)
* Apresentar imagens das cartas do jogo

## Referências

* Apple. CreateML Documentation. [https://developer.apple.com/documentation/createml](https://developer.apple.com/documentation/createml)
* Apple. CoreML Documentation. [https://developer.apple.com/documentation/coreml](https://developer.apple.com/documentation/coreml)
* Pokémon TCG Pocket Dataset. [https://github.com/hugoburguete/pokemon-tcg-pocket-card-database](https://github.com/hugoburguete/pokemon-tcg-pocket-card-database$0)
