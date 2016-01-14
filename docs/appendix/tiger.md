# Tiger 语言参考手册

原文作者：Prof. Stephen A. Edwards，哥伦比亚大学

原文文档：国内可以在上海交大的[课程网站](http://bcmi.sjtu.edu.cn/~mli/tiger/)中取得[电子版](http://bcmi.sjtu.edu.cn/~mli/tiger/Res/tiger.pdf)（pdf，56kb）

译文：[@Yufei Li](http://blog.thxminds.com) 2016年1月13日译于上海

译文协议：[CC By 4.0](http://creativecommons.org/licenses/by/4.0/deed.zh)

这个文档描述了 Andrew Appel 的书 《Modern Compiler Implementation in Java》(Cam-bridge University Press, 1998) 中对于 Tiger 语言的定义。

Tiger 语言是一个小巧精致的、带有整型和字符串变量，数组，记录和嵌套函数的语言。其语法类似于一些函数式语言。

## 1 词法部分

一个 *identifier* 是一系列字母、数字和下划线组成的，并以一个字母开头，大小写敏感。

空白（空格，制表符，换行，回车，换页）或者注释可能出现在标识符之间，并被忽略。一段注释以 `/*` 开始并以 `*/` 结尾。注释可以嵌套。

一个整型常量由一个或更多数字的序列构成（比如，0123456789），没有负整数常量。负数可以使用一元操作符 `-` 对整数取负得到。

一个字符串常量是由一对 `"` 括起来的零个或更多个可打印字符、回车或转义字符组成。每一个转义字符由一个反斜杠 `\` 开始，并且跟着一些字符序列，这些转义序列是：

* `\n`，换行
* `\t`，制表符
* `\"`，双引号
* `\\`，反斜杠
* `\^c`，`Control-c`，*c* 可以是 *@A…Z[\]^_* 中的一个
* `\ddd`，ASCII码 *ddd* 表示的字符（三个数字）
* `\...\`，任何被 `\s` 包围的空白字符（空格，制表符，换行，回车，换页）序列都被忽略。这允许字符串常量通过以一个起始和结束反斜杠跨越多行。

保留字是，`array` `break` `do` `else` `end` `for` `function` `if` `in` `let` `nil` `of` `then` `to` `type` `var` `while`。

标点符号是，`,` `:` `;` `(` `)` `[` `]` `{` `}` `.` `+` `-` `*` `/` `=` `<>` `<` `<=` `>` `>=` `&` `|` `:=`

## 2 表达式

一个 Tiger 程序是一个单一的表达式。

---

*expr* :

​	*string-constant*

​	*integer-constant*

​	**nil**

​	*lvalue*

​	- *expr*

​	*expr* *binary-operator* *expr*

​	*lvalue* := *expr*

​	*id* ( $$expr-list_{opt}$$ )

​	( $$expr-seq_{opt}$$ )

​	*type-id* { $$field-list_{opt}$$ }

​	*type-id* [ *expr* ] **of** *expr*

​	**if** *expr* **then** *expr*

​	**if** *expr* **then** *expr* **else** *expr*

​	**while** *expr* **do** *expr*

​	**for** *id* := *expr* **to** *expr* **do** *expr*

​	**break**

​	**let** *declaration-list* **in** $$expr-seq_{opt}$$ **end**

---

*expr-seq* :

​	*expr*

​	*expr-seq* : *expr*

---

*expr-list* :

​	*expr*

​	*expr-list* , *expr*

---

*field-list* :

​	*id* = *expr*

​	*field-list* , *id* = *expr*

### 2.1 左值

---

*lvalue* :

​	*id*

​	*lvalue* . *id*

​	*lvalue* [ *expr* ]

一个左值表示一块可被赋值的存储区域：变量、参数、记录的字段和数组的元素。一个大小为 n 的数组元素索引为 0，1，… ，n - 1。

### 2.2 返回值

过程调用，赋值，`if-then`，`while`，`break` 和有时 `if-then-else` …… （此处有疑问，暂不译）

一个 `let` 表达式在 `in` 和 `end` 之间什么都没有时，会返回无值。

在圆括号里的零个或更多用逗号分隔的表达式组成的序列（比如，`(a :=3; b := a)` ）会按顺序求值，并且返回最后一个表达式得出的值，如果有的话。一对空的圆括号 `()` 是合法的并且没有返回值。

### 2.3 记录和数组常量

表达式 *type-id* { $$field-list_{opt}$$ } （允许零个或更多字段）创建一个类型为 *type-id* 的新记录实例。字段名，表达式类型和它们的顺序必须明确地与给定的记录类型匹配。（暂时尚不理解）

表达式 *type-id* [ *expr* ] **of** *expr* 创建一个类型为 *type-id* 的新数组。
