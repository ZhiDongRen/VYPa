%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>

void yyerror(char *s, ...);
int yylex();
%}

%debug

%locations

%union {
    int intval;
    double floatval;
    char *strval;
    int subtok;
}

	/* token*/
%token INT
%token FLOAT
%token DOUBLE
%token AUTO
%token BREAK
%token CASE
%token CONST
%token ELSE
%token FOR
%token IF
%token LONG
%token RETURN
%token SHORT
%token SIGNED
%token CHAR
%token UNSIGNED
%token <strval> IDENTITY
%token <intval> INT_NUMBER
%token <floatval> FLOAT_NUMBER
%token <strval> STRING

%left OR
%left AND
%left ASSIGN
%left '!'
%left '+' '-'
%left '*' '/' '%'

%type <intval> decl_stmt bin_expr factor expr sentence id_list assign_stmt

%start statement

%%

/* 语法规则 */
statement: sentence ';'         { printf("STMT\n"); }
    | statement sentence ';'
    ;

sentence: decl_stmt     { $$ = $1; }
    | assign_stmt       { $$ = $1; }
    | /* empty rule */  { $$ = 0; }
    ;


decl_stmt: type_dec id_list { printf("stmt_decl\n"); }
    | type_dec assign_stmt  { printf("stmt_decl & assignment\n"); }
    ;

id_list: IDENTITY           { printf("id: %s\n", $1); $$ = $1; }
    | id_list ',' IDENTITY  { printf("id: %s\n", $3); $$ = $3; }
    ;

assign_stmt: IDENTITY ASSIGN expr    { printf("id: %s\nASSIGNMENT\n", $1); }
    ;

expr: factor    { $$ = $1; }
    | bin_expr  { $$ = $1; }
    ;

factor: INT_NUMBER      { printf("VALUE: %d\n", $1); $$ = $1; }
    | FLOAT_NUMBER      { printf("VALUE: %d\n", $1); $$ = $1; }
    | IDENTITY          { printf("VALUE: %s\n", $1); $$ = $1; }
    ;

bin_expr: expr '+' expr     { printf("PLUS.\n"); }
    | expr '-' expr         { printf("SUB.\n"); }
    | expr '*' expr         { printf("MUL.\n"); }
    | expr '/' expr         { printf("DIV.\n"); }
    ;

type_dec: INT       { printf("TYPE:INT\n"); }
    | FLOAT         { printf("TYPE:FLOAT\n"); }
    | SHORT         { printf("TYPE:SHORT\n"); }
    | LONG          { printf("TYPE:LONG\n"); }
    | UNSIGNED LONG { printf("TYPE:UNSIGNED\n"); }
    ;


%%

int main(int argc, const char *args[])
{
	
    /* yydebug = 1; */

	extern FILE *yyin;
	if(argc > 1 && (yyin = fopen(args[1], "r")) == NULL) {
		fprintf(stderr, "can not open %s\n", args[1]);
		exit(1);
	}
	if(yyparse()) {
		exit(-1);
	}
	
    return 0;
}

void yyerror(char *s, ...)
{
    extern int yylineno;

    va_list ap;
    va_start(ap, s);

    fprintf(stderr, "%d: error: ", yylineno);
    vfprintf(stderr, s, ap);
    fprintf(stderr, "\n");
}