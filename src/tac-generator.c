#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>

#include "tac-generator.h"


// Função auxiliar para criar uma linha de código TAC formatada
static char *make_line(const char *format, ...) {
    va_list args;
    va_list copy;
    int size;
    char *buffer;

    va_start(args, format);
    va_copy(copy, args);
    size = vsnprintf(NULL, 0, format, copy);
    va_end(copy);

    if (size < 0) {
        va_end(args);
        return NULL;
    }

    buffer = (char *)malloc((size_t)size + 1);
    if (!buffer) {
        va_end(args);
        return NULL;
    }

    vsnprintf(buffer, (size_t)size + 1, format, args);
    va_end(args);

    return buffer;
}

// gera uma linha TAC com base nos argumentos fornecidos
char* generate(char *operator, char *argument1, char *argument2, char *result) {
    if (!result) {
        return NULL;
    }

    if (argument2) {
        return make_line("%s = %s %s %s\n",
                         result,
                         argument1 ? argument1 : "",
                         operator ? operator : "",
                         argument2);
    }

    if (operator && strcmp(operator, "=") == 0) {
        return make_line("%s = %s\n", result, argument1 ? argument1 : "");
    }

    return make_line("%s = %s %s\n",
                     result,
                     operator ? operator : "",
                     argument1 ? argument1 : "");
}

// gera uma label TAC
char* generate_label(char *label_name) {
    return make_line("%s:\n", label_name ? label_name : "");
}

// gera um goto TAC
char* generate_goto(char *label_name) {
    return make_line("goto %s\n", label_name ? label_name : "");
}

// gera um if-goto TAC
char* generate_if_goto(char *condition, char *label_name) {
    return make_line("if %s goto %s\n",
                     condition ? condition : "",
                     label_name ? label_name : "");
}

// gera um cast TAC
char* generate_cast(char *type_name, char *value, char *result) {
    return make_line("%s = (%s) %s\n",
                     result ? result : "",
                     type_name ? type_name : "",
                     value ? value : "");
}

// gera um return TAC
char* generate_return(char *expr) {
    if (expr && expr[0] != '\0') {
        return make_line("return %s\n", expr);
    }

    return make_line("return\n");
}

// gera um return TAC com valor
char* generate_param(char *arg) {
    return make_line("param %s\n", arg ? arg : "");
}

// gera um return TAC com valor
char* generate_print(char *arg) {
    return make_line("print %s\n", arg ? arg : "");
}

// gera um return TAC instrução de leitura
char* generate_read(char *arg) {
    return make_line("read %s\n", arg ? arg : "");
}

// gera um call TAC
char* generate_call(char *func_name, int num_params) {
    return make_line("call %s, %d\n", func_name ? func_name : "", num_params);
}

// gera um call TAC com atribuição
char* generate_call_assign(char *result, char *func_name, int num_params) {
    return make_line("%s = call %s, %d\n",
                     result ? result : "",
                     func_name ? func_name : "",
                     num_params);
}