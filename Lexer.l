%{
  #include <stdio.h>
  #include <string.h>
  #include <stdlib.h>
  
typedef struct _token{
    int clase;
    char valor[32];
    int line;
} token;

token TOKEN;

enum clase {ID=1, NUM, CAD,CHAR};

void error(char *s);
%}

%option yylineno
%s COMENTARIO
letra [a-zA-Z]
num [0-9]
letra_ {letra}|_
entero ({num})+
real {num}*"."{num}+|{num}+"."{num}*
arreglo {num}*|
id {letra}(_{num})*
cadena {letra}{letra}+
caracter [>|<|>=|<=|<>|=]
oparit [[+|-|*|/]
base {entero|real|caracter}
tipo {base}*
boleano e bool o e bool | e bool y e bool | no e bool | ( e bool )| relacional |"verdadero"|"falso"

%%
"estructura" {return ESTRUCTURA;}
"inicio" {return INICIO;}
"fin" {return END;}
"ent" {return ENTERO;}
"real" {return REAL;}
"dreal" {return DREAL;}
"sin" {return SIN;}
"si"  {return SI;}
"def" {return DEF;}
"entonces" {return ENTONCES;}
"sino" {return SINO;}
"mientras" {return MIENTRAS;}
"hacer" {return HACER;}
"segun" {return SEGUN;}
"escribir" {return ESCRIBIR;}
"leer"  {return LEER;}
"devolver" {return DEVOLVER;}
"terminar" {return TERMINAR;}
"caso" {return CASO;}
"pred" {return PRED;}
"o" {return O;}
"y" {return Y;}
"no" {return NO;}
"verdadero" {return VERDADERO;}
"falso" {return FALSO;}
"+" {return MAS;}
"-" {return MENOS;}
"*" {return MUL;}
"/" {return DIV;}
"%" {return MODULO;}
"<" {return MENOR;}
">" {return MAYOR;}
"<=" {return MENORIGUAL;}
">=" {return MAYORIGUAL;}
"==" {return IDENTICO;}
"<>" {return DIFERENTE;}
":=" {return IGUAL;}
"(" {return LPAR;}
")" {return RPAR;}
"[" {return LCOR;}
"]" {return RCOR;}
"." {return PUNTO;}
"," {return COMA;}
":" {return DOSP;}
";" {return PYC;}
{num} {
        TOKEN.clase = NUM;
        strcpy(TOKEN.valor, yytext);
        TOKEN.line = yylineno;
        return NUM
      }
{id} {
            TOKEN.clase = ID;
            strcpy(TOKEN.valor, yytext);
            TOKEN.line = yylineno;
            return ID;
      }

{cadena} {
            TOKEN.clase = CAD;
            strcpy(TOKEN.valor, yytext);
            TOKEN.line = yylineno;
            return CAD;
      }
{caracter} {
            TOKEN.clase = CHAR;
            strcpy(TOKEN.valor, yytext);
            TOKEN.line = yylineno;
            return CHAR;
      }
[ \t\n\r] {/* Ignora los espacios en blanco*/}
.   {error(yytext);}
%%

int yywrap(){
    return 1;
}

void error(char *s){
    printf("Error léxico: %s, en la línea %d\n",s,yylineno);
}

int main(int argc, char **argv){
    FILE *f;
    if(argc<2){
        printf("Falta archivo\n");
        exit(-1);
    }
    f = fopen(argv[1],"r");
    if(!f){
        printf("No se puede abrir el archivo\n");
        exit(-1);
    }
    yyin = f;
    int tok = yylex();
    while(tok != 0){
        printf("%d\n",tok);
        tok = yylex();
    }    
    return 0;
}
