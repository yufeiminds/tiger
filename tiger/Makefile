#
# Copyright 2016 Yufei Li
#

help:
	@echo "compile 	编译生成Parser"
	@echo "debug  	调试词法分析程序"

compile:
	bison -d tiger.ypp
	flex tiger.lex
	g++ -o tiger tiger.tab.cpp lex.yy.c

debug:
	bison -d debug.ypp
	flex tiger.lex
	g++ -o tiger debug.tab.cpp lex.yy.c