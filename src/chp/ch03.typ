#import "../utils.typ": abstract, code-and-show, code-block, code-card, show-block

= 文档元素

#abstract[
  在知道了如何输入文字后，我们将在本章了解一个结构化的文档所依赖的各种元素
  ------ 章节、目录、列表、图表、交叉引用、脚注等等。
]

== 章节和目录

=== 章节标题<ch-3-章节标题>

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

  在 Typst 中，编号方式可以使用编号模式或者编号函数来设置。

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

=== 目录<ch-3-目录>

在 Typst 中生成目录非常容易，只需在合适的地方使用 `outline` 函数。

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

PDF 文档除了文档内容，还包含许多元数据#footnote[
  请不要和 Typst 的 #link("https://typst.app/docs/reference/introspection/metadata")[
    metadata
  ] 混淆。
]，包括文档标题、创建日期、作者等。
要设置这些元数据，可以使用 `document` 函数。例如：

#figure(kind: raw, caption: [在 Typst 中设置 PDF 元数据源代码示例。])[
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
LaTeX 中，还有宏包提供了边注以及其他注释方法，
Typst 目前仅支持使用脚注，并且还缺少很多功能，
详情请查看#link("https://github.com/typst/typst/issues/1337")[typst/issues/1337]。

使用 `footnote` 函数可以在页面底部生成一个脚注：

#code-block[
  ```typ
  #text(font: "Zhuque Fangsong (technical preview)")[
    “天地玄黄，宇宙洪荒。日月盈昃，辰宿列张。”
    #footnote[出自《千字文》。]
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

#code-and-show(columns: (5fr, 4fr))[```typ
  #set enum(numbering: "1.a.")
  #enum(
    [参数一],
    [ 参数二
      #enum(
        [参数A],
        [参数B],
      )
    ],
  )
  ```]

还可以使用标记语法 `+` 和 `-` 表示有序和无序列表：

#code-and-show(columns: (5fr, 4fr))[```typ
  #set enum(numbering: "1.a.")
  + 参数一
  + 参数二
    + 参数A
    + 参数B
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
所以冒号和引号会各自占用一个汉字的宽度默认#footnote[
  可以使用 ```typ #set text(features: ("pwid",))``` 解决，但是这依赖于字体的实现方式。
]。

在排版较长的引用内容时，通常会将其独立成一个块，以便与正文区分。
此时可以将 `quote` 函数的参数 `block`，设置为 `true`：

#code-block[
  ```typ
  《尸子》曾有云：
  #quote(block: true, attribution: [卷下·散见诸书文汇辑])[
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

#figure(kind: raw, caption: [在 Typst 中设置中文引用样式源代码示例。])[
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
]<设置中文引用样式示例>

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

#figure(kind: raw, caption: [在 Typst 中自定义代码块显示源代码示例。])[
  #code-block[
    ````typ
    #show raw.where(block: true): it => {
      // 如果显示行号，则使用 grid 排版
      grid(
        // 行号右对齐，代码左对齐，水平居中
        align: (right + top, left + horizon),
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

#show-block(width: 36%)[
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

一个基本的表格示例如下：

#code-and-show(columns: (7fr, 3fr))[```typ
  #table(
    columns: (1fr, 1fr),
    table.header([*表头1*], [*表头2*]),
    [行1列1], [行1列2],
    [行2列1], [行2列2],
    [行3列1], [行3列2],
    table.footer([_表尾 1_], [_表尾 2_]),
  )
  ```]

其中，`table.header` 用于设置表头，`table.footer` 用于设置表尾。
如果表格在一页无法完全展示，那么表格会被自动截断，
但是表头和表尾会在每一页都显示。

=== 行列格式

`table` 函数使用参数 `columns`、`rows` 和 `align` 分别设置列宽、行高以及对齐方式。

其中，`1fr` 是一个相对长度，表示“一份”。
例如 `columns: (2fr, 1fr)` 表示将表格的宽度分成了三份，第一列占两份，第二列占一份。
相对长度除了可以使用 `fr` 表示，还可以使用百分比，例如 `columns: (67%, 33%)`。

如果要设置表格内容的对齐方式，可以使用参数 `align`。例如：

#code-and-show(columns: (5fr, 2fr))[```typ
  #table(columns: (1fr, 1fr),
    align: (center + top ,right + horizon),
    [A], [B\ V], [C\ V], [D],
  )
  ```]

其中，列对齐可以使用水平方向的对齐方式调整；
行对齐可以使用竖直方向的对齐方式来调整。
如果需要更加精细的对齐方式，参数 `align` 还可以接受一个函数，
其中函数的参数是两个整数，对应单元格的列坐标和行坐标：

#code-and-show(columns: (7fr, 3fr))[```typ
  #table(columns: (1fr, 1fr, 1fr),
    align: (col, row) => { // 坐标从零开始
      if calc.even(col) { right + bottom }
      else if calc.even(row) {
        center + horizon
      } else { left + top }
    }, [A], [B\ V], [C], [D], [E], [F \ V])
  ```]


如果只想调整特定的单元格的对齐方式，可以使用 `table.cell` 函数。例如：

#code-block[
  ```typ
  #table(columns: (1fr, 2fr), align: center + horizon,
    [A], table.cell(align: right + bottom)[special text],
    [B], [normal text])
  ```
]

=== 网格线

如果想要手动调整表格的样式，例如想要绘制三线表，
那么可以把 `table` 函数与 `table.hline` 和 `table.vline` 函数配合使用。

这里简单展示一下如何使用这两个网格线函数：

#code-and-show(columns: (7fr, 3fr))[```typ
  #table(columns: (3em, 3em, 3em),
    rows: 3em, // 行高设置为 3em
    align: center + horizon,
    stroke: none, // 取消默认网格线
    [4], [9], [2],
    [3], [5], [7],
    [8], [1], [6],
    table.hline(y: 1, start: 1),
    table.vline(x: 1),
    table.vline(x: 0), table.vline(x: 3),
    table.hline(y: 3, start: 0, end: 1),
    table.hline(y: 0), table.hline(y: 3))
  ```]

其中，`table.hline` 有四个参数可以使用，分别是 `y`,、`start`、`end` 以及 `position`。

/ y: 表示横线的起始行，默认等于函数所在位置的内容的行坐标。

/ start/end: 表示从横线的起始/结束点的列坐标。

/ position#footnote[
    除非设置了表格行间距，否则不应该设置参数 `position`。
  ]: 在 `y` 的基础上调整横线位置，可选值有 `top` 和 `bottom`，默认是 `top`。

`table.vline` 函数的参数与 `table.hline` 函数类似，仅将 `y` 换成了 `x`，行列坐标互换；
参数 `position` 的可选值有 `right` 和 `left`，默认是 `left`。

下面是一个三线表的例子：

#code-block[
  ```typ
  #table(columns: (3fr, 1fr, 1fr, 1fr),
    align: center + horizon,
    stroke: none, // 取消默认网格线
    rows: 2.4em, // 稍微增加行高
    table.hline(y: 0, start: 0, end: 4, stroke: 0.08em),
    table.header( // 表头内容
      [], table.cell(colspan: 3)[*Numbers*],
      table.hline(y: 1, start: 1, end: 4, stroke: 0.04em),
      [], [*1*], [*2*], [*3*]),
    table.hline(y: 2, start: 0, end: 4, stroke: 0.06em),
    [*Alphabeta*], [A], [B], [C],
    [*Roman*], [I], [II], [III],
    table.hline(y: 4, start: 0, end: 4, stroke: 0.08em))
  ```
]

#show-block(width: 80%)[
  #table(
    columns: (3fr, 1fr, 1fr, 1fr),
    align: center + horizon,
    // 取消默认网格线
    stroke: none,
    // 稍微增加行高
    rows: 2.4em,
    // 表头线
    table.hline(stroke: 0.08em),
    table.header(
      // 表头内容
      [], table.cell(colspan: 3)[*Numbers*],
      // 内部分隔线
      table.hline(y: 1, start: 1, end: 4, stroke: 0.04em),
      [], [*1*], [*2*], [*3*],
    ),
    // 分隔线
    table.hline(stroke: 0.06em),
    [*Alphabeta*], [A], [B], [C],
    [*Roman*], [I], [II], [III],
    // 表底线
    table.hline(stroke: 0.08em),
  )
]

对于这三条线，可以使用 `with` 方法设置默认值以方便使用：

#code-block[
  ```typ
  #let middle-line = table.hline.with(stroke: 0.06em)
  #let top-bottom-line = table.hline.with(stroke: 0.08em)
  #let inner-middle-line = table.hline.with(stroke: 0.04em)
  ```
]

=== 合并单元格

通过 `table.cell` 函数的参数 `colspan` 和 `rowspan` 可以实现合并单元格。例如：

#code-block[
  ```typ
  #table(columns: (1fr, 2fr, 4fr),
    align: center + horizon, inset: 1.2em,
    table.cell(rowspan: 2, rotate(-90deg, reflow: true)[*标题*]),
    [2], [Center], [3], table.cell(align: right)[Right],
    table.cell(colspan: 2)[4], [C],
  )
  ```
]

#show-block(width: 64%)[
  #table(
    columns: (1fr, 2fr, 4fr),
    align: center + horizon,
    inset: 1.2em,
    table.cell(rowspan: 2, rotate(-90deg, reflow: true)[*标题*]),
    [2], [Center], [3], table.cell(align: right)[Right],
    table.cell(colspan: 2)[4], [C],
  )
]

其中，`rotate` 函数可以旋转内容。
参数 `reflow` 设置为 `true` 时，`rotate` 函数会调整内容的边界框，*可能改变布局*。
中文内容建议将参数 `reflow` 设置为 `true` 以避免：

#code-and-show(columns: (4fr, 1fr), width: auto)[```typ
  #block(width: 11%)[#rotate(-90deg)[*标题*]]
  ```]

=== 间距控制

通过调整 `table` 函数的参数 `gutter` 可以设置单元格的间距。

#code-and-show(columns: (5fr, 3fr))[```typ
  #table(
    columns: (1fr, 1fr, 1fr),
    align: center + horizon,
    [a], [b], [c],
    [d], [e], [f],
    [g], [h], [i],
  )

  #table(
    columns: (1fr, 1fr, 1fr),
    align: center + horizon,
    gutter: (1em, 0pt),
    [a], [b], [c],
    [d], [e], [f],
    [g], [h], [i],
  )
  ```]

或者通过参数 `row-gutter` 和 `column-gutter` 来具体设置行间距和列间距。

如果传递一个长度给参数 `gutter`，所有的行间距和列间距都会被设置为这个长度。
如果传递一个长度列表，那么 `gutter` 会依次应用间距。

具体来说，如果列表长度大于表格的行数或列数，那么表格的间距等于列表中对应的值；
如果列表长度小于表格行数或列数，那么最后一个值将被重复使用。

=== grid 函数

`grid` 函数与 `table` 函数基本一致，除了：

/ stroke: `table` 函数默认会绘制边框#footnote[
    边框默认设置为 `stroke: 1pt + black`。
  ]，`grid` 函数不会。

/ inset: `table` 函数的单元格默认有 `5pt` 的内边距，`grid` 函数没有。

#code-and-show(columns: (5fr, 3fr))[```typ
  #table(
    columns: (1fr, 1fr, 1fr),
    align: center + horizon,
    [a], [b], [c],
    [d], [e], [f],
    [g], [h], [i],
  )
  ```]

所以通过修改参数，`grid` 和 `table` 函数可以实现相同的效果：

#code-and-show(columns: (5fr, 3fr))[```typ
  #grid(
    columns: (1fr, 1fr, 1fr),
    stroke: 1pt + black,
    inset: 5pt,
    align: center + horizon,
    [a], [b], [c],
    [d], [e], [f],
    [g], [h], [i],
  )
  ```]

== 图片

Typst 支持插入 `.png`、`.jpg`、`.gif` 和 `.svg` 格式的图片。
你可以传入路径字符串，或者以字节的形式传入图片，然后按照如下方式指定图片格式：

/ encoding: 编码方式，目前支持 `"rgb8"`、`"rgba8"`、`"luma8"` 以及 `"lumaa8"`。

/ width: 一个整数，表示图片的像素宽度。

/ height: 一个整数，表示图片的像素高度。

#code-and-show(columns: (5fr, 2fr))[```typ
  #image(
    bytes(range(16).map(x => x * 16)),
    format: (
      encoding: "luma8",
      width: 4,
      height: 4,
    ),
    width: 2cm,
  )
  ```]

除了使用参数 `format` 指定图片的格式，`image` 函数还有一些常用参数：

/ width: 图片的宽度，接受一个相对长度。将图片宽度调整至其原始尺寸的相应比例。

/ height: 图片的高度，接受一个相对长度。将图片高度调整至其原始尺寸的相应比例。

/ alt: 图片的描述文本，是一个字符串。

/ fit: 图片的调整策略，如果剩余空间不足以显示图像该如何调整图片。目前的策略有：

  / cover: 覆盖，或者说裁剪。

    图片比例不变，尽可能覆盖剩余空间，超出部分被舍弃。

    参数 `fit` 的默认值就是 `"cover"`。

  / contain: 包含。

    保持图片比例不变，但是缩小图片让图片能够在剩余空间完整显示。

  / stretch: 拉伸。

    改变图片比例，让图片完全填充剩余空间。

如果想要旋转图片，可以使用之前提到的 `rotate` 函数：

#code-and-show(columns: (5fr, 2fr))[```typ
  #rotate(45deg, reflow: true)[
    #image(
      bytes(range(16).map(x => x * 16)),
      format: (
        encoding: "luma8",
        width: 4,
        height: 4,
      ),
      width: 2cm,
    )
  ]
  ```]

== 盒子

如果曾经接触过网页设计，对“盒模型”这一概念想必不会陌生。
在排版中，文档的每一个元素都可被视为一个矩形“盒子”，包含内容、内边距、边框以及外边距。
Typst 在这之上提供了 `box` 和 `block` 等函数，让我们可以构建自己的盒子。

=== box 函数

在 Typst 中，除了行内数学、文本以及 `box`，其他所有元素均为块级元素。

一个元素是块级元素意味着这个元素默认情况下会独占一行，无法与其他元素并列一行。
但是 `box` 函数可以把这些块级元素“打包”成一个行内元素，例如：

#code-and-show(columns: (5fr, 2fr))[```typ
  一个图片：#box(
    baseline: 0.64em,
    image(
      bytes(range(16).map(x => x * 16)),
      format: (
        encoding: "luma8",
        width: 4, height: 4),
      width: 2em,
    ))！
  ```]

可以看到，文本和图片确实在同一行了，其中参数 `baseline` 可用于调整基线位置。
使用 `underline` 函数可以确认基线位置，下划线默认会生成在基线处。

如果想要控制行内元素的对齐方式，可以将 `box` 函数与 `align` 函数结合起来使用：

#code-block[
  ```typ
  #let makebox(
    body,
    width: auto, height: auto,
    stroke: none, inset: 0%,
    alignment: center,
  ) = {
    box(width: width, height: height, stroke: stroke, inset: inset)[
      #align(alignment, body)
    ]
  }

  |#makebox(width: 10em)[测试文本]| \
  |#makebox(width: 10em, alignment: left)[测试文本]| \
  |#makebox(width: 10em, alignment: right)[测试文本]|
  ```
]

#show-block(width: auto)[
  #let makebox(
    body,
    width: auto,
    height: auto,
    stroke: none,
    inset: 0%,
    alignment: center,
  ) = {
    box(width: width, height: height, stroke: stroke, inset: inset)[
      #align(alignment, body)
    ]
  }

  |#makebox(width: 10em)[测试文本]| \
  |#makebox(width: 10em, alignment: left)[测试文本]| \
  |#makebox(width: 10em, alignment: right)[测试文本]|
]

其中 `box` 函数的参数 `width` 和 `height` 用于调整行内元素的大小。

=== 盒子边框

许多函数有一个参数 `stroke`，表示元素的边框。
对于文本而言，边框就是文字本身，所以文本的参数 `stroke` 对应的是文本的描边：

#code-and-show(columns: (5fr, 2fr))[```typ
  #text(stroke: 1pt + red)[测试文本] \
  测试文本
  ```]

而 `box` 的参数 `stroke` 则是对应行内元素的边框，例如：

#code-and-show(code-func: code-card, columns: (5fr, 2fr))[```typ
  #box(stroke: 1pt + blue.lighten(32%))[测试文本]
  ```]

如果想要为元素加上边框，还可以使用 `rect` 函数：

#code-and-show(code-func: code-card, columns: (5fr, 2fr))[```typ
  #rect(stroke: 1pt + blue.lighten(32%))[测试文本]
  ```]

`rect` 函数和 `box` 函数的关系与 `table` 函数和 `grid` 函数的关系非常类似，
`rect` 函数的参数 `stroke` 默认设为 `1pt + black`，并且有 `5pt` 的内边距，而 `box` 函数没有。

通过设置参数 `stroke`，可以设置边框的样式，设置参数 `inset` 可以调整边框与内容的距离。
如果要调整对齐方式，可以将 `box` 函数或者 `rect` 函数与 `align` 函数配合使用。

#code-and-show(code-func: code-card, columns: (5fr, 2fr))[```typ
  #rect(inset: 1em, radius: 1em, stroke: stroke(
    dash: "dash-dotted", thickness: 1.6pt,
    paint: gradient.linear(red, blue),
  ))[#align(right + horizon)[测试文本]]
  ```]

关于参数 `stroke` 的具体设置方式，
可以参考 #link("https://typst.app/docs/reference/visualize/rect/#parameters-stroke")[rect-stroke]
以及 #link("https://typst.app/docs/reference/visualize/stroke")[stroke 类型]。

=== 基线调整

要在一行内排版多行内容，最关键的就是要调整好基线。
一般会使用 `em` 作为单位，因为 `1em` 等于当前文本的大小（size），不需要换算：

#code-and-show(code-func: code-card, columns: (5fr, 2fr))[```typ
  #{ [`1em` 长度：] + context measure(h(1em)).width } \
  #{ [m 的宽度：] + context measure([m]).width } \
  #{ [汉的宽度：] + context measure([汉]).width } \
  #{ [汉的高度：] + context measure([汉]).height } \
  #set text(size: 10pt)
  #{ [改变后：] + context measure(h(1em)).width }
  ```]

其中，`measure` 函数可以获取任意元素的大小信息。

下面是一个调整基线的例子：

#code-block[
  ```typ
  行内调整基线对齐：\ 三字经：#box(baseline: 3 * (8.75pt + 0.8em))[
    // 向下移动三行，每行间隔 0.8em，默认间隔 0.65em
    人之初\ 性本善\ 性相近\ 习相远
  ]，千字文：#box[天地玄黄\ 宇宙洪荒] \
  测试下一行文本位置
  ```
]

#show-block(width: auto)[
  行内调整基线对齐：\ 三字经：#box(baseline: 3 * (8.75pt + 0.8em))[
    // 向下移动三行，每行间隔 0.8em，默认间隔 0.65em
    人之初\ 性本善\ 性相近\ 习相远
  ]，千字文：#box[天地玄黄\ 宇宙洪荒] \
  测试下一行文本位置
]

=== block 函数

`block` 函数用于构造一个块级元素。
例如 @设置中文引用样式示例 使用 `block` 函数构造块级引用样式。

下面是一个使用 `block` 和 `move` 函数构造自定义块级元素的例子：

#code-and-show(columns: (5fr, 3fr))[```typ
  #let sticker(body) = block(
    stroke: 1pt + rgb(78, 31, 0),
    inset: 0em,
    radius: 0.32em,
    fill: rgb(243, 198, 35),
    move(dx: 0.5em, dy: 0.5em, block(
      stroke: 1pt + rgb(116, 81, 45),
      inset: 1em,
      radius: 0.32em,
      fill: yellow.lighten(64%),
      body,
    )),
  )
  #sticker[自定义块级元素]
  ```]

其中 `move` 函数用于相对父级元素移动当前元素。

== 浮动体

排版文档时，经常能遇到许多图片和表格等内容，有些内容的尺寸往往太大而导致分页困难。
使用浮动体让大块的内容可以脱离上下文，放置在合适的位置。

`figure` 函数用于显示需要编号和标题的内容，一般用于排版图表。
参数 `kind` 可以说明图表内容的类别。
图表默认不是浮动体。
如果想要让图表变成浮动体，可以设置参数 `placement` 为 `auto`、`top` 或者 `bottom`，
默认值是 `none`。例如：

#code-card[
  ```typ
  #figure(caption: [_A example of gradient_],
    placement: bottom, kind: image, numbering: none,
  )[
    #block(width: 12em, height: 12em, radius: 6em, fill: gradient
      .radial(..color.map.rocket)
      .repeat(4))
  ]
  #lorem(32)
  ```
]

参数 `caption` 用于为图表添加标题；
对于多列布局，如果想要让图表可以跨列显示，
可以让图表变成浮动体的同时，设置参数 `scope` 为 `"parent"`。

#show-block[
  #figure(placement: bottom, caption: [_An example of gradient_], numbering: none, kind: image)[
    #block(width: 12em, height: 12em, radius: 6em, fill: gradient
      .radial(..color.map.rocket)
      .repeat(4))
  ]
  #lorem(32)
]

可以看到，按照渲染顺序，文本应该显示在图表下面，
但图片使用了浮动体，要求排版到底部，
所以文本反而显示在了图表上面。

=== 图表标题

图表标题默认会显示在图表内容下面。
如果想要修改图表标题的位置，可以设置 `figure.caption` 的参数 `position`：

#code-block[
  ```typ
  #show figure.where(kind: table): set figure.caption(position: top)
  #figure(kind: table, caption: [图表标题测试], numbering: none)[
    #table(columns: (2em, 2em), rows: (2em, 2em),
      align: center + horizon,
      [A], [B],
      [C], [D],
    )
  ]
  ```
]

#show-block(width: auto)[
  #show figure.where(kind: table): set figure.caption(position: top)
  #figure(kind: table, caption: [图表标题测试], numbering: none)[
    #table(
      columns: (2em, 2em),
      rows: (2em, 2em),
      align: center + horizon,
      [A], [B],
      [C], [D],
    )
  ]
]

在 @ch-3-目录 中提到 `outline` 函数的参数 `target` 可以用于筛选目录要显示的内容。
而图表的参数 `kind` 可以接受一个字符串，这意味着我们可以自定义图表，
并使用目录列出所有自定义图表的位置。

例如自定义一个图表专门显示猫猫相关的内容：

#code-card[
  ```typ
  // 设置专门的图表标识
  #show figure.where(kind: "猫猫"): set figure(supplement: [🐱])
  // 使用参数 target 让目录显示自定义图表的条目
  #outline(target: figure.where(kind: "猫猫"), title: [猫猫目录])
  // 使用自定义图表
  #figure(kind: "猫猫", caption: [🐱👌👨👎])[
    #image("猫猫图片.png", format: "png", width: 64%)
  ]
  ```
]

=== 并列和子图表

如果要并列两个图表，可以使用 `grid` 函数。
如果只需要均匀分成特定列数，可以使用 `columns` 函数。
例如使用 `grid` 函数并列显示两个图表：

#code-block[
  ```typ
  #grid(columns: (1fr, 1fr), align: center + horizon)[
    #figure(kind: image, caption: [_A square_])[
      #block(width: 8em, height: 8em, fill: blue.lighten(32%))
    ]
  ][
    #figure(kind: image, caption: [_Another square_])[
      #block(width: 8em, height: 8em, fill: green.lighten(32%))
    ]
  ]
  ```
]

#show-block(width: auto)[
  #grid(columns: (1fr, 1fr), align: center + horizon)[
    #figure(kind: image, caption: [_A square_])[
      #block(width: 8em, height: 8em, fill: blue.lighten(32%))
    ]
  ][
    #figure(kind: image, caption: [_Another square_])[
      #block(width: 8em, height: 8em, fill: green.lighten(32%))
    ]
  ]
]

如果要让这两个图表归属同一个图表下，就需要用到子图表功能了。
Typst *并没有*提供子图表函数，但是我们可以使用自定义计数器和自定义图表实现这个功能：

#figure(kind: raw, caption: [在 Typst 中自定义子图片图表源代码示例。])[
  #code-block[
    ```typ
    // 设置图片编号为 1.1
    #show figure.where(kind: image): set figure(numbering: it => {
      // 每次使用图片图表都重置子图片图表计数，从 0 开始
      counter(figure.where(kind: "subimage")).update(0)
      // 设置编号方式
      numbering("1.1",
        counter(heading.where(level: 1)).get().at(0), it)
    })
    // 设置子图片图表的图表标识
    #show figure.where(kind: "subimage"): set figure(supplement: [图])
    // 设置子图片图表的编号为 1.1.a
    #show figure.where(kind: "subimage"): set figure(
      numbering: it => {
        numbering(
          "1.1.a",
          counter(heading.where(level: 1)).get().at(0),
          counter(figure.where(kind: image)).get().at(0),
          it,
        )
      })
    // 使用图表
    #figure(kind: image, caption: [演示自定义子图片图表。])[
      // 使用 grid 函数控制布局
      #grid(columns: (1fr, 1fr), align: center + horizon)[
        #figure(kind: "subimage", caption: [_A square_])[
          #block(width: 8em, height: 8em, fill: blue.lighten(32%))
        ]<test-subimage-a>
      ][
        #figure(kind: "subimage", caption: [_Another square_])[
          #block(width: 8em, height: 8em, fill: green.lighten(32%))
        ]<test-subimage-b>
      ]
    ]
    ```
  ]
]<自定义子图片图表示例>

#show-block[
  // 设置图片编号为 1.1
  #show figure.where(kind: image): set figure(numbering: it => {
    // 每次使用图片图表都重置子图片图表计数，从 0 开始
    counter(figure.where(kind: "subimage")).update(0)
    // 设置编号方式
    numbering(
      "1.1",
      counter(heading.where(level: 1)).get().at(0),
      it,
    )
  })
  // 设置子图片图表的图表标识
  #show figure.where(kind: "subimage"): set figure(supplement: [图])
  // 设置子图片图表的编号为 1.1.a
  #show figure.where(kind: "subimage"): set figure(numbering: it => {
    numbering(
      "1.1.a",
      counter(heading.where(level: 1)).get().at(0),
      counter(figure.where(kind: image)).get().at(0),
      it,
    )
  })
  // 使用图表
  #figure(kind: image, caption: [演示自定义子图片图表。])[
    // 使用 grid 函数控制布局
    #grid(columns: (1fr, 1fr), align: center + horizon)[
      #figure(kind: "subimage", caption: [_A square_])[
        #block(width: 8em, height: 8em, fill: blue.lighten(32%))
      ]<test-subimage-a>
    ][
      #figure(kind: "subimage", caption: [_Another square_])[
        #block(width: 8em, height: 8em, fill: green.lighten(32%))
      ]<test-subimage-b>
    ]
  ]
]

引用功能也是可以正常使用的，例如 @test-subimage-a 和 @test-subimage-b。
