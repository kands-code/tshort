#import "../utils.typ": abstract, code-and-show, code-block, code-card, show-block

= 排版样式设定

#abstract[
  至此你已经基本学会排版内容丰富的文档，标题、目录、章节、公式、列表、图片、表格等等应有尽有。
  但是你可能有点不甘心，因为排版出来的文档“千篇一律”
  ------ Typst 默认的字体、不太满意的页边距，等等。
  本章的内容将带你一览如何修改 Typst 的排版样式。
]

== 字体和字号

Typst 会根据内容的位置自动选择字体样式和字号。
但是目前 Typst 的字体设置还是比较局限，
只能设置默认字体，然后使用 `covers` 去匹配应用。


#figure(kind: table, caption: [标准字体命令与字号的对应@ctex-manual-2022], numbering: none)[
  #table(
    columns: (3fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr),
    stroke: none,
    column-gutter: 1em,
    align: center + horizon,
    table.hline(stroke: 0.08em + black),
    table.header(
      [LaTeX], table.cell(colspan: 2)[`zihao = 5`],
      table.cell(colspan: 2)[`zihao = -4`],
      [`10pt`], [`11pt`], [`12pt`],
      [ 字体命令], [字号], [bp], [字号], [bp], [pt], [pt], [pt],
    ),
    table.hline(y: 1, start: 1, end: 3, stroke: 0.04em + black),
    table.hline(y: 1, start: 3, end: 5, stroke: 0.04em + black),
    table.hline(y: 1, start: 5, end: 6, stroke: 0.04em + black),
    table.hline(y: 1, start: 6, end: 7, stroke: 0.04em + black),
    table.hline(y: 1, start: 7, end: 8, stroke: 0.04em + black),
    table.hline(y: 2, stroke: 0.06em + black),
    [`tiny`], [七号], [5.5], [小六], [6.5], [5], [6], [6],
    [`scriptsize`], [小六], [6.5], [六号], [7.5], [7], [8], [8],
    [`footnotesize`], [六号], [7.5], [小五], [9], [8], [9], [10],
    [`small`], [小五], [9], [五号], [10.5], [9], [10], [11],
    [`normalsize`], [五号], [10.5], [小四], [12], [10], [11], [12],
    [`large`], [小四], [12], [小三], [15], [12], [12], [14],
    [`Large`], [小三], [15], [小二], [18], [14], [14], [17],
    [`LARGE`], [小二], [18], [二号], [22], [17], [17], [20],
    [`huge`], [二号], [22], [小一], [24], [20], [20], [25],
    [`Huge`], [一号], [26], [一号], [26], [25], [25], [25],
    table.hline(stroke: 0.08em + black),
  )
]


#code-and-show(columns: (3fr, 2fr))[```typ
  #text(size: 11pt)[Small] and
  #text(size: 14pt)[Large].
  ```]

=== 字体样式

字体样式包括字体，字重和字形，分别对应 `text` 函数的参数 `font`、`weight` 和 `style`。
通过 `set` 规则设置的字体样式会在文档内全局生效，而单独使用 `text` 函数设置的样式仅对函数参数生效。

#code-and-show(columns: (9fr, 5fr))[```typ
  #set text(size: 16pt) // 全局
  Text, #text(size: 9pt)[
    Text, // 局部
  ] and Text.
  ```]

=== 更改对应元素字体

通过 `set` 规则设置的字体仅对标记模式的文本内容生效。
如果想要修改其他元素的字体，则需要使用 `show` 规则来设置：

#code-and-show(columns: (7fr, 3fr))[````typ
  #set text( // 普通文本
    font: "Sarasa Gothic SC",
  )
  #show raw: set text( // 等宽文本
    font: "DejaVu Sans Mono",
  )
  #show math.equation: set text(
    font: "New Computer Modern Sans Math",
  ) // 数学字体
  标记模式文本测试。\
  ```py
  // 等宽文本测试
  print("hello")
  ```
  $
    integral_0^1 ln(x) = -1
  $
  ````]

如果要分语言设置字体，可以参考 @ch-2-排版中文 中的示例。

如果需要使用其他字体，例如仿宋，建议使用 `with` 方法得到对应函数，然后在需要使用的地方使用。

#code-card[```typ
  #let fangsong = text.with(font: "Zhuque Fangsong (technical preview)")
  #fangsong[需要仿宋]，正常文本。
  ```]

== 文字装饰与强调

要强调一段文字，除了改变文字的字体，就是为文字添加一些装饰物。

通常的强调方法包括加粗文本和使用斜体，对应 `strong` 和 `emph` 函数。
函数的效果可以使用 `show` 规则设置，例如让 `strong` 函数在加粗文本时让文本颜色变成红色：

#code-and-show(columns: (9fr, 5fr))[```typ
  #show strong: set text(fill: red)
  *Strong* test. \
  _Emphasis_ test.
  ```]


要为一段文字添加下划线装饰，可以使用 `underline` 函数：

#code-and-show(columns: (9fr, 5fr))[```typ
  An #underline[underlined] text.
  ```]

下划线可以通过参数 `stroke` 设置，例如加粗的渐变色下划线：

#code-and-show(columns: (9fr, 5fr))[```typ
  #set underline(
    stroke: 2pt + gradient
      .linear(..color.map.crest),
  )
  #underline(lorem(8))
  ```]

仔细看会发现，下划线有可能会被一些字母“截断”。
将参数 `evade` 设置 `false` 后，下划线就会穿过文字底部，不会被截断。
如果设置参数 `background` 为 `true`，下划线将不会遮挡文本，可用于模拟文本高亮的效果。

#code-and-show(columns: (9fr, 5fr))[```typ
  #set underline(
    stroke: 1em + yellow.lighten(64%),
    evade: false, background: true)
  #underline(lorem(8))
  ```]

不过 Typst 已经提供了 `highlight` 函数用于文本高亮，不需要重新实现：

#code-and-show(columns: (9fr, 5fr))[```typ
  #highlight(lorem(4))
  ```]

通过设置参数 `fill` 和 `stroke`，可以调整高亮使用的颜色，以及边框效果。

#code-and-show(columns: (9fr, 5fr))[```typ
  #highlight(
    stroke: 1pt + rgb(155, 23, 126),
    fill: rgb(255, 220, 220), lorem(8))
  ```]

== 段落格式和间距

=== 长度和长度变量

到目前为止，我们已经见到过许多长度的用法。
这一节作为汇总，将介绍 Typst 中所有支持的长度单位和用法。

#align(center)[
  #let normal = text.with(size: 12pt, lang: "zh", fill: black, font: (
    (name: "New Computer Modern", covers: "latin-in-cjk"),
    (name: "Noto Color Emoji", covers: regex("\p{Emoji}")),
    "Source Han Serif SC",
  ))
  #block(width: 72%)[
    #table(
      columns: (1fr, 4fr),
      stroke: none,
      align: (center + horizon, left + horizon),
      rows: 1.6em,
      table.hline(stroke: 0.08em + black),
      table.vline(x: 1, stroke: 0.06em + black),
      [`pt`],
      [磅，$approx 1\/72.27 #[in] #normal[（传统）] approx 1\/72 #[in] #normal[（现代）]$],
      [`mm`], [毫米],
      [`cm`], [厘米],
      [`in`], [英寸，$= 2.54 #[cm]$],
      table.hline(stroke: 0.04em + black),
      [`em`], [相对文本宽度，对应 `text` 函数的参数 `size`],
      [`%`], [相对某个长度的比例，例如 `64%`],
      [`fr`], [一份，将剩余空间等分后所占份数],
      table.hline(stroke: 0.08em + black),
    )
  ]

  通常使用 `百分比+绝对长度` 的形式表示相对长度，例如 `0%+5pt`。
]

=== 行距

当前 Typst 的页面模型中，*并没有*行距的概念#footnote[
  详情可以参考 #link("https://github.com/typst/typst/issues/4224")[typst/issues/4224]。
]。取而代之的是当前行的下边界与下一行的上边界的距离，以及段落之间的距离，
对应参数 `leading` 和 `spacing`。

参数 `leading` 的效果实际上会受到字体以及文本内容的影响，不过我们还是可以将其视为行间距。
参数 `leading` 和 `spacing` 的默认值分别为 `0.65em` 和 `1.2em`。

#code-and-show(columns: (9fr, 7fr))[```typ
  // 使用默认间距
  #set par(leading: 0.65em,
    spacing: 1.2em)
  #lorem(8)

  #lorem(8)

  #line(length: 100%)

  // 改变行间距和段间距
  #set par(leading: 1em,
    spacing: 2em)
  #lorem(8)

  #lorem(8)
  ```]

=== 段落格式

下面展示了如何设置段落的左缩进、右缩进和首行缩进：

#code-block[
  ```typ
  #lorem(16)
  #align(center, block(width: 100%, inset: (left: 5em, right: 4em))[
    #set align(left)
    #set par(
      first-line-indent: (amount: -1em, all: false),
      justify: true,
    )

    #lorem(16)

    #lorem(16)
  ])
  ```
]

#show-block(width: 100%)[
  #lorem(16)
  #align(center, block(width: 100%, inset: (left: 5em, right: 4em))[
    #set align(left)
    #set par(
      first-line-indent: (amount: -1em, all: false),
      justify: true,
    )

    #lorem(16)

    #lorem(16)
  ])
]

首行缩进可以通过 `par` 函数的参数 `first-line-indent` 设置。
如果 `all` 设置为 `false`，那么每一部分的第一段不缩进；
设置为 `true`，则所有的段落都缩进。
`amount` 表示缩进大小，小于零时表示悬挂缩进；
还可以通过参数 `hanging-indent` 设置悬挂缩进。

Typst 没有提供设置段落左右缩进的方法，但是可以使用 `align` 函数与 `block` 函数配合来实现。
设置 `block` 函数的宽度为 `100%` 以确保一行的长度与正常段落一致，
然后设置 `block` 函数的内边距来设置左右缩进。

=== 水平间距与竖直间距

如果要插入水平间距，可以使用 `h` 函数；插入竖直间距可以使用 `v` 函数。

#code-and-show[```typ
  #lorem(2)#h(2em)#lorem(2)\
  #v(2em)
  #lorem(2)
  ```]

如果要填充剩余空间，可以使用 `h(1fr)` 或这 `v(1fr)`。

== 页面和分栏

TODO
