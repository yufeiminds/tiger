#include <stdio.h>
#include "util.h"
#include "absyn.h"
#include "prabsyn.h"
#include "errormsg.h"

extern int yyparse(void);
extern A_exp absyn_root;

void parse(string fname)
{EM_reset(fname);
 if (yyparse() == 0) /* parsing worked */
   fprintf(stdout,"Parsing successful!\n");
 else fprintf(stdout,"Parsing failed\n");
}


int main(int argc, char **argv) {
 if (argc!=2) {fprintf(stderr,"usage: a.out filename\n"); exit(1);}
 parse(argv[1]);
 pr_exp(stdout, absyn_root, 4);
 return 0;
}
