#
# Copyright 2016 Yufei Li
#

help:
	@echo "compile 	编译生成Parser"

compile:
	bison -d tiger.ypp
	flex tiger.lex
	g++ -o tiger tiger.tab.cpp lex.yy.c
