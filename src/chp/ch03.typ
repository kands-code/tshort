#import "../utils.typ": abstract, code-and-show, code-block, code-card, show-block

= 文档元素

#abstract[
  在知道了如何输入文字后，我们将在本章了解一个结构化的文档所依赖的各种元素
  ------ 章节、目录、列表、图表、交叉引用、脚注等等。
]

== 章节和目录

=== 章节标题

一篇结构化的、条理清晰文档一定是层次分明的。
Typst 通过 `heading` 函数，
不同层级的标题可以将内容划分成章、节、小节等等。

在标记模式下，标题的层级可以通过等号 `=` 的数量来表示，例如：

#code-card[
  ```typ
  = level 1
  == level 2
  === level 3
  ```
]

Typst 理论上支持任意深度的标题层级，
但是，标题的过度嵌套会使文档结构显得臃肿复杂。
为了让文档清晰可读，通常建议将标题的层级限制在三级以内。
少数需要更细致划分的场景下，可以使用四级标题。

`heading` 函数有许多参数可以设置，常用的参数有：

/ numbering: 用于控制标题的编号。

  Typst 中，编号方式可以使用编号模式或者编号函数来设置。

  / 编号模式: 一个字符串，其中包含了“计数符号”、“后缀”和“前缀”。

    / 计数符号: 包含 `1`、`a`、`A`、`i`、`I`、`一` 和 `壹` 等，是等价于“一”的字符。
      数字将被替换为对应序列中的字符，
      例如 ```typ #numbering("I", 16)``` 显示为 #raw(str(numbering("I", 16)))。

      计数符号 `*` 表示使用符号计数，
      顺序为 #sym.ast #sym.arrow.r #sym.dagger #sym.arrow.r
      #sym.dagger.double #sym.arrow.r #sym.section #sym.arrow.r
      #sym.pilcrow #sym.arrow.r #sym.bar.v.double。
      如果编号超过了符号个数，则使用重复的符号表示数字。

    / 后缀: 最后一个计数符号之后的所有字符，会在所有编号的末尾按原样重复。

    / 前缀: 第一个计数符号前的所有字符，会在所有编号的开头按原样重复。

  例如 ```typ #numbering("前缀|a.壹|后缀", 10, 20)```
  显示为 #raw(str(numbering("前缀|a.壹|后缀", 10, 20)))。

  / 编号函数: 接受任意个数字作为参数，返回内容。

    参数个数与编号层级和要编号的内容有关，例如设置标题编号：

    #code-block[
      ```typ
      #set heading(numbering: (..nums) => {
        let level = nums.pos().len()
        if level == 1 {
          numbering("第一章", ..nums)
        } else if level < 4 {
          numbering("1.1.1.1", ..nums)
        } else {
          none
        }
      })
      ```
    ]

    其中 `..nums` 表示将传入的参数收集起来，`nums` 的类型是 `arguments`；
    `nums.pos()` 方法会返回一个列表，列表中的元素为传入的参数。

    在这个规则下，一级标题的编号模式为 `第一章`；
    其他标题的编号模式是 `1.1.1.1`，
    例如第三章第一节第二小节显示为 `3.1.2`。
    层级在四级以下的标题，例如五级标题，将不显示编号。

/ level: 一个整数，用于表示标题层级。

/ outlined: 一个布尔值，表示是否显示在目录中#footnote[
    目录并不等于 PDF 大纲。
    如果不想某个标题显示在大纲中，
    可以设置参数 `bookmarked` 为 ```typc false```。
    如果一个标题设置为 `outlined: true`，
    默认情况下该标题也会显示在 PDF 大纲中。
  ]。

=== 目录

在 Typst 中生成目录非常容易，只需在合适的地方使用 `#outline()` 函数。

这个函数会单独的一章，标题使用一级标题，并且标题内容会根据使用的语言自动选择，
例如英语会使用 `Contents`，而中文会使用 `目录`。

如果想要修改目录的标题，可以设置参数 `title`，例如：

#code-card[
  ```typ
  #outline(title: [自定义目录标题])
  ```
]

默认情况下，目录会包含所有层级的章节标题，除了生成的目录章节。
如果只想要包含一级标题到三级标题，可以设置 `outline` 的参数 `depth` 为 `3`。

参数 `depth` 的表示至多要包含的标题层级。

如果要将目录章节也添加到目录，可以设置参数 `title` 为 ```typc none```，
然后使用章节标题手动为目录添加标题，例如：

#code-card[
  ```typ
  = 目录
  #outline(title: none)
  ```
]

其中，```typ #outline(title: [自定义目录标题])``` 等价于：

#code-card[
  ```typ
  #heading(level: 1, outlined: false)[自定义目录标题]
  #outline(title: none)
  ```
]

如果想要生成特定内容的目录，可以设置参数 `target` 用于定位。
参数 `target` 通常会被设置为一个 `where` 语句，
例如所有 `figure` 中类型为图片的内容：

#code-card[
  ```typ
  #outline(title: [图片列表], target: figure.where(kind: image))
  ```
]

如果对生成的目录每一层级的缩进不满意，可以设置参数 `indent`。
`indent` 可以接受一个长度表示每一层级的缩进大小，
例如想要目录每一层级缩进 `1.6em`：

#code-card[```typ #outline(indent: 1.6em)```]

=== 文档结构划分

Typst *并没有*提供用于划分文档结构的函数。
但是我们可以使用 `set` 和 `show` 设置规则，自己划分出合适的文档结构。

/ 前言: 页码使用小写罗马数字，标题不编号。

  #code-block[
    ```typ
    // 设置页码使用小写罗马数字
    #set page(numbering: "i")
    // 设置当前页面为逻辑上的第一页
    #counter(page).update(1)
    // 标题不编号
    #set heading(numbering: none)
    ```
  ]

/ 正文: 页码使用阿拉伯数字，标题的编号模式看具体要求，例如 `"1.1.1.1"`。

  #code-block[
    ```typ
    // 设置页码使用阿拉伯数字
    #set page(numbering: "1")
    // 设置当前页面为逻辑上的第一页
    #counter(page).update(1)
    // 标题编号模式使用 1.1.1.1
    #set heading(numbering: "1.1.1.1")
    ```
  ]

/ 附录: 一般附录的一级标题会使用英文字母编号，并且编号会重置，例如 @appendix-a。

  可以设置如下规则来改变一级标题的编号方式：

  #code-block[
    ```typ
    // 设置编号方式为 附录A
    #show heading.where(level: 1): set heading(numbering: "附录A")
    // 重置标题计数，标题默认从 0 开始计数
    #counter(heading).update(0)
    ```
  ]

/ 后记: 页码格式不变，继续正常计数；标题不编号。

  #code-block[
    ```typ
    // 标题不编号
    #set heading(numbering: none)
    ```
  ]

=== 设置规则<设置规则>

在之前章节中已经展示了许多设置规则的示例，这里我们稍微总结一下。

在 Typst 中，设置规则有两种方式：

/ Set: 设置*元素（element）函数*#footnote[
    元素函数是指 Typst 的基本样式元素，包括 `heading` 和 `table`，详情请查看
    #link("https://typst.app/docs/reference/foundations/function/#element-functions")[
      element functions
    ]。
  ]参数的默认值。

  使用 `set` 可以避免重复设置参数默认值，例如：

  #code-card[
    ```typ
    #set heading(numbering: "1.a.i")
    ```
  ]


  这里，设置 `heading` 函数的参数 `numbering` 的默认值为 `"1.a.i"`。
  这样设置后，使用 `heading` 函数的时候就不需要重复写 `numbering` 了。

/ Show: 修改元素函数返回值。

  `show` 有两种使用方式，分别是设置 `show-set` 规则和通过函数修改。

  / 设置 `show-set` 规则: 函数会先应用 `set` 规则，然后再渲染函数内容，例如：

  #code-and-show(columns: (3fr, 2fr))[```typ
    #emph[Before].

    #show emph: set text(fill: red)

    #emph[After].

    其他内容不会被影响。
    ```]

  这里，先将 `emph` 函数中的文本颜色设置为红色，
  然后再渲染 `emph` 函数，默认会让文本样式改为斜体。
  `show-set` 设置的规则不会影响其他内容。

  更常用的方法是配合 `where` 方法筛选，可以更加精细的设置渲染。
  `where` 方法的参数是对应函数的参数，例如：

  #code-and-show(columns: (3fr, 1fr))[```typ
    `Before`.

    #show raw.where(block: false): set text(
      fill: blue, // 字体颜色设置为蓝色
    )

    `After`.
    ```]

  / 通过函数修改: 使用函数可以精细设置函数该如何渲染元素，例如：

  #code-and-show(columns: (5fr, 2fr))[```typ
    #emph[Before].

    #show emph: it => [「#it.body」]
    #emph[After].
    ```]

  这里，`emph` 函数的渲染结果由原本的将文本样式改为斜体，变成了在文本两边加上括号。
  其中，`it.body` 可以获取 `emph` 函数要渲染的文本。

  ```typc it => [「#it.body」]``` 是一个匿名函数，`it` 是函数参数。
  匿名函数的基本语法是 ```typc (参数列表) => 表达式```，
  如果参数只有一个，可以省略括号。

== 文档信息

PDF 文档除了文档内容外，还包含了许多元数据信息#footnote[
  请不要和 Typst 的 #link("https://typst.app/docs/reference/introspection/metadata")[
    metadata
  ] 混淆。
]，包括文档标题、创建日期、作者等。
要设置这些信息，可以使用 `document` 函数。例如：

#figure(kind: raw, caption: [在 Typst 中设置 PDF 元数据信息源代码示例。])[
  #code-block[
    ```typ
    #set document(
      title: [文档标题],
      author: ("作者列表", "可以有多个"),
      description: [文档简介],
      keywords: ("关键词", "描述", "文档"),
      date: datetime.today(), // 文档创建日期，默认为当天
    )
    ```
  ]
]

其中参数 `date` 接受 ```typc auto```、```typc none``` 和 `datetime` 类型的值。

== 交叉引用<交叉引用>

交叉引用是 Typst 强大的自动排版功能的体现之一。
在可以被交叉引用的元素后使用 `label` 函数或 `<..>`，标签会附加到对应元素上：

#code-card[```typ 要引用的元素<标签内容>```]

之后可以在别处使用 `ref` 函数或 `@`，可以生成交叉引用的编号：

#code-and-show[```typ
  在这里引用这一小节标题
  @交叉引用，\
  或者生成交叉引用的页码
  #ref(
    <交叉引用>,
    form: "page",
  )
  ```]

`ref` 函数的第一个参数是要引用的标签；
参数 `form` 可能值是 `"normal"` 或者 `"page"`，
对应生成交叉引用的编号或对应页码。

标签作为基本元素，可以使用 `show` 来设置规则：

#code-and-show(columns: (3fr, 1fr))[```typ
  #show <测试引用1>: set text(fill: green)

  标签规则测试<测试引用1>

  标签规则测试<测试引用2>
  ```]

但是，能够设置标签不等于能够被引用。
只有包含 `supplement` 和 `numbering` 的元素可以被引用，
包括章节标题、图表、数学公式和脚注。

如果要创建自定义可引用元素，
目前一个可行的做法是使用 `figure` 函数，
然后将参数 `kind` 的值设置为特定文本，之后使用 `show` 设置渲染方式。

#code-card[
  ```typ
  #show figure.where(kind: "custom"): .. // 设置渲染方式
  #figure(kind: "custom", ..)
  ```
]

== 脚注

有时我们想要为一些内容添加注释，但是又不想影响正文布局。
此时可以使用脚注来为内容添加注释。

使用 `footnote` 函数可以在页面底部生成一个脚注：

#code-block[
  ```typ
  #text(font: "Zhuque Fangsong (technical preview)")[
    “天地玄黄，宇宙洪荒。日月盈昃，辰宿列张。”
    #footnote[
      出自《千字文》。
    ]
  ]
  ```
]

#show-block(width: auto)[
  #text(font: "Zhuque Fangsong (technical preview)")[
    “天地玄黄，宇宙洪荒。日月盈昃，辰宿列张。”
    #footnote[
      出自《千字文》。
    ]
  ]
]

脚注的编号方式可以使用 `numbering` 来设置，例如：

#code-card[```typ #set footnote(numbering: "*")```]

默认情况下，脚注编号在*整个文档*中继续进行。
如果想要脚注编号局限在每一页，可以在页眉或者页脚中重置脚注计数器：

#code-card[
  ```typ
  #set page(header: {
    // 其他设置
    counter(footnote).update(0)
    // 其他设置
  })
  ```
]

== 特殊元素函数

=== 列表

Typst 提供了基本的有序列表 `enum` 函数和无序列表 `list` 函数。
这两个函数的用法十分类似，使用位置参数标明每个列表项。
`enum` 函数会自动对列表项编号。

#code-and-show[```typ
  #enum(numbering: "1.")[
    参数一
  ][
    参数二
  ][
    参数三
  ]
  ```]

还可以使用标记语法 `+` 和 `-` 表示有序和无序列表：

#code-and-show[```typ
  #set enum(numbering: "1.")
  + 参数一
  + 参数二
  + 参数三
  ```]

列表间可以相互嵌套，每一层级的编号，
`enum` 函数可以使用参数 `numbering` 设置，
`list` 函数可以使用参数 `marker` 设置。

#code-and-show[```typ
  #set enum(
    numbering: "1.A.a",
  )
  #set list(
    marker: (
      sym.ast.basic,
      [>], sym.section )
  )
  + 参数 a
    - 参数 aa
      - 参数 aaa
        + 参数 aaaa
        - 参数 aaab
        + 参数 aaac
    + 参数 ba
      + 参数 baa
  ```]

注意到，有序列表和无序列表的编号*并不共享*。
列表会根据其最近的上一层级同种列表的编号继续编号。
例如 `参数 aaaa`，其最近有序列表项是 `参数 a`，
所以 `参数 aaaa` 会根据 `参数 a` 继续编号，即“1.A”；
`参数 aaac` 和 `参数 ba` 也是如此。

除此之外，对于一些关键词或术语的解释，还可以使用 `terms` 函数：

#code-and-show(columns: (5fr, 2fr))[```typ
  #terms(
    terms.item([A], [some description]),
    terms.item([B], [some description]),
    // ..
  )
  ```]

等价的标记语法为：

#code-card[
  ```typ
  / A: some description
  / B: some description
  ```
]

=== 对齐函数

如果需要调整内容的对齐方式，可以使用 `align` 函数。

#code-and-show(columns: (5fr, 4fr))[```typ
  #align(left)[ 左对齐 ]
  #align(center)[ 水平居中对齐 ]
  #align(right)[ 右对齐 ]
  ```]

竖直方向上，对齐方式有 `top`、`bottom` 和 `horizon`。
如果需要水平方向居中且竖直方向居中，可以使用 `+` 组合对齐方式：

#code-card[```typ #align(center + horizon)[ 内容 ]```]

=== 引用函数

有些时候，我们可能需要引用他人的言论、文章片段或经典语录。
为了让这些引用内容在视觉上与正文区分开来，
我们可以使用 `quote` 函数。

如果引用的内容只是一句话，那么可以直接使用 `quote` 函数：

#code-and-show(columns: (3fr, 2fr))[```typ
  李白曾说过：#quote[噫吁嚱] \
  李白曾说过：“噫吁嚱”
  ```]

可以看到，引用函数的基本样式就是在文本两边加上引号。
但是，引用函数的引号不会与其它标点符号挤压，
所以冒号和引号会各自占用一个汉字的宽度默认。

在排版较长的引用内容时，通常会将其独立成一个块，以便与正文区分。
此时可以将 `quote` 函数的参数 `block`，设置为 `true`：

#code-block[
  ```typ
  《尸子》曾有云：
  #quote(
    block: true,
    attribution: [卷下·散见诸书文汇辑],
  )[
    天地四方曰宇，往古来今曰宙。
  ]
  ```
]

#show-block(width: 80%)[
  《尸子》曾有云：
  #quote(block: true, attribution: [卷下·散见诸书文汇辑])[
    天地四方曰宇，往古来今曰宙。
  ]
]

其中参数 `attribution` 可用来标记引用来源。但是 `attribution` 默认使用的是 `---`，
中文排版应该要使用 `------`，所以我们可以用如下方法设置：

#figure(kind: raw, caption: [在 Typst 中设置中文引用样式。])[
  #code-block[
    ```typ
    #show quote.where(block: true): it => [
      // 默认宽度为 100%，水平内边距由 1em 增大为 2em
      #align(center, block(width: 100%, inset: (x: 2em))[
        // 引用内容字体大小略小于正文字体
        #set text(size: 0.96em)
        // 使用朱雀仿宋体展示引用内容
        #align(left, text(
          font: "Zhuque Fangsong (technical preview)",
          it.body,
        ))
        #if it.attribution != none {
          align(right)[------ #it.attribution]
        }
      ])
    ]
    #let qb = quote.with(block: true)

    《尸子》曾有云：
    #qb(attribution: [卷下·散见诸书文汇辑])[
      天地四方曰宇，往古来今曰宙。
    ]
    ```
  ]
]

#show-block(width: 80%)[
  #show quote.where(block: true): it => [
    // 默认宽度为 100%，水平内边距由 1em 增大为 2em
    #align(center, block(width: 100%, inset: (x: 2em))[
      // 引用内容字体大小略小于正文字体
      #set text(size: 0.96em)
      // 使用朱雀仿宋体展示引用内容
      #align(left, text(
        font: "Zhuque Fangsong (technical preview)",
        it.body,
      ))
      #if it.attribution != none {
        align(right)[------ #it.attribution]
      }
    ])
  ]
  #let qb = quote.with(block: true)

  《尸子》曾有云：
  #qb(attribution: [卷下·散见诸书文汇辑])[
    天地四方曰宇，往古来今曰宙。
  ]
]

其中 ```typ #let qb = quote.with(block: true)``` 表示将
`quote` 函数的参数 `block` 的默认值设置为 ```typc true```，
然后将修改默认值后的函数定义为 `qb`。
这种方式不仅可以避免重复设置参数默认值，
而且*不会*修改函数参数的全局默认值。

如果要实现类似 LaTeX 中 `verse` 环境的效果，即首行悬挂缩进，可以使用：

#code-card[
  ```typ
  #show quote.where(block: true): it => [
    #set par(first-line-indent: (amount: -2em, all: true))
    // 其他设置 ......
  ]
  ```
]

=== 代码函数

有时我们需要将一段代码原样转义输出，这就要用到代码 `raw` 函数。
`raw` 函数默认使用等宽字体排版代码，回车和空格也分别起到换行和空位的作用。

#code-and-show(columns: (10fr, 7fr))[```typ
  #raw("fn main() {\n"
    + "    println!(\"hey!\");\n"
    + "}", lang: "rs")
  ```]

和其他函数不同的是，`raw` 函数使用*字符串*作为参数，而不是内容。

作为元素函数，`raw` 函数也有自己的标记语法，使用成对的反引号 ``` ` ``` 来标记。
使用一对反引号时，使用行内渲染，并且默认代码语言是 `txt`，即普通文本。例如：

#code-and-show(code-func: code-card)[```typ
  `普通文本` 与正常内容
  ```]

使用三对及以上反引号时，可以设置代码语言，即参数 `lang`，例如：

#code-and-show(code-func: code-card, columns: (3fr, 2fr))[````typ
  Rust 代码：```rs struct A;```
  ````]

如果代码包含多行内容，则会自动使用行间渲染，例如：

#code-and-show[````typ
  测试代码块 ```c
  #include <stdio.h>
  int main() {
    printf("hey!\n");
    return 0;
  }```
  ````]

默认情况下，`raw` 函数是没有行号显示的，
但是可以通过 `raw.lines` 获取代码块的每一行的内容。
我们可以使用这些内容自定义代码块渲染：

#figure(kind: raw, caption: [在 Typst 中自定义代码块显示。])[
  #code-block[
    ````typ
    #show raw.where(block: true): it => {
      // 如果显示行号，则使用 grid 排版
      grid(
        // 行号右对齐，代码左对齐，水平居中
        align: (right + horizon, left + horizon),
        // 行号宽度自动，代码内容占据所有剩下的空间
        columns: (auto, 1fr),
        // 行间距设置为 0.64em
        row-gutter: 0.64em,
        // 行号和代码内容间距设置为 1em
        column-gutter: 1em,
        ..it.lines.map(line => (
            // 使用 raw.line.number 获取行号
            text(fill: rgb(112, 119, 161))[#line.number],
            line.body,
          ))
          .flatten()
      )
    }

    测试有行号的代码块：
    ```c
    #include <stdio.h>
    int main() {
      printf("hey!\n");
      return 0;
    }
    ```
    ````
  ]
]

#show-block(width: 32%)[
  #show raw.where(block: true): it => {
    // 如果显示行号，则使用 grid 排版
    grid(
      // 行号右对齐，代码左对齐，水平居中
      align: (right + horizon, left + horizon),
      // 行号宽度自动，代码内容占据所有剩下的空间
      columns: (
        auto,
        1fr,
      ),
      // 行间距设置为 0.64em
      row-gutter: 0.64em,
      // 行号和代码内容间距设置为 1em
      column-gutter: 1em,
      ..it
        .lines
        .map(l => (
          // 使用 raw.line.number 获取行号
          text(fill: rgb(112, 119, 161))[#l.number],
          l.body,
        ))
        .flatten()
    )
  }

  测试有行号的代码块：
  ```c
  #include <stdio.h>
  int main() {
    printf("hey!\n");
    return 0;
  }
  ```
]

== 表格

在 Typst 中可以轻松地排版表格。
Typst 提供了 `grid` 和 `table` 两个函数用于排版表格内容。
其中 `grid` 函数用于排版*表格布局*；而 `table` 函数用于显示*表格内容*。
