#import "../utils.typ": abstract, kbd, code-card, code-block

= Typst 的基本概念

#abstract[
  欢迎使用 Typst！本章开头用简短的篇幅介绍了 Typst 的来源，
  然后介绍了 Typst 源代码的写法，编译 Typst 源代码生成文档的方法，
  以及理解接下来的章节的一些必要知识。
]

== 概述

=== Typst

Typst 是一个面向科学写作的新型排版系统，
其设计目标是拥有与 LaTeX@latex 一样强大的排版能力，同时更易于学习和使用。
Typst 还是一门标记语言，提供了类似 Markdown@markdown 的编写体验的同时，
通过 `set` 和 `show` 组成的规则#footnote[使用方法将在后续章节中详细介绍]，
可以轻松地设置文档样式，内嵌的脚本支持也可以用于实现复杂的版面设计。

Typst 的国际音标是 `/taɪpst/`，与汉字“泰普斯特”的发音接近。
在书写时作为专有名词，注意需要将 T 大写。

=== Typst 的优缺点

经常有人喜欢对比 Typst 和以 Microsoft Office Word 为代表的 “所见即所得”字处理工具。
这种对比是没有意义的，因为 Typst 是一个排版系统，而 Word 是字处理工具。
二者的设计目标不一致，也各自有自己的适用范围。

不过，这里仍旧总结 Typst 的一些优点：

/ 结构清晰: 使用标记语言编写，文档结构更易阅读和维护，尤其适合长篇或重复性内容。

/ 排版质量高: Typst 的排版效果专业，尤其在数学公式和复杂文档结构方面表现出色。

/ 功能强大: 内嵌了一门脚本语言，可以实现自动化布局，适合编制复杂文档。

/ 即时预览: Typst 编译速度非常快，在支持的编辑器内可以做到实时渲染，所见即所得。

/ 强大的可扩展性: 世界各地的人开发了数以千计的 Typst 包用于补充和扩展 Typst。

/ 跨平台使用: Typst 是跨平台、免费、开源的，并且使用 Rust 编写，
  可以在几乎所有 Rust 支持的平台上使用这一强大的排版工具，并且获得稳定的输出。

/ 轻量快速: Typst 安装体积非常小，并且生成文档速度快，支持增量编译，
  在支持的编辑器内可以做到实时渲染，适合现代开发环境。

Typst 的缺点也是显而易见的：

/ 入门门槛高: 虽然语法相对简洁直观，但是初次接触仍需要适应。
  并且有许多细节需要用户深入文档去了解，不如 Word 这样的图形工具直观。

/ 不容易排查错误: 对于没有接触过编程的用户而言，通过错误信息排查问题是比较困难的。
  并且 Typst 没有提供直接的调试方法，有时错误信息还很难理解。

/ 社区生态不完善: 当前可用的模板样式和功能包还比较少，
  部分功能还需要用户实现。

=== 命令行基础

Typst 工具仅提供了命令行接口，而不像 Word、Google Docs 一样有图形用户界面。
命令行程序的结构往往比较简单，它们接受用户输入，读取相关文件，
进行一些操作和运算后输出目标文件，有时还会将提示信息、运行结果显示在屏幕上。
在 Windows 系统上，如需进入命令行，可在开始菜单中搜索“命令提示符”，
也可在“运行”窗口中输入 `cmd` 打开；
Linux 或 macOS 等 \*nix#footnote[
  类 Unix 操作系统，包含 Linux、macOS
] 系统中可搜索“Terminal”打开终端。
部分系统也提供了一些快捷方式，具体请参考相关手册。

与常规软件类似，命令行程序也都是可执行程序，
在 Windows 上后缀名为 `.exe`，而在类 Unix 系统上则需要带有可执行权限。
在大多数命令行环境中，系统会根据 #text(weight: "bold")[环境变量] `PATH` 中存储的路径来搜索可供执行的程序。
因此在运行之前，需确保 Typst 可执行文件所在路径已包含在 `PATH` 中。

在命令行中运行程序时，需要先输入程序名，
其后可加一系列用空格分隔的参数，并按下 #kbd[Enter] 键执行。
一般情况下，命令行程序执行完毕会自行退出。
若遇到错误或中断，可输入 #kbd[Ctrl]+#kbd[C] 以强制结束。

使用命令行程序输入、输出文件时，需确保文件路径正确。
通常需要先切换到文件所在目录，再执行有关程序。切换路径可以执行：

#code-card[cd \[#text(style: "italic")[path]\]]

注意 `[path]`中的多级目录在 Windows 系统上使用反斜线 `\` 分隔，
而在类 Unix 系统上使用正斜线 `/` 分隔。
如果 `[path]` 中带有空格或其他特殊字符，则需加上引号 `"`。
此外，在 Windows 系统上如果要切换到其他分区，还需加上 ```bat /d``` 选项，
例如要从 `D:\folder` 切换到 `C:\Program Files (x86)`，
则可以使用 ```bat cd /d "C:\Program Files (x86)"```。

许多用户会使用 #link("https://code.visualstudio.com/")[Visual Studio Code]
或 #link("https://typst.app/")[Typst 在线编辑器] 来编写 Typst 文档。
这些编辑器提供的编译功能，实际上只是对特定命令行程序的封装，而并非魔法。

== 第一次使用 Typst


@code-1-1 是一份最短的 Typst 源代码示例。

#figure(kind: raw, caption: [Typst 的一个最简单的源代码示例。])[
  #code-block(
    linenumber: true,
    top-bottom-stroke: true,
    stroke-thickness: 0.04em,
  )[
    ```typ
    Hello👋，world🌏!
    ```
  ]
]<code-1-1>

这里首先介绍如何编译使用这份源代码，在后续小节中再介绍源代码的细节。
你可以将这份源代码保存为 `hello.typ`，而后编译。
具体来说:

/ 本地编辑器: 如果使用 Visual Studio Code 配合 #link(
    "https://marketplace.visualstudio.com/items?itemName=myriad-dreamin.tinymist",
  )[Tinymist 插件]，你可以使用编辑器提供的“显示导出的 PDF”按钮生成 PDF 文档。

/ 在线编辑器: 如果使用 Typst 在线编辑器，
  你可以通过 #kbd[file] #math.triangle.filled.small.r #kbd[Quick export PDF]，
  或者 #kbd[file] #math.triangle.filled.small.r #kbd[Export as]
  #math.triangle.filled.small.r #kbd[PDF]，
  或者使用 #kbd[Shift]+#kbd[Ctrl]+#kbd[S] 都可以下载导出后的 PDF 文档。

/ 命令行: 如果使用命令行，则需要先打开系统的终端，
  然后切换到源代码所在的目录，使用如下命令：
  #code-card[typst hello.typ]
  如果编译成功，可以在 `hello.typ` 所在目录看到生成的 `hello.pdf`。

@code-1-2 是在 Typst 排版中文的一个最简示例。
编译的方式与上一份源代码相同，只是需要将字体设置为系统中有的中文字体
#footnote[
  文件应该保存为 UTF-8 编码
]。

#figure(kind: raw, caption: [在 Typst 中排版中文的最简源代码示例。])[
  #code-block(
    linenumber: true,
    top-bottom-stroke: true,
    stroke-thickness: 0.04em,
  )[
    ```typ
    // 请将这里字体替换为系统中有的中文字体
    #set text(font: "Source Han Serif", lang: "zh")

    你好👋，世界🌏!
    ```
  ]
]<code-1-2>

== Typst 函数和代码结构

Typst 的源代码为文本文件。这些文本除了文字本身，还包括各种定义和函数调用，
用在排版公式、划分文档结构、控制样式等等不同的地方。

=== Typst 函数和模式

aaa
