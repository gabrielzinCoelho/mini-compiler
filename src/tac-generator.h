#ifndef TAC_GENERATOR_H
#define TAC_GENERATOR_H

typedef struct TAC {
    int unused;
} TAC;

void generate(char *operator, char *argument1, char *argument2, char *result);
void generate_label(char *label_name);
void generate_return(char *expr);
void generate_param(char *arg);
void generate_call(char *func_name, int num_params);
void generate_call_assign(char *result, char *func_name, int num_params);

#endif /* TAC_GENERATOR_H */