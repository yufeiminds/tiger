# Lex/Flex

Lex是一个词法分析器，Flex是 *Unix* 环境中用来替代 Lex 的词法分析工具，跟 Lex/Yacc 这一对好搭档一样，Flex/Bison 也是一对完美伙伴。

## 参考

词法分析相关的理论知识请参阅 [词法分析概念](../academic/lex.html)。

虎书第二章也有相关的[分析和样例](http://book.douban.com/subject/1886911/)（包括Lex的写法）

## Flex 语法

假设你已经阅读完上述两章内容，那么试看下面对于Flex工具的总结。

### Token

对于文件中的每一个字符串，我们都可以将其识别为一个Token，在Flex的实现中，这个Token是一个整数，它可以是整数的枚举类型，

``` c++
enum yytokentype {
     STRING_CONSTANT = 258,
     INTEGER_CONSTANT = 259,
     NIL = 260,
}
```

或者一个整数宏，

``` c++
/* Tokens.  */
#define STRING_CONSTANT 258
#define INTEGER_CONSTANT 259
#define NIL 260
```

### Flex

一个 Lex 文件分为三个部分，用 `%%` 分隔。

``` c++
%{
    /* 这段代码会被插入到生成代码中 */
%}

%option noyywrap        // 配置选项

whitespace  [ \t\n\r]   // 预定义正则

%x COMMENT              // 定义有限自动机的状态

%%

/* 正则有限状态机 */
"+"             { }     // 完全匹配
{whitespace}    { }     // 使用预定义正则
[0-9]+          { }     // 手写正则

/* 手写有限状态机 */
"/*"            { BEGIN COMMENT;    }               // 开始一个有限状态机
<COMMENT>"*/"   { BEGIN INITIAL;    }               // 切换到另一个有限状态机(起始态)
<COMMENT>.      { /* eat the block comments */  }   // 吞掉注释

%%

/*
 * 这里的代码会被插入到生成代码的最后面
 */
```

所有的 Token 都会被一个有限状态机来识别，它们遵守如下几个原则：

**最大匹配**，一个规则会匹配（吞掉）所有它可以匹配的字符，直到无法匹配为止。

**顺序匹配**，Lex 会按顺序用这些规则来匹配当前字符，规则写在前面的会优先匹配。

``` c++
.*				{}		// 匹配所有的字符
[0-9]+			{}		// 那么这条规则就没用了，因为上一条规则已经把所有字符都吞掉了
```

### 生成代码

在 Flex 的生成代码中，有许多可能会用到的变量、函数或者宏，比如，

| 变量             | 描述                                       | 类型/签名                                    |
| -------------- | ---------------------------------------- | ---------------------------------------- |
| yytext         | 当前匹配的文本                                  | `char *`                                 |
| yyleng         | 当前匹配的文本长度                                | `yy_size_t (size_t)`                     |
| yylineno       | 行号                                       | `int`                                    |
| ECHO           | 写入 `yytext` 到 `yyout` （`yyout` 默认值是 `stdout`） | 无参数宏                                     |
| YY_FATAL_ERROR | 打印错误信息，重定向至 `yy_fatal_error`             | `static void yy_fatal_error (yyconst char* msg )` |
| yyterminate    | 正确使用方法是 `yyterminate();`，表示词法分析已结束，终止扫描。在文件尾也会自动被调用。 | `#define yyterminate() return YY_NULL`   |
| yylex          | 启动词法分析程序                                 | 无参数函数                                    |

## 一些小技巧

类型......

错误信息......

仍在琢磨中......