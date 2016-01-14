# Gitbook 文档构建

## Gitbook

* [Gitbook 主页][Gitbook]
* [Gitbook 工作方式](https://help.gitbook.com/)
* [Gitbook 的一篇中文指南](http://wanqingwong.com/gitbook-zh/)
* [关于 Git 的一篇中文指南](https://kingofamani.gitbooks.io/git-teach/content/chapter_6_gitbook/chapter_6_gitbookgitbook2.html)

## 编辑文档

Tiger 根目录下，有一个 `docs` 目录，按照约定放置文档（Markdown格式的文件）。

安装好 [Gitbook][Gitbook] 后，在 `docs` 文件夹下运行

``` shell
gitbook serve
```

即可启动本地调试服务器，此时再用你喜欢的编辑器编辑Markdown文档即可看到浏览器中文档的变化。

## 发布文档

文档存储在 [gh-pages][gh-pages] 上，使用 [ghp-import][ghp-import] 工具发布。

安装好 [ghp-import][ghp-import] ，在 `docs` 文件夹下运行

``` shell
gitbook build
```

命令生成文档目录（默认是 `_book`）后，执行

``` shell
ghp-import _book -p -n -b gh-pages
```

发布文档网站到 [这里](https://yufeiminds.github.io/tiger)

[Gitbook]: https://www.gitbook.com/	"Gitbook website"
[gh-pages]: https://pages.github.com/	"Github pages"
[ghp-import]: https://github.com/davisp/ghp-import	"GHP import tools"

**TODOS**

1. 用CI的脚本跑自动文档