/*
 * Copyright 2016 Yufei Li
 */

%{
#include <iostream>
#include "tiger.tab.hpp"
%}

%option noyywrap


/*
 * Token syntax rules [Regular Expression]
 */
%%

"/*"            { /* comment(); */ };
"//"[^\n]*      { /* eat the inline comment */ }


"nil"           { ECHO; return NIL; }
"if"            { ECHO; return IF; }
"then"          { ECHO; return THEN; }
"else"          { ECHO; return ELSE; }
"while"         { ECHO; return WHILE; }
"do"            { ECHO; return DO; }
"for"           { ECHO; return FOR; }
"to"            { ECHO; return TO; }
"break"         { ECHO; return BREAK; }
"let"           { ECHO; return LET; }
"in"            { ECHO; return IN; }
"end"           { ECHO; return END; }
"function"      { ECHO; return FUNCTION; }
"of"            { ECHO; return OF; }
"array"         { ECHO; return ARRAY; }

[a-zA-Z][a-zA-Z0-9_]*   { std::cout << "ID: "; ECHO; return ID; }
.                       { std::cout << "Others." << std::endl; }

%%

/*
 * Addition code.
 */
