#ifndef TAC_GENERATOR_H
#define TAC_GENERATOR_H

typedef struct TAC {
    int unused;
} TAC;

char* generate(char *operator, char *argument1, char *argument2, char *result);
char* generate_label(char *label_name);
char* generate_return(char *expr);
char* generate_param(char *arg);
char* generate_call(char *func_name, int num_params);
char* generate_call_assign(char *result, char *func_name, int num_params);

#endif /* TAC_GENERATOR_H */