## FALTA FAZER:

expr
├── ID ASSIGN expr          → lookup + checagem de tipo
├── expr OR expr            → $$.tipo = SYM_TYPE_INT (relacional produz 0 ou 1)
├── expr AND expr           → $$.tipo = SYM_TYPE_INT
├── expr EQOP expr          → $$.tipo = SYM_TYPE_INT
├── expr RELOP expr         → $$.tipo = SYM_TYPE_INT
├── expr PLUS expr          → promoção: int+float = float, senão int
├── expr MINUS expr         → idem
├── expr MULT expr          → idem
├── expr DIV expr           → idem
├── expr POW expr           → idem
├── MINUS expr (unário)     → $$.tipo = $2.tipo
├── NOT expr                → $$.tipo = SYM_TYPE_INT
└── primary_expr            → $$.tipo = $1.tipo (propaga)

primary_expr
├── ID                      → lookup + $$.tipo = s->type
├── literal                 → $$.tipo = $1.tipo (propaga)
├── (expr)                  → $$.tipo = $2.tipo (propaga)
└── func_call               → $$.tipo = tipo de retorno da função

literal
├── INTEGER_LITERAL         → $$.tipo = SYM_TYPE_INT
├── FLOAT_LITERAL           → $$.tipo = SYM_TYPE_FLOAT
├── STR_LITERAL             → $$.tipo = SYM_TYPE_STR
└── BOOL_LITERAL            → $$.tipo = SYM_TYPE_BOOL

param_list
├── param_list , TYPE ID    → sym_declare como SYM_PARAM
└── TYPE ID                 → sym_declare como SYM_PARAM

## FEITOS:
- program, 
- global_decl_list, 
- global_decl,
- opt_param_list,
- stmt_list,
- stmt,
- opt_expr,
- assign_stmt,
- if_stmt,
- else_clause,
- while_stmt,
- print_stmt,
- print_list,
- read_stmt,
- read_list,
- return_stmt
- func_call_list
- opt_func_call_list,
- id_list

## CORRIGIR:
- SÓ ERA PRA TER TIPOS INT E FLOAT
- RE-ESCREVER COMENTÁRIOS EM symtable.h e symtable.c
- LIMPAR COMENTÁRIOS no parser.y, lexer.l