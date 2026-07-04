# Mini-Compiler

## Sobre o projeto

O objetivo do trabalho prático é desenvolver um compilador para uma mini linguagem didática. O trabalho está dividido em 3 etapas, conforme a descrição a seguir.

## Tecnologias Utilizadas

- **Flex**: gerador de analisadores léxicos utilizado para especificar, por meio de expressões regulares, o reconhecimento dos tokens da linguagem (palavras-chave, identificadores, números, operadores e símbolos de pontuação), além do descarte de espaços em branco e comentários.
- **Bison**: gerador de analisadores sintáticos (parsers) baseado em gramáticas livres de contexto (LALR), utilizado para definir as regras gramaticais da linguagem, resolver ambiguidades (e.g., dangling else) e detectar/reportar erros sintáticos, integrando-se ao analisador léxico gerado pelo Flex.
- **C**: linguagem hospedeira utilizada para implementar as ações semânticas embutidas nas regras do Flex e do Bison, bem como a lógica de apoio (tabela de símbolos, tratamento de erros e geração de código intermediário).
- **GCC**: utilizado para compilar e integrar os arquivos gerados pelo Flex e pelo Bison, automatizando o processo de build do compilador.

## Requisitos Funcionais

### Analisador Léxico
- Implemente um analisador léxico em Flex para a linguagem com os seguintes elementos:
  - Declarações de tipos (int, float);
  - Identificadores, números inteiros e decimais;
  - Palavras-chave (if, else, while, print, read);
  - Operadores relacionais, aritméticos e lógicos;
  - Símbolos de pontuação (; , ( ) { }).
- PS: tipo int pode assumir valores negativos.
- Critérios a serem avaliados:
  - Além de reconhecer os tokens, deve:
    - estar organizado, com comentários explicativos;
    - imprimir o token, seu lexema e sua posição (linha e coluna);
    - detectar erros e reportá-los ao usuário informando a posição;
    - exibir a tabela de símbolos construída pelo analisador léxico; e
    - desconsiderar espaços em branco e comentários (linha única // e múltipla /\* \*/).
  - O relatório (conciso e objetivo) deve:
    - discutir as decisões de projeto;
    - discutir as dificuldades encontradas;
    - apresentar dois diagramas de transição (DFAs) referentes a classes de tokens; e
    - incluir um arquivo de teste e sua saída (não precisa ser grande, porém completo).

### Analisador Sintático
- Implemente um analisador sintático em Bison para uma gramática que deve prover:
  - declarações de variáveis e tipos;
  - declaração e chamada de funções;
  - instruções de atribuição;
  - condicionais (if/else);
  - laços (while);
  - blocos e comandos compostos ({ });
  - instruções de entrada/saída (print, read);
  - expressões aritméticas, relacionais e lógicas, com a precedência definida; e
  - comentários de uma linha e múltiplas linhas.
- Critérios a serem avaliados:
  - Correções apontadas pelo professor na Etapa 1.
  - O analisador deve:
    - estar organizado, com comentários explicativos;
    - reconhecer a sintaxe de programas escritos na linguagem proposta;
    - compilar corretamente no Bison e rodar em conjunto com o analisador léxico da Etapa 1;
    - detectar e reportar erros sintáticos com mensagem clara indicando a posição (linha e coluna); e
    - resolver ambiguidades (e.g., dangling else e -).
  - O relatório (conciso e objetivo) deve:
    - apresentar a gramática completa em BNF da linguagem implementada;
    - discutir as decisões de projeto (e.g., ambiguidades e tratamento de erros);
    - discutir as dificuldades encontradas;
    - calcular os conjuntos FIRST e FOLLOW apenas para os não-terminais de expressões;
    - apresentar e comentar os estados do autômato LR(0) com conflitos (e.g., dangling else e -); e
    - incluir um arquivo de teste e sua saída (não precisa ser grande, porém completo).

### Análise Semântica e Geração de Código Intermediário
- Implemente a análise semântica e a geração de código de três endereços (IR) para a mesma linguagem das Etapas 1 e 2.
- Critérios a serem avaliados:
  - Correções apontadas pelo professor na Etapa 2.
  - O compilador deve:
    - manter uma tabela de símbolos com escopos aninhados (abrir/fechar escopo em { }), armazenando ao menos identificador, tipo e nível de escopo;
    - realizar verificação de tipos em:
      - atribuição (lado direito compatível com o tipo da variável);
      - expressões aritméticas (+ - \* / aceitam int e float com promoção implícita de tipos¹, e % aceita apenas int);
      - relacionais (== != < <= > >= tomam int ou float e produzem valores inteiros (0 ou 1)²);
      - lógicos (! && || aceitam operandos numéricos, realizando conversão implícita para valores lógicos e produzem valores inteiros (0 ou 1));
      - unários (- unário sobre int e float, ! sobre expressões numéricas);
      - if/while: condição deve ser qualquer expressão numérica³.
    - reportar erros semânticos com posição, e.g., identificadores não declarados ou redeclarados no mesmo escopo.
    - gerar código intermediário para todas as construções da linguagem;
      - usar de temporários (t1, t2, ..., tn) e rótulos (L1, L2, ..., Lm); e
      - especificar e usar um conjunto mínimo de instruções de IR, incluindo chamada de funções.
  - O relatório (conciso e objetivo) deve:
    - descrever a estrutura da tabela de símbolos e o gerenciamento de escopos;
    - apresentar uma tabela de regras de tipagem dos operadores/construções;
    - explicar a estratégia de geração de IR para if/else e while;
    - incluir um programa de teste e o IR gerado correspondente (saída do compilador);
    - apresentar pelo menos uma Tradução Dirigida por Sintaxe (TDS); e
    - discutir decisões de projeto e dificuldades encontradas.

> ¹ Quando um operando é float, o outro é promovido implicitamente para float.
> ² A linguagem não possui tipo booleano explícito. Valores inteiros são utilizados para representar resultados lógicos, onde 0 representa falso e qualquer valor diferente de 0 representa verdadeiro.
> ³ A condição é avaliada como falsa quando igual a 0 e verdadeira caso contrário, seguindo a convenção de linguagens como C.

## Autores

- [Otávio Sbampato Andrade](https://github.com/otaviosbampato)
- [Gabriel Coelho Costa](https://github.com/gabrielzinCoelho)
- [Heitor Ramos Vieira Rocha](https://github.com/heitor-vieira)
