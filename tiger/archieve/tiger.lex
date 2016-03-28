/*
 * Copyright 2016 Yufei Li
 */

%{
#include "stdlib.h"
#include "string.h"
#include <iostream>
#include <string>
#include "tiger.tab.hpp"

int nested_comment = 0;
int check_type();
char *get_text();
void echo_debug(void)
{
    fwrite(yytext, yyleng, 1, yyout);
    std::cout << std::endl;
}

#ifndef ADJUST
#define ADJUST echo_debug()
#endif
%}

%option noyywrap

/*
 * Token syntax rules [Regular Expression]
 */

whitespaces     [ \t\n\r]
id              [a-zA-Z][a-zA-Z0-9_]*
integer         [0-9]+
string          "\""[^"]*"\""

%x COMMENT
%%

"/*"            { BEGIN COMMENT; nested_comment += 1;         }
<COMMENT>{
    "/*"        { nested_comment += 1;                        }
    "*/"        { if (-- nested_comment == 0) BEGIN INITIAL;  }
    .           { /* eat the block comments */                }
}
"//"[^\n]*      { /* eat the inline comment */  }

"+"             { ADJUST; return ADD; }
"-"             { ADJUST; return SUB; }
"*"             { ADJUST; return MUL; }
"/"             { ADJUST; return DIV; }
"="             { ADJUST; return EQ;  }
"<>"            { ADJUST; return NEQ; }
">"             { ADJUST; return GT;  }
"<"             { ADJUST; return LT;  }
">="            { ADJUST; return GT_EQ;     }
"<="            { ADJUST; return LT_EQ;     }
"&"             { ADJUST; return AND; }
"|"             { ADJUST; return OR;  }

":="            { ADJUST; return ASSIGN;    }
"."             { ADJUST; return DOT; }

"nil"           { ADJUST; return NIL; }
"if"            { ADJUST; return IF;  }
"then"          { ADJUST; return THEN;      }
"else"          { ADJUST; return ELSE;      }
"while"         { ADJUST; return WHILE;     }
"do"            { ADJUST; return DO;  }
"for"           { ADJUST; return FOR; }
"to"            { ADJUST; return TO;  }
"break"         { ADJUST; return BREAK;     }
"let"           { ADJUST; return LET; }
"var"           { ADJUST; return VAR; }
"type"          { ADJUST; return TYPE;      }
"in"            { ADJUST; return IN;  }
"end"           { ADJUST; return END; }
"function"      { ADJUST; return FUNCTION;  }
"of"            { ADJUST; return OF;  }
"array"         { ADJUST; return ARRAY;     }

","             { ADJUST; return COMMA;     }
";"             { ADJUST; return SEMICOLON; }
":"             { ADJUST; return COLON;     }

"("             { ADJUST; return LPAREN;    }
")"             { ADJUST; return RPAREN;    }
"["             { ADJUST; return LBRACK;    }
"]"             { ADJUST; return RBRACK;    }
"{"             { ADJUST; return LBRACE;    }
"}"             { ADJUST; return RBRACE;    }

{whitespaces}   { /* Ignored */     }
<<EOF>>         { exit(0); }

{id}            { return check_type();   }
{string}        { std::cout << "String: "; ADJUST; yylval.sval = get_text(); return STRING_CONSTANT;        }
{integer}       { std::cout << "Integer: "; ADJUST; yylval.ival = atoi(yytext); return INTEGER_CONSTANT;    }
.               { std::cout << "Lex Error. "; ECHO; std::cout << "Line No.: " << yylineno << std::endl;  }

%%

/*
 * Addition code.
 */

int check_type() {
    /*
    if (std::string(yytext) == "int") {
        std::cout << "type int" << std::endl;
        return INT;
    }
    else if (std::string(yytext) == "string") {
        std::cout << "type string" << std::endl;
        return STRING;
    }
    */
    std::cout << "ID: " << yytext << std::endl;
    return ID;
}

char *get_text() {
    char * s = (char *) malloc(yyleng + 1);
    strncpy(s, yytext, yyleng);
    return s;
}
