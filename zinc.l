%{

//Definitions
#include <stdio.h>
#include <string.h>
#include "y.tab.h"

char *textTemp;
char tokenTemp[15];
int tablePlace = 0;
int currentLineNum;

//Symbol table
typedef struct {
	char Lexeme[10];
	char Type[15];
	int Address;
} symbols;
symbols symbolTable[100];

//pushing values into the table
void pushSymTab(int token, char* textTemp)
{
	int i;
	for( i = 0; i < tablePlace; i ++ )
	{
		if(strcmp(symbolTable[i].Lexeme,textTemp) == 0)			
		{
			return;
		}
	}
	strcpy(symbolTable[tablePlace].Lexeme, textTemp);
	strcpy(symbolTable[tablePlace].Type, tokenTemp);
	symbolTable[tablePlace].Address = tablePlace;
	tablePlace ++;
}

//Rules
%}
%option noyywrap
%option yylineno

LP "("
RP ")"
ASGN ":="
SC ";"
COLON ":"
POWER "**"
NUM ("+"|"-")?[1-9][0-9]*|0
IDENT [A-Z][_A-Z0-9]*
MULTIPLY "*"
DIVIDE "div"
MOD "mod"
ADD "+"
SUB "-"
EQUAL "="
NOTEQUAL "<>"
LESSTHAN "<"
GREATERTHAN ">"
LESSEQUAL "<="
GREATEREQUAL ">="
IF "if"
THEN "then"
ELSE "else"
BEGIN "begin"
END "end"
ENDIF "endif"
ENDWHILE "endwhile"
WHILE "while"
LOOP "loop"
PROGRAM "program"
VAR "var"
INT "integer"
WRITEINT "writeInt"
READINT "readInt"
COMMENT "--".*?
%%

[ \t]		        // ignore whitespace
{COMMENT} 	        // ignore comments
[\n]				{currentLineNum++;}
{LP}				{/* printf("Text: %s \n",yytext);*/  return Token_LP; }
{RP}				{/* printf("Text: %s \n",yytext);*/  return Token_RP; }
{ASGN}				{/* printf("Text: %s \n",yytext);*/  return Token_ASGN; }
{SC}				{/* printf("Text: %s \n",yytext);*/  return Token_SC; }
{COLON}				{/* printf("Text: %s \n",yytext);*/  return Token_COLON; }
{POWER}				{/* printf("Text: %s \n",yytext);*/  return Token_POWER; }
{MULTIPLY}			{/* printf("Text: %s \n",yytext);*/  return Token_MULTIPLY; }
{DIVIDE}			{/* printf("Text: %s \n",yytext);*/  return Token_DIVIDE; }
{MOD}				{/* printf("Text: %s \n",yytext);*/  return Token_MOD; }
{ADD}				{/* printf("Text: %s \n",yytext);*/  return Token_ADD; }
{SUB}				{/* printf("Text: %s \n",yytext);*/  return Token_SUB; }
{EQUAL}				{/* printf("Text: %s \n",yytext);*/  return Token_EQUAL; }
{NOTEQUAL}			{/* printf("Text: %s \n",yytext);*/  return Token_NOTEQUAL; }
{LESSTHAN}			{/* printf("Text: %s \n",yytext);*/  return Token_LESSTHAN; }
{GREATERTHAN}		{/* printf("Text: %s \n",yytext);*/  return Token_GREATERTHAN; }
{LESSEQUAL}			{/* printf("Text: %s \n",yytext);*/  return Token_LESSEQUAL; }
{GREATEREQUAL}		{/* printf("Text: %s \n",yytext);*/  return Token_GREATEREQUAL; }
{IF}				{/* printf("Text: %s \n",yytext);*/  return Token_IF; }
{THEN}				{/* printf("Text: %s \n",yytext);*/  return Token_THEN; }
{ELSE}				{/* printf("Text: %s \n",yytext);*/  return Token_ELSE; }
{BEGIN}				{/* printf("Text: %s \n",yytext);*/  return Token_BEGIN; }
{END}				{/* printf("Text: %s \n",yytext);*/  return Token_END; }
{ENDIF}				{/* printf("Text: %s \n",yytext);*/  return Token_ENDIF; }
{ENDWHILE}			{/* printf("Text: %s \n",yytext);*/  return Token_ENDWHILE; }
{WHILE}				{/* printf("Text: %s \n",yytext);*/  return Token_WHILE; }
{LOOP}				{/* printf("Text: %s \n",yytext);*/  return Token_LOOP; }
{PROGRAM}			{/* printf("Text: %s \n",yytext);*/  return Token_PROGRAM; }
{VAR}				{/* printf("Text: %s \n",yytext);*/  return Token_VAR; }
{INT}				{/* printf("Text: %s \n",yytext);*/  return Token_INT; }
{WRITEINT}			{/* printf("Text: %s \n",yytext);*/  return Token_WRITEINT; }
{READINT}			{/* printf("Text: %s \n",yytext);*/   return Token_READINT; }
{NUM}				{/* printf("Text: %s \n",yytext);*/ yylval.num=atoi(yytext); return Token_NUM; }
{IDENT}				{/* printf("Text: %s \n",yytext);*/ strcpy(yylval.str ,yytext); return Token_IDENT; }
.                   	printf("unexpected token %s\n",yytext);
