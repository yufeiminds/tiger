# 语法分析

语法分析（Parsing）主要是根据给定的文法（Grammer）对源程序做一些分析。

这里选取的还是 [Gnu Project](https://www.gnu.org/) 下的 [Bison](https://www.gnu.org/software/bison/) 工具来构造我们的 Parser。

文法描述的手册可以从这里下载：[中文](http://blog.thxminds.com/tiger/appendix/tiger.html)（html），[英文](http://bcmi.sjtu.edu.cn/~mli/tiger/Res/tiger.pdf)（pdf，56kb）

目前还是没有直接的证据（文档）表明，Bison 支持 EBNF，所以按照书中的说法，对于文法中可选的部分，我们要先将手册中的 Grammar 扩展成形如

$$
expr\text{-}list_{opt} \rightarrow \epsilon \mid expr\text{-}list
$$

的文法。至于左递归，Bison的[文档](https://www.gnu.org/software/bison/manual/bison.pdf)上说它采用了LALR算法来做Parsing，这个还没仔细看，但原理上还是基于LR的，所以不用消除左递归。

另外网上说LALR偏向于使用左递归，原理也需要看完这一章之后验证一下才是。

正在从LL(1)看起，当前写的文法有歧义，正在看书弄明白这个歧义的解决办法。

继续看书，写代码......[音乐1](http://www.xiami.com/collect/41014165)

## 参考资料

* [Tiger 语言参考手册](http://bcmi.sjtu.edu.cn/~mli/tiger/Res/tiger.pdf)