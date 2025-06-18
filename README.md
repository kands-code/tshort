# 一份（不太）简短的 Typst 介绍

这份文档算是 [lshort-zh-cn](https://github.com/CTeX-org/lshort-zh-cn) 的 Typst 移植版，
文档的大部分内容是模仿 lshort 的方式编写，在部分地方调整为对应的 Typst 内容，
并且对于常见的排版问题做了一定的补充说明。

## 许可证

This document is licensed under the [**GNU Free Documentation License, Version 1.3**](LICENSE).
For detailed information, please refer to the section titled "GNU Free Documentation License" in this document,
or consult the source file `license.typ`.

## 生成文档前的准备

安装最新版本的 Typst 工具，或者更新 Typst 到最新版本。

## 生成方式

### 使用脚本

对于 Shell 用户，可以在项目根目录使用准备好的脚本进行文档生成：

```bash
./build.sh
```

### 手动编译

也可以直接使用 `typst` 进行编译：

```bash
typst compile "src/tshort.typ" "tshort.pdf"
```

生成后的文档可以在项目根目录下找到。
