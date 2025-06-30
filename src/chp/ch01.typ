#import "../utils.typ": abstract, code-and-show, code-block, code-card, kbd, show-block

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
Typst 还是一门标记（markup）语言，提供了类似 Markdown@markdown 的编写体验的同时，
通过 `set` 和 `show` 组成的规则#footnote[使用方法详见 @设置规则。]，
可以轻松地设置文档样式，内嵌的脚本支持也可以用于实现复杂的版面设计。

Typst 的国际音标是 `/taɪpst/`，与汉字“泰普斯特”的发音接近。
在书写时作为专有名词，注意需要将 T 大写。

=== Typst 的优缺点

经常有人拿 Typst 和“所见即所得”的字处理工具对比，例如 Typst 对比 WPS。
这种对比是没有意义的，因为 Typst 是一个排版系统，而 WPS 是字处理工具，
二者的设计目标不一致，也各自有自己的适用范围。

不过，这里仍旧总结 Typst 的一些优点：

/ 结构清晰: 使用标记语言编写，文档结构更易阅读和维护，尤其适合长篇或重复性内容。

/ 排版质量高: Typst 的排版效果专业，尤其在数学公式和复杂文档结构方面表现出色。

/ 功能强大: 内嵌了一门脚本语言，可以实现自动化布局，适合编制复杂文档。

/ 即时预览: Typst 编译速度非常快，在支持的编辑器内可以做到实时渲染，所见即所得。

/ 强大的可扩展性: 世界各地的人开发了数以千计的 Typst 包用于补充和扩展 Typst。

/ 跨平台使用: Typst 是跨平台、免费、开源的，并且使用 Rust 编写，
  可以在几乎所有 Rust 支持的平台上使用这一强大的排版工具，并且获得稳定的输出。

/ 轻量快速: Typst 安装体积小，并且生成文档速度快，支持增量编译，
  在支持的编辑器内可以做到实时渲染，适合现代开发环境。

Typst 的缺点也是显而易见的：

/ 入门门槛高: 虽然语法相对简洁直观，但是初次接触仍需要适应。
  并且有许多细节需要用户深入文档去了解，不如 WPS 这样的图形工具直观。

/ 不容易排查错误: 对于没有接触过编程的用户而言，通过错误信息排查问题是比较困难的。
  并且 Typst 没有提供直接的调试方法，有时错误信息还很难理解。

/ 社区生态不完善: 当前可用的模板样式和功能包还比较少，
  部分功能还需要用户实现。

=== 命令行基础

Typst 工具仅提供了命令行接口，不像 WPS、Google Docs 一样有图形用户界面。
命令行程序的结构往往比较简单，它们接受用户输入，读取相关文件，
进行一些操作后输出目标文件，有时还会将提示信息、运行结果显示在屏幕上。
在 Windows 上，如需进入命令行，可在开始菜单搜索“命令提示符”，
也可在“运行”窗口 `cmd` 打开；
Linux 或 macOS 等 \*nix#footnote[
  类 Unix 操作系统，包含 Linux、macOS。
] 系统可搜索“Terminal”打开终端。
部分系统也提供了一些快捷方式，具体请参考相关手册。

与常规软件类似，命令行程序也都是可执行程序，
在 Windows 上后缀名为 `.exe`，而在类 Unix 系统上则需要带有可执行权限。
在大多数命令行环境中，系统会根据 #text(weight: "bold")[环境变量] `PATH` 中存储的路径来搜索可供执行的程序。
因此在运行之前，需确保 Typst 可执行文件所在路径已包含在 `PATH` 中。

在命令行中运行程序时，需要先输入程序名，
其后可加一系列用空格分隔的参数，并按下 #kbd("Enter") 键执行。
一般情况下，命令行程序执行完毕会自行退出。
若遇到错误或中断，可输入快捷键 #kbd("Ctrl")+#kbd("C") 强制结束。

使用命令行程序输入、输出文件时，需确保文件路径正确。
通常需要先切换到文件所在目录，再执行有关程序。切换路径可以执行：

#code-card[`cd [path]`]

注意 `[path]`中的多级目录在 Windows 上使用反斜线 `\` 分隔，
而在类 Unix 系统上使用正斜线 `/` 分隔。
如果 `[path]` 中带有空格或其他特殊字符，则需加上引号 `"`。
此外，在 Windows 上如果要切换到其他分区，还需加上 ```bat /d``` 选项，
例如要从 `D:\folder` 切换到 `C:\Program Files (x86)`，
则可以使用 ```bat cd /d "C:\Program Files (x86)"```。

使用 #link("https://code.visualstudio.com/")[Visual Studio Code]
或 #link("https://typst.app/")[Typst 在线编辑器] 编写 Typst 文档时，
编辑器提供的编译功能，实际上只是对特定命令行程序的封装，而并非魔法。

== 第一次使用 Typst


@最短源代码示例 是一份最短的 Typst 源代码示例。

#figure(kind: raw, caption: [Typst 的一个最简单的源代码示例。])[
  #code-block[
    ```typ
    Hello👋，world🌏!
    ```
  ]
]<最短源代码示例>

这里首先介绍如何编译使用这份源代码，在后续小节中再介绍源代码细节。
你可以将这份源代码保存为 `hello.typ`，然后编译。
具体来说:

/ 本地编辑器: 如果使用 Visual Studio Code，并且安装了
  #link("https://marketplace.visualstudio.com/items?itemName=myriad-dreamin.tinymist")[
    Tinymist 插件
  ]，那么可以使用快捷键 #kbd("Shift")+#kbd("Ctrl")+#kbd("P") 打开命令面板，
  然后选择命令

  #code-card[`Typst: Export the Opened File as PDF`]

  在源代码所在目录下可以看到生成的 PDF 文档。

/ 在线编辑器: 如果使用 Typst 在线编辑器，
  则可以通过 #kbd("file") #sym.triangle.filled.small.r #kbd("Quick export PDF")，
  或者 #kbd("file") #sym.triangle.filled.small.r #kbd("Export as")
  #sym.triangle.filled.small.r #kbd("PDF")，
  或者使用快捷键 #kbd("Shift")+#kbd("Ctrl")+#kbd("S") 都可以下载导出后的 PDF 文档。

/ 命令行: 如果使用命令行，需要打开对应系统终端，在源代码所在目录下输入：

  #code-card[```sh typst compile hello.typ```]

  #h(-2em)如果编译成功，可以在 `hello.typ` 所在目录看到生成的 `hello.pdf`。

@排版中文最简示例 是在 Typst 排版中文的一个最简示例。
编译的方式与上一份源代码相同，只是需要将字体设置为系统中有的中文字体
#footnote[
  文件应该保存为 UTF-8 编码。
]。

#figure(kind: raw, caption: [在 Typst 中排版中文的最简源代码示例。])[
  #code-block[
    ```typ
    // 请将这里字体替换为系统中有的中文字体
    #set text(font: "Source Han Serif SC", lang: "zh")

    你好👋，世界🌏!
    ```
  ]
]<排版中文最简示例>

== Typst 的语法

Typst 的源代码是以纯文本文件的形式编写的。
这些文本除了文字本身，还包括各种定义和函数调用，
用在排版公式、划分文档结构、控制样式等等不同的地方。

=== Typst 的模式<ch-3-typst的模式>

在 Typst 文档中有三种模式：标记模式、数学模式和代码模式。

/ 标记模式: Typst 文档的默认模式，在这个模式下可以使用各种标记语法，
  例如 ```typ *hello*``` 表示强调文本，一般表现为加粗。
  大多数标记语法只是相应函数的语法糖，
  例如 ```typ _hello_``` 就是 ```typ #emph[hello]``` 的标记语法。

/ 数学模式: 数学模式是一种专门用于排版数学公式的模式，将公式放置在 `$` 符号间即可。
  如果与 `$` 之间有空白字符，公式会独占一行，否则会在行内渲染。

#block[
  #show math.equation.where(block: true): set block(above: 0.8em)
  #grid(columns: (1fr, 1fr), align: center + horizon)[
    #code-card[```typ 行内公式：$sum^3_1 x = 6$```]

    行内公式：$sum^3_1 x = 6$
  ][
    #code-card[```typ 行间公式：$ sum^3_1 x = 6 $```]

    行间公式：$ sum^3_1 x = 6 $
  ]
]

/ 代码模式: 在代码模式中可以使用 Typst 中内嵌的脚本语言，使用方式是在标记模式中使用 `#`。
  例如想要让文本“hello”显示为红色，可以使用 ```typ #text(fill: red)[hello]```。
  如果想要减少使用 `#`，可以使用 `#{}`，
  在大括号的范围内都属于代码模式，不需要使用 `#`。
  如果想要在代码模式中使用标记模式，需要使用 `[]`，例如：

  #code-and-show[```typ
    #{
      let a = 10
      let sum = 0
      while a > 0 {
        sum = sum + a
        a = a - 1
      }
      [sum 等于 #sum]
    }
    ```]

/ 注释: 如果在编写 Typst 文档的过程中想要对文档中的一些内容做一些标注，则可以使用注释。
  例如要说明这一部分是第一章的内容，则可以使用：

  #code-card[```typ #include "ch01.typ" // 这是第一章内容```]

  这一行内， `//` 后的所有内容都会被 Typst 忽略，且不会被渲染。

  除了使用 `//`，还可以使用 `/* */` 来表示多行的注释，例如：

  #code-and-show[```typ
    这个会渲染 /* 这里
        还有这里
    不会被渲染 */ 这里可以
    ```]

=== Typst 的脚本语法

在 Typst 脚本中，有一些重要的概念，以下将逐一介绍

/ 表达式: 脚本中最基本的元素就是表达式（expression），包括*函数的调用*和*基本元素*，
  例如 `#emoji.face` 和 `#"hello".len()`#footnote[
    这里 `"hello"` 前需要加上 `#`，表示是脚本代码，
    否则会被当成正常文本解析。]。
  如果在表达式后需要立即使用文本，可以使用 `;` 结束表达式，
  例如 ```typ #emoji.ant;蚂蚁``` 显示为：“#emoji.ant;蚂蚁”。

/ 作用块: 为了让脚本与内容结合，Typst 提供了两种类型的作用块（block）：
  / 代码块: ```typc { let x = 1; x + 2 }```

    通常，在编写脚本时，一条表达式是不够的，
    而代码块能让你在只能写一条表达式的地方编写多条表达式。
    代码块中的每条表达式应该用换行符或分号分隔。
    代码块中每条表达式的输出值会被连接起来以确定代码块的值，
    不包含内容（content）的表达式可以与任何值连接而不会影响渲染效果。

  / 内容块: ```typc [ *Hey* there! ]```

    内容块让我们可以把标记内容作为表达式处理，
    内容块中属于标记模式，可以包含任意标记。
    函数后可以尾随任意数量的内容块，这些内容块会按照顺序作为参数传递给函数，
    例如 ```typc list[A][B]``` 等同于 ```typc list([A], [B])```。

    内容可以使用 `+` 连接，
    ```typc [hello,] + [ world]``` 等同于 ```typc [hello, world]```。

  / 相互嵌套: 下面的示例展示了代码块与内容块的相互嵌套：

#code-and-show(columns: (3fr, 2fr))[```typ
  #{
    let a = [from]
    let b = [*world* #{
        let stars = emoji.star.arc
        stars + stars
      }]
    [hello ]
    a + [ the ] + b
  }
  ```]

/ 绑定与解构: 在之前的示例中，已经展示了绑定（binding），
  即使用 `let` 来定义变量，基本语法是：```typc let 变量名 = 值```。
  其中将 `值` 绑定到 `变量名` 的过程叫做初始化。

  初始化是可选的，也就意味着 ```typc let 变量名``` 也是正确的表达式，
  此时 `变量名` 的值是 ```typc none```。
  在代码块中定义的变量只有在该代码块中可以访问，例如：

  #code-and-show(columns: (3fr, 2fr))[```typ
    #{
      let a1 = 1
      let res = []
      {
        let a2 = 2
        res = res + [#a2]
      }
      // a2 无法访问
      res = res + [#a1]
      res
    }
    ```]

  `值` 可以是任意 Typst 元素，包括*函数*，例如：

  #code-and-show(columns: (3fr, 2fr))[```typ
    #{
      let f(x) = x + 2
      [#f(40)]
    }
    ```]

  定义函数的语法是：```typc let 函数名(参数列表) = 表达式```。

  使用 `let` 还可以解构一些结构，例如数组和字典。
  数组就是一系列元素，使用圆括号表示，例如：```typc (1, "2", [三])```。
  字典是由字符串作为“键”的*键值对*组成的列表，也是用圆括号表示；
  字典的“键”是唯一的，通过这个键我们可以找到这个字典中对应的值，
  例如：```typc ("a": 1, b: "2", "c": [三])```。

  下面是解构字典的语法示例：

  #code-and-show(columns: (3fr, 2fr))[```typ
    #let 字典 = (
        你: "you",
        我: "I",
        他: "he",
      )
    #let (你,) = 字典
    你是#你。\
    #let (他: ta) = 字典
    他是#ta。\
    #let (他, ..other) = 字典
    #for (中, en) in other [
      #中;是#en。\
    ]
    ```]

  其中 `..other` 表示将字典中 `他` 键以外的所有键值对收集起来，绑定为 `other`。
  `(他: ta)` 表示找到字典中 `他` 键对应的值，然后绑定到 `ta` 上。
  如果列表只有一个元素，，末尾的 `,` 可用于与分组（grouping）括号#footnote[
    分组括号对应数学上的括号，用于改变优先级。
  ]区分，例如 `(1,)` 和 `(1)`。

  下面是列表的解构语法示例：

  #code-and-show(columns: (2fr, 1fr))[```typ
    #let (x, y) = (1, 2)
    坐标是 $angle.l#x, #y angle.r$。

    #let (a, _, .., b) = (1, 2, 3, 4, 5)
    第一个元素是 #a。\
    最后一个元素是 #b。
    ```]

  其中 `_` 表示忽略这个位置的元素，在示例中对应 `2`；
  `..` 表示忽略其他元素，在示例中对应 `3, 4`，
  可以用类似字典解构示例中的 `..c` 将值绑定到 `c` 上。

/ 赋值: 赋值用于更新变量的值，基本语法是：```typc 变量名 = 新值```。

  在赋值中也可以使用解构，例如：

  #code-and-show(columns: (3fr, 2fr))[```typ
    #{
      let (a, b) = (1, 2)
      (a, b) = (b, a)
      [a是#a，b是#b。]
    }
    ```]

/ 条件语句: 条件语句用于在符合某些条件下执行某些表达式，
  Typst 支持 `if`、`else if` 和 `else` 三种条件语句，其中 `if` 是必须的。
  基本语法是：

  #code-card[
    ```typ
    #if 条件1 {
      // 符合条件1
    } else if 条件2 {
      // 不符合条件1，符合条件2
    } else {
      // 不符合条件1，也不符合条件2
    }
    ```
  ]

  符合某个条件是指某个条件的值是 `true`，否则就是不符合。

  每个分支都可以有一个代码块或内容块其主体，例如：
  - ```typc if condition {..}```
  - ```typc if condition [..] else {..}```
  - ```typc if condition {..} else if condition {..} else [..]```

/ 循环: 循环可以用于重复执行某些表达式，Typst 支持 `for` 和 `while` 两种循环。

  / for循环: for循环用于迭代集合元素，包括列表和字典，并且支持解构操作，例如：

    #code-and-show(columns: (3fr, 2fr))[```typ
      #{
        let lst = (1, 2, 3)
        for e in lst [
          #e;在列表中。\
        ]
        let dict = (a: 1, b: 2)
        for (k, v) in dict [
          #k;是#v。\
        ]
      }
      ```]

  / while循环: 用于在条件满足的情况下一直重复执行表达式，例如：

    #code-and-show(columns: (3fr, 2fr))[```typ
      #{
        let a = 1
        let sum = 0
        while a < 5 {
          sum = sum + a
          a = a + 1
        }
        [sum等于#sum。]
      }
      ```]

== Typst 包

Typst 自从 #text(font: "Zhuque Fangsong (technical preview)")[v0.6.0] 内置了包管理器后，
我们就能轻松地引入 Typst Universe 中的包来使用别人已经帮我们实现好的功能。
调用包的方式为：

#code-card[```typ #import "@preview/[包名]:[版本]": ..函数名```]

其中，包名指的是要引入的包的名称，版本则是所使用的具体版本。
而函数名是指一系列用逗号分隔的函数名称，这些函数都来自于要引入的包。
例如：

#code-card[```typ #import "@preview/example:0.1.0": add```]

在引入包的时候，如果之前没有引入过这个包，或者没有使用这个版本，
Typst 会先在本地目录缓存（cache）这个包的对应版本，然后再使用这个包。

Typst 在本地缓存的包的具体路径为：`[缓存目录]/typst/packages/preview/[包名]/[版本]`，
其中 `[缓存目录]` 默认是标准的用户缓存目录：

- 对于 Windows 用户：`C:\User\[用户名]\AppData\Local`。
- 对于 Linux 用户：`~/.cache`。
- 对于 macOS 用户：`~/Library/Caches`。

如果你想要编写自己的包，然后在文档中使用，
可以将其存放到：`[数据目录]/typst/packages/[命名空间]/[包名]/[版本]`，
然后可以用如下方式使用：

#code-card[```typ #import "@[命名空间]/[包名]:[版本]": ..函数名```]

通常会使用 `local` 作为 `[命名空间]`，而 `[数据目录]` 默认是标准的用户数据目录：

- 对于 Windows 用户：`C:\User\[用户名]\AppData\Roaming`。
- 对于 Linux 用户：`~/.local/share`。
- 对于 macOS 用户：`~/Library/"Application Support"`。

当然，这些默认路径是可以修改的，
对于 Linux 用户，缓存目录可以使用环境变量 `XDG_CACHE_HOME` 来修改，
数据目录可以使用环境变量 `XDG_DATA_HOME` 来修改；
其他平台的用户，缓存目录可以通过环境变量 `TYPST_PACKAGE_CACHE_PATH` 来修改，
数据目录可以使用环境变量 `TYPST_PACKAGE_PATH` 来修改。

除了通过环境变量，在编译时使用 `--package-cache-path` 和 `--package-path` 选项，
可以指明要使用的缓存目录和数据目录，例如要使用`~/typst/cache` 作为缓存目录 ：

#code-card[
  ```sh
  typst compile --package-cache-path="~/typst/cache" example.typ
  ```
]

== 文件的组织方式

当编写长篇文档时，例如要编写书籍、毕业论文，
单个源文件会让修改、校对变得十分困难。
将源文件分割成若干个文件，会大大简化修改和校对的工作。

Typst 提供了 ```typc include``` 用于在源代码里插入文件：

#code-card[```typ #include "other.typ"```]

`"other.typ"` 需要替换成要引入的文件名称，例如：

#code-block[
  ```typ
  #include "../chp02/sec01.typ" // 相对路径
  #include "/home/user/other/theme.typ" // *nix 绝对路径
  #include "D:/data/utils.typ" // Windows 绝对路径，使用正斜线
  ```
]

需要注意的是，```typc include``` 会强制断页。
如果使用过 LaTeX 可能会想到 ```tex \input``` 命令，
但 Typst *并没有*提供等价的功能。

如果想要从其他文件中直接引入一些内容，可以使用 ```typc import```。
```typc import``` 除了可以引入包，还可以引入具体文件中的内容，例如：

#code-block[
  ```typ
  // main.typ 文件
  // 使用 import 导入 utils.typ 文件中的内容和函数
  #import "utils.typ": some-content, red-text
  // 使用函数和内容
  导入的内容是：#red-text[#some-content]
  ```
]

#grid(columns: (3fr, 2fr), align: center + horizon)[
  #code-block[
    ```typ
    // utils.typ 文件
    #let some-content = [
      一些内容。
    ]
    #let red-text(body) = {
      text(fill: red)[#body]
    }
    ```
  ]
][
  #show-block([导入的内容是：] + text(fill: red)[一些内容。])
]

最后，介绍一下如何实现几乎实时渲染的自动编译。
只需将编译命令中的 `compile` 替换为 `watch` 即可。
例如，如果想要自动编译，并将缓存目录设置为 `~/typst/cache`，
特殊字体目录设置为 `./fonts`，数据目录设置为 `~/typst/data`，可以使用以下命令：

#code-card[
  ```sh
  typst watch --package-path="~/typst/data" \
    --package-cache-path="~/typst/cache" \
    --font-path="./fonts" \
    main.typ main.pdf
  ```
]
