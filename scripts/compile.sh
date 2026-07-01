#!/bin/bash

# Script para compilar Lexer (.l) e Parser (.y) de forma integrada
# Uso: ./scripts/compile.sh

echo "Iniciando compilação do Lexer e Parser..."

# Define os diretórios baseados na estrutura do seu projeto
SRC_DIR="src"
BIN_DIR="bin"

# Cria a pasta bin caso ela não exista
mkdir -p "$BIN_DIR"

# Passo 1: Gerar parser.c e parser.h com bison
echo "[1/3] Executando bison..."
# A flag -d gera também o .h (header) necessário para o lexer enxergar os tokens
bison -Wall -d -o "$BIN_DIR/parser.c" "$SRC_DIR/parser.y"
if [ $? -ne 0 ]; then
    echo "Erro ao executar bison no arquivo parser.y"
    exit 1
fi
echo "✓ parser.c e parser.h gerados em $BIN_DIR"

# Passo 2: Gerar lexer.c com flex
echo "[2/3] Executando flex..."
flex -o "$BIN_DIR/lexer.c" "$SRC_DIR/lexer.l"
if [ $? -ne 0 ]; then
    echo "Erro ao executar flex no arquivo lexer.l"
    exit 1
fi
echo "✓ lexer.c gerado em $BIN_DIR"

# Passo 3: Compilar com gcc
echo "[3/3] Compilando com gcc..."
# Seguindo a instrução do professor: usando -lfl (para Linux)
gcc -o "$BIN_DIR/main" "$BIN_DIR/parser.c" "$BIN_DIR/lexer.c" "$SRC_DIR/utils.c" "$SRC_DIR/temporary.c" "$SRC_DIR/tac-generator.c" -lfl

# Nota: Se tiver um erro sobre "undefined reference to yyerror" no futuro,
# pode ser necessário adicionar a flag -ly ou implementar yyerror no seu .y.
# gcc -o "$BIN_DIR/main" "$BIN_DIR/parser.c" "$BIN_DIR/lexer.c" -ly -lfl

if [ $? -ne 0 ]; then
    echo "Erro ao compilar com gcc"
    exit 1
fi
echo "✓ Executável gerado em $BIN_DIR/main"

echo ""
echo "Compilação concluída com sucesso!"
echo "Para executar, redirecione um dos inputs. Exemplo:"
echo "./bin/main < inputs/test-1.txt"