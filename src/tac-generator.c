#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "tac-generator.h"

char* generate(char *operator, char *argument1, char *argument2, char *result) {
    char buffer[256];
    snprintf(buffer, sizeof(buffer), "%s, %s, %s, %s",
           operator ? operator : "",
           argument1 ? argument1 : "",
           argument2 ? argument2 : "",
           result ? result : "");
    printf("%s\n", buffer);
    return strdup(buffer);
}

char* generate_label(char *label_name) {
    char buffer[256];
    snprintf(buffer, sizeof(buffer), "label %s", label_name ? label_name : "");
    printf("%s\n", buffer);
    return strdup(buffer);
}

char* generate_return(char *expr) {
    char buffer[256];
    snprintf(buffer, sizeof(buffer), "return %s", expr ? expr : "");
    printf("%s\n", buffer);
    return strdup(buffer);
}

char* generate_param(char *arg) {
    char buffer[256];
    snprintf(buffer, sizeof(buffer), "param %s", arg ? arg : "");
    printf("%s\n", buffer);
    return strdup(buffer);
}

char* generate_call(char *func_name, int num_params) {
    char buffer[256];
    snprintf(buffer, sizeof(buffer), "call %s, %d", func_name ? func_name : "", num_params);
    printf("%s\n", buffer);
    return strdup(buffer);
}

char* generate_call_assign(char *result, char *func_name, int num_params) {
    char buffer[256];
    snprintf(buffer, sizeof(buffer), "%s = call %s, %d", 
           result ? result : "", 
           func_name ? func_name : "", 
           num_params);
    printf("%s\n", buffer);
    return strdup(buffer);
}