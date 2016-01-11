# 周报脚本

在根目录的 `tools` 子文件夹下有一个 `report.py`，用于调用 Github API，生成每周的代码提交记录报告。

```python
python report.py # 生成 HTML 格式报告
python report.py -f pdf # 生成 PDF 格式报告
```

上述命令会在 build 目录下生成以当前日期为文件名的文档文件，文件名格式为 `%F` 或 `%Y-%m-%d`，比如

* `2016-1-10.html`
* `2016-1-10.pdf`

---

**TODOS**

1. 定时发送