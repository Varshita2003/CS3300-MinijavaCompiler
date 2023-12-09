%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "P1.tab.h"
%}

%%
"+" { yylval.ch = strdup(yytext); return ADD; }
"-" {yylval.ch = strdup(yytext); return SUB; }
"*" {yylval.ch = strdup(yytext); return MUL; }
"/" {yylval.ch = strdup(yytext); return DIV; }
"||" {yylval.ch = strdup(yytext); return OR;}
"&&" {yylval.ch = strdup(yytext); return AND;}
"<=" {yylval.ch = strdup(yytext); return LTE;}
"!=" {yylval.ch = strdup(yytext); return NEQL;}
"." {yylval.ch = strdup(yytext); return DOT;}
"!" {yylval.ch = strdup(yytext); return NOT;}
"," {yylval.ch = strdup(yytext); return COMMA;}
"=" {yylval.ch = strdup(yytext); return EQUAL;}

"int"  { yylval.ch = strdup(yytext); return INT;}
"boolean" { yylval.ch = strdup(yytext); return BOOL;}
"class" { yylval.ch = strdup(yytext); return CLASS;}
"System.out.println" {yylval.ch = strdup(yytext); return SYSOUT;}
"String" {yylval.ch = strdup(yytext); return STRING;}
"extends" {yylval.ch = strdup(yytext); return EXTENDS;}
"public" {yylval.ch = strdup(yytext); return PUBLIC;}
"static" {yylval.ch = strdup(yytext); return STATIC;}
"void" {yylval.ch = strdup(yytext); return VOID;}
"main" {yylval.ch = strdup(yytext); return MAIN;}
"return" {yylval.ch = strdup(yytext); return RET;}
"length" {yylval.ch = strdup(yytext); return LEN;}
"if" {yylval.ch = strdup(yytext); return IF;}
"else" {yylval.ch = strdup(yytext); return ELSE;}
"do" {yylval.ch = strdup(yytext); return DO;}
"while" { yylval.ch = strdup(yytext); return WHILE;}
"new" {yylval.ch = strdup(yytext); return NEW;}
"this" {yylval.ch = strdup(yytext); return THIS;}
"true" {yylval.ch = strdup(yytext); return TRU;}
"false" {yylval.ch = strdup(yytext); return FALS;}
"#define" {yylval.ch = strdup(yytext); return DEF;}
"(" {yylval.ch = strdup(yytext); return LB; }
")" {yylval.ch = strdup(yytext); return RB; }
"{" { yylval.ch = strdup(yytext); return LCB; }
"}" { yylval.ch = strdup(yytext); return RCB; }
"[" {yylval.ch = strdup(yytext); return LSB;}
"]" {yylval.ch = strdup(yytext); return RSB;}
";" {yylval.ch = strdup(yytext); return SEMICOLON;}

[\r \t] {}
\/\/[^\n]* {}
\/\*[^*]*\*+([^/*][^*]*\*+)*\/ {}
[0-9]+ { yylval.ch = (char*)malloc((strlen(yytext)+1)*(sizeof(char)));
           strcpy (yylval.ch, yytext); return NUMBER; }
[_a-zA-Z][_a-zA-Z0-9]* {yylval.ch = strdup(yytext); return ID;}



[ \n \t] {}

. {  }




%%

int yywrap()
{
    return 1;
}
