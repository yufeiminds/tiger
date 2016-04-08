a.out: parsetest.o y.tab.o lex.yy.o errormsg.o util.o absyn.o symbol.o table.o prabsyn.o
	cc -g parsetest.o y.tab.o lex.yy.o errormsg.o util.o absyn.o symbol.o table.o prabsyn.o

parsetest.o: parsetest.c errormsg.h util.h
	cc -g -c parsetest.c

y.tab.o: y.tab.c
	cc -g -c y.tab.c

y.tab.c: tiger.grm
	bison -dv tiger.grm -o y.tab.c

y.tab.h: y.tab.c
	echo "y.tab.h was created at the same time as y.tab.c"

errormsg.o: errormsg.c errormsg.h util.h
	cc -g -c errormsg.c

lex.yy.o: lex.yy.c y.tab.h errormsg.h util.h
	cc -g -c lex.yy.c

lex.yy.c: tiger.lex
	flex tiger.lex

util.o: util.c util.h
	cc -g -c util.c

absyn.o: absyn.c absyn.h
	cc -g -c absyn.c

symbol.o: symbol.c symbol.h
	cc -g -c symbol.c

table.o: table.c table.h
	cc -g -c table.c

prabsyn.o: prabsyn.c prabsyn.h
	cc -g -c prabsyn.c

clean:
	rm -f a.out util.o parsetest.o lex.yy.o errormsg.o y.tab.c y.tab.h y.tab.o lex.yy.c tiger.tab.grm tiger.output y.output
