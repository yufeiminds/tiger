%{
#include <string.h>
#include "util.h"
#include "absyn.h"
#include "y.tab.h"
#include "errormsg.h"

int charPos = 1;
int nested_comment = 0;

int yywrap(void)
{
 charPos = 1;
 return 1;
}


void adjust(void)
{
 EM_tokPos = charPos;
 charPos += yyleng;
}

%}

/*
 * All Options
 *
 *   ...
 *
 */


/* Predefined Rules */
whitespaces     [ \t\n\r]
id              [a-zA-Z][a-zA-Z0-9_]*
integer         [0-9]+
string          "\""[^"]*"\""

/* Automaton Status */
%x COMMENT

%%

"/*"            { BEGIN COMMENT; nested_comment += 1;         }
<COMMENT>{
    "/*"        { nested_comment += 1;                        }
    "*/"        { if (-- nested_comment == 0) BEGIN INITIAL;  }
    .           { /* eat the block comments */                }
}
"//"[^\n]*      { /* eat the inline comment */  }

"+"             { adjust(); return ADD; }
"-"             { adjust(); return SUB; }
"*"             { adjust(); return MUL; }
"/"             { adjust(); return DIV; }
"="             { adjust(); return EQ;  }
"<>"            { adjust(); return NEQ; }
">"             { adjust(); return GT;  }
"<"             { adjust(); return LT;  }
">="            { adjust(); return GT_EQ;     }
"<="            { adjust(); return LT_EQ;     }
"&"             { adjust(); return AND; }
"|"             { adjust(); return OR;  }

":="            { adjust(); return ASSIGN;    }
"."             { adjust(); return DOT; }

"nil"           { adjust(); return NIL; }
"if"            { adjust(); return IF;  }
"then"          { adjust(); return THEN;      }
"else"          { adjust(); return ELSE;      }
"while"         { adjust(); return WHILE;     }
"do"            { adjust(); return DO;  }
"for"           { adjust(); return FOR; }
"to"            { adjust(); return TO;  }
"break"         { adjust(); return BREAK;     }
"let"           { adjust(); return LET; }
"var"           { adjust(); return VAR; }
"type"          { adjust(); return TYPE;      }
"in"            { adjust(); return IN;  }
"end"           { adjust(); return END; }
"function"      { adjust(); return FUNCTION;  }
"of"            { adjust(); return OF;  }
"array"         { adjust(); return ARRAY;     }

","             { adjust(); return COMMA;     }
";"             { adjust(); return SEMICOLON; }
":"             { adjust(); return COLON;     }

"("             { adjust(); return LPAREN;    }
")"             { adjust(); return RPAREN;    }
"["             { adjust(); return LBRACK;    }
"]"             { adjust(); return RBRACK;    }
"{"             { adjust(); return LBRACE;    }
"}"             { adjust(); return RBRACE;    }

{whitespaces}   { adjust(); /* Ignored */     }

{id}            { adjust(); yylval.sval = String(yytext); return ID;   }
{string}        { adjust(); yylval.sval = String(yytext); return STRING;     }
{integer}       { adjust(); yylval.ival = atoi(yytext); return INT;      }
.               { adjust(); EM_error(EM_tokPos,"illegal token");  }
