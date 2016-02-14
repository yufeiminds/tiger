# Tiger 语言参考手册

原文作者：Prof. Stephen A. Edwards，哥伦比亚大学

原文文档：国内可以在上海交大的[课程网站](http://bcmi.sjtu.edu.cn/~mli/tiger/)中取得[电子版](http://bcmi.sjtu.edu.cn/~mli/tiger/Res/tiger.pdf)（pdf，56kb）

译文：[@Yufei Li](http://blog.thxminds.com) 2016年1月13日译于上海

译文协议：[CC By 4.0](http://creativecommons.org/licenses/by/4.0/deed.zh)

PS: 很少翻译文献，错漏之处，请见谅。该手册仅供参考（快速阅览），学术研究请参阅原文。

排版约定：加粗的是Token，斜体是Grammar，带有下标的使用Latex公式排版。

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

过程调用，赋值，`if-then`，`while`，`break` 以及有时 `if-then-else` 返回无，并且当期望某值时它并没有返回值（比如，`(a := b) + c` 是不合法的）。

一个 `let` 表达式在 `in` 和 `end` 之间什么都没有时，会返回无。

在圆括号里的零个或更多用逗号分隔的表达式组成的序列（比如，`(a :=3; b := a)` ）会按顺序求值，并且返回最后一个表达式得出的值，如果有的话。一对空的圆括号 `()` 是合法的并且返回无。

### 2.3 记录和数组字面值

表达式 *type-id* { $$field-list_{opt}$$ } （允许零个或更多字段）创建一个类型为 *type-id* 的新记录实例。字段名，表达式类型和它们的顺序必须明确地与给定的记录类型匹配。（有歧义）

表达式 *type-id* [ *expr* ] **of** *expr* 创建一个类型为 *type-id* ，大小为括号里给定表达式大小的新数组。初始化时，该数组被 **of** 后给定表达式的值填充。上述两个表达式按照它们出现的顺序被求值。

### 2.4 函数调用

一个函数调用是一个带有零个或更多逗号分隔的表达式参数的表达式 *id* ( $$expr-list_{opt}$$ )。当一个函数被调用时，实参被从左到右求值，并使用常见的静态作用域规则绑定到函数的形参上。

### 2.5 操作符

二元操作符是 `+` `-` `*` `/` `=` `<>` `<` `>` `<=` `>=` `&` `|` 。

圆括号表达式和一般情况一样。

打头的减号表示负整数表达式。

二元操作符 `+` ，`-` ，`*` ，`/` 需要一个整型操作数并且返回一个整数结果。

二元操作符 `>` ，`<` ，`>=` ，`<=` 比较它们的操作数，而且他们或者都是整型，或者都是字符串，如果比较结果符合就返回整数1，否则返回0。字符串的比较结果取决于标准ASCII词典顺序。

二元操作符 `=` 和 `<>` 可以比较任意两个相同类型的操作数，并且返回整数0或1。整数取决于他们是否有相同的值。字符串取决于它们包含的字符是否相同。两个类型是记录的对象取决于它们是否是同一个记录的引用。

逻辑运算符 `&` 和 `|` 是对于整数惰性求值的逻辑运算符，如果算得左侧的值有效，那么它们就不计算右面的操作数。`0`按照`false`来考虑。其它的都被认为是`true`。

一元的负号有最高的优先级，随后是 `*` 和 `/` ，然后是 `+` 和 `-` ，然后是 `=` ，`<>` ，`<` ，`>` ，`<=` 和 `>=` ，然后是 `&` ，然后是 `|` ，最后是 `:=` 。

运算符 `+` ，`-` ，`*` ，`/` 是左结合的。比较运算符没有结合性。比如，`a=b=c` 是错误的，但 `a=(b=c)` 是合法的。

### 2.6 赋值

赋值表达式 `lvalue := expr` 计算表达式然后绑定它的值到左值上。赋值表达式不产生值，所以像 `a := b := 1` 是非法的。

数组和记录赋值是通过引用而非值。赋值一个数组或者记录到一个变量时，会创建一个绑定。这意味着稍后对于这个变量或者值的改变会给所有地方带来影响。将一个数组或者记录作为函数实参来传递，其行为也是类似的。

一个记录或者数组从程序开始到终结持续存在着，即使已经离开其定义的控制范围。

### 2.7 *nil*

表达式 nil 表示一个可以复制给任何记录类型的值，从一个值为 nil 的记录中访问一个字段，是一个运行时错误。Nil 必须被用于一个确定的记录类型的上下文中，像下面这样是合法的。

``` javascript
var a : rec := nil 		a := nil
if a <> nil then ... 	if a = nil then ...
function f(p : rec) = f(nil)
```

但这些是非法的，

``` javascript
var a := nil 			if nil = nil then ...
```

### 2.8 流程控制

`if-then-else` 表达式，被写成 **if** *expr* **then** *expr* **else** *expr*，第一个表达式求值必须返回一个整数。如果结果是非零的，第二个表达式被求值并变成这个值，第三个也是一样。因此，第二个和第三个表达式必须是相同类型的，或者都没有返回值。

`if-then` 表达式，**if** *expr* **then** *expr* 计算它的第一个表达式，它必须是整数，如果结果是非零值，它计算第二个表达式，必须不返回值。

`while-do` 表达式，**while** *expr* **do** *expr* 计算它的第一个表达式，它必须返回一个整数，如果它是非零值，第二个表达式会被计算，它必须不返回值，并且 `while-do` 表达式被再次计算。

`for` 表达式，**for** *id* := *expr* **to** *expr* **do** *expr* ，计算第一个和第二个表达式，它是循环边界，然后对于这两个表达式之间的每一个整数（包括），第三个表达式使用绑定到循环索引上的名为 *id* 的变量来求值。这个变量的作用域被限定到第三个表达式中，并且不可被赋值。这个表达式将不会生成一个值，并且如果循环超出或低于其界限时，将不会被执行。

`break` 表达式终止`while` 或 `for` 表达式最内层，在同一函数/过程中的表达式。`break` 在（`while`，`for`）外面也是合法的。

### 2.9 Let

表达式 **let** *declaration-list* **in** $$expr-seq_{opt}$$ **end** 计算声明，绑定类型，变量，函数，到 $$expr-seq_{opt}$$ 范围内，它是一个由零个或更多分号分隔的表达式。返回值是最后一个表达式，或者是none的时候不返回值。

## 3 声明

*declaration-list* :

​	*declaration*

​	*declaration-list* *declaration*

*declaration* :

​	*type-declaration*

​	*variable-declaration*

​	*function-declaration*

### 3.1 Types

*type-declaration* :

​	**type** *type-id* = *type*

*type* :

​	*type-id*

​	{ $$type-fields_{opt}$$ }

​	**array** **of** *type-id*

*type-fields* :

​	*type-field*

​	*type-fields* , *type-field*

*type-field* :

​	*id* : *type-id*

Tiger 有两个预定一类型：int 和 string。像下面这样，新类型可以被定义，已存在的类型被重定义。

有三种 **type** 的引用形式（在声明中创建一个别名），带有名字的记录，有类型的字段（像是一个C的结构体，不同的记录会重用这些字段名），和一个数组。

多个类型表达式（比如，`{x:int}`，`array of ty`）创建不同的类型，所以元素类型相同的两个数组或者字段相同的两个记录是不同的。类型 `a=b` 是一个别名。

类型声明（换句话说，中间没有变量或函数声明）的顺序可能是相互递归。在这样的序列没有两个定义的类型可具有相同的名称。每个递归循环必须传递一个记录或数组类型。

在 **let** … *type-declaration* … **in** $$expr-seq_{opt}$$ **end** 中，类型声明的作用域起始于它所属的类型声明序列（可能只有单个声明）的开始，并且在 **end** 处结束。

类型名有它们自己的命名空间。

### 3.2 变量

*variable-declaration* :

​	**var** *id* := *expr*

​	**var** *id* : *type-id* := *expr*

这是声明一个变量和它的初始值。如果这个类型是未指定的，变量类型从 *expr* 中得到。

在 **let** … *variable-declaration* … **in** $$expr-seq_{opt}$$ **end**，变量声明的作用域就是从声明之后开始到 **end** 截止。一个变量持续贯穿于整个作用域。

变量和函数共享其命名空间。

### 3.3 函数

*function-declaration* :

​	**function** *id* ( $$type-fields_{opt}$$ ) = *expr*

​	**function** *id* ( $$type-fields_{opt}$$ ) : *type-id* = *expr*

第一种形式是一个过程定义，第二个是一个函数定义。函数返回一个特定类型的值；过程仅仅为了它们的作用而被调用。所有的形式都允许指定由零个或多个带有类型的参数组成的一个列表，它们是按值传递的。参数的作用域是 *expr* 中。

*expr* 是函数和过程的主体。

一个函数声明的序列（换言之，其中没有变量和类型声明）可能是相互递归的。在这个序列中不可能有两个函数有相同的名字。

在 **let** … *function-declaration* … **in** $$expr-seq_{opt}$$ **end**，函数声明的作用域起始于它所属的函数声明序列（可能只有单个声明）的开始，并且在 **end** 处结束。

## 4 标准库

``` javascript
function print(s : string)
	打印字符串到标准输出。
function printi(i : int)
	打印整数到标准输出。
function flush()
	刷新标准输出缓冲区。
function getchar() : string
	从标准输入读取并返回一个字符；如果字符串在EOF处，返回一个空字符串。
function ord(s : string) : int
	返回 s 第一个字符的 ASCII 值，或者如果 s 为空则返回 -1。
function chr(i : int) : string
	返回 ACSII 值 i 对应的一个单字符，如果 i 超过范围则终止程序。
function size(s : string) : int
	返回 s 中的字符数。
function substring(s : string, f : int, n : int) : string
	返回以第f个字符(首字符记为第0个)开始，连续n个字符的子串。
function concat(s1 : string, s2 : string) : string
	返回一个由 s1 后面跟着 s2 构造的新的字符串。
function not(i : int) : int
	如果 i 是0则返回1，反之则返回0。
function exit(i : int)
	用错误码 i 终止执行程序。
```

## 5 例子

``` pascal
let 	/* Appel 的八皇后问题解法 */
	var N := 8
    type intArray = array of int
    var row := intArray [ N ] of 0
    var col := intArray [ N ] of 0
    var diag1 := intArray [ N+N-1 ] of 0
    var diag2 := intArray [ N+N-1 ] of 0
    
    function printboard() = 
    (
    	for i := 0 to N - 1
        do (
        	for j := 0 to N - 1
            do print(if col[i] = j then " 0" else " .");
            print("\n")
        );
        print("\n")
    )
    
    function try(c : int) =
      	if c = N then printboard()
        else 
          	for r := 0 to N - 1
        	do
              	if row[r] = 0 &
                   diag1[r+c] = 0 &
                   diag2[r+7-c] = 0
                then (
                  	row[r] := 1;
                  	diag1[r+c] := 1;
                  	diag2[r+7-c] := 1;
                  	col[c] := r;
                    try(c+1);
                    row[r] := 0;
                    diag1[r+c] := 0;
                    diag2[r+7-c] := 0
                )
in
	try(0)
end
```