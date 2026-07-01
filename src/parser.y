%{
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include "symtable.h"
#include "temporary.h"
#include "tac-generator.h"

int yylex(void);

/* −−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−− Variáveis Globais −−−−−−−−−−−−−−−−−−−−−−−−−−−−−−− */

/* tipo corrente durante declarações */
static int current_decl_type = 0;

/* offset */
static int offset = 0;

void yyerror(const char *s);
int tipos_compativeis(int, int);

%}

%union {
    int   ival;   /* valor inteiro: TYPE_INT, RELOP_LE, etc. */
    char *sval;       /* lexema de um identificador              */
    struct {
        int tipo; /* tipo semântico do resultado (SYM_TYPE_*)*/
        char* code // codigo de fato da expr  
    } expr;
    struct {
        int tipo; /* tipo semântico do resultado (SYM_TYPE_*)*/
        char* name // lexema do id para depuração  
        int category // categoria do símbolo (SYM_VAR, SYM_FUNC, SYM_PARAM)
    } use_id;
}

// * definimos os valores de %union usados por essas expressões
%type <expr> expr primary_expr literal func_call

%type <use_id> use_id use_func_id use_var_id decl_var_id decl_func_id decl_param_id

%type <ival> func_call_list opt_func_call_list

/* −−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−− Lexer Tokens −−−−−−−−−−−−−−−−−−−−−−−−−−−−−−− */
%define parse.error verbose

%token IF
%token ELSE
%token WHILE
%token PRINT
%token READ
%token RETURN

%token <ival> TYPE

%token <ival> RELOP
%token <ival> EQOP
%token AND
%token OR
%token NOT

%token ASSIGN

%token PLUS
%token MINUS
%token POW
%token MULT
%token DIV

%token PUNCT_SEMICOLON
%token PUNCT_COMMA
%token PUNCT_OPEN_PAREN
%token PUNCT_CLOSE_PAREN
%token PUNCT_OPEN_BRACE
%token PUNCT_CLOSE_BRACE

%token <sval> ID
%token INTEGER_LITERAL
%token FLOAT_LITERAL

/* −−−−−−−−−−−−−−−−−−−−−−−−−−−−− Definição de Precedência −−−−−−−−−−−−−−−−−−−−−−−−−−−−− */

%precedence ASSIGN
%left OR
%left AND
%left EQOP
%left RELOP
%left PLUS MINUS
%left MULT DIV
%right POW
%precedence NOT
%precedence UMINUS

%%

// TO-DO: OK
program
  : { sym_init(); } global_decl_list
  ;

// TO-DO: OK
global_decl_list
  : global_decl_list global_decl
  | %empty /* vazio */
  ;

// TO-DO: OK
global_decl
  : func_decl
  | var_decl
  ;


// TO-DO: OK
func_decl
  : TYPE {
      // atualiza o tipo
      current_decl_type = $1.ival;
    }
    // * registra a função no escopo global antes de abrir o escopo dela
    decl_func_id PUNCT_OPEN_PAREN 
    {
      generate_label($2.name);  // * gera o label de entrada da função
      open_scope();             // * escopo dos parâmetros + corpo
    } 
    opt_param_list PUNCT_CLOSE_PAREN no_scope_block 
    {
      close_scope();
    }
  ;

// TO-DO: OK
opt_param_list
  : param_list
  | %empty /* vazio */
  ;

// TO-DO: OK
param_list
  : param_list PUNCT_COMMA 
    TYPE { current_decl_type = $3.ival; } decl_param_id
  | TYPE { current_decl_type = $1.ival; } decl_param_id
  ;

// TO-DO: OK - usa use_func_id para garantir que é uma função
func_call
  : use_func_id PUNCT_OPEN_PAREN opt_func_call_list PUNCT_CLOSE_PAREN
  {
    Temporary *temp = temporary_new();
    generate_call_assign((char *)temporary_get_name(temp), $1.name, $3);
    
    $$.tipo = $1.tipo;
    $$.code = (char *)temporary_get_name(temp);
  }
  ;

opt_func_call_list
  : func_call_list { $$ = $1; }
  | %empty { $$ = 0; }
  ;

func_call_list
  : func_call_list PUNCT_COMMA expr
  {
    generate_param($3.code ? $3.code : "");
    $$ = $1 + 1;
  }
  | expr
  {
    generate_param($1.code ? $1.code : "");
    $$ = 1;
  }
  ;

stmt_list
  : stmt_list stmt
  | %empty /* vazio */
  ;

stmt
  : var_decl
  | assign_stmt
  | if_stmt
  | while_stmt
  | print_stmt
  | read_stmt
  | return_stmt
  | block
  ;

return_stmt
  : RETURN opt_expr PUNCT_SEMICOLON
  ;

opt_expr
  : expr
  | %empty /* vazio */
  ;

block
  : PUNCT_OPEN_BRACE { open_scope(); } stmt_list PUNCT_CLOSE_BRACE { close_scope(); }
  ;

no_scope_block
  : PUNCT_OPEN_BRACE stmt_list PUNCT_CLOSE_BRACE
  ;

var_decl
  : TYPE {current_decl_type = $1.ival;} id_list PUNCT_SEMICOLON
  ;

id_list
  : id_list PUNCT_COMMA id_decl
  | id_decl
  ;

id_decl
  : decl_var_id
  | decl_var_id ASSIGN expr 
    {
      if(!tipos_compativeis($1.type, $3.expr.tipo)){
          fprintf(stderr,
                "Erro semântico linha %d: tipo incompatível na inicialização de '%s' "
                "(esperado '%s', recebeu '%s')\n",
                yylineno, $1.name,
                sym_type_str($1.type), sym_type_str($3.expr.tipo));
        }
    }
  ;

assign_stmt
  : expr PUNCT_SEMICOLON
  ;

if_stmt
  : IF PUNCT_OPEN_PAREN expr PUNCT_CLOSE_PAREN block else_clause
  ;

else_clause
  : %empty /* vazio */
  | ELSE block
  | ELSE if_stmt
  ;

while_stmt
  : WHILE PUNCT_OPEN_PAREN expr PUNCT_CLOSE_PAREN block
  ;

print_stmt
  : PRINT PUNCT_OPEN_PAREN print_list PUNCT_CLOSE_PAREN PUNCT_SEMICOLON
  ;

print_list
  : print_list PUNCT_COMMA expr
  | expr
  ;

read_stmt
  : READ PUNCT_OPEN_PAREN read_list PUNCT_CLOSE_PAREN PUNCT_SEMICOLON
  ;

read_list
  : read_list PUNCT_COMMA use_id
  | use_id
  ;

primary_expr
  : use_id { $$.tipo = $1.tipo; $$.code = $1.name; }
  | literal { $$.tipo = $1.tipo; $$.code = NULL; }
  | PUNCT_OPEN_PAREN expr PUNCT_CLOSE_PAREN { $$.tipo = $2.tipo; $$.code = $2.code; }
  | func_call { $$.tipo = $1.tipo; $$.code = $1.code; }
  ;

literal
  : INTEGER_LITERAL { $$.tipo = SYM_TYPE_INT;   }
  | FLOAT_LITERAL   { $$.tipo = SYM_TYPE_FLOAT; }
  ;

expr
  : use_id ASSIGN expr
    {
      // * verificação de tipo
      if (!tipos_compativeis($1.type, $3.expr.tipo)) {
          fprintf(stderr,
          "Erro semântico linha %d: tipo incompatível na atribuição de '%s' "
          "(esperado '%s', recebeu '%s')\n",
          yylineno, $1.name,
          sym_type_str($1.tipo), sym_type_str($3.expr.tipo));
      }
      $$.tipo = $1.tipo;
      $$.code = $1.name;
    }
  
  | expr OR expr { $$.tipo = SYM_TYPE_INT; $$.code = NULL; }
  | expr AND expr { $$.tipo = SYM_TYPE_INT; $$.code = NULL; }

  | expr EQOP expr { $$.tipo = SYM_TYPE_INT; $$.code = NULL; }
  | expr RELOP expr { $$.tipo = SYM_TYPE_INT; $$.code = NULL; }

  | expr PLUS expr { $$.tipo = $1.tipo; $$.code = NULL; }
  | expr MINUS expr { $$.tipo = $1.tipo; $$.code = NULL; }

  | expr MULT expr { $$.tipo = $1.tipo; $$.code = NULL; }
  | expr DIV expr { $$.tipo = $1.tipo; $$.code = NULL; }
  | expr POW expr { $$.tipo = $1.tipo; $$.code = NULL; }

  | MINUS expr %prec UMINUS { $$.tipo = $2.tipo; $$.code = NULL; }
  | NOT expr %prec NOT { $$.tipo = SYM_TYPE_INT; $$.code = NULL; }

  | primary_expr { $$.tipo = $1.tipo; $$.code = $1.code; }
  ;

  use_id
  : ID {
    Symbol *s = sym_lookup($1.sval);
      if (!s) {
          fprintf(stderr, "Erro semântico linha %d: '%s' não declarado\n",
                  yylineno, $1.sval);
          $$.tipo = SYM_TYPE_INT;  //* tipo de recuperação para não propagar erro
          $$.name = $1.sval;
          $$.category = -1;  /* categoria inválida */
      } else {
          $$.tipo = s->type;
          $$.name = s->name;
          $$.category = s->category;
      }
  }
  ;

  use_func_id
  : use_id
  {
    /* Verifica se o identificador é realmente uma função */
    if ($1.category != SYM_FUNC) {
        fprintf(stderr, "Erro semântico linha %d: '%s' não é uma função\n",
                yylineno, $1.name);
    }
    $$ = $1;
  }
  ;

  use_var_id
  : use_id
  {
    /* Verifica se o identificador é realmente uma variável */
    if ($1.category != SYM_VAR && $1.category != SYM_PARAM) {
        fprintf(stderr, "Erro semântico linha %d: '%s' não é uma variável\n",
                yylineno, $1.name);
    }
    $$ = $1;
  }
  ;

  decl_var_id
  : ID {
    Symbol *s = sym_declare($1.sval, current_decl_type, SYM_VAR, yylineno, column_number);
      if (!s) {
          $$.tipo = SYM_TYPE_INT;  //* tipo de recuperação para não propagar erro
          $$.name = $1.sval;
      } else {
          $$.tipo = s->type;
          $$.name = s->name;
      }
  }
  ;

  decl_func_id
  : ID {
    Symbol *s = sym_declare($1.sval, current_decl_type, SYM_FUNC, yylineno, column_number);
      if (!s) {
          $$.tipo = SYM_TYPE_INT;  //* tipo de recuperação para não propagar erro
          $$.name = $1.sval;
      } else {
          $$.tipo = s->type;
          $$.name = s->name;
      }
  }
  ;

  decl_param_id
  : ID {
    Symbol *s = sym_declare($1.sval, current_decl_type, SYM_PARAM, yylineno, column_number);
      if (!s) {
          $$.tipo = SYM_TYPE_INT;  //* tipo de recuperação para não propagar erro
          $$.name = $1.sval;
      } else {
          $$.tipo = s->type;
          $$.name = s->name;
      }
  }
  ;

%%

int tipos_compativeis(int tipo_esperado, int tipo_recebido) {
  return tipo_esperado == tipo_recebido ||
       (tipo_esperado == SYM_TYPE_INT && tipo_recebido == SYM_TYPE_FLOAT) ||
       (tipo_esperado == SYM_TYPE_FLOAT && tipo_recebido == SYM_TYPE_INT);
}

void yyerror(const char *s) {
    extern int yylineno;
    extern int column_number;
    extern int yyleng;
    fprintf(stderr, "Error at line %d, column %d: %s\n", yylineno, column_number - yyleng, s);
}

extern int lexical_error_count;

int main(int argc, char **argv) {
  
  extern FILE *yyin;
  if (argc > 1) {
      yyin = fopen(argv[1], "r");
      if (!yyin) {
          perror("Error opening file");
          return 1;
      }
  }

  // roda o parsing, que por sua vez roda o lex
  int has_errors = (yyparse() != 0) || (lexical_error_count > 0);

  if (!has_errors) {
    printf("Aceita\n");
  }

  sym_print();

  return has_errors ? 1 : 0;
}
