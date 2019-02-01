%{

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

void push();
char* pop();
char* gen_label();
void yyerror();

char temp1[20];
char temp2[20];
char label_stack[20][90];
int stackPointer = 0;
extern int yylineno;

%}

%union{
	char str[60];
	int num;
}

%token <num>Token_NUM
%token <str>Token_IDENT
%token Token_LP
%token Token_RP
%token Token_ASGN
%token Token_SC
%token Token_COLON
%token Token_POWER
%token Token_MULTIPLY
%token Token_DIVIDE
%token Token_MOD
%token Token_ADD
%token Token_SUB
%token Token_EQUAL
%token Token_NOTEQUAL
%token Token_LESSTHAN
%token Token_GREATERTHAN
%token Token_LESSEQUAL
%token Token_GREATEREQUAL
%token Token_IF
%token Token_THEN
%token Token_ELSE
%token Token_BEGIN
%token Token_END
%token Token_ENDIF
%token Token_ENDWHILE
%token Token_WHILE
%token Token_LOOP
%token Token_PROGRAM
%token Token_VAR
%token Token_INT
%token Token_WRITEINT
%token Token_READINT
%token Token_COMMENT

%%

//productions

program			: Token_PROGRAM { printf("Section\t.data\n"); } 
				declarations Token_BEGIN { printf("Section\t.code\n"); } 
				statementSequence Token_END { printf("HALT\n");}
				;

declarations	:  Token_VAR Token_IDENT Token_COLON { printf("%s:\t",$2);} type Token_SC declarations
				|
				;

type 			:  Token_INT { printf("word\n");}
				;

statementSequence 	: statement Token_SC statementSequence
				|
				;

statement		: assignment
				| ifStatement
				| whileStatement
				| writeInt
				;

assignment		: Token_IDENT Token_ASGN {printf("LVALUE \t%s\n", $1);}
					expression {printf("STO\n");}
				| Token_IDENT Token_ASGN Token_READINT
					{printf("LVALUE \t%s\nREADINT\nSTO\n", $1);}
				;

ifStatement		: Token_IF expression Token_THEN
				{printf("GOFALSE \t%s\n", gen_label());}
				statementSequence elseClause Token_ENDIF
				{printf("LABEL \t%s\n", pop());}
				;

elseClause		: Token_ELSE
				{
				strcpy(temp1, pop()); // goFalse (in ifStatement) Label
				printf("GOTO \t%s\n", gen_label());
				printf("LABEL \t%s\n", temp1);
				}
				statementSequence
				|
				;

whileStatement		: Token_WHILE { printf("LABEL \t%s\n", gen_label()); }
				expression Token_LOOP
				{ printf("GOFALSE %s\n", gen_label()); }
				statementSequence Token_ENDWHILE
				{
					strcpy(temp1, pop()); // goFalse Label
					strcpy(temp2, pop()); // while Label
					printf("GOTO \t%s\n", temp2); // goto while label
					printf("LABEL \t%s\n", temp1);
				}
				;

writeInt 		: Token_WRITEINT expression {printf("PRINT\n");}
				;

expression		: simpleExpression
				| simpleExpression Token_EQUAL expression { printf("EQ\n");}
				| simpleExpression Token_NOTEQUAL expression { printf("NE\n");}
				| simpleExpression Token_LESSTHAN expression { printf("LT\n");}
				| simpleExpression Token_GREATERTHAN expression { printf("GT\n");}
				| simpleExpression Token_LESSEQUAL expression { printf("LE\n");}
				| simpleExpression Token_GREATEREQUAL expression { printf("GE\n");}
				;


simpleExpression	: term Token_ADD simpleExpression { printf("ADD\n");}
				| term Token_SUB simpleExpression { printf("SUB\n");}
				| term
				;

term			: factor Token_MULTIPLY term { printf("MPY\n");}
				| factor Token_DIVIDE term { printf("DIV\n");}
				| factor Token_MOD term { printf("MOD\n");}
				| factor
				;

factor			: primary Token_POWER factor { printf("POW\n");}
				| primary
				;

primary			: Token_IDENT  { printf("RVALUE %s\n", $1); }
				| Token_NUM { printf("PUSH %d\n", $1);}
				| Token_LP expression Token_RP
				;

%%

void yyerror(char *s) {

	fprintf(stderr, "ERROR: %s (line: %d)\n", s, yylineno);
}

char* gen_label() {

	static int i = 0;
	char *temp = malloc(5);
    	sprintf(temp,"%04d",i++);
	push(temp);
	return temp;
}

void push(char* s) {

	if(stackPointer < 30)
	{
		strcpy(label_stack[stackPointer], s);
		stackPointer++;
	}
}

char* pop() {

	if(stackPointer > 0)
	{
       	stackPointer--;
		return label_stack[stackPointer];
   	}
	return NULL;
}

void main() {

	yyparse();
}
